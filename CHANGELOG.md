# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]
### Added
- Dedicated `imports.xml` file enabling fine-grained configuration of URIs for
  inclusion in `owl:imports` statements for each generated RDF artefact (TEDM2O-21).

### Changed
- Enhance ontology import configuration and separate import declarations from
  namespaces (TEDM2O-21).
- Add human-readable, title-cased labels to SHACL artefacts (TEDM2O-20).
- Extend support for qualified cardinality constraints and improve OWL
  restriction generation (TEDM2O-33).
- Parametrize URI construction for SHACL node shapes and set `Shape` as the
  default suffix (TEDM2O-19).

### Deprecated

### Removed
- Generation of incorrect axioms for disjointness among sibling classes in
  generalizations (TEDM2O-15).

### Fixed
- Missing `rdfs:isDefinedBy` properties for `sh:PropertyShape` instances; make
  the property generation configurable (TEDM2O-18).
- Incorrect violation generation for generalizations with two subclasses
  (TEDM2O-32). 
- Generation of extra triples for reused concepts (TEDM2O-16).

### Security


## [3.0.0] — 2025-03-26
### Added
- [Status-based filtering (Task 1)](https://github.com/OP-TED/model2owl/issues/226) by @Dragos0000 in #237
- [Export of controlled vocabulary restrictions (Task 2)](https://github.com/OP-TED/model2owl/issues/228)
    - Implementation by @Dragos0000 in #240
    - Demonstration of restrictions on controlled vocabularies in practice by @gkostkowski in #242
- [Export of metadata about concepts (Task 3)](https://github.com/OP-TED/model2owl/issues/229) by @Dragos0000 in #236
- [Support for translation of rdf:PlainLiteral to alternative properties in SHACL shapes](https://github.com/OP-TED/model2owl/issues/219) by @gkostkowski in #233
- [Implementation for property inheritance checkers](https://github.com/OP-TED/model2owl/issues/205) by @Dragos0000 in #247

### Changed
- [Improved camelCase into words functionality in model2owl](https://github.com/OP-TED/model2owl/issues/77) by @gkostkowski in #223
- Enable code coverage reports, implement new unit tests, minor improvements in code and fixes in test data by @gkostkowski in #211
- Support for alternative URIs of the supported UML versions by @gkostkowski in #217 ; required for the new EA version (v17)

### Fixed
- [Removal of duplicated imports](https://github.com/OP-TED/model2owl/issues/213) by @gkostkowski in #216
- [Avoiding Appending or Altering Input Descriptions](https://github.com/OP-TED/model2owl/issues/198) by @gkostkowski in https://github.com/OP-TED/model2owl/commit/48e04
- Filtering of external terms for attributes and relationships by @gkostkowski in #248


## [2.3.0-rc.2] — 2025-11-25
### Changed
- Update config parameter name and its description by @gkostkowski in #235


## [2.3.0-rc.1] — 2025-11-25
### Changed
- Text changes for checker descriptions by @Dragos0000 in #194
- SEMIC model2owl features from meaningfy fork by @Dragos0000 in #206
- Reused concepts filters and readme changes by @Dragos0000 in #208
