import html
from copy import deepcopy
from io import StringIO
import re
from typing import Iterable, Optional

from lxml import html as lxml_html
import pandas as pd


EXT_TERM_DEFINITION_PREFIX = "External concept defined by"


def normalize_text(data: dict, keys: Optional[Iterable[str]] = None) -> dict:
    """
    Normalizes text in string values within the given dictionary.

    The goal is to reduce formatting differences that do not affect the actual
    content.

    The normalization is applied only to the values of the specified keys (or
    all keys if `keys` is falsy).
    The normalization process covers the following changes:
    - It replaces non-alphanumeric characters with spaces and subsequently, two
      or more consecutive whitespace characters with a single space.
    - It replaces the arrow symbol "->" with the Unicode right arrow "→".
    - For external concept definitions (strings starting with a specific
      prefix), it standardizes the format to include only the prefix and the
      URL.
    - It normalizes bi-directional relationships to have a consistent direction
      representation.
    """

    def _cond_normalize_text(value, key):
        return normalize_text(value, keys) if not keys or key in keys else value

    if isinstance(data, dict):
        return {key: _cond_normalize_text(value, key) for key, value in data.items()}
    elif isinstance(data, list):
        return [normalize_text(item, keys) for item in data]
    elif isinstance(data, str):
        s = normalize_external_concept_definition(data)

        # TODO: temporary workaround to deal with "(external)" words in glossary
        # unless it's clear whether they are needed or not
        s = s.replace("(external)", "")

        s = s.replace("->", "→")
        s = s.replace("<-", "←")

        # Normalize Bi-directional relationships
        if "←" in s:
            l, r = s.split("←", 1)
            s = f"{r.strip()} → {l.strip()}"

        s = re.sub(r"[^a-zA-Z0-9*\.\[\]:→\-]", " ", s)
        return re.sub(r"\s{2,}", " ", s)
    else:
        return data


def normalize_raw_html_text(text: str) -> str:
    s = text.replace("&#8230;&#8203;", "...")
    s = s.replace("<strong>", "*")
    s = s.replace("</strong>", "*")
    return s


def fix_excessive_space_in_cardinality(text: str) -> str:
    """
    Removes excessive spaces after '[' in cardinality indications like
    '[0..*]'.
    """
    return re.sub(r"(?<=\[)\s+", "", text)


def fix_former_glossary_formatting(data: dict) -> dict:
    """
    Fixes specific formatting issues found in the former glossary HTML content.

    It addresses excessive spaces in cardinality indications and missing spaces
    after periods in definitions.
    """
    card_key = "Domain, Range and Cardinality"
    def_key = "Definition"
    for obj in data:
        if card_key in obj:
            text = obj[card_key]
            obj[card_key] = fix_excessive_space_in_cardinality(text)
    return data


def normalize_external_concept_definition(text: str) -> str:
    # Only process if string starts with the expected prefix (ignoring leading
    # spaces)
    stripped = text.lstrip()
    if not stripped.startswith(EXT_TERM_DEFINITION_PREFIX):
        return text

    # Unescape HTML entities (e.g., &lt; -> <), in case it's HTML-escaped
    unescaped = html.unescape(text)

    # Find the first URL
    match = re.search(r'https?://[^\s"<>]+', unescaped)
    if not match:
        return text  # No change if no URL present

    url = match.group(0)

    # Normalize output
    return f"{EXT_TERM_DEFINITION_PREFIX} {url}"


def extract_table_by_xpath(
    html_file_path: str, table_xpath: str, normalize_html_formatting=True
) -> str:
    """
    Reads an HTML file, extracts a table by XPath, and returns it as a string.
    """
    # Read HTML file
    with open(html_file_path, "r", encoding="utf-8") as f:
        if normalize_html_formatting:
            html_content = normalize_raw_html_text(f.read())
        else:
            html_content = f.read()
    tree = lxml_html.fromstring(html_content)

    # Find table by XPath
    table_nodes = tree.xpath(table_xpath)
    if not table_nodes:
        raise ValueError(f"No table found for XPath: {table_xpath}")

    # Convert the first matching table to a string
    table_html = lxml_html.tostring(
        table_nodes[0], encoding="unicode", pretty_print=True
    )
    return table_html


def html_table_as_dict(html_table_data: str, order_by: Optional[str] = None) -> dict:
    """
    Converts an HTML table string into a list of dictionaries.

    Each dictionary represents a row in the table, with keys as column headers.
    Optionally orders the data by the specified header if provided.
    """
    dfs = pd.read_html(StringIO(html_table_data))
    table_data = [df.fillna("").to_dict(orient="records") for df in dfs]
    table_data = table_data[0]
    if order_by and order_by in table_data[0]:
        table_data = sorted(table_data, key=lambda x: x.get(order_by, ""))
    return table_data


def is_attribute_name_shared(attribute_obj: dict) -> bool:
    """
    Returns True if the given attribute object represents a reused attribute,
    i.e., if the 'Class name' field contains multiple class names separated by
    spaces.

    By "reused attribute", we mean an attribute that share the same name across
    multiple classes.
    """
    multiple_elems_separator = " "
    field = "Class name"
    return multiple_elems_separator in attribute_obj[field]


def is_relationship_name_shared(relationship_obj: dict) -> bool:
    """
    Return True if the given relationship object represents a reused
    relationship, i.e., if the 'Domain, Range and Cardinality' field contains
    indications of multiple entries.

    By "reused relationship", we mean a relationship that share the same
    relationship name across multiple cases.
    """
    multiple_elems_indicators = ("→", "->")
    field = "Domain, Range and Cardinality"
    count = sum(relationship_obj[field].count(i) for i in multiple_elems_indicators)
    return count >= 2


def preprocess_shared_attribute_data(obj: dict) -> dict:
    """
    Preprocesses shared attribute data to facilitate comparison and identify
    differences.
    """
    res = deepcopy(obj)
    card_key = "Data type / cardinality"
    class_key = "Class name"
    def_key = "Definition"
    classes = sorted(res[class_key].split(" "))
    res[class_key] = classes

    text = res[card_key]
    # Split only on spaces that immediately follow a closing bracket `]`
    entries = sorted(re.split(r"(?<=\])\s+", text))
    res[card_key] = entries
    del res[def_key]  # definition will be handled in a different way
    return res


def preprocess_shared_relationship_data(obj: dict) -> dict:
    """
    Preprocesses shared relationship data to facilitate comparison and identify
    differences.
    """
    card_key = "Domain, Range and Cardinality"
    def_key = "Definition"
    res = deepcopy(obj)
    text = res[card_key]
    # Split only on spaces that immediately follow a closing bracket `]`
    entries = sorted(re.split(r"(?<=\])\s+", text))
    res[card_key] = entries
    del res[def_key]  # definition will be handled in a different way
    return res


def build_index(data, key):
    """
    Build an index from a list of flat dictionaries using one key.

    Parameters:
        data (list[dict]): list of dictionaries.
        key (str): key to index by.

    Returns:
        dict: { item[key]: item }
    """
    return {item[key]: item for item in data if key in item}
