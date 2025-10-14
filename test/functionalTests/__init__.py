import pathlib

PROJECT_DIR_PATH = pathlib.Path(__file__).parent.parent.parent
ROOT_TEST_DATA_PATH = (PROJECT_DIR_PATH / "test" / "testData")
ROOT_DEAFULT_CFG_PATH = (PROJECT_DIR_PATH / "test" / "ePO-default-config")
NAMESPACES_FILE = ROOT_DEAFULT_CFG_PATH / "namespaces.xml"
