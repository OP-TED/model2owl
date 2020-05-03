# Deliverable B

Date: 04/05/2020

### Content 

| Deliverable A+B | Ontology architecture and specifications 	|
|--------	|-----------------------------------------------------------------------------------------------------------------------------	|
| WP1.1 	| [Ontology architecture document](doc/ontology-architecture/main.pdf) 	|
| WP1.2 	| [Technical convention document for the UML representation of the conceptual model](doc/uml-conventions/main.pdf)	|
| WP1.3 	| [Script checking the conformance to the technical conventions of the conceptual model](src/html-conventions-report.xsl) 	|
| WP1.4 	| [Conformance checking script unit tests](test/unitTests/test-html-conventions-lib) 	|
| WP1.5 	| [inventory of conformance tests derived from the UML conventions (WP1.2)](doc/checkers-inventory/eProcurement conceptual model checkers inventory.xlsx) 	|

### Folder structure

/data -  conventions reports generated from test data (snapshots of the CM from 02/14/2020, 30/03/2020, 30/04/2020)
* /data/static - contains JS and CSS styles refereed by HTML reports.


/doc - documentations
* /checkers-inventory - [WP1.5] an inventory of conformance tests derived from the UML conventions (WP1.2)
* /ontology-architecture - [WP1.1] an updated version of the ontology architecture specification integrating the comments from OP
* /uml-conventions -  [WP1.2] an updated version of the UML conventions specifications integrating comments from OP


/src - source code of the XSLT scripts generating the HTML conventions report. 
* html-conventions-report.xsl - the main file to perform the transformations.
* config-parameters.xsl - the configurations file that may be adjusted as necessary.
* /common and /html-conventions-lib contain modules loaded by the main file
* /static contains JS and CSS styles refereed by HTML reports. It should be copied to wherever the report is saved in order to ensure proper display.

/test - [WP1.4] contains unit tests for each XSL module ensuring the correct implementation.
* /test/unitTests - contain XSpec unit tests
* /test/testData - test data used in the unit tests
