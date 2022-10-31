########################################################################################################
#@author: Duy DINH
#@date: Oct. 2022
#@pre-conditions: 
# We suppose that you already clone the model2owl using github command line below
# $ git clone https://github.com/OP-TED/model2owl.git
#
# After cloning into your local repository
# $ cd model2owl
#
# To see the content of the Makefile, please use the command below
# $ less Makefile
#
########################################################################################################
#curBranch := $(shell git branch --show-current)
curBranch := $(shell git rev-parse --abbrev-ref HEAD)
# Number of file under .git repo (to test if the git repo was already cloned)
gitRepoFiles :=  $(shell ls -l transform/model2owl/.git >/dev/null 2>&1 | wc -l )
secrets.GITHUB_TOKEN := *******

# Model2owl directory
MODEL2OWL_DIR="."
# One of the xmi input files to be merged into a single UML xmi/xml file
FIRST_INPUT_XMI_FILE="test/test-multi-xmi/ePO_CM.xml"
# Input dir containing files to be merged
INPUT_XMI_DIR=$(shell dirname ${FIRST_INPUT_XMI_FILE})
# rdflib version
RDF_LIB_VERSION=6.2.0
SAXON="../saxon-he-10.6.jar"
# Output directory containing combined file from multiple xmi / xml UML models
OUTPUT_COMBINED_XMI_PATH="../output/combined-xmi"
# Glossary output directory
OUTPUT_GLOSSARY_PATH="../output/glossary"

# Input XMI/XML UML models
ePO_CM_FILE_PATH="test/test-multi-xmi/ePO_CM.xml"
OUTPUT_CORE_FILE_NAME="ePO_CM-core.rdf"
OUTPUT_RESTRICTIONS_FILE_NAME="ePO_CM-restrictions.rdf"
OUTPUT_SHACL_SHAPES_FILE_NAME="ePO_CM-shacl.rdf"

# Output ontologies
OUTPUT_PATH_OWL="../output/epo-ontologies"
FILELIST=$(shell ls ${OUTPUT_PATH_OWL}/*.rdf)
# download saxon library 	
get-saxon:
	@cd ..	&& curl -L -o saxon.zip "https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip

# Clone model2owl if the directory model2owl does not exist
#get-model2owl-repo:	
#	@git clone https://github.com/OP-TED/model2owl.git
	
# download xspec framework to run unit tests
get-xspec:	
	@cd .. && rm -rf xspec && curl -L -o xspec.zip https://github.com/xspec/xspec/archive/refs/tags/v2.2.4.zip && unzip xspec.zip -d model2owl && rm -rf xspec.zip && cd model2owl && ln -s xspec-* xspec

# download and install rdflib
get-rdflib:
	#@cd .. &&  wget https://github.com/RDFLib/rdflib/releases/download/${RDF_LIB_VERSION}/rdflib-${RDF_LIB_VERSION}.tar.gz && tar xvf  rdflib-${RDF_LIB_VERSION}.tar.gz	 && pip install -e rdflib-${RDF_LIB_VERSION}
	@sudo apt-get install -y python3-rdflib

######################################################################################
# Download, install saxon, xspec, rdflib and other dependencies
######################################################################################
init:  get-saxon  get-xspec get-rdflib

############################ Main tasks ##############################################
# Run unit_tests
unit-tests:
	@ant -lib ${SAXON} unit_tests

# Combine xmi UML files
merge-xmi:
	@mkdir -p ${OUTPUT_COMBINED_XMI_PATH}
	@java -jar ${SAXON} -s:${FIRST_INPUT_XMI_FILE} -xsl:${MODEL2OWL_DIR}/src/xml/merge-multi-xmi.xsl -o:${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml
	@echo Input files to be combined are located at the directory containing this input file: ${FIRST_INPUT_XMI_FILE} under directory ${INPUT_XMI_DIR}
	@ls -lh ${INPUT_XMI_DIR}
	@echo 
	@echo "==> The combined document is located at the following location ${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml"
	@ls -lh ${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml

# Generate the glossary
generate-glossary:
	@mkdir -p "${OUTPUT_GLOSSARY_PATH}"
	@java -jar ${SAXON} -s:${OUTPUT_COMBINED_XMI_PATH}/ePO-combined.xml -xsl:${MODEL2OWL_DIR}/src/html-model-glossary.xsl -o:${OUTPUT_GLOSSARY_PATH}/glossary.html
	@echo The combined glossary is located at ${OUTPUT_GLOSSARY_PATH}/glossary.html
	@echo
	@ls -lh ${OUTPUT_GLOSSARY_PATH}/glossary.html
	@echo
	#@head ${OUTPUT_GLOSSARY_PATH}/glossary.html	
	#@echo ...
	#@tail ${OUTPUT_GLOSSARY_PATH}/glossary.html

owl-core:
	@java -jar ${SAXON} -s:${ePO_CM_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/owl-core.xsl -o:${OUTPUT_PATH_OWL}/${OUTPUT_CORE_FILE_NAME}
	@echo Output owl core file:
	@ls -lh ${OUTPUT_PATH_OWL}/${OUTPUT_CORE_FILE_NAME}
owl-restrictions:
	@java -jar ${SAXON} -s:${ePO_CM_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/owl-restrictions.xsl -o:${OUTPUT_PATH_OWL}/${OUTPUT_RESTRICTIONS_FILE_NAME}
    @echo Output owl restrictions file:
	@ls -lh ${OUTPUT_PATH_OWL}/${OUTPUT_RESTRICTIONS_FILE_NAME}
shacl:
	@java -jar ${SAXON} -s:${ePO_CM_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/shacl-shapes.xsl -o:${OUTPUT_PATH_OWL}/${OUTPUT_SHACL_SHAPES_FILE_NAME}
	@echo Output shacl file:
	@ls -lh ${OUTPUT_PATH_OWL}/${OUTPUT_SHACL_SHAPES_FILE_NAME}

transform: owl-core owl-restrictions shacl
convert-to-turtle:
	@for filename in ${FILELIST}; do \
		echo Converting $${filename}; \
		python3 scripts/rdfxml2turtle.py --input  $${filename} --output $${filename%.*}.ttl;  \
		echo Input in RDF/XML format;  \
		ls -lh $${filename};  \
		echo " ==> Output in Turtle format";  \
		ls -lh $${filename%.*}.ttl;  \
	done
#@for filename in $$(ls $$FILELIST ); do echo Converting ${filename}; python3 scripts/rdfxml2turtle.py --input  ${filename} --output ${filename%.*}.ttl;  echo Input in RDF/XML format;  ls -lh ${filename};  echo Output in Turtle format;  ls -lh ${filename%.*}.ttl;  done;
help:
	@echo The automatic tasks available are defined as below 
	@echo "\$$ Command line # Description"
	@echo "\$$ make merge-xmi # to combine multi input files (xmi, xml)" 
	@echo "\$$ make generate-glossary # to generate the glossary using the output from the merge-xmi task"
	@echo "\$$ make transform # transform from XMI/XML UML into RDF/XML (core, restrictions and shacl)"
	@echo "\$$ # "
	@echo "\$$ # "

h: help	
usage: help
default: help