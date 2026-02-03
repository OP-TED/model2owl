# Minimal ePO test data for OWL-core profile

Given the following versions of a dataset:

- **old:** `ePO_sample-4.0.0.orig.ttl`
- **new:** `ePO_sample-4.0.0.upd.ttl`

The **new** file is a _combined_ OWL and SHACL file that contains also
embedded SHACL data, for testing retrieval of certain constraint information
for added resources, such as the domain, range and cardinality, which would
otherwise not be supported/available in the OWL-core profile.

The following are changes comparing **old** to **new**, where _redundant_
refers to redundant appearances in the existing diff'ing/reporting, and _not
captured_ to the non-appearance thereof. The latter relates to complex cases that are not supported:

1. added class **epo:AwardCriterion**
2. class **epo:AwardCriterion** added `skos:prefLabel` (redundant, from added class)
3. class **epo:AwardCriterion** added `skos:definition` (redundant, from added class)
4. class **epo:AwardCriterion** added `rdfs:subClassOf` (redundant, from added class)
5. class **epo:AwardCriterion** added `rdfs:isDefinedBy` (redundant, from added class)
6. deleted class **epo:AdHocChannel**
7. class **epo:AdHocChannel** deleted `skos:prefLabel` (redundant, from deleted class)
8. class **epo:AdHocChannel** deleted `skos:definition` (redundant, from deleted class)
9. class **epo:AdHocChannel** deleted `rdfs:subClassOf` (redundant, from deleted class)
10. class **epo:AdHocChannel** deleted `rdfs:isDefinedBy` (redundant, from deleted class)
11. class **epo:AcquiringCentralPurchasingBody** `skos:prefLabel` changed to `rdfs:label`
12. class **epo:AcquiringCentralPurchasingBody** added `rdfs:label` (redundant, from changed property)
13. class **epo:AcquiringCentralPurchasingBody** deleted `skos:prefLabel` (redundant, from changed property)
14. class **epo:Document** added `skos:prefLabel` lang _es_
1. class **epo:AccessTerm** deleted `skos:prefLabel`
2. class **epo:AwardCriteriaSummary** updated `skos:prefLabel` (new value "Award criteria summarization"; original value "Award criteria summary" moved to `skos:altLabel`)
3. class **epo:AwardCriteriaSummary** changed `skos:prefLabel` to `skos:altLabel` (cross-property move of original `skos:prefLabel` to `skos:altLabel`; could be ignored as the original property was retained with a new value)
4. class **epo:AwardCriteriaSummary** added `skos:altLabel` (redundant, from changed property; could be considered non-redundant if the cross-property move is ignored)
5. added objectProperty **epo:followsRulesSetBy** with domain `epo:PurchaseContract`, range `epo:FrameworkAgreement` and maxCardinality 1
6. objectProperty **epo:followsRulesSetBy** added `skos:prefLabel` (redundant, from added objectProperty)
7. objectProperty **epo:followsRulesSetBy** added `rdfs:isDefinedBy` (redundant, from added objectProperty)
8. deleted objectProperty **epo:exposesChannel**
9. objectProperty **epo:exposesChannel** deleted `skos:prefLabel` (redundant, from deleted objectProperty)
10. objectProperty **epo:exposesChannel** deleted `rdfs:isDefinedBy` (redundant, from deleted objectProperty)
11. objectProperty **epo:exposesInvoiceeChannel** added `rdfs:label`
12. objectProperty **epo:describesResultNotice** added `skos:altLabel`
13. added datatypeProperty **epo:describesObjectiveParticipationRules**
14. datatypeProperty **epo:describesObjectiveParticipationRules** added `skos:prefLabel` (redundant, from added datatypeProperty)
15. datatypeProperty **epo:describesObjectiveParticipationRules** added `rdfs:isDefinedBy` (redundant, from added datatypeProperty)
16. deleted datatypeProperty **epo:describesProfessionRelevantLaw**
17. datatypeProperty **epo:describesProfessionRelevantLaw** deleted `skos:prefLabel` (redundant, from deleted datatypeProperty)
18. datatypeProperty **epo:describesProfessionRelevantLaw** deleted `rdfs:isDefinedBy` (redundant, from deleted datatypeProperty)
19. datatypeProperty **epo:describesProfession** added `rdfs:label` no lang
20. datatypeProperty **epo:describesVerificationMethod** converted to objectProperty (not captured)
21. objectProperty **epo:distributesOffer** deleted `skos:prefLabel` lang (not captured)
22. objectProperty **epo:actsOnBehalfOf** updated `skos:prefLabel` lang _en_ to _de_ (not captured)

The files are used by the test suite specified in [owl_diff.feature](../../features/owl_diff.feature) and implemented in [test_owl_diff_steps.py](../../steps/test_owl_diff_steps.py). The above description can be also used to facilitate manual tests.
