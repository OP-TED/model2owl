# model2owl

This project comprises a set of tools for transforming an UML (v2.5) model from its XMI (v2.5.1) serialisation into a formal ontology. This transformation is performed using XSLT stylesheets under the assumption that the UML model conforms to the set of conventions outlined in the documentation.    

* UML -> OWL 2 (light / complete)
* UML -> SHACL

This work is developed in the context of [eProcurement ontology project](https://github.com/eprocurementontology/eprocurementontology) financed by the Digital Europe Programme and led by the [Publications Office of the European Union](https://op.europa.eu/en/).

### Documents
* The **architectural design** and the formal specifications are provided in the [Ontology architecture document](docs/ontology-architecture/ontology-architecture.pdf).  
* The technical **conventions** for the UML representation of the conceptual model are provided in [UML conventions document](docs/uml-conventions/uml-conventions.pdf)
* An **inventory** of conformance tests derived from the UML conventions document are provided in the [Inventory Worksheet document](docs/checkers-inventory/eProcurement conceptual model checkers inventory.xlsx)
* The **transformation rules** from UML into OWL and SHACL are provided in the [uml2owl transformation document](docs/uml2owl-transformation/uml2owl-transformation.pdf)

### Scripts
* [html-conventions-report.xsl](src/html-conventions-report.xsl) is the script checking the conformance to the technical conventions of the conceptual model.   
* [owl-core.xsl](src/owl-core.xsl) is the transformation script for the core OWL ontology.
* [shacl-shapes.xsl](src/shacl-shapes.xsl) is the transformation script for the SHACL data shape constraints
* [owl-restrictions.xsl](src/owl-restrictions.xsl) is the transformation script for the restrictions of OWL ontology (on classes and properties).

### Script unit tests

* [test/unitTest/test-html-conventions-lib](
https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/test-html-conventions-lib) is the location of the unit tests for the script checking the conformance to the technical conventions of the conceptual model are
* [test/unitTest/test-owl-core-lib](https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/test-owl-core-lib) is the location of the unit tests for the transformation script for the core OWL ontology.

* [test/unitTest/test-shacl-shape-lib](https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/test-shacl-shape-lib) is the location of the unit tests for the transformation script for the SHACL data shape constraints.
* [test/unitTest/reasoning-layer-lib](https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/reasoning-layer-lib) is the location of the unit tests for the transformation script for the restrictions of OWL ontology (on classes and properties).

## Running the transformation

The scripts developed in this project conform to XSLT 3.0 and can be executed with a corresponding XSLT engine of choice. A recommendation is to use [Saxon-HE](http://saxon.sourceforge.net/), but it is not the only one.

The input eProcurement conceptual model is available in the [eProcurement Ontology project on GitHub](https://github.com/eprocurementontology/eprocurementontology). Note that the XMI (v.2.5.1) output is generated with [Enterprise Architect](https://sparxsystems.com/products/ea/index.html) and was not tested with outputs from other software (although, XMI is an OMG standard). But, this does not restrict the current scripts to this project alone and any UML model that conforms to the specified UML conventions can be transformed into a formal ontology.    

We assume that the users of this project are familiar with XML, UML and XSLT technologies and know how to perform an XSLT transformation. 

## Automation with Makefile

## Create an virtual environment
pip install virtualenv
virtualenv venv
## Activate your venv
source venv/bin/activate

## Install rdflib inside your virtual environment
pip install rdflib

## Combine multiple XMI / XML UML documents
make merge-xmi

This will merge multiple input XMI / XML UML documents into a single one. The output is located under ../output/combined-xmi/ and will be used to generate a single glossary.

## Generate the glossary from the merged document
make generate-glossary
The glossary will generated and located in the ../output/glossary/

## Repository Structure

* /src - source code of the XSLT scripts generating the HTML conventions report. 
  * /common , /html-conventions-lib, /reasoning-layer-lib and /shacl-shape-lib contain modules loaded by the main files.
  * /static contains JS and CSS styles refereed by HTML reports. It should be copied to wherever the report is saved in order to ensure proper display.
  * config-parameters.xsl - the configurations file that may be adjusted as necessary.  
  * html-conventions-report.xsl - source code of the XSLT scripts generating the HTML conventions report.
  * owl-core.xsl - Transformation script for the core ontology
  * shacl-shapes.xsl -  Transformation script for the SHACL shapes    
  * owl-restrictions.xsl - Transformation script for the ontology intensional definitions based on the class and property restrictions

* /test - contains unit tests for each XSL module ensuring the correct implementation.
  * /test/unitTests - contain XSpec unit tests
  * /test/testData - test data used in the unit tests

# Contributing
You are more than welcome to help expand and mature this project. 

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we adhere to [Apache code of conduct](https://www.apache.org/foundation/policies/conduct), please follow it in all your interactions with the project.  

## Licence 

The documents, such as reports and specifications, available in the /doc folder, are licenced under a [CC BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/deed.en).

The XSLT (stylesheets) and other scripts are licenced under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) licence. 

 



