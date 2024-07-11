# Feasibility test.

## Related issue

SHACL - Missing predicates for ESPDRequest

- [pull request](https://github.com/OP-TED/ePO/pull/586)

Some predicates are missing in
the [SHACL shape](https://github.com/OP-TED/ePO/blob/98dcd5d8ee11ccd12ba86bb52d6f9c49e16d4102/implementation/eAccess/shacl_shapes/eAccess_shapes.ttl#L70)
for ESPDRequest of the e-access module, for the pre-release 4.1.0-rc.2.

It currently describes no predicates.

```
acc-shape:epo-acc-ESPDRequest a sh:NodeShape ;
    rdfs:label "E s p d request" ;
    rdfs:comment "An updated self-declaration used by the economic operator as a preliminary evidence in replacement of certificates issued by public authorities or third parties confirming that the economic operator fulfils the Exclusion Grounds and the Selection Criteria set out by the Buyer for a specific Procurement. WG Approval 05/03/2024" ;
    rdfs:isDefinedBy acc-shape:acc-shape ;
    sh:targetClass :ESPDRequest .
```

Querying the Enterprise Architect file directly I get 3 predicates, `specifiesProcurementCriterion`, `refersToNotice`
and `concernsProcedure`.

![png](http://www.plantuml.com/plantuml/img/bLJBRiCW4Bpp5OXZ9QBuYgegKfrh5RMLUh1oiDQR1ic1b4SlRV-z9dNZ1zXMZh33C3FiGZRMbSRvKqsWBgsb3CzQv1hy2PLZz8jG6dOC7j3OLxqp-2crjrJGFf0MwzNgRj-26nuDidHOlKbtd8KUIxkj4PpHIa8ktz6w2VmFwIjyqau2nlh-zbkATX48idraH0DMtlnZktMHZI-xri9zYLfJ2KeVZNHef5OnZ9S0Olkoov_nmpSUE-7sZ20F4csAgASjAXLP5-E5VYc2Q-QW5Q1HTYc2KIlSVtC-27yI4BabwGmuVw0is61pMOhbdCYW9owquStPi5T4ebFcbAqxPGEAHDgp1bdKHIBz3kD0nogwYaWEvQtdXtDww-d4w2RUOT9zD8XaWweA7z4l)

This is my expectation in SHACL

```
a4g:ESPDRequestShape a shacl:NodeShape ;
		shacl:targetClass a4g:ESPDRequest ;
	shacl:property [
		shacl:targetClass a4g:ProcurementCriterion ;
		shacl:path a4g:specifiesProcurementCriterion ;
		shacl:minCount 1 ;
		shacl:nodeKind shacl:IRI ;
	], [
		shacl:targetClass a4g:Notice ;
		shacl:path a4g:refersToNotice ;
		shacl:nodeKind shacl:IRI ;
	], [
		shacl:targetClass a4g:Procedure ;
		shacl:path a4g:concernsProcedure ;
		shacl:minCount 1 ;
		shacl:maxCount 1 ;
		shacl:nodeKind shacl:IRI ;
	] .

```
