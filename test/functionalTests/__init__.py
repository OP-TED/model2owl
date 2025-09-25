import pathlib

PROJECT_DIR_PATH = pathlib.Path(__file__).parent.parent.parent
ROOT_TEST_DATA_PATH = (PROJECT_DIR_PATH / "test" / "testData")
NAMESPACES_FILE = PROJECT_DIR_PATH / "model2owl-config" / "namespaces.xml"