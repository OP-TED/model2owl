<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:functx="http://www.functx.com"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines project level variables and parameters</xd:p>
        </xd:desc>
    </xd:doc>

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
        select="('ccts:Code', 'ccts:Quantity', 
                 'ccts:Measure', 'ccts:Identifier', 'ccts:Amount', 
                 'ccts:Indicator', 'ccts:Text', 'ccts:Numeric')"/>
<!--    the type of attributes which takes values from a controlled list-->
    <xsl:variable name="controlledListType" select="'ccts:Code'"/>
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
<!--    title and description for each ontology module-->
    <xsl:variable name="title-shape-module">eProcurement datashapes</xsl:variable>
    <xsl:variable name="description-shape-module">This module provides the datashape definitions for the eProcurement ontology.</xsl:variable>
    
    <xsl:variable name="title-core-module">eProcurement core ontology</xsl:variable>
    <xsl:variable name="description-core-module">
        This module provides the definitions for the core eProcurement ontology.
        
        Procurement data has been identified as data with a
        high-reuse potential. Given the increasing importance of data standards for
        eProcurement, a number of initiatives driven by the public sector, the industry and
        academia have been kick-started in recent years. Some have grown organically, while
        others are the result of standardisation work. The vocabularies and the semantics that
        they are introducing, the phases of public procurement that they are covering, and the
        technologies that they are using all differ. These differences hamper data
        interoperability and thus its reuse by them or by the wider public. This creates the
        need for a common data standard for publishing procurement data, hence allowing data
        from different sources to be easily accessed and linked, and consequently
        reused.</xsl:variable>
    
    <xsl:variable name="title-restriction-module">eProcurement extended ontology</xsl:variable>
    <xsl:variable name="description-restriction-module">This module provides the inference-related definitions for
        the eProcurement ontology.</xsl:variable>

</xsl:stylesheet>