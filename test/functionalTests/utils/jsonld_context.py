"""
Test utilities for functional testing of the model2owl tool.

This module provides helper classes and functions for running model2owl CLI commands,
handling artefact generation, loading JSON-LD test data, and error management.
"""
from dataclasses import dataclass
import glob
import json
import os
import subprocess
from typing import Optional

from functionalTests import (
    NAMESPACES_FILE,
    PROJECT_DIR_PATH,
    ROOT_TEST_DATA_PATH,
)


@dataclass
class Model2owlArtefact:
    """
    Represents a model2owl artefact, storing metadata required for its
    generation and usage.
    """
    name: str
    cliCommand: str
    artefactFileGlob: str

class Model2owlError(Exception):
    """Custom exception for model2owl errors."""
    pass


def get_jsonld_data_for_test_suite(test_suite_data_dir_name, file_name) -> dict:
    with open(ROOT_TEST_DATA_PATH / test_suite_data_dir_name / file_name) as f:
        return json.load(f)

def get_jsonld_data(file_path) -> dict:
    with open(file_path) as f:
        return json.load(f)

def run_model2owl_for_artefact(
    input_xmi_file: str, 
    model2owl_artefact: Model2owlArtefact, 
    output_dir: str
) -> str:
    """
    Runs the model2owl tool for a specified artefact and returns the path to the
    generated artefact file.
    Args:
        input_xmi_file (str): Path to the input XMI file.
        output_dir (str): Directory where the artefact should be generated.
        model2owl_artefact (Model2owlArtefact): Artefact configuration
        containing CLI command and file glob pattern.
    Returns:
        str: Path to the generated artefact file.
    Raises:
        Model2owlError: If the requested artefact was not created.
    """
    run_model2owl(
        input_xmi_file, 
        output_dir, 
        model2owl_artefact.cliCommand
    )
    artefact_path = find_first_matching_file(
        output_dir,
        model2owl_artefact.artefactFileGlob
    )
    if not artefact_path:
        raise Model2owlError("The requested artefact was not created.")
    return artefact_path


def run_model2owl(
    input_xmi_file: str, 
    output_dir: str, 
    command: str
) -> None:
    """
    Runs the model2owl tool for by invoking the given make recipe and returns
    the path to the generated artefact file.
    Args:
        input_xmi_file (str): Path to the input XMI file.
        output_dir (str): Directory where the artefact should be generated.
        command (str): A make recipe for running model2owl.
    Returns:
        str: Path to the generated artefact file.
    Raises:
        Model2owlError: If the requested artefact was not created.
    """
    # Ensure output directory exists (optional)
    output_dir.mkdir(parents=True, exist_ok=True)
    try:
        subprocess.run(
            [
                "make", command,
                f"XMI_INPUT_FILE_PATH={input_xmi_file}",
                f"OUTPUT_FOLDER_PATH={output_dir}",
                f"NAMESPACES_USER_XML_FILE_PATH={NAMESPACES_FILE}"
            ],
            cwd=PROJECT_DIR_PATH,
            check=True
        )
    except subprocess.CalledProcessError as e:
        raise Model2owlError(
            f"Model2owl failed during executing '{command}' command. Error: {e}"
        )
    except OSError as e:
        raise Model2owlError(
            f"OS error occurred while executing '{command}' command. Error: {e}"
        )



def find_first_matching_file(directory: str, glob_str: str) -> Optional[str]:
    """
    Searches for files in the specified directory matching the given glob
    pattern and returns the first match.

    Args:
        directory (str): The path to the directory to search in.
        glob_str (str): The glob pattern to match files against.

    Returns:
        Optional[str]: The path to the first matching file, or None if no match
        is found.
    """
    matches = glob.glob(os.path.join(directory, glob_str))
    return matches[0] if matches else None

