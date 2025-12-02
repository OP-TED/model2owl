# architecture (e.g. amd64, arm64)
ARCH?=amd64
# Model2owl directory
MODEL2OWL_FOLDER?=.
ABSOLUTE_MODEL2OWL_FOLDER?=$(shell realpath "${MODEL2OWL_FOLDER}")
# rdflib version
RDF_LIB_VERSION?=6.2.0
#Saxon path
SAXON?=${MODEL2OWL_FOLDER}/saxon/saxon.jar
JENA_RIOT_TOOL?=${MODEL2OWL_FOLDER}/jena/apache-jena-4.10.0/bin/riot
JQ=${MODEL2OWL_FOLDER}/jq/jq
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
IMPORTS_XML_FILE_PATH?=${ABSOLUTE_MODEL2OWL_FOLDER}/test/ePO-default-config/imports.xml
INTERM_FOLDER_PATH?=${ABSOLUTE_MODEL2OWL_FOLDER}/.temp
ENRICHED_NAMESPACES_XML_PATH:=${INTERM_FOLDER_PATH}/enriched-namespaces.xml
NAMESPACES_AS_RDFPIPE_ARGS=$(shell ${MODEL2OWL_FOLDER}/scripts/get_namespaces.sh ${ENRICHED_NAMESPACES_XML_PATH})
RDF_XML_MIME_TYPE:='application/rdf+xml'
TURTLE_MIME_TYPE:='turtle'
JSONLD_CONTEXT_INDENTATION?=2

# respec variables with default values
RESPEC_JSON_INDENTATION?=2
RESPEC_DATA_JSON_PATH?=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec.json
MODEL_DATA_JSON_PATH?=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec.json
RESPEC_CFG_JSON_PATH?=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec-cfg.json
RESPEC_METADATA_JSON_PATH?=${ABSOLUTE_MODEL2OWL_FOLDER}/test/ePO-default-config/metadata.json
RESPEC_INPUT_ASSETS_DIR=${ABSOLUTE_MODEL2OWL_FOLDER}/respec-resources/assets
INPUT_SDS_FILES_JSON_LOCATION=.metadata.projectLocalResources
TARGET_SDS_FILES_JSON_LOCATION=.assets.sdsSection
RESPEC_OUTPUT_DIR?=${OUTPUT_FOLDER_PATH}/respec
RESPEC_SDS_OUTPUT_DIR=${RESPEC_OUTPUT_DIR}/sds

# download saxon library
get-saxon: saxon/saxon.jar

saxon/saxon.jar:
	@echo Installing saxon
	mkdir -p saxon
	cd saxon  && curl -L -o saxon.zip "https://sourceforge.net/projects/saxon/files/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip
	cd saxon && mv saxon-he-10.6.jar saxon.jar
	@echo 'Saxon path is saxon/saxon.jar'

get-jena-cli-tools: jena/apache-jena/bin/riot

jena/apache-jena/bin/riot:
	@echo Installing jena-cli-tools
	mkdir -p jena
	cd jena  && curl -L -o jena.zip "https://archive.apache.org/dist/jena/binaries/apache-jena-5.3.0.zip" && unzip jena.zip && rm -rf jena.zip && ln -s apache-jena-* apache-jena
	@echo 'Jena riot tool path is jena/apache-jena/bin/riot'

get-jq: jq/jq

jq/jq:
	mkdir jq
	cd jq  && curl -L -o jq https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-${ARCH} && chmod +x jq

# install rdflib
get-rdflib: model2owl-venv/bin/rdfpipe

model2owl-venv/bin/rdfpipe: model2owl-venv
	@echo Installing rdflib
	source model2owl-venv/bin/activate && pip install rdflib

get-widoco: widoco/widoco.jar

get-jinja:
	@echo Installing jinja
	@source model2owl-venv/bin/activate && pip install jinja-cli

widoco/widoco.jar:
	@echo Installing widoco
	mkdir widoco
	cd widoco  && curl -L -o widoco.jar "https://github.com/dgarijo/Widoco/releases/download/v1.4.17/java-11-widoco-1.4.17-jar-with-dependencies.jar"

get-python-test-deps:
	@echo Installing test dependencies
	source model2owl-venv/bin/activate && pip install -r requirements-test.txt

######################################################################################
# Download, install saxon, xspec, rdflib and other dependencies
######################################################################################
install:  get-saxon get-rdflib get-widoco get-jena-cli-tools get-jinja get-jq

############################ Main tasks ##############################################
# Run all tests
test: unit-tests functional-tests
	@mvn surefire-report:report-only

# Run functional tests in Python
functional-tests: .deps_installed
	@mvn exec:exec@run-pytest

.deps_installed: requirements-test.txt
	@make get-python-test-deps
	touch .deps_installed

# Run unit tests in XSpec
unit-tests:
	@make test-prerequisites
	@mvn xspec:run-xspec \
		-Dsaxon.options.enrichedNamespacesPath=${ENRICHED_NAMESPACES_XML_PATH} \
		-Dsaxon.options.importsPath=${IMPORTS_XML_FILE_PATH}

# Actions required in order to setup the environment for testing purposes.
# Usage (`[]` denotes an optional argument; if omited, default value will be used):
# make test-prerequisites [NAMESPACES_USER_XML_FILE_PATH=/path/to/namespaces.xml]
# where:
#   NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file provided by a user
test-prerequisites:
	@make gen-enriched-ns-file

create-virtual-env: model2owl-venv

model2owl-venv:
	python3 -m venv model2owl-venv


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
#	[IMPORTS_XML_FILE_PATH=/path/to/imports.xml]
# where:
#   NAMESPACES_USER_XML_FILE_PATH: path to the *.xml file containing namespaces provided by a user
#	IMPORTS_XML_FILE_PATH: path to the *.xml file containing URIs to be imported provided by a user
#
# Example:
# make owl-core XMI_INPUT_FILE_PATH=/home/mypc/work/model2owl/eNotice_CM.xml OUTPUT_FOLDER_PATH=./my-folder
owl-core:
	@make gen-enriched-ns-file
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/owl-core.xsl \
		-o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}.tmp.rdf \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}" \
		importsPath="${IMPORTS_XML_FILE_PATH}"
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
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}" \
		importsPath="${IMPORTS_XML_FILE_PATH}"
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
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}" \
		importsPath="${IMPORTS_XML_FILE_PATH}"
	@make convert-between-serialization-formats INPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		OUTPUT_FORMAT=${RDF_XML_MIME_TYPE} \
		FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.tmp.rdf \
		OUTPUT_FILE_PATH=${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.rdf
	@echo Output shacl file location:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.rdf
	@rm -f ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_shapes.tmp.rdf

respec-json:
	@make gen-enriched-ns-file
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/rspec-json-generate.xsl \
		-o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec.json.tmp \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}" \
		importsPath="${IMPORTS_XML_FILE_PATH}"
	@# reformat the JSON file to be more readable
	@cat ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec.json.tmp \
		| python3 -c "import sys, json; \
		data = json.load(sys.stdin); \
		print(json.dumps(data, sort_keys=True, indent=int(${RESPEC_JSON_INDENTATION})))" \
		> ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec.json
	@echo Output respec json file location:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec.json
	@rm -f ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec.json.tmp

respec-cfg-json:
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/rspec-cfg-json-generate.xsl \
		-o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec-cfg.json.tmp \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}" \
		importsPath="${IMPORTS_XML_FILE_PATH}"
	@# reformat the JSON file to be more readable
	@cat ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec-cfg.json.tmp \
		| python3 -c "import sys, json; \
		data = json.load(sys.stdin); \
		print(json.dumps(data, sort_keys=True, indent=int(${RESPEC_JSON_INDENTATION})))" \
		> ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec-cfg.json
	@echo Output respec json file location:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec-cfg.json
	@rm -f ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_respec-cfg.json.tmp
	
# make generate-jsonld-context [XMI_INPUT_FILE_PATH=/path/to/cm.xmi] 
#	[OUTPUT_FOLDER_PATH=/output/directory]
#   [JSONLD_CONTEXT_INDENTATION=indentation_size]
# where:
#   JSONLD_CONTEXT_INDENTATION: Indentation for the generated file (defaults to 2 spaces)
generate-jsonld-context:
	@make gen-enriched-ns-file
	@java -jar ${SAXON} -s:${XMI_INPUT_FILE_PATH} -xsl:${MODEL2OWL_FOLDER}/src/jsonld-context.xsl \
		-o:${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_context.jsonld.tmp \
		enrichedNamespacesPath="${ENRICHED_NAMESPACES_XML_PATH}"
	@# reformat the JSON-LD context file to be more readable
	@cat ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_context.jsonld.tmp \
		| python3 -c "import sys, json; \
		data = json.load(sys.stdin); \
		print(json.dumps(data, sort_keys=True, indent=int(${JSONLD_CONTEXT_INDENTATION})))" \
		> ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_context.jsonld

	@echo Output JSON-LD context file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_context.jsonld
	@rm -f ${OUTPUT_FOLDER_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_context.jsonld.tmp

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

# Creates ReSpec HTML documentation package for an ontology.
# Steps performed:
#  1. Optionally generates a ReSpec JSON data file (if not provided).
#  2. Copies static assets and ontology artefacts (OWL, SHACL, JSON-LD, UML
#     files) to the ReSpec package directory.
#  3. Updates the metadata JSON to reference all included artefacts.
#  4. Merges metadata and data JSON files for use in documentation generation.
#  5. Renders the final HTML documentation using Jinja templates.
#
# Usage (`[]` denotes an optional argument; if omited, default value will be used):
# make generate-respec-new 
#	[RESPEC_OUTPUT_DIR=/output/respec_package]
#	[RESPEC_DATA_JSON_PATH=/path/to/respec-data.json]
#	[RESPEC_METADATA_JSON_PATH=/path/to/metadata.json]
#	[RESPEC_INPUT_ASSETS_DIR=/path/to/static/assets]
#	[XMI_INPUT_FILE_PATH=/path/to/model.xmi]
#	[OUTPUT_FOLDER_PATH=/path/to/generated/model2owl/artefacts]
# where:
#   RESPEC_OUTPUT_DIR: Output directory for the documentation package.
#   RESPEC_DATA_JSON_PATH: (Optional) Path to the ReSpec data JSON file.
#   RESPEC_METADATA_JSON_PATH: Path to the metadata JSON file.
#   RESPEC_INPUT_ASSETS_DIR: Directory containing static assets (images, examples, etc.).
#   XMI_INPUT_FILE_PATH: (Optional) Path to the UML XMI model file needed for
#						 generating the ReSpec data JSON file (if not given).
#   OUTPUT_FOLDER_PATH: (Optional) Directory where a ReSpec data JSON file 
#						should be stored (if not given).
generate-respec:
	@## Add a key-value artefact entry to the metadata JSON file. \
	extend_metadata_json() { \
		local json_file="$$1"; \
		local key="$$2"; \
		local value="$$3"; \
		tmp=$$(mktemp --suffix=".json"); \
		$(JQ) --arg k "$$key" --arg v "$$value" '${TARGET_SDS_FILES_JSON_LOCATION} += [{"name": $$k, "path": $$v}]' "$$json_file" > $$tmp && mv $$tmp "$$json_file"; \
		rm -f $$tmp; \
	}; \
	\
	## Copy artefact to target ReSpec directory and records its relative path in metadata JSON. \
	handle_artefact_file() { \
		local json_file="$$1"; \
		local artefact_name="$$2"; \
		local artefact_path="$$3"; \
		local output_dir="${RESPEC_SDS_OUTPUT_DIR}"; \
		local respec_root_dir="${RESPEC_OUTPUT_DIR}"; \
		if [ -f "$$artefact_path" ]; then \
			cp "$$artefact_path" "$$output_dir"; \
			file_name_without_path=$$(basename "$$artefact_path"); \
			rel_path=""; \
			pushd "$$respec_root_dir" > /dev/null; \
			rel_path=$$(find . -name "$$file_name_without_path" | head -n 1); \
			popd > /dev/null; \
			extend_metadata_json "$$json_file" "$$artefact_name" "$$rel_path"; \
		else \
			echo "[WARN] Artefact '$$artefact_name' not found at '$$artefact_path'" >&2; \
		fi; \
	}; \
	\
	mkdir -p ${RESPEC_SDS_OUTPUT_DIR}; \
	\
	# Copy any provided artefacts to the target directory and update file paths in the metadata JSON \
	ext_md_json=$$(mktemp --suffix=".json"); \
	cp -f ${RESPEC_METADATA_JSON_PATH} $$ext_md_json; \
	# Loop over each object in projectLocalResources \
	jq -c '${INPUT_SDS_FILES_JSON_LOCATION}[]' $$ext_md_json | while read -r item; do \
		# Extract name and path \
		name=$$(echo "$$item" | jq -r '.name') ; \
		path=$$(echo "$$item" | jq -r '.path') ; \
		\
		handle_artefact_file $$ext_md_json "$$name" "$$path" ; \
	done ; \
	\
	# remove any existing projectLocalResources entry as it is no longer needed in the working metadata JSON \
	ext_md_json_updated=$$(mktemp --suffix=".json"); \
	jq 'del(${INPUT_SDS_FILES_JSON_LOCATION})' $$ext_md_json > $$ext_md_json_updated; \
	\
	# generate a respec data JSON if not provided \
	if [ ! -e ${RESPEC_DATA_JSON_PATH} ]; then \
		echo "Generating a ReSpec JSON data file..."; \
		$(MAKE) respec-json XMI_INPUT_FILE_PATH=${XMI_INPUT_FILE_PATH} OUTPUT_FOLDER_PATH=${OUTPUT_FOLDER_PATH} ; \
	fi; \
	\
	# generate a respec config JSON file \
	$(MAKE) respec-cfg-json XMI_INPUT_FILE_PATH=${XMI_INPUT_FILE_PATH} OUTPUT_FOLDER_PATH=${OUTPUT_FOLDER_PATH} ; \
	# merge the metadata and data JSON files into a single JSON file to be used \
	# for generating the respec document \
	merged_json=$$(mktemp --suffix=".json"); \
	$(JQ) -s 'reduce .[] as $$item ({}; . * $$item)' ${RESPEC_DATA_JSON_PATH} ${RESPEC_CFG_JSON_PATH} $$ext_md_json_updated > $$merged_json; \
	\
	# copy other static assets (e.g. images, examples) to the output folder \
	cp -rf ${RESPEC_INPUT_ASSETS_DIR} ${RESPEC_OUTPUT_DIR}; \
	\
	# run jinja to generate the respec document \
	source model2owl-venv/bin/activate; \
	jinja -d $$merged_json respec-resources/templates/main.j2 -o ${RESPEC_OUTPUT_DIR}/index.html; \
	\
	echo "Output respec package:"; \
	ls -ldh ${RESPEC_OUTPUT_DIR}; \
	command -v tree > /dev/null 2>&1 && tree "${RESPEC_OUTPUT_DIR}"; \
	rm -f $$merged_json $$ext_md_json $$ext_md_json_updated

# Usage (`[]` denotes an optional argument; if omited, default value will be used):
# make generate-asciidoc-glossary
#	[XMI_INPUT_FILE_PATH=/path/to/model.xmi]
#	[MODEL_DATA_JSON_PATH=/path/to/respec-data.json]
#	[OUTPUT_GLOSSARY_PATH=/output/glossary_directory]
#	[OUTPUT_FOLDER_PATH=/path/to/generated/model2owl/artefacts]
# where:
#   XMI_INPUT_FILE_PATH: (Optional) Path to the UML XMI model file needed for
#						 generating the ReSpec data JSON file (if not given).
#   MODEL_DATA_JSON_PATH: (Optional) Path to the ReSpec data JSON file.
#						  If not given, it will be generated.
#   OUTPUT_GLOSSARY_PATH: Output directory for the glossary package.
#   OUTPUT_FOLDER_PATH: (Optional) Directory to store the generated model data
#   					JSON if MODEL_DATA_JSON_PATH is not given; if not set,
# 						then the default directory is used.
#
generate-asciidoc-glossary:
	@mkdir -p "${OUTPUT_GLOSSARY_PATH}"; \
	## generate a model data JSON if not provided \
	GEN_MODEL_DATA_JSON=0; \
	if [ ! -e ${MODEL_DATA_JSON_PATH} ]; then \
		echo "Generating a model data JSON file..."; \
		$(MAKE) respec-json XMI_INPUT_FILE_PATH=${XMI_INPUT_FILE_PATH} \
			OUTPUT_FOLDER_PATH=${OUTPUT_FOLDER_PATH} ; \
		MODEL_DATA_JSON_PATH=$$(find "${OUTPUT_FOLDER_PATH}" -maxdepth 1 -name '*_respec.json' | head -n 1); \
		GEN_MODEL_DATA_JSON=1; \
	fi; \
	\
	## get value of a config parameter from the correct XSL config file \
	generate_reused_concepts=$$( \
		printf '%s\n' \
		'<?xml version="1.0"?>' \
		'<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' \
		'  <xsl:import href="config-proxy.xsl"/>' \
		'  <xsl:output method="text"/>' \
		'  <xsl:template match="/">' \
		'    <xsl:value-of select="$$generateReusedConceptsGlossary"/>' \
		'  </xsl:template>' \
		'</xsl:stylesheet>' \
		| java -jar $(SAXON) -xsl:- -s:<(printf '<nil/>'); \
	); \
	if [ "$$generate_reused_concepts" = "true" ]; then \
	    echo "Generating AsciiDoc glossary with reused concepts ..."; \
	else \
	    echo "Generating AsciiDoc glossary without reused concepts ..."; \
	fi ; \
	\
	## run jinja to generate the respec document \
	source model2owl-venv/bin/activate; \
	jinja -d ${MODEL_DATA_JSON_PATH} \
		-D generate_reused_concepts $$generate_reused_concepts \
		glossary-resources/asciidoc-glossary.j2 \
		-o ${OUTPUT_GLOSSARY_PATH}/${XMI_INPUT_FILENAME_WITHOUT_EXTENSION}_glossary.adoc ; \
	\
	echo "Output glossary directory:"; \
	ls -ldh ${OUTPUT_GLOSSARY_PATH}; \
	if [ "$$GEN_MODEL_DATA_JSON" -eq 1 ]; then \
		echo "Generated model data JSON: $$MODEL_DATA_JSON_PATH"; \
	fi; \
 	command -v tree > /dev/null 2>&1 && tree "${OUTPUT_GLOSSARY_PATH}"

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



