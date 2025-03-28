# model2owl

_Transform a UML model into a formal OWL ontology, and a SHACL shape based on established UML conventions._ 

[![Build](https://github.com/OP-TED/model2owl/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/OP-TED/model2owl/actions/workflows/main.yml)

![GitHub last commit](https://img.shields.io/github/last-commit/OP-TED/model2owl)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/OP-TED/model2owl)

![GitHub issues](https://img.shields.io/github/issues/OP-TED/model2owl)
![GitHub contributors](https://img.shields.io/github/contributors-anon/OP-TED/model2owl)
![GitHub Repo stars](https://img.shields.io/github/stars/OP-TED/model2owl?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/OP-TED/model2owl?style=social)

![GitHub](https://img.shields.io/github/license/OP-TED/model2owl)


## About 

This project comprises a set of tools for transforming an UML (v2.5) model from its XMI (v2.5.1) serialisation into a formal OWL ontology, and a SHACL shape. This approach is conformant to the [SEMIC Style Guide](https://semiceu.github.io/style-guide/1.0.0/index.html) and with [eProcurement Ontology Architecture specification](https://github.com/OP-TED/model2owl/blob/master/docs/ontology-architecture/ontology-architecture.pdf). 

The UML transformation is performed using XSLT stylesheets under the assumption that the UML model conforms to the set of conventions outlined in the [EPO UML conventions documentation](https://docs.ted.europa.eu/M2O/latest/uml/conceptual-model-conventions.html). This set of UML conventions is an extension to the UML conventions specified in [SEMIC Style Guide](https://semiceu.github.io/style-guide/1.0.0/index.html). 

The following capabilities are addressed:

* UML -> Compliance report (ideal for checking the model against the established conventions) 
* UML -> Glossary
* UML -> OWL 2 (lightweight ontology suitable as a Core Vocabulary)
* UML -> OWL 2 (heavyweight ontology with additional axioms suitable for reasoning purposes)
* UML -> SHACL (data shapes suitable for validation)
* UML -> SVRL (Compliance report in SVRL format)

This work is developed in the context of [eProcurement ontology project](https://github.com/eprocurementontology/eprocurementontology) financed by the Digital Europe Programme and led by the [Publications Office of the European Union](https://op.europa.eu/en/).

### Documents
* The **architectural design** and the formal specifications are provided in the [eProcurement Ontology Architecture specification](https://github.com/OP-TED/model2owl/blob/master/docs/ontology-architecture/ontology-architecture.pdf).  
* The technical **conventions** for the UML representation of the conceptual model are provided in [EPO UML conventions documentation](https://docs.ted.europa.eu/M2O/latest/uml/conceptual-model-conventions.html).
* An **inventory** of conformance tests derived from the UML conventions document are provided in the [EPO UML conventions checking specification](https://docs.ted.europa.eu/M2O/latest/checkers/model2owl-checkers.html).
* The **transformation rules** from UML into OWL and SHACL are provided in the [UML2OWL transformation rules](https://docs.ted.europa.eu/M2O/latest/transformation/uml2owl-transformation.html).

### Scripts
* [html-conventions-report.xsl](src/html-conventions-report.xsl) is the script checking the conformance to the technical conventions of the conceptual model. (HTML)
* [html-model-glossary.xsl](src/html-model-glossary.xsl) is the script for creating a glossary of the conceptual model.
* [owl-core.xsl](src/owl-core.xsl) is the transformation script for the core OWL ontology.
* [shacl-shapes.xsl](src/shacl-shapes.xsl) is the transformation script for the SHACL data shape constraints.
* [owl-restrictions.xsl](src/owl-restrictions.xsl) is the transformation script for the restrictions of OWL ontology (on classes and properties).
* [svrl-conventions-report.xsl](src/svrl-conventions-report.xsl) is the script checking the conformance to the technical conventions of the conceptual model. (SVRL)

### Script unit tests

* [test/unitTest/test-html-conventions-lib](
https://github.com/OP-TED/model2owl/tree/master/test/unitTests/test-html-conventions-lib) is the location of the unit tests for the script checking the conformance to the technical conventions of the conceptual model are
* [test/unitTest/test-owl-core-lib](https://github.com/OP-TED/model2owl/tree/master/test/unitTests/test-owl-core-lib) is the location of the unit tests for the transformation script for the core OWL ontology.
* [test/unitTest/test-shacl-shape-lib](https://github.com/OP-TED/model2owl/tree/master/test/unitTests/test-shacl-shape-lib) is the location of the unit tests for the transformation script for the SHACL data shape constraints.
* [test/unitTest/test-reasoning-layer-lib](https://github.com/OP-TED/model2owl/tree/master/test/unitTests/test-reasoning-layer-lib) is the location of the unit tests for the transformation script for the restrictions of OWL ontology (on classes and properties).

# How to use
This project can be used in 2 different ways as follows.
## Locally
### Makefile
The Makefile is a powerful tool that automates different commands for software projects. It provides a convenient way to define and execute various tasks, 
such as using source code, generating documentation, running tests, and more. This will help the user to easily use the software.

All commands will be executed using the **Make** build automation tool that needs to be installed if not available on the system.
The make targets can sometime have optional parameters (see example bellow). The project will have default values for the available parameters for the different commands.

Example 

```shell
# without parameters
make install 
# with parameters 
make owl-core XMI_INPUT_FILE_PATH=/home/mypc/work/model2owl/file1.xml OUTPUT_FOLDER_PATH=./my-folder
```


#### Setting up commands
* **get-saxon** - this will install saxon in a folder inside the project
* **get-rdflib** - this will install rdflib library
* **get-widoco** - this will install saxon in a folder inside the project
* **install** - this will automatically execute all the commands above
* **create-virtual-env** - this creates a virtual environment for the project
#### Functionality commands
* **generate-glossary** - this generates a glossary from the UML export (xml/xmi)
  * parameters:
    * XMI_INPUT_FILE_PATH - path to the xmi file
    * OUTPUT_GLOSSARY_PATH - path to the folder that stores the output
* **generate-convention-report** - this generates the compliance report from the UML export (xml/xmi) in HTML format
  * parameters:
    * XMI_INPUT_FILE_PATH - path to the xmi file
    * OUTPUT_CONVENTION_REPORT_PATH - path to the folder that stores the output
* **generate-convention-SVRL-report** - this generates the compliance report from the UML export (xml/xmi) in SVRL format
  * parameters:
    * XMI_INPUT_FILE_PATH - path to the xmi file
    * OUTPUT_CONVENTION_REPORT_PATH - path to the folder that stores the output
* **owl-core** - this generates lightweight ontology from the UML export (xml/xmi)
  * parameters:
    * XMI_INPUT_FILE_PATH - path to the xmi file
    * OUTPUT_FOLDER_PATH - path to the folder that stores the output
* **owl-restrictions** - this generates heavyweight ontology with additional axioms suitable for reasoning purposes from the UML export (xml/xmi)
  * parameters:
    * XMI_INPUT_FILE_PATH - path to the xmi file
    * OUTPUT_FOLDER_PATH - path to the folder that stores the output
* **shacl** - this generates data shapes suitable for validation from the UML export (xml/xmi)
  * parameters:
    * XMI_INPUT_FILE_PATH - path to the xmi file
    * OUTPUT_FOLDER_PATH - path to the folder that stores the output
* **generate-html-docs-from-rdf** - this generates html documentation using widoco from a rdf file
  * parameters:
    * WIDOCO_RDF_INPUT_FILE_PATH - path to the rdf file
    * OUTPUT_FOLDER_PATH - path to the folder that stores the output
* **merge-xmi** - this will merge xmis from specific folder
  * parameters:
    * FIRST_XMI_TO_BE_MERGED_FILE_PATH - path to the first xmi to be merged. All xmi files need to be 
    in the same folder as the first xmi to be merged.
    * XMI_MERGED_OUTPUT_FOLDER_PATH - path to the folder that stores the output
* **convert-to-turtle** - converts rdf file/files to turtle
  * parameters:
    * ONTOLOGY_FOLDER_PATH - path to the folder containing rdf file/files
* **convert-to-rdf** - converts turtle file/files to rdf
  * parameters:
    * ONTOLOGY_FOLDER_PATH - path to the folder containing turtle file/files

### Installation
Prerequisites:
* Have make installed
* Have python3 installed

Steps:
* clone this repository
* execute `` make install``

  Note: If you don't have a virtual environment set up use ``make create-virtual-env`` to create a virtual environment and
then activate it by using  ``source model2owl-venv/bin/activate``.

### Configuration
The model2owl configuration is formed from 4 files that should be in one folder:
* config-parameters.xsl - main config variables
* namespaces.xml - add namespaces that are used in your UML model
* umlToXsdDataTypes.xml - mapping between uml to xsd data types
* xsdAndRdfDataTypes.xml - configure datatypes used

To start just copy the default configuration files from [ePO-default-config folder](test/ePO-default-config) in your new configuration folder.
#### Changing config parameters
To change the configuration in the config-parameters.xsl just simply change the value of the variable.
Notes: 
* Do not change the values from the namespacePrefixes, umlDataTypesMapping, xsdAndRdfDataTypes variables as these will 
already work with having one config folder with all config files. 
* When changing variables make sure you modify it with the same datatype (boolean, string, list)
```shell
#exiting variables 
    <xsl:variable name="acceptableTypesForObjectProperties"
        select="('epo:Identifier', 'rdfs:Literal')"/>
    <xsl:variable name="defaultNamespaceInterpretation" select="fn:true()"/>
#Don't change to different datatypes
<xsl:variable name="defaultNamespaceInterpretation" select="'new-value'"/> ---> incorrect
```
* If the variable is a list, and you don't need any values just leave an empty list
``<xsl:variable name="stereotypeValidOnAssociations" select="()"/>``

**Example for controlling the generation of reused concepts in artefacts with the config parameters
variables**

The following variables determine the inclusion or exclusion of reused concepts within each artifact:
```shell

<!-- This variable stores the concept prefixes that should be excluded from being treated as external or reused. Concepts with these prefixes will be included in the generated artefacts. -->
<xsl:variable name="includedPrefixesList" select="('epo', 'epo-not', 'epo-ord', 'epo-cat', 'epo-con', 'epo-ful')"/>

<!-- Controls whether reused concepts are generated in SHACL artefact -->
<xsl:variable name="generateReusedConceptsSHACL" select="fn:true()"/>

<!-- Controls whether reused concepts are generated in OWL core artefact -->
<xsl:variable name="generateReusedConceptsOWLcore" select="fn:false()"/>

<!-- Controls whether reused concepts are generated in OWL restrictions artefact -->
<xsl:variable name="generateReusedConceptsOWLrestrictions" select="fn:false()"/>

<!-- Controls whether reused concepts are generated in the glossary -->
<xsl:variable name="generateReusedConceptsGlossary" select="fn:true()"/>
```

Explanation

* includedPrefixesList: Concepts with the specified prefixes in this list will be treated as internal to the model and will not be excluded from the artefacts, regardless of the settings for generating reused concepts controls (see below).
* generateReusedConceptsSHACL: Set to true, reused concepts will be included in SHACL artefact.
* generateReusedConceptsOWLcore: Set to false, reused concepts will be excluded from OWL core artefact.
* generateReusedConceptsOWLrestrictions: Set to false, reused concepts will be excluded from OWL restrictions artefact.
* generateReusedConceptsGlossary: Set to true, reused concepts will be included in the glossary.

By adjusting these variables, it is possible to customize whether specific artefacts contain reused concepts, 
providing fine control over the content of each output.

#### Namespaces configuration
In the namespaces.xml file you can add the namespaces that you use in UML model and also can control which of them should
appear as import in the final output.

Example

```shell
# to add prefix you need a name and the URI
 <prefix name="foaf" value="http://xmlns.com/foaf/0.1/"/>
# to have an import statement in the final output 
# add importURI attribute to the definition above
 <prefix name="dct" value="http://purl.org/dc/terms/" importURI="http://purl.org/dc/terms/"/>
 
#Output will have the following import statement
<owl:imports rdf:resource="http://purl.org/dc/terms/"/>
```
#### XSD/RDF datatypes
Use xsdAndRdfDataTypes.xml file to define the datatypes used in the UML model.

Example

```shell
    <datatype namespace="xsd" qname="xsd:date"/>
```
#### UML to XSD mappings
If the model uses UML datatypes these should be mapped in the umlToXsdDataTypes.xml file.

Example

```shell
    <mapping>
        <from  qname="epo:Date"/>
        <to  qname="xsd:date"/>
    </mapping>
```


All configuration files (see above) should be in one folder. 
Once the folder with the desired configurations is created the  **config-proxy.xsl** file (found in the root directory of this project)
should be changed to point to the location of the new configuration before executing any transformations.

Example:

```shell
# Change the path to the config-parameters.xsl inside the config-proxy.xsl
# from
 <xsl:import href="test/ePO-default-config/config-parameters.xsl"/>
# to
 <xsl:import href="my-pc/user/my-config-folder/config-parameters.xsl"/>
```
### Running transformations
After installing and creating your configuration folder use the available make targets described above to transform/generate 
output from you XMI/XML export file. The command should be executed from the root folder of this project.

Example 

```shell
# generate lightweight ontology from the UML export (xml/xmi)
make owl-core XMI_INPUT_FILE_PATH=/home/mypc/work/model2owl/file1.xml OUTPUT_FOLDER_PATH=./my-folder
```
## Online
To use model2owl in an automatic way, we have created a github repository [model2owl-boilerplate](https://github.com/OP-TED/model2owl-boilerplate) that will no longer require for you to install or to execute anything.
Follow the instructions found there for using this model2owl automation.

# Contributing
You are more than welcome to help expand and mature this project. 

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we adhere to [Apache code of conduct](https://www.apache.org/foundation/policies/conduct), please follow it in all your interactions with the project.  

## Licence 

The documents, such as reports and specifications, available in the /doc folder, are licenced under a [CC BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/deed.en).

The XSLT (stylesheets) and other scripts are licenced under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) licence.


