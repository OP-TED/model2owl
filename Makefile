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
MODEL2OWL_DIR?="."
# Project directory, ie. directory where we store the input/output from model2owl
PROJECT_DIR?=".."
# One of the xmi input files to be merged into a single UML xmi/xml file
FIRST_INPUT_XMI_FILE?="test/test-multi-xmi/ePO_CM.xml"
# Input dir containing files to be merged
INPUT_XMI_DIR?=$(shell dirname ${FIRST_INPUT_XMI_FILE})
# rdflib version
RDF_LIB_VERSION?=6.2.0
SAXON?="../saxon-he-10.6.jar"
# Output directory containing combined file from multiple xmi / xml UML models
COMBINED_XMI_DIRECTORY?="output/combined-xmi"
COMBINED_FILE_NAME?=ePO-combined.xmi
XMI_DIRECTORY?="../output/combined-xmi"
# Glossary output directory
OUTPUT_GLOSSARY_PATH?="output/glossary"

# Input XMI/XML UML file path
UML_INPUT_FILENAME?="test/test-multi-xmi/ePO_CM.xml"
filename=$(shell basename -- "${UML_INPUT_FILENAME}") 
UML_FILENAME_WITHOUT_EXTENSION=$(shell echo ${filename} | cut -f1 -d '.')
RDF_FILE_PATH?="../file.rdf"
WIDOCO_OUTPUT_DIRECTORY_NAME?="widoco"

OUTPUT_CORE_FILE_NAME?="ePO_CM-core.rdf"
OUTPUT_RESTRICTIONS_FILE_NAME?="ePO_CM-restrictions.rdf"
OUTPUT_SHACL_SHAPES_FILE_NAME?="ePO_CM-shacl.rdf"

# Output ontologies
OUTPUT_FOLDER_PATH?="../output/epo-ontologies"
ONTOLOGY_DIR?=${OUTPUT_FOLDER_PATH}
FILELIST=$(shell ls ${ONTOLOGY_DIR}/*.rdf)
TURTLE_FILELIST=$(shell ls ${ONTOLOGY_DIR}/*.ttl)
# download saxon library 	
get-saxon:
	@cd ${PROJECT_DIR}  && curl -L -o saxon.zip "https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip

# Clone model2owl if the directory model2owl does not exist
#get-model2owl-repo:	
#	@git clone https://github.com/OP-TED/model2owl.git
	
# download xspec framework to run unit tests
get-xspec:	
	@cd ${PROJECT_DIR}  && rm -rf xspec && curl -L -o xspec.zip https://github.com/xspec/xspec/archive/refs/tags/v2.2.4.zip && unzip xspec.zip -d model2owl && rm -rf xspec.zip && cd model2owl && ln -s xspec-* xspec

# install rdflib
get-rdflib:
	@echo please activate your virtual env first using the commands below
	@echo -- Create an virtual environment    
	@echo pip install virtualenv
	@echo virtualenv venv
	@echo -- Activate your venv
	@echo source venv/bin/activate
	@echo -- Install rdflib inside your virtual environment
	@pip install rdflib

# activate a virtual env
activate-venv:
	@echo virtualenv venv
	@echo -- Activate your venv
	@echo source venv/bin/activate

######################################################################################
# Download, install saxon, xspec, rdflib and other dependencies
######################################################################################
init:  get-saxon  get-xspec get-rdflib

############################ Main tasks ##############################################
# Run unit_tests
unit-tests:
	@mvn install

update-metadata.xml-to-test-data:
	@echo "${MODEL2OWL_DIR}/test/testData ${MODEL2OWL_DIR}/test/test-multi-xmi ${MODEL2OWL_DIR}/test/test-merge-xmi" | xargs -n 1 cp -v ${MODEL2OWL_DIR}/config/metadata.xml

# Combine xmi UML files
# all files for combine should be in test/test-multi-xmi
merge-xmi:
	@mkdir -p ${COMBINED_XMI_DIRECTORY}
	@java -jar ${SAXON} -s:${FIRST_INPUT_XMI_FILE} -xsl:${MODEL2OWL_DIR}/src/xml/merge-multi-xmi.xsl -o:${COMBINED_XMI_DIRECTORY}/${COMBINED_FILE_NAME}
	@echo Input files to be combined are located at the directory containing this input file: ${FIRST_INPUT_XMI_FILE} under directory ${INPUT_XMI_DIR}
	@ls -lh ${INPUT_XMI_DIR}
	@echo 
	@echo "==> The combined document is located at the following location" 
	@ls -lh ${COMBINED_XMI_DIRECTORY}/${COMBINED_FILE_NAME}

# Generate the glossary from an input file
generate-glossary:
	@mkdir -p "${OUTPUT_GLOSSARY_PATH}"
	@echo Input: ${UML_INPUT_FILENAME}
	@echo Input without extension: ${UML_FILENAME_WITHOUT_EXTENSION}
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/html-model-glossary.xsl -o:${OUTPUT_GLOSSARY_PATH}/${UML_FILENAME_WITHOUT_EXTENSION}-glossary.html
	@echo The combined glossary is located at the following location:
	@echo
	@ls -lh ${OUTPUT_GLOSSARY_PATH}/${UML_FILENAME_WITHOUT_EXTENSION}-glossary.html
	@echo
	 
#Example how to run transformation commands :
# make owl-core UML_INPUT_FILENAME=/home/mypc/work/model2owl/eNotice_CM.xml OUTPUT_FOLDER_PATH=./my-folder
owl-core:
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/owl-core.xsl -o:${OUTPUT_FOLDER_PATH}/${OUTPUT_CORE_FILE_NAME}
	@echo Output owl core file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${OUTPUT_CORE_FILE_NAME}
owl-restrictions:
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/owl-restrictions.xsl -o:${OUTPUT_FOLDER_PATH}/${OUTPUT_RESTRICTIONS_FILE_NAME}
    @echo Output owl restrictions file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${OUTPUT_RESTRICTIONS_FILE_NAME}
shacl:
	@java -jar ${SAXON} -s:${UML_INPUT_FILENAME} -xsl:${MODEL2OWL_DIR}/src/shacl-shapes.xsl -o:${OUTPUT_FOLDER_PATH}/${OUTPUT_SHACL_SHAPES_FILE_NAME}
	@echo Output shacl file:
	@ls -lh ${OUTPUT_FOLDER_PATH}/${OUTPUT_SHACL_SHAPES_FILE_NAME}

transform: owl-core owl-restrictions shacl

#Example how to run transformation commands :
# make convert-to-turtle OUTPUT_FOLDER_PATH=./my-folder
# OUTPUT_FOLDER_PATH is the the path to the folder containing .rdf files for converting to turtle or .ttl files to convert to rdf
convert-to-turtle:
	@for filename in ${FILELIST}; do \
		echo Converting $${filename} into Turtle; \
		rdfpipe -i application/rdf+xml -o  turtle $${filename} > $${filename%.*}.ttl; \
		echo Input in RDF/XML format;  \
		ls -lh $${filename};  \
		echo " ==> Output in Turtle format";  \
		ls -lh $${filename%.*}.ttl;  \
	done
convert-to-rdf:
	@for filename in ${TURTLE_FILELIST}; do \
		echo Creating a backup of the originally rdf file generated by model2owl $${filename%.*}.rdf;\
		cp $${filename%.*}.rdf $${filename%.*}.rdf_model2owl;\
		echo Converting $${filename} into RDF/XML; \
		rdfpipe -i turtle -o  application/rdf+xml $${filename} > $${filename%.*}.rdf; \
		echo Input in Turtle format;  \
		ls -lh $${filename};  \
		echo " ==> Output in RDF/XML format";  \
		ls -lh $${filename%.*}.rdf;  \
	done	
#@for filename in $$(ls $$FILELIST ); do echo Converting ${filename}; python3 scripts/rdfxml2turtle.py --input  ${filename} --output ${filename%.*}.ttl;  echo Input in RDF/XML format;  ls -lh ${filename};  echo Output in Turtle format;  ls -lh ${filename%.*}.ttl;  done;
get-widoco:
	@curl -L -o widoco.jar "https://github.com/dgarijo/Widoco/releases/download/v1.4.17/java-11-widoco-1.4.17-jar-with-dependencies.jar"
#make generate-html-docs-from-rdf RDF_FILE_PATH=../Documents/model2owl-2023/owl-core.rdf WIDOCO_OUTPUT_DIRECTORY_NAME=core-html
generate-html-docs-from-rdf: get-widoco
	@echo ${RDF_FILE_PATH}
	@java -jar widoco.jar -ontFile ${RDF_FILE_PATH} -outFolder ${WIDOCO_OUTPUT_DIRECTORY_NAME}  -getOntologyMetadata -uniteSections -webVowl

help:
	@echo The automatic tasks available are defined as below
	@echo "\$$ Command line # Description"
	@echo
	@echo "\$$ make merge-xmi # to combine multiple input files (*.xmi, *.xml)"
	@echo Variables:
	@echo FIRST_INPUT_XMI_FILE=[first xmi or xml filename]
	@echo COMBINED_XMI_DIRECTORY=[the directory containing the output combined or merged XMI file.]
	@echo COMBINED_FILE_NAME=[the filename of the combined or merged XMI files, e.g. combined.xmi]
	@echo
	@echo "\$$ make generate-glossary # to generate the glossary from an input file"	
	@echo Variables:
	@echo UML_INPUT_FILENAME=[the path to the xmi or xml UML input file.]	
	@echo OUTPUT_GLOSSARY_PATH=[the output directory containing the glossary]
	@echo "\$$ make transform # transform from XMI/XML UML into RDF/XML (core, restrictions and shacl)"
	@echo
	@echo "\$$ make convert-to-turtle # convert RDF/XML files from an input folder into Turtle format"
	@echo Variables:
	@echo ONTOLOGY_DIR=[Directory containing files to be converted into Turtle format]
	@echo
	@echo "\$$ make convert-to-rdf # convert Turtle files from an input folder into RDF/XML format"
	@echo Variables:
	@echo ONTOLOGY_DIR=[Directory containing input files to be converted into Turtle format]
	@echo "\$$ # "

h: help	
usage: help
default: help

# ####################################################
#  Added Antora support for document generation
# ####################################################

SHELL=/bin/bash -o pipefail
BUILD_PRINT = \e[1;34mSTEP:

install-node:
	@ echo -e "$(BUILD_PRINT)Installing the NodeJS$(END_BUILD_PRINT)"
	@ sudo apt install npm
	@ mkdir -p ~/.npm
	@ npm config set prefix ~/.npm
	@ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
	@ nvm list-remote
	@ nvm install lts/gallium
	@ source ~/.bashrc


install-antora:
	@ echo -e "$(BUILD_PRINT)Installing the Antora$(END_BUILD_PRINT)"
	@ npm install

# install: install-node install-antora
# 	@ echo -e "$(BUILD_PRINT)Finish installation of the dev environment requirements$(END_BUILD_PRINT)"
#

# Optionally add the line below to ~/.bashrc
# export PATH="$PATH:$HOME/.npm/bin"

build-site:
	@ echo -e "$(BUILD_PRINT)Build site$(END_BUILD_PRINT)"
	@ npx antora --fetch antora-playbook.yml


