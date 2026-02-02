from enum import Enum
import json
import os
import subprocess
from pathlib import Path

import pytest
from pytest_bdd import given, when, then, scenario, parsers

from diffTests import PROJECT_DIR_PATH, TEST_DATA_DIR


SCRIPT_PATH = PROJECT_DIR_PATH / "rdf-differ-ws" / "bash" / "rdf-differ.sh"
BASE_URL = os.environ.get("RDF_DIFFER_BASE_URL", "http://localhost:4030")
SAVED_REPORT = TEST_DATA_DIR / "ePO_sample-4.0.0-upd_diff-report.json"
REUSE_SAVED_REPORT = os.environ.get(
    "RDF_DIFFER_REUSE_SAVED_REPORT", "true"
).lower() in ["1", "true", "yes"]

# trick to run diffing only once and not for all scenarios
_diff_cache = {}

SUPPORTED_TYPES = ("class", "datatype_property", "object_property")

@scenario("../features/owl_diff.feature", "Diffing example resources in the OWL sample")
def test_owl_diff_feature():
    pass


@pytest.fixture
def ctx(tmp_path):
    """Context fixture to store state between steps."""
    return {"tmpdir": tmp_path}


@given("the test prefixes are defined")
def prefixes(ctx):
    # Hardcoded prefixes for converting between the feature file
    # and the diff reports which are RDF/JSON with no prefixes
    ctx["prefixes"] = {
        "epo": "http://data.europa.eu/a4g/ontology#",
        "skos": "http://www.w3.org/2004/02/skos/core#",
        "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
    }
    return ctx["prefixes"]


@given(parsers.parse('the OWL files "{old}" and "{new}"'))
def owl_files(ctx, old, new):
    # store absolute paths
    ctx["old"] = str(Path(old))
    ctx["new"] = str(Path(new))
    return ctx


@when("the diff is run")
def run_diff(ctx):
    script = os.path.abspath(os.path.join(os.path.dirname(__file__), SCRIPT_PATH))
    outdir = str(ctx["tmpdir"])
    old = ctx["old"]
    new = ctx["new"]
    profile = "owl-core-en-only"

    # we keep a record of already run diffs to speed up tests (we set the cache at the end of this function)
    key = (old, new)
    if key in _diff_cache:
        ctx["report"] = _diff_cache[key]
        return

    if REUSE_SAVED_REPORT:
        # use pre-existing report -- for faster testing/debugging of this test skipping the building of the report
        report_file = Path(
            os.path.abspath(os.path.join(os.path.dirname(__file__), SAVED_REPORT))
        )
    else:
        # run full workflow producing JSON output into temporary dir -- this should be the normal way
        # WARNING: as this runs an async call, sometimes this can fail due to race conditions
        # (the Celery task queue may be empty if called too fast or too late)
        result = subprocess.run(
            [
                script,
                "--base-url",
                BASE_URL,
                "--old",
                old,
                "--new",
                new,
                "--ap",
                profile,
                "--template",
                "json",
                "--output",
                outdir,
                "full",
            ],
            capture_output=False,
            text=True,
        )

        assert (
            result.returncode == 0
        ), f"Diff script failed: {result.stderr}\n{result.stdout}"
        report_file = Path(outdir) / "diff.json"

    assert report_file.exists(), f"Report file not found: {report_file}"
    with open(report_file) as fh:
        report = json.load(fh)
        ctx["report"] = report
        _diff_cache[key] = report


def expand(prefixed, prefixes):
    if prefixed is None:
        return None
    if ":" not in prefixed:
        return prefixed
    p, local = prefixed.split(":", 1)
    if p not in prefixes:
        raise ValueError(f"Unknown prefix: {p}")
    return prefixes[p] + local


def camel_to_snake(name: str) -> str:
    # Convert camelCase or mixed to snake_case (prefLabel -> pref_label)
    out = ""
    for ch in name:
        if ch.isupper():
            out += "_" + ch.lower()
        else:
            out += ch
    return out

def build_query_key(operation: str, resource_type: str, prop_snake: str) -> str:
    normalized = resource_type.replace("datatype_", "").replace("object_", "")
    return f"{operation}_property_{normalized}_{prop_snake}.rq"

# this is only possible in Behave (e.g. {predicate:NullableString})
# @parse.with_pattern(r'.*')
# def parse_nullable_string(text):
#     return text
# register_type(NullableString=parse_nullable_string)


# pytest-bdd currently lacks support for optional parameters (empty cells in the feature) in parse, so we use a regex trick
# @then(parsers.parse('the report should contain the change for "{type}","{instance}","{operation}","{predicate}","{old_value}","{new_value}"'))
@then(
    parsers.re(
        r'the report should contain the change for "(?P<resource_type>[^"]*)","(?P<instance>[^"]*)","(?P<operation>[^"]*)","(?P<predicate>[^"]*)","(?P<old_value>[^"]*)","(?P<new_value>[^"]*)"'
    )
)
def assert_report_contains(ctx, resource_type, instance, operation, predicate, old_value, new_value):
    report = ctx.get("report")
    prefixes = ctx.get("prefixes")

    assert report is not None, "Report not found in context"

    # normalize inputs
    predicate = predicate.strip() or None
    new_value = new_value.strip() or None
    old_value = old_value.strip() or None
    if resource_type == "data_property":
        resource_type = "datatype_property"

    if operation in ("added", "deleted") and resource_type in SUPPORTED_TYPES:
        # unified handling for added/deleted instances
        key = f"{operation}_instance_{resource_type}.rq"
        assert key in report, f"Missing key {key} in report"
        full_instance = expand(instance, prefixes)
        bindings = report[key].get("results", {}).get("bindings", [])
        assert any(
            b.get("resource", {}).get("value") == full_instance for b in bindings
        ), f"{operation.capitalize()} {resource_type} {full_instance} not found in {key}"

    elif operation == "changed" and resource_type in SUPPORTED_TYPES:
        prop_prefix, prop_local = predicate.split(":", 1)
        prop_snake = camel_to_snake(prop_local)
        key = build_query_key(operation, resource_type, prop_snake)
        assert key in report, f"Missing key {key} in report"
        full_instance = expand(instance, prefixes)
        bindings = report[key].get("results", {}).get("bindings", [])
        binding = next(
            (b for b in bindings if b.get("resource", {}).get("value") == full_instance),
            None,
        )
        assert binding is not None, f"No binding for instance {full_instance} in {key}"
        # check oldProperty and newProperty values for the given instance
        # where the given predicate is oldProperty
        # and the given newValue is newProperty
        expected_old = expand(predicate, prefixes)
        expected_new = expand(new_value, prefixes)
        assert (
            binding.get("oldProperty", {}).get("value") == expected_old
        ), f"oldProperty mismatch: expected {expected_old}, got {binding.get('oldProperty', {}).get('value')}"
        assert (
            binding.get("newProperty", {}).get("value") == expected_new
        ), f"newProperty mismatch: expected {expected_new}, got {binding.get('newProperty', {}).get('value')}"
    elif operation == "updated" and resource_type in SUPPORTED_TYPES:
        prop_prefix, prop_local = predicate.split(":", 1)
        prop_snake = camel_to_snake(prop_local)
        key = build_query_key(operation, resource_type, prop_snake)
        assert key in report, f"Missing key {key} in report"
        full_instance = expand(instance, prefixes)
        bindings = report[key].get("results", {}).get("bindings", [])
        binding = next(
            (b for b in bindings if b.get("resource", {}).get("value") == full_instance),
            None,
        )
        assert binding is not None, f"No binding for instance {full_instance} in {key}"
        # check oldValue and newValue values for the given predicate of the given instance
        expected_old = old_value.strip() if old_value else None
        expected_new = new_value.strip() if new_value else None
        assert (
            binding.get("oldValue", {}).get("value") == expected_old
        ), f"oldValue mismatch: expected {expected_old}, got {binding.get('oldValue', {}).get('value')}"
        assert (
            binding.get("newValue", {}).get("value") == expected_new
        ), f"newValue mismatch: expected {expected_new}, got {binding.get('newValue', {}).get('value')}"
    else:
        raise AssertionError(
            f"Unsupported combination: resource_type={resource_type}, operation={operation}"
        )
