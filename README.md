# model2owl

This project comprises a set of tools for transforming an UML (v2.5) model from its XMI (v2.5.1) serialisation into a formal ontology. This transformation is performed using XSLT stylesheets under the assumption that the UML model conforms to the set of conventions outlined in the documentation.    

* UML -> OWL 2 (light / complete)
* UML -> SHACL

This work is developed in the context of [eProcurement ontology project](https://github.com/eprocurementontology/eprocurementontology) financed by ISA2 and led by the [Publications Office of the European Union](https://op.europa.eu/en/).

The architectural design and the formal specifications are provided in the [Ontology architecture document](doc/ontology-architecture/wp1-1-ontology-architecture-2020-05-03.pdf).  

##  Work packages

The project development is split into three phases aiming at providing three kinds of deliverables: documents, transformation scripts and formal data/models. The planned deliverables are as follows.

| Phase 1 	| Ontology architecture and specifications 	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP1.1 	| [Ontology architecture document](doc/ontology-architecture/main.pdf) 	|
| WP1.2 	| [Technical convention document for the UML representation of the conceptual model](doc/uml-conventions/main.pdf)	|
| WP1.3 	| [Script checking the conformance to the technical conventions of the conceptual model](src/html-conventions-report.xsl) 	|
| WP1.4 	| [Conformance checking script unit tests](test/unitTests/test-html-conventions-lib) 	|
| WP1.5+ 	| [inventory of conformance tests derived from the UML conventions (WP1.2)](doc/checkers-inventory/eProcurement conceptual model checkers inventory.xlsx) 	|
| WP1.6+ 	| [transformation rules from UML to OWL and SHACL](doc/uml2owl-transformation/wp1-6-uml2owl-transformation-2020-05-25.pdf) 	|

###### Footnotes:
_+_ The work package WP1.5 and WP1.6 was not foreseen in the initial planning, but, nevertheless, was created with additional efforts for the success of the eProcurement ontology project. This additional work package contributes to completing the eProcurement overall architecture and provides a concise, human readable, documentation of the transformation logic that is implemented across work packages of the second phase (WP2.*).   


| Phase 2 	| Generate the formal ontology 	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP2.1 	| [Transformation script for the core ontology](src/owl-core.xsl) 	|
| WP2.2 	| [Core ontology transformation script unit tests](test/test-owl-core-lib) 	|
| WP2.3 	| [Core ontology generated with the current state of the conceptual model](data/core-ont-ePO-CM-v2.0.1-2020-05-19.ttl) 	|
| WP2.4 	| [Transformation script for the SHACL shapes](src/shacl-shapes.xsl) 	|
| WP2.5 	| [SHACL shape transformation script unit tests](test/test-shacl-shape-lib) 	|
| WP2.6 	| [SHACL shapes generated with the current state of the conceptual model](data/data-shapes-ePO-CM-v2.0.1-2020-05-19.shapes.rdf) 	|
| WP2.7 	| [Transformation script for the ontology intensional definitions based on the class and property restrictions](src/owl-restrictions.xsl) 	|
| WP2.8 	| [Intensional ontology definitions transformation script unit tests](test/reasoning-layer-lib) 	|
| WP2.9 	| [Intensional ontology definitions generated with the current state of the conceptual model](data/owl-restrictions-ePO-CM-v2.0.1-2020-06-08-mappings.rdf) 	|

| Phase 3 	| Maintenance and final report 	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP3.1 	| On demand project related maintenance and interventions  	|
| WP3.2 	| Final report summarising the ontology generation project 	|


## Running the transformation

The scripts developed in this project conform to XSLT 3.0 and can be executed with a corresponding XSLT engine of choice. A recommendation is to use [Saxon-HE](http://saxon.sourceforge.net/), but it is not the only one.

The input eProcurement conceptual model is available in the [eProcurement Ontology project on GitHub](https://github.com/eprocurementontology/eprocurementontology). Note that the XMI (v.2.5.1) output is generated with [Enterprise Architect](https://sparxsystems.com/products/ea/index.html) and was not tested with outputs from other software (although, XMI is an OMG standard). But, this does not restrict the current scripts to this project alone and any UML model that conforms to the specified UML conventions can be transformed into a formal ontology.    

We assume that the users of this project are familiar with XML, UML and XSLT technologies and know how to perform an XSLT transformation. 

## Repository Structure

* /deliverables/*/data -  generated data
  * validation-ePO-CM-v2.0.1-2020-05-19.html - conventions reports generated from test data (snapshots of the CM from 19/05/2020)   
  * core-ont-ePO-CM-v2.0.1-2020-05-19.ttl - [WP2.3] the core ontology component in Turtle format generated from test data (snapshots of the CM from 19/05/2020)  
  * core-ont-ePO-CM-v2.0.1-2020-05-19.rdf - [WP2.3] the core ontology component in RDF/XML format 
  * validation-ePO-CM-v2.0.1-2020-05-19.html - conventions reports generated from test data (snapshots of the CM from 19/05/2020) 
  * data-shapes-ePO-CM-v2.0.1-2020-05-19.shapes.ttl - [WP2.6] the data shape ontology component in Turtle format generated from test data (snapshots of the CM from 19/05/2020)  
  * core-ont-ePO-CM-v2.0.1-2020-05-19.rdf - [WP2.6] the data shape ontology component in Turtle format generated from test data (snapshots of the CM from 19/05/2020)
  * owl-restrictions-ePO-CM-v2.0.1-2020-06-08-mappings.rdf - [WP2.9] Intensional ontology definitions generated with the current state of the conceptual model (snapshots of the CM - mappings from 08/06/2020)  

* /doc - documentations
  * /checkers-inventory - [WP1.5] an inventory of conformance tests derived from the UML conventions (WP1.2)
  * /ontology-architecture - [WP1.1] an updated version of the ontology architecture specification integrating the comments from OP
  * /uml-conventions -  [WP1.2] an updated version of the UML conventions specifications integrating comments from OP
  * /uml2owl-transformation - [WP1.6] transformation rules from UML to OWL and SHACL

* /src - source code of the XSLT scripts generating the HTML conventions report. 
  * /common , /html-conventions-lib, /reasoning-layer-lib and /shacl-shape-lib contain modules loaded by the main files.
  * /static contains JS and CSS styles refereed by HTML reports. It should be copied to wherever the report is saved in order to ensure proper display.
  * config-parameters.xsl - the configurations file that may be adjusted as necessary.  
  * html-conventions-report.xsl - [WP1.3] source code of the XSLT scripts generating the HTML conventions report.
  * owl-core.xsl - [WP2.1] - Transformation script for the core ontology
  * shacl-shapes.xsl - [WP2.4] - Transformation script for the SHACL shapes    
  * owl-restrictions.xsl - [WP2.7] Transformation script for the ontology intensional definitions based on the class and property restrictions

* /test - [WP1.4], [WP2.2], [WP2.5], [WP2.8] contains unit tests for each XSL module ensuring the correct implementation.
  * /test/unitTests - contain XSpec unit tests
  * /test/testData - test data used in the unit tests

# Contributing
You are more than welcome to help expand and mature this project. 

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we adhere to [Apache code of conduct](https://www.apache.org/foundation/policies/conduct), please follow it in all your interactions with the project.  

## Licence 

The document deliverables, such as reports and specifications, available in the /doc folder, are licenced under a [CC BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/deed.en).

The XSLT (stylesheets) scripts are licenced under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) licence. 

        




