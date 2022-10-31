#curBranch := $(shell git branch --show-current)
curBranch := $(shell git rev-parse --abbrev-ref HEAD)
# Number of file under .git repo (to test if the git repo was already cloned)
gitRepoFiles :=  $(shell ls -l transform/model2owl/.git >/dev/null 2>&1 | wc -l )
secrets.GITHUB_TOKEN := *******
# One of the xmi input file
FIRST_INPUT_XMI_FILE := "transform/model2owl/test/test-multi-xmi/ePO_CM.xml"
# Output directory containing combined file from multiple xmi / xml UML models
OUTPUT_COMBINED_XMI_PATH := "transform/output/combined-xmi/"
# Glossary output directory
OUTPUT_GLOSSARY_PATH := "transform/output/glossary/"
# download saxon library 	
get-saxon:
	mkdir -p transform
	cd transform &&	curl -L -o saxon.zip "https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip

# Clone model2owl if the directory model2owl does not exist
get-model2owl-repo:	
	@mkdir -p transform
	@cd transform && git clone https://github.com/OP-TED/model2owl.git
	
# download xspec framework to run unit tests
get-xspec: 
	cd transform && rm -rf xspec && curl -L -o xspec.zip https://github.com/xspec/xspec/archive/refs/tags/v2.2.4.zip && unzip xspec.zip -d model2owl && rm -rf xspec.zip && cd model2owl && ln -s xspec-* xspec
	
# Initialize the project, download model2owl repo, install saxon and dependencies
init:  get-saxon get-model2owl-repo get-xspec

# Run unit_tests
unit-tests:
	@cd transform/model2owl && ant -lib ../saxon-he-10.6.jar unit_tests

# Combine xmi UML files
merge-xmi:
	@mkdir -p transform/output/combined-xmi/
	@java -jar transform/saxon-he-10.6.jar -s:${FIRST_INPUT_XMI_FILE} -xsl:transform/model2owl/src/xml/merge-multi-xmi.xsl -o:${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml
	@echo The combined document is located at "${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml"
	@ls -lh ${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml

# Generate the glossary
generate-glossary:
	@mkdir -p "${OUTPUT_GLOSSARY_PATH}"
	@java -jar transform/saxon-he-10.6.jar -s:${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml -xsl:transform/model2owl/src/html-model-glossary.xsl -o:${OUTPUT_GLOSSARY_PATH}/glossary.html
	@echo The combined glossary is located at ${OUTPUT_GLOSSARY_PATH}/glossary.html
	@echo
	@ls -lh ${OUTPUT_GLOSSARY_PATH}/glossary.html
	@echo
	@head ${OUTPUT_GLOSSARY_PATH}/glossary.html	
	@echo ...
	@tail ${OUTPUT_GLOSSARY_PATH}/glossary.html