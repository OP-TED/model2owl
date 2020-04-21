# model2owl
This project comprises a set of tools for transforming an UML (v2.5) model from its XMI (v2.5.1) serialisation into a formal ontology. This transformation is performed using XSLT stylesheets under the assumption that the UML model conforms to the set of conventions outlined in the documentation.    

This work is developed in the context of eProcurement project financed by ISA2 and led by the Publications Office of the European Union.

The architectural design and the formal specifications are provided in the [Ontology architecture document](doc/ontology-architecture/main.pdf).  

##  Work packages

The project development is split into three phases aiming at providing three kinds of deliverables: documents, transformation scripts and formal data/models. The planned deliverables are as follows.

| Phase 1 	| Ontology architecture and specifications 	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP1.1 	| [Ontology architecture document](doc/ontology-architecture/main.pdf) 	|
| WP1.2 	| [Technical convention document for the UML representation of the conceptual model](doc/uml-conventions/main.pdf)	|
| WP1.3 	| [Script checking the conformance to the technical conventions of the conceptual model](src/html-conventions-report.xsl) 	|
| WP1.4 	| [Conformance checking script unit tests](test/unitTests/test-html-conventions-lib) 	|


| Phase 2 	| Generate the formal ontology 	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP2.1 	| Transformation script for the core ontology 	|
| WP2.2 	| Core ontology transformation script unit tests 	|
| WP2.3 	| Core ontology generated with the current state of the conceptual model 	|
| WP2.4 	| Transformation script for the SHACL shapes 	|
| WP2.5 	| SHACL shape transformation script unit tests 	|
| WP2.6 	| SHACL shapes generated with the current state of the conceptual model 	|
| WP2.7 	| Transformation script for the ontology intensional definitions based on the class and property restrictions 	|
| WP2.8 	| Intensional ontology definitions transformation script unit tests 	|
| WP2.9 	| Intensional ontology definitions generated with the current state of the conceptual model 	|

| Phase 3 	| Maintenance and final report 	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP3.1 	| On demand project related maintenance and interventions  	|
| WP3.2 	| Final report summarising the ontology generation project 	|


## Running the transformation

The scripts developed in this project conform to XSLT 3.0 and can be executed with a corresponding XSLT engine of choice. A recommendation is to use [Saxon-HE](http://saxon.sourceforge.net/), but it is not the only one.

The input eProcurement conceptual model is available in the [eProcurement Ontology project on GitHub](https://github.com/eprocurementontology/eprocurementontology). Note that the XMI (v.2.5.1) output is generated with [Enterprise Architect](https://sparxsystems.com/products/ea/index.html) and was not tested with outputs from other software (although, XMI is an OMG standard).

## Lincence 

The document deliverables, such as reports and specifications, available in the /doc folder, are licenced under a [CC BY 4.0 licence](https://creativecommons.org/licenses/by/4.0/deed.en).

The XSLT (stylesheets) scripts are licenced under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) licence. 

        




