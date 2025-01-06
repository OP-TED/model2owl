# Configuration File Documentation

This document provides an explanation for the variables in the configuration file, detailing their purpose and data types.

---

## Variables and Their Descriptions

### 1. `namespacePrefixes`
- **Type:** String
- **Description:** A reference to an XML document containing prefix-baseURI definitions.
- **Note:** Don't change this

### 2. `umlDataTypesMapping`
- **Type:** String
- **Description:** A reference to an XML document mapping UML atomic types to XSD data types.
- **Note:** Don't change this

### 3. `xsdAndRdfDataTypes`
- **Type:** String
- **Description:** A reference to an XML document listing XSD data types compliant with OWL2 requirements.
- **Note:** Don't change this

### 4. `defaultNamespaceInterpretation`
- **Type:** Boolean
- **Description:** set default namespace interpretation for lexical Qnames that are not `prefix:localSegment` or `:localSegment`. If this 
    is set to true `localSegment` will be transformed to `:localSegment`

### 5. `base-ontology-uri`
- **Type:** String
- **Description:** The base URI for the ontology. Should not include a trailing delimiter.

### 6. `base-shape-uri`
- **Type:** String
- **Description:** The base URI for SHACL shapes.

### 7. `base-restriction-uri`
- **Type:** String
- **Description:** The base URI for restrictions, derived from `base-ontology-uri`.

### 8. `shapeArtefactURI`
- **Type:** String
- **Description:** Constructs the URI for shape artefacts using base shape URI, delimiter, and module reference.

### 9. `restrictionsArtefactURI`
- **Type:** String
- **Description:** Constructs the URI for restrictions artefacts using base restriction URI, delimiter, and module reference.

### 10. `coreArtefactURI`
- **Type:** String
- **Description:** Constructs the URI for the core ontology artefact.

### 11. `defaultDelimiter`
- **Type:** String
- **Description:** Default delimiter for namespaces when missing in base URI (e.g., `#`).

### 12. `acceptableTypesForObjectProperties`
- **Type:** List
- **Description:** Specifies element types eligible for object property generation.

### 13. `controlledListType`
- **Type:** String
- **Description:** Defines the type of attributes that use controlled vocabularies.

### 14. Stereotype Validation Variables
- **Type:** List
- **Description:** Define acceptable stereotypes for various elements:
  - `stereotypeValidOnAttributes`
  - `stereotypeValidOnObjects`
  - `stereotypeValidOnGeneralisations`
  - `stereotypeValidOnAssociations`
  - `stereotypeValidOnDependencies`
  - `stereotypeValidOnClasses`
  - `stereotypeValidOnDatatypes`
  - `stereotypeValidOnEnumerations`
  - `stereotypeValidOnPackages`

### 15. `abstractClassesStereotypes`
- **Type:** List
- **Description:** Stereotypes considered valid for abstract classes.

### 16. Enumeration generation variables
- **Type:** Boolean
- **Description:** Control the transformation of enumerations and enumeration items:
  - `enableGenerationOfSkosConcept`
  - `enableGenerationOfConceptSchemes`

### 17. `allowedStrings`
- **Type:** String (Regex Pattern)
- **Description:** Defines valid characters for a normalised string.

### 18. `includedPrefixesList`
- **Type:** List
- **Description:** Specifies prefixes that should be considered internal to the model and not reused. The variable controls what concepts will be *included* in the generated artefacts when generation of reused concepts is disabled. 

### 19. Filter reused concepts variables
- **Type:** Boolean
- **Description:** Controls reused concept generation for various artefacts:
  - `generateReusedConceptsSHACL`
  - `generateReusedConceptsOWLcore`
  - `generateReusedConceptsOWLrestrictions`
  - `generateReusedConceptsGlossary`

### 20. `generateObjectsAndRealisations`
- **Type:** Boolean
- **Description:** Controls the generation of objects and realisations.

### 21. Convention Report Variables
- **Type:** String
- **Description:** Define metadata for convention reports:
  - `conventionReportCopyrightText`
  - `conventionReportAuthor`
  - `conventionReportAuthorLocation`
  - `conventionReportAuthorWebsite`
  - `conventionReportUMLModelName`

### 22. Ontology Metadata Variables
- **Type:** String
- **Description:** Metadata for ontology modules, including titles, descriptions, labels, and publication details:
  - `ontologyTitleCore`
  - `ontologyDescriptionCore`
  - `ontologyLabelCore`
  - `ontologyTitleRestrictions`
  - `ontologyDescriptionRestrictions`
  - `ontologyLabelRestrictions`
  - `ontologyTitleShapes`
  - `ontologyDescriptionShapes`
  - `ontologyLabelShapes`
 
- **Type:** List
- **Description:** Links to additional resources.
  - `seeAlsoResources`
  
- **Type:** String
- **Description:** Automatically generated date fields:
  - `issuedDate`
  - `createdDate`

- **Type:** String
- **Description:** Manage versioning and compatibility:
  - `incompatibleWith`
  - `versionInfo`
  - `priorVersion`
  - 
- **Type:** String
- **Description:** Define namespace preferences and license information:
  - `preferredNamespaceUri`
  - `preferredNamespacePrefix`
  - `licenseLiteral`
  
- **Type:** String
- **Description:** The publisher's URI.
  - `publisher`

---