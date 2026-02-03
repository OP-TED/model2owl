Feature: OWL diffing

  Background:
    Given the OWL files "tests/test_data/owl/ePO_sample-4.0.0.orig.ttl" and "tests/test_data/owl/ePO_sample-4.0.0.upd.ttl"
    And the test prefixes are defined

  Scenario Outline: Diffing example resources in the OWL sample
    When the diff is run
    Then the report should contain the change for "<resource_type>","<instance>","<operation>","<predicate>","<old_value>","<new_value>"

    Examples:
      | resource_type     | instance                                 | operation | predicate      | old_value              | new_value                    |
      | class             | epo:AwardCriterion                       | added     |                |                        |                              |
      | class             | epo:AdHocChannel                         | deleted   |                |                        |                              |
      | class             | epo:AcquiringCentralPurchasingBody       | changed   | skos:prefLabel |                        | rdfs:label                   |
      | class             | epo:AwardCriteriaSummary                 | updated   | skos:prefLabel | Award criteria summary | Award criteria summarization |
      | datatype_property | epo:describesObjectiveParticipationRules | added     |                |                        |                              |
      | datatype_property | epo:describesProfessionRelevantLaw       | deleted   |                |                        |                              |
      | object_property   | epo:followsRulesSetBy                    | added     |                |                        |                              |
      | object_property   | epo:exposesChannel                       | deleted   |                |                        |                              |
