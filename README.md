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

This project comprises a set of tools for transforming an UML (v2.5) model from its XMI (v2.5.1) serialisation into a formal OWL ontology, and a SHACL shape. This approach is conformant to the [SEMIC Style Guide](https://OP-TED.github.io/style-guide/1.0.0/index.html) and with [eProcurement Ontology Architecture specification](https://github.com/meaningfy-ws/model2owl/blob/master/doc/ontology-architecture/ontology-architecture.pdf). 

The UML transformation is performed using XSLT stylesheets under the assumption that the UML model conforms to the set of conventions outlined in the [EPO UML conventions documentation](https://meaningfy-ws.github.io/model2owl-docs/public-review/uml/conceptual-model-conventions.html). This set of UML conventions is an extension to the UML conventions specified in [SEMIC Style Guide](https://OP-TED.github.io/style-guide/1.0.0/index.html). 

The following capabilities are addressed:

* UML -> Compliance report (ideal for checking the model against the established conventions) 
* UML -> OWL 2 (lightweight ontology suitable as a Core Cocabulary)
* UML -> OWL 2 (heavyweight ontology with additional axioms suitable for reasoning purposes)
* UML -> SHACL (data shapes suitable for validation)

This work is developed in the context of [eProcurement ontology project](https://github.com/eprocurementontology/eprocurementontology) financed by the Digital Europe Programme and led by the [Publications Office of the European Union](https://op.europa.eu/en/).

### Documents
* The **architectural design** and the formal specifications are provided in the [Ontology architecture document](doc/ontology-architecture/ontology-architecture.pdf).  
* The technical **conventions** for the UML representation of the conceptual model are provided in [UML conventions document](doc/uml-conventions/uml-conventions.pdf)
* An **inventory** of conformance tests derived from the UML conventions document are provided in the [Inventory Worksheet document](doc/checkers-inventory/eProcurement conceptual model checkers inventory.xlsx)
* The **transformation rules** from UML into OWL and SHACL are provided in the [uml2owl transformation document](doc/uml2owl-transformation/uml2owl-transformation.pdf)

### Scripts
* [html-conventions-report.xsl](src/html-conventions-report.xsl) is the script checking the conformance to the technical conventions of the conceptual model.   
* [owl-core.xsl](src/owl-core.xsl) is the transformation script for the core OWL ontology.
* [shacl-shapes.xsl](src/shacl-shapes.xsl) is the transformation script for the SHACL data shape constraints.
* [owl-restrictions.xsl](src/owl-restrictions.xsl) is the transformation script for the restrictions of OWL ontology (on classes and properties).

### Script unit tests

* [test/unitTest/test-html-conventions-lib](
https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/test-html-conventions-lib) is the location of the unit tests for the script checking the conformance to the technical conventions of the conceptual model are
* [test/unitTest/test-owl-core-lib](https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/test-owl-core-lib) is the location of the unit tests for the transformation script for the core OWL ontology.
* [test/unitTest/test-shacl-shape-lib](https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/test-shacl-shape-lib) is the location of the unit tests for the transformation script for the SHACL data shape constraints.
* [test/unitTest/reasoning-layer-lib](https://github.com/meaningfy-ws/model2owl/tree/master/test/unitTests/reasoning-layer-lib) is the location of the unit tests for the transformation script for the restrictions of OWL ontology (on classes and properties).



# Contributing
You are more than welcome to help expand and mature this project. 

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we adhere to [Apache code of conduct](https://www.apache.org/foundation/policies/conduct), please follow it in all your interactions with the project.  

## Licence 

The documents, such as reports and specifications, available in the /doc folder, are licenced under a [CC BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/deed.en).

The XSLT (stylesheets) and other scripts are licenced under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) licence.


