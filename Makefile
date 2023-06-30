# Model2owl directory
MODEL2OWL_DIR?=.
# rdflib version
RDF_LIB_VERSION?=6.2.0
#Saxon path
SAXON?=${MODEL2OWL_DIR}/saxon/saxon-he-10.6.jar
# Glossary output directory
OUTPUT_GLOSSARY_PATH?=output
# Convention report output directory
OUTPUT_CONVENTION_REPORT_PATH?=output
# Output folder path
OUTPUT_FOLDER_PATH?=output
# Input XMI/XML UML file path
XMI_INPUT_FILE_PATH?=test/test-multi-xmi/ePO_CM.xml
#Input filename without extension
FILENAME=$(shell basename -- "${XMI_INPUT_FILE_PATH}")
XMI_INPUT_FILENAME_WITHOUT_EXTENSION=$(shell echo ${FILENAME} | cut -f1 -d '.')
# Output directory containing combined file from multiple xmi / xml UML models
COMBINED_XMI_DIRECTORY?=output/combined-xmi
COMBINED_FILE_NAME?=ontologies-combined.xmi
# Path to one of the xmi input files to be merged into a single UML xmi/xml file
# All XMIs files to combine need to be in the same directory
FIRST_INPUT_XMI_FILE_PATH?=test/test-multi-xmi/ePO_CM.xml
# Input directory containing files to be merged
INPUT_XMI_DIR?=$(shell dirname ${FIRST_INPUT_XMI_FILE_PATH})
# Variables for converting in ttl/rdf
ONTOLOGY_FOLDER_PATH?=${OUTPUT_FOLDER_PATH}
RDF_FILELIST=$(shell ls ${ONTOLOGY_FOLDER_PATH}/*.rdf)
TURTLE_FILELIST=$(shell ls ${ONTOLOGY_FOLDER_PATH}/*.ttl)
# Widoco variables
RDF_FILE_PATH?=../file.rdf
WIDOCO_OUTPUT_DIR_PATH?=output/widoco

# download saxon library 	
get-saxon:
	@echo Installing saxon
	@mkdir -p ${MODEL2OWL_DIR}/saxon
	@cd ${MODEL2OWL_DIR}/saxon  && curl -L -o saxon.zip "https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip
	@echo 'Saxon path is ${SAXON}'

# install rdflib
get-rdflib:
	@echo Installing rdflib
	@pip install rdflib

get-widoco:
	@echo Installing widoco
	@mkdir -p ${MODEL2OWL_DIR}/widoco
	@cd ${MODEL2OWL_DIR}/widoco  && curl -L -o widoco.jar "https://github.com/dgarijo/Widoco/releases/download/v1.4.17/java-11-widoco-1.4.17-jar-with-dependencies.jar"

######################################################################################
# Download, install saxon, xspec, rdflib and other dependencies
######################################################################################
install:  get-saxon get-rdflib get-widoco

############################ Main tasks ##############################################
# Run unit_tests
unit-tests:
	@mvn install

# Generate the glossary from an input file
# Example when not using the default variables
# make generate-glossary XMI_INPUT_FILE_PATH=/home/mypc/work/model2owl/eNotice_CM.xml OUTPUT_GLOSSARY_PATH=/home/mypc/work/model2owl/glossary
generate-glossary:
	@mkdir -p "${OUTPUT_GLOSSARY_PATH}"
	@echo Input file path: ${XMI_INPUT_FILE_PATH}
	@echo Input file name: ${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}
	@cp -rf ./src/static "${OUTPUT_GLOSSARY_PATH}"
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/html-model-glossary.xsl -o:${OUTPUT_GLOSSARY_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-glossary.html
	@echo The glossary is located at the following location:
	@echo
	@ls -lh ${OUTPUT_GLOSSARY_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-glossary.html
	@echo

generate-convention-report:
	@mkdir -p "${OUTPUT_CONVENTION_REPORT_PATH}"
	@echo Input file path: ${XMI_INPUT_FILE_PATH}
	@echo Input file name: ${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}
	@cp -rf ./src/static "${OUTPUT_CONVENTION_REPORT_PATH}"
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/html-conventions-report.xsl -o:${OUTPUT_CONVENTION_REPORT_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-convention-report.html
	@echo The convention report is located at the following location:
	@echo
	@ls -lh ${OUTPUT_CONVENTION_REPORT_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-convention-report.html
	@echo

#Example how to run transformation commands :
# make owl-core XMI_INPUT_FILE_PATH=/home/mypc/work/model2owl/eNotice_CM.xml OUTPUT_FOLDER_PATH=./my-folder
owl-core:
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/owl-core.xsl -o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-core.rdf
	@echo Output owl core file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-core.rdf
owl-restrictions:
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/owl-restrictions.xsl -o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-restrictions.rdf
    @echo Output owl restrictions file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-restrictions.rdf
shacl:
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/shacl-shapes.xsl -o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-shacl.rdf
	@echo Output shacl file location:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}-shacl.rdf


# Combine xmi UML files
# all files for combine should be in test/test-multi-xmi (or in COMBINED_XMI_DIRECTORY)
merge-xmi:
	@mkdir -p ${COMBINED_XMI_DIRECTORY}
	@java -jar ${SAXON} -s:${FIRST_INPUT_XMI_FILE_PATH} -xsl:${MODEL2OWL_DIR}/src/xml/merge-multi-xmi.xsl -o:${COMBINED_XMI_DIRECTORY}/${COMBINED_FILE_NAME}
	@echo Input files to be combined are located at the directory containing this input file: ${FIRST_INPUT_XMI_FILE_PATH} under directory ${INPUT_XMI_DIR}
	@ls -lh ${INPUT_XMI_DIR}
	@echo 
	@echo "==> The combined document is located at the following location" 
	@ls -lh ${COMBINED_XMI_DIRECTORY}/${COMBINED_FILE_NAME}




#Example how to run converting commands :
# make convert-to-turtle ONTOLOGY_FOLDER_PATH=./my-folder
# OUTPUT_FOLDER_PATH is the the path to the folder containing .rdf files for converting to turtle or .ttl files to convert to rdf
convert-to-turtle:
	@for FILE_PATH in ${RDF_FILELIST}; do \
		echo Converting $${FILE_PATH} into Turtle; \
		rdfpipe -i application/rdf+xml -o  turtle $${FILE_PATH} > $${FILE_PATH%.*}.ttl; \
		echo Input in RDF/XML format;  \
		echo $${FILE_PATH};  \
		echo " ==> Output in Turtle format";  \
		ls -lh $${FILE_PATH%.*}.ttl;  \
	done
convert-to-rdf:
	@for FILE_PATH in ${TURTLE_FILELIST}; do \
		echo Converting $${FILE_PATH} into RDF/XML; \
		rdfpipe -i turtle -o  application/rdf+xml $${FILE_PATH} > $${FILE_PATH%.*}.rdf; \
		echo Input in Turtle format;  \
		ls -lh $${FILE_PATH};  \
		echo " ==> Output in RDF/XML format";  \
		ls -lh $${FILE_PATH%.*}.rdf;  \
	done	

#make generate-html-docs-from-rdf RDF_FILE_PATH=../Documents/model2owl-2023/owl-core.rdf WIDOCO_OUTPUT_DIR_PATH=core-html
generate-html-docs-from-rdf: get-widoco
	@echo ${RDF_FILE_PATH}
	@java -jar widoco.jar -ontFile ${RDF_FILE_PATH} -outFolder ${WIDOCO_OUTPUT_DIR_PATH}  -getOntologyMetadata -uniteSections -webVowl

SHELL=/bin/bash -o pipefail
BUILD_PRINT = \e[1;34mSTEP:



