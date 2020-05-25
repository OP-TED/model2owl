# Deliverable C

Date: 25/05/2020

### Content 

| Deliverable C | Generate the formal ontology (core component)	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP1.6+ 	| [transformation rules from UML to OWL and SHACL](deliverables/C/doc/uml2owl-transformation/wp1-6-uml2owl-transformation-2020-05-25.pdf) 	|
| WP2.1 	| [Transformation script for the core ontology](deliverables/C/src/owl-core.xsl) 	|
| WP2.2 	| [Core ontology transformation script unit tests](deliverables/C/test/test-owl-core-lib) 	|
| WP2.3 	| [Core ontology generated with the current state of the conceptual model](deliverables/C/data/core-ont-ePO-CM-v2.0.1-2020-05-19.ttl) 	|

###### Footnotes:
_+_ This delivery batch contains the work package WP1.6, which was not foreseen in the initial planning, but, nevertheless, was created with additional efforts for the success of the eProcurement ontology project. This additional work package contributes to completing the eProcurement overall architecture and provides a concise, human readable, documentation of the transformation logic that is implemented across work packages of the second phase (WP2.*).   

### Folder structure

/data - generated data  
* validation-ePO-CM-v2.0.1-2020-05-19.html - conventions reports generated from test data (snapshots of the CM from 19/05/2020) 
* /data/static - contains JS and CSS styles refereed by HTML reports.
* core-ont-ePO-CM-v2.0.1-2020-05-19.ttl - [WP2.3] the core ontology component in Turtle format generated from test data (snapshots of the CM from 19/05/2020)  
* core-ont-ePO-CM-v2.0.1-2020-05-19.rdf - [WP2.3] the core ontology component in RDF/XML format 

/doc - documentations
* /uml2owl-transformation - [WP1.6] transformation rules from UML to OWL and SHACL

/src - source code of the XSLT scripts generating the core ontology in RDF/XML format. 
* owl-core.xsl - [WP2.1] - Transformation script for the core ontology
* /common and /owl-core-lib contain modules loaded by the main file (owl-core.xsl)

/test - [WP2.2] contains unit tests for each XSL module ensuring the correct implementation.
* /test/unitTests - contain XSpec unit tests
* /test/testData - test data used in the unit tests
