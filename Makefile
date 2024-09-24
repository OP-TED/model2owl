
# Model2owl directory
MODEL2OWL_FOLDER?=.
ABSOLUTE_MODEL2OWL_FOLDER?=$(shell realpath "${MODEL2OWL_FOLDER}")
# rdflib version
RDF_LIB_VERSION?=6.2.0
#Saxon path
SAXON?=${MODEL2OWL_FOLDER}/saxon/saxon.jar
JENA_RIOT_TOOL?=${MODEL2OWL_FOLDER}/jena/apache-jena-4.10.0/bin/riot
TEMP_FILE=./temp_file.txt
# Glossary output directory
OUTPUT_GLOSSARY_PATH?=output
# Convention report output directory
OUTPUT_CONVENTION_REPORT_PATH?=output
# Output folder path
OUTPUT_FOLDER_PATH?=output
# Input XMI/XML UML file path
XMI_INPUT_FILE_PATH?=test/test-multi-xmi/ePO_CM.xml
#Input filename without extension
XMI_INPUT_FILENAME=$(shell basename -- "${XMI_INPUT_FILE_PATH}")
XMI_INPUT_FILENAME_WITHOUT_EXTENSION=$(shell echo ${XMI_INPUT_FILENAME} | cut -f1 -d '.')
# Output directory containing combined file from multiple xmi / xml UML models
XMI_MERGED_OUTPUT_FOLDER_PATH?=output/combined-xmi
MERGED_XMIS_FILE_NAME?=ontologies-combined.xmi
# Path to one of the xmi input files to be merged into a single UML xmi/xml file
# All XMIs files to combine need to be in the same directory
FIRST_XMI_TO_BE_MERGED_FILE_PATH?=test/test-multi-xmi/ePO_CM.xml
# Input directory containing files to be merged
MERGE_XMIS_FOLDER_NAME?=$(shell dirname ${FIRST_XMI_TO_BE_MERGED_FILE_PATH})
# Variables for converting in ttl/rdf
ONTOLOGY_FOLDER_PATH?=${OUTPUT_FOLDER_PATH}
RDF_FILELIST=$(shell ls ${ONTOLOGY_FOLDER_PATH}/*.rdf)
TURTLE_FILELIST=$(shell ls ${ONTOLOGY_FOLDER_PATH}/*.ttl)
# Widoco variables
WIDOCO_RDF_INPUT_FILE_PATH?=test/reasoning-investigation/model-2020-12-16/ePO_restrictions.rdf
WIDOCO_OUTPUT_FOLDER_PATH?=output/widoco
NAMESPACES_USER_XML_FILE_PATH?=${MODEL2OWL_FOLDER}/test/ePO-default-config/namespaces.xml
INTERM_FOLDER_PATH?=${ABSOLUTE_MODEL2OWL_FOLDER}/.temp
ENRICHED_NAMESPACES_XML_PATH:=${INTERM_FOLDER_PATH}/enriched-namespaces.xml
NAMESPACES_AS_RDFPIPE_ARGS=$(shell ${MODEL2OWL_FOLDER}/scripts/get_namespaces.sh ${ENRICHED_NAMESPACES_XML_PATH})
RDF_XML_MIME_TYPE:='application/rdf+xml'
TURTLE_MIME_TYPE:='turtle'

# download saxon library 	
get-saxon:
	@echo Installing saxon
	@mkdir -p ${MODEL2OWL_FOLDER}/saxon
	@cd ${MODEL2OWL_FOLDER}/saxon  && curl -L -o saxon.zip "https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip
	@cd ${MODEL2OWL_FOLDER}/saxon && mv saxon-he-10.6.jar saxon.jar
	@echo 'Saxon path is ${SAXON}'

get-jena-cli-tools:
	@echo Installing jena-cli-tools
	@mkdir -p ${MODEL2OWL_FOLDER}/jena
	@cd ${MODEL2OWL_FOLDER}/jena  && curl -L -o jena.zip "https://dlcdn.apache.org/jena/binaries/apache-jena-4.10.0.zip" && unzip jena.zip && rm -rf jena.zip
	@echo 'Jena riot tool path is ${JENA_RIOT_TOOL}'

# install rdflib
get-rdflib:
	@echo Installing rdflib
	@source model2owl-venv/bin/activate && pip install rdflib

get-widoco:
	@echo Installing widoco
	@mkdir -p ${MODEL2OWL_FOLDER}/widoco
	@cd ${MODEL2OWL_FOLDER}/widoco  && curl -L -o widoco.jar "https://github.com/dgarijo/Widoco/releases/download/v1.4.17/java-11-widoco-1.4.17-jar-with-dependencies.jar"

######################################################################################
# Download, install saxon, xspec, rdflib and other dependencies
######################################################################################
install:  get-saxon create-virtual-env get-rdflib get-widoco

############################ Main tasks ##############################################
# Run unit_tests
unit-tests:
	@make test-prerequisites
	@mvn install -Dsaxon.options.enrichedNamespacesPath=${ENRICHED_NAMESPACES_XML_PATH}

# Actions required in order to setup the environment for testing purposes.
# Usage (`[]` denotes an optional argument; if omited, default value will be used):
# make test-prerequisites [NAMESPACES_USER_XML_FILE_PATH=/path/to/namespaces.xml]
# where:
#   NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file provided by a user
test-prerequisites:
	@make gen-enriched-ns-file

create-virtual-env:
	@python -m venv model2owl-venv


# Generate the glossary from an input file
# Usage (`[]` denotes an optional argument; if omited, default value will be used):
# make generate-glossary [XMI_INPUT_FILE_PATH=/path/to/cm.xmi] 
#	[OUTPUT_GLOSSARY_PATH=/output/directory]
#	[NAMESPACES_USER_XML_FILE_PATH=/path/to/namespaces.xml]
# where:
#   NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file provided by a user
#
# Example when not using the default variables
# make generate-glossary XMI_INPUT_FILE_PATH=/home/mypc/work/model2owl/eNotice_CM.xml OUTPUT_GLOSSARY_PATH=/home/mypc/work/model2owl/glossary
generate-glossary:
	@mkdir -p "${OUTPUT_GLOSSARY_PATH}"
	@make gen-enriched-ns-file
	@echo Input file path: ${XMI_INPUT_FILE_PATH}
	@echo Input file name: ${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}
	@cp -rf ./src/static "${OUTPUT_GLOSSARY_PATH}"
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} \
		-xsl:${MODEL2OWL_FOLDER}/src/html-model-glossary.xsl \
		-o:${OUTPUT_GLOSSARY_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_glossary.html \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}"
	@echo The glossary is located at the following location:
	@echo
	@ls -lh ${OUTPUT_GLOSSARY_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_glossary.html
	@echo

# Usage of the convention report generation recipes (generate-convention-report | generate-convention-SVRL-report).
# `[]` denotes an optional argument; if omited, default value will be used:
# make (generate-convention-report | generate-convention-SVRL-report) 
#	[XMI_INPUT_FILE_PATH=/path/to/cm.xmi] 
#	[OUTPUT_CONVENTION_REPORT_PATH=/output/directory]
#	[NAMESPACES_USER_XML_FILE_PATH=/path/to/namespaces.xml]
# where:
#   NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file provided by a user
generate-convention-report:
	@mkdir -p "${OUTPUT_CONVENTION_REPORT_PATH}"
	@make gen-enriched-ns-file
	@echo Input file path: ${XMI_INPUT_FILE_PATH}
	@echo Input file name: ${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}
	@cp -rf ./src/static "${OUTPUT_CONVENTION_REPORT_PATH}"
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} \
		-xsl:${MODEL2OWL_FOLDER}/src/html-conventions-report.xsl \
		-o:${OUTPUT_CONVENTION_REPORT_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_convention_report.html \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}"
	@echo The convention report is located at the following location:
	@echo
	@ls -lh ${OUTPUT_CONVENTION_REPORT_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_convention_report.html
	@echo

generate-convention-SVRL-report:
	@mkdir -p "${OUTPUT_CONVENTION_REPORT_PATH}"
	@make gen-enriched-ns-file
	@echo Input file path: ${XMI_INPUT_FILE_PATH}
	@echo Input file name: ${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}
	@cp -rf ./src/static "${OUTPUT_CONVENTION_REPORT_PATH}"
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} \
		-xsl:${MODEL2OWL_FOLDER}/src/svrl-conventions-report.xsl \
		-o:${OUTPUT_CONVENTION_REPORT_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_convention_svrl_report.xml \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}"
	@echo The convention report is located at the following location:
	@echo
	@ls -lh ${OUTPUT_CONVENTION_REPORT_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_convention_svrl_report.xml
	@echo


# Usage of the transformation recipes (owl-core | owl-restrictions | shacl).
# `[]` denotes an optional argument; if omited, default value will be used:
# make (owl-core | owl-restrictions | shacl) [XMI_INPUT_FILE_PATH=/path/to/cm.xmi] 
#	[OUTPUT_FOLDER_PATH=/output/directory]
#	[NAMESPACES_USER_XML_FILE_PATH=/path/to/namespaces.xml]
# where:
#   NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file provided by a user
#
# Example:
# make owl-core XMI_INPUT_FILE_PATH=/home/mypc/work/model2owl/eNotice_CM.xml OUTPUT_FOLDER_PATH=./my-folder
owl-core:
	@make gen-enriched-ns-file
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/owl-core.xsl \
		-o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}.tmp.rdf \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}"
	@make convert-between-serialization-formats INPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		OUTPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}.tmp.rdf \
		OUTPUT_FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}.rdf
	@echo Output owl core file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}.rdf
	@rm -f ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}.tmp.rdf

owl-restrictions:
	@make gen-enriched-ns-file
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/owl-restrictions.xsl \
		-o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_restrictions.tmp.rdf \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}"
	@make convert-between-serialization-formats INPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		OUTPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_restrictions.tmp.rdf \
		OUTPUT_FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_restrictions.rdf
	@echo Output owl restrictions file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_restrictions.rdf
	@rm -f ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_restrictions.tmp.rdf

shacl:
	@make gen-enriched-ns-file
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/shacl-shapes.xsl \
		-o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.tmp.rdf \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}"
	@make convert-between-serialization-formats INPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		OUTPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.tmp.rdf \
		OUTPUT_FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.rdf
	@echo Output shacl file location:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.rdf
	@rm -f ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.tmp.rdf

# Generate enriched namespaces XML file which contains user namespaces (defined
# in namespaces.xml) and internal namespaces (such as core-shape)
# Usage (`[]` denotes an optional argument; if omited, default value will be used):
# make gen-enriched-ns-file [NAMESPACES_USER_XML_FILE_PATH=/path/to/namespaces.xml]
# where:
#   NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file provided by a user
gen-enriched-ns-file:
	@mkdir -p ${INTERM_FOLDER_PATH}
	@java -jar ${SAXON} -s:${NAMESPACES_USER_XML_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/xml/enriched-namespaces.xsl \
		-o:${ENRICHED_NAMESPACES_XML_PATH}

# Combine xmi UML files
# all files for combine should be in test/test-multi-xmi (or in XMI_MERGED_OUTPUT_FOLDER_PATH)
merge-xmi:
	@mkdir -p ${XMI_MERGED_OUTPUT_FOLDER_PATH}
	@java -jar ${SAXON} -s:${FIRST_XMI_TO_BE_MERGED_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/xml/merge-multi-xmi.xsl -o:${XMI_MERGED_OUTPUT_FOLDER_PATH}/${MERGED_XMIS_FILE_NAME}
	@echo Input files to be combined are located at the directory containing this input file: ${FIRST_XMI_TO_BE_MERGED_FILE_PATH} under directory ${MERGE_XMIS_FOLDER_NAME}
	@ls -lh ${MERGE_XMIS_FOLDER_NAME}
	@echo 
	@echo "==> The combined document is located at the following location" 
	@ls -lh ${XMI_MERGED_OUTPUT_FOLDER_PATH}/${MERGED_XMIS_FILE_NAME}




# Example how to run converting commands (`[]` denotes an optional argument;
#  if omited, default value will be used):
# make convert-to-turtle [ONTOLOGY_FOLDER_PATH=./my-folder] 
#	[NAMESPACES_USER_XML_FILE_PATH=/path/to/namespaces.xml]
# where:
# ONTOLOGY_FOLDER_PATH: the path to the folder containing .rdf files for 
#						converting to turtle or .ttl files to convert to rdf
# NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file provided by a user
convert-rdf-to-turtle:
	@make gen-enriched-ns-file
	@for FILE_PATH in ${RDF_FILELIST}; do \
		echo Converting $${FILE_PATH} into Turtle; \
		source model2owl-venv/bin/activate; \
		make convert-between-serialization-formats \
			INPUT_FORMAT=${RDF_XML_MIME_TYPE} \
			OUTPUT_FORMAT=${TURTLE_MIME_TYPE}  \
			FILE_PATH=$${FILE_PATH}  \
			OUTPUT_FILE_PATH=$${FILE_PATH%.*}.ttl \
			USE_NAMESPACES=1; \
		echo Input in RDF/XML format;  \
		echo $${FILE_PATH};  \
		echo " ==> Output in Turtle format";  \
		ls -lh $${FILE_PATH%.*}.ttl;  \
	done
convert-turtle-to-rdf:
	@for FILE_PATH in ${TURTLE_FILELIST}; do \
		echo Converting $${FILE_PATH} into RDF/XML; \
		source model2owl-venv/bin/activate; \
		rdfpipe -i turtle -o  application/rdf+xml $${FILE_PATH} > $${FILE_PATH%.*}.rdf; \
		echo Input in Turtle format;  \
		ls -lh $${FILE_PATH};  \
		echo " ==> Output in RDF/XML format";  \
		ls -lh $${FILE_PATH%.*}.rdf;  \
	done	

convert-rdf-to-jsonld:
	@for FILE_PATH in ${RDF_FILELIST}; do \
		echo Converting $${FILE_PATH} into JSON-LD; \
		source model2owl-venv/bin/activate; \
		rdfpipe -i application/rdf+xml -o json-ld  $${FILE_PATH} > $${FILE_PATH%.*}.json; \
		echo Input in RDF/XML format;  \
		echo $${FILE_PATH};  \
		echo " ==> Output in JSON-LD format";  \
		ls -lh $${FILE_PATH%.*}.json;  \
	done
convert-rdf-to-rdf:
	@for FILE_PATH in ${RDF_FILELIST}; do \
		echo Converting $${FILE_PATH} into RDF/XML; \
		source model2owl-venv/bin/activate; \
		rdfpipe -i application/rdf+xml -o application/rdf+xml $${FILE_PATH} > $${FILE_PATH%.*}.rdf2; \
		mv -v $${FILE_PATH%.*}.rdf2 $${FILE_PATH%.*}.rdf; \
		echo Input in RDF/XML format;  \
		ls -lh $${FILE_PATH};  \
		echo " ==> Output in RDF/XML format";  \
		ls -lh $${FILE_PATH%.*}.rdf;  \
	done

# A generic recipe for converting RDF data from one serialization format to 
# another. It can also be used to regenerate a file using the same format.
# 
# Arguments:
# 	FILE_PATH: Input RDF file in any allowed serialization format
# 	OUTPUT_FILE_PATH: Path for the output file
# 	INPUT_FORMAT: a MIME type of the given input RDF file
# 	OUTPUT_FORMAT: a MIME type of any of the valid RDF serializations
#   USE_NAMESPACES: optional; if non-empty then namespaces (from the
#                   enriched-namespaces.xml file). This can be used if the input
#                   (FILE_PATH) doesn't include namespaces we want to be applied
#                   (e.g. to have compact instead of full URIs in the output
#                   file).
#					
# Supported MIME types: https://rdflib.readthedocs.io/en/7.0.0/plugin_serializers.html
# 	
# Example:
# make convert-between-serialization-formats
#   INPUT_FORMAT='application/rdf+xml'
#   OUTPUT_FORMAT='application/rdf+xml' 
#   FILE_PATH=output/ePO_core.tmp.rdf 
#   OUTPUT_FILE_PATH=output/ePO_core.rdf
# 	USE_NAMESPACES=1
convert-between-serialization-formats:
	@source model2owl-venv/bin/activate; \
	rdfpipe -i ${INPUT_FORMAT} -o ${OUTPUT_FORMAT} \
		$(if $(USE_NAMESPACES),${NAMESPACES_AS_RDFPIPE_ARGS}) \
		${FILE_PATH} > ${OUTPUT_FILE_PATH}

# make validate-rdf-file FILE_TO_VALIDATE_PATH=./output/eFulfilment.rdf
validate-rdf-file:
	@$(JENA_RIOT_TOOL) --validate $(FILE_TO_VALIDATE_PATH)


#make generate-html-docs-from-rdf WIDOCO_RDF_INPUT_FILE_PATH=../Documents/model2owl-2023/owl-core.rdf WIDOCO_OUTPUT_FOLDER_PATH=core-html
generate-html-docs-from-rdf: get-widoco
	@echo ${WIDOCO_RDF_INPUT_FILE_PATH}
	@java -jar widoco/widoco.jar -ontFile ${WIDOCO_RDF_INPUT_FILE_PATH} -outFolder ${WIDOCO_OUTPUT_FOLDER_PATH}  -getOntologyMetadata -uniteSections -webVowl

SHELL=/bin/bash -o pipefail
BUILD_PRINT = \e[1;34mSTEP:



