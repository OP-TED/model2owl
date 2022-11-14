<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xd xsl dc fn"
    xmlns:cc="http://creativecommons.org/ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:vann="http://purl.org/vocab/vann/"        
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines project level variables and parameters</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!-- some advanced xpath functions -->
    <xsl:import href="../../src/common/functx-1.0.1-doc.xsl"/>
    
    <!-- a set of prefix-baseURI definitions -->
    <xsl:variable name="namespacePrefixes" select="fn:doc('namespaces.xml')"/>

    <!-- a mapping between UML atomic types to XSD datatypes  -->
    <xsl:variable name="umlDataTypesMapping"
        select="fn:doc('umlToXsdDataTypes.xml')"/>

    <!-- XSD datatypes that conform to OWL2 requirements   -->
    <xsl:variable name="xsdAndRdfDataTypes"
        select="fn:doc('xsdAndRdfDataTypes.xml')"/>

    <!-- Ontology base URI, configure as necessary. Do not use a trailing local delimiter 
        like in the namespace definition-->
    <!--<xsl:variable name="base-uri" select="'http://publications.europa.eu/ontology/ePO'"/>-->
    <xsl:variable name="base-ontology-uri" select="'http://data.europa.eu/a4g/ontology'"/>
    <xsl:variable name="base-shape-uri" select="'http://data.europa.eu/a4g/shape'"/>
    <xsl:variable name="base-rule-uri" select="'http://data.europa.eu/a4g/rule'"/>


    <!-- when a delimiter is missing in the base URI of a namespace, use this default value-->
    <xsl:variable name="defaultDelimiter" select="'#'"/>

    <!-- Sometimes when it is not possible to resolve teh repfix or the base URI of a namespace, these mock values are used-->
    <xsl:variable name="mockUnknownDomain">http://unknown.domain/for/prefix#</xsl:variable>
    <xsl:variable name="mockUnknownPrefix">unknown</xsl:variable>

    <!-- Sometimes names are missing, then use this default value  -->
    <xsl:variable name="mockUnnamedElement">unnamed</xsl:variable>

    <!-- the local segment of an URI cannot start with digits, like "prefix:03000000-1" therefore a prefix must beused -->
    <xsl:variable name="mockPrefixforLocalSegment">i</xsl:variable>

    <!-- types of elements and names for attribute types that are acceptable to produce object properties -->
    <xsl:variable name="acceptableTypesForObjectProperties"
        select="('epo:Identifier', 'rdfs:Literal')"/>
<!--    the type of attributes which takes values from a controlled list-->
    <xsl:variable name="controlledListType" select="'epo:Code'"/>
    <!-- Acceptable stereotypes -->
    <xsl:variable name="stereotypeValidOnAttributes" select="()"/>
    <xsl:variable name="stereotypeValidOnGeneralisations"
        select="('Disjoint', 'Equivalent', 'Complete')"/>
    <xsl:variable name="stereotypeValidOnAssociations" select="()"/>
    <xsl:variable name="stereotypeValidOnDependencies" select="('Disjoint', 'disjoint', 'join')"/>
    <xsl:variable name="stereotypeValidOnClasses" select="('Abstract')"/>
    <xsl:variable name="stereotypeValidOnDatatypes" select="()"/>
    <xsl:variable name="stereotypeValidOnEnumerations" select="()"/>
    <xsl:variable name="stereotypeValidOnPackages" select="()"/>
    
<!--    This variable controlls whether the enumeration items are transformed into skos concepts or ignored-->
    <xsl:variable name="enableGenerationOfSkosConcept" select="fn:false()"/>

    <!--Allowed characters for a normalized string-->
    <xsl:variable name="allowedStrings" select="'^[\w\d-_:]+$'"/>

    <!--    Shapes Module URI-->
    <xsl:variable name="shapeModuleURI" select="$base-shape-uri"/>
    <!--    Restrictions Module URI-->
    <xsl:variable name="restrictionsModuleURI" select="$base-rule-uri"/>
    <!--    Core Module URI-->
    <xsl:variable name="coreModuleURI" select="$base-ontology-uri"/>

    <xsl:variable name="reference-to-external-classes-in-glossary" select="fn:false()"/>
    
    <!-- The metadata.xml is used to define the metadata for each input xmi file. The metadata.xml is found next to the input file. -->    
    <xsl:variable name="m" select="document(concat(functx:substring-before-last(base-uri(), '/'), '/', 'metadata.xml'))" />
    <!-- ontology title, version to be inserted in the ontology header -->
    <!-- Customized metadata: title and description can be appended or extended -->    
    <xsl:variable name="ontologyTitle" select="$m//title"/>    
    <xsl:variable name="ontologyDescription" select="$m//description"/>
    <!-- Common metadata (core, restrictions and shacle) -->    
    <xsl:variable name="commonMetadata" 
        select="
        $m//rdfs:seeAlso| 
        $m//owl:versionInfo|
        $m//dc:contributor|
        $m//dct:creator|
        $m//dc:rights|
        $m//dct:license|
        $m//owl:incompatibleWith|
        $m//cc:attributionName|
        $m//cc:attributionURL|
        $m//vann:preferredNamespacePrefix               
        "/>    
</xsl:stylesheet>