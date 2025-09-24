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
