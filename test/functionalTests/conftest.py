"""
Shared pytest fixtures for functional tests in this package.
"""
import pytest

from functionalTests.utils import Model2owlArtefact


@pytest.fixture
def jsonld_context_artefact() -> Model2owlArtefact:
    return Model2owlArtefact(
        "jsonld context", "generate-jsonld-context", "*_context.jsonld"
    )
