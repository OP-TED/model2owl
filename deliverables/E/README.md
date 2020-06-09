# Deliverable E

Date: 09/06/2020

### Content 

| Deliverable E | Generate the formal ontology (reasoning-related component)	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP2.7 	| [Transformation script for the ontology intensional definitions based on the class and property restrictions](src/owl-restrictions.xsl) 	|
| WP2.8 	| [Intensional ontology definitions transformation script unit tests](test/reasoning-layer-lib) 	|
| WP2.9 	| [Intensional ontology definitions generated with the current state of the conceptual model](data/owl-restrictions-ePO-CM-v2.0.1-2020-06-08-mappings.rdf) 	|

### Folder structure

/data - generated data  
* owl-restrictions-ePO-CM-v2.0.1-2020-06-08-mappings.rdf - [WP2.9] Intensional ontology definitions generated with the current state of the conceptual model (snapshots of the CM - mappings from 08/06/2020) 

/src - source code of the XSLT scripts generating the ontology reasoning axioms in RDF/XML format. 
* owl-restrictions.xsl - [WP2.7] Transformation script for the ontology intensional definitions based on the class and property restrictions
* /common and /reasoning-layer-lib - [WP2.7]* contain modules loaded by the main files. 

/test - [WP2.8] contains unit tests for each XSL module ensuring the correct implementation.
* /test/unitTests - contain XSpec unit tests
* /test/testData - test data used in the unit tests
