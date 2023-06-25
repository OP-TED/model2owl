# Documentation migration

The documentation in this folder is slowly migrated into [model2owl-docs](https://github.com/meaningfy-ws/model2owl-docs) repository.

## Running the transformation (old instructions)
**[The user manual is currently under revision; please be patient]**

The scripts developed in this project conform to XSLT 3.0 and can be executed with a corresponding XSLT engine of choice. A recommendation is to use [Saxon-HE](http://saxon.sourceforge.net/), but it is not the only one.

The input eProcurement conceptual model is available in the [eProcurement Ontology project on GitHub](https://github.com/eprocurementontology/eprocurementontology). Note that the XMI (v.2.5.1) output is generated with [Enterprise Architect](https://sparxsystems.com/products/ea/index.html) and was not tested with outputs from other software (although, XMI is an OMG standard). But, this does not restrict the current scripts to this project alone and any UML model that conforms to the specified UML conventions can be transformed into a formal ontology.    

We assume that the users of this project are familiar with XML, UML and XSLT technologies and know how to perform an XSLT transformation. 

### Create an virtual environment
```
pip install virtualenv
virtualenv venv
```

### Activate your venv
```
source venv/bin/activate
```

### Install rdflib inside your virtual environment
```
pip install rdflib
```

### Combine multiple XMI / XML UML documents

```
make merge-xmi
```
This will merge multiple input XMI / XML UML documents into a single one. The output is located under `../output/combined-xmi/` and will be used to generate a single glossary.

### Generate the glossary from the merged document
```  
make generate-glossary
```

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