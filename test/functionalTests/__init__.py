from contextlib import contextmanager
import json
import pathlib


PROJECT_DIR_PATH = pathlib.Path(__file__).parent.parent.parent
ROOT_TEST_DATA_PATH = (PROJECT_DIR_PATH / "test" / "testData")
ROOT_DEAFULT_CFG_PATH = (PROJECT_DIR_PATH / "test" / "ePO-default-config")
NAMESPACES_FILE = ROOT_DEAFULT_CFG_PATH / "namespaces.xml"


@contextmanager
def save_on_assert_failure(
    save_enabled, save_path_expected, data_expected, save_path_actual, data_actual
):
    try:
        yield
    except AssertionError:
        if save_enabled:
            with open(save_path_expected, "w") as f:
                json.dump(data_expected, f, indent=2, ensure_ascii=False)
            with open(save_path_actual, "w") as f:
                json.dump(data_actual, f, indent=2, ensure_ascii=False)
        raise  # re-raise so the test still fails
