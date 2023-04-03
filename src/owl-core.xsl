<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sh="http://www.w3.org/ns/shacl#"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi fn f sh"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:bibo="http://purl.org/ontology/bibo/" 
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"    
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" 
    xmlns:vann="http://purl.org/vocab/vann/"
    xmlns:cc="http://creativecommons.org/ns#" 
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:org="http://www.w3.org/ns/org#" 
    xmlns:schema="https://schema.org/"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module constructs the core OWL ontology</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="common/selectors.xsl"/>
    <xsl:import href="owl-core-lib/connectors-owl-core.xsl"/>
    <xsl:import href="owl-core-lib/elements-owl-core.xsl"/>
    <!-- xsl:import href="../config/config-proxy.xsl"/ -->

    <xsl:output name="core-ePO.rdf" method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>    
    
    
    <xd:doc>
        <xd:desc>The main template for OWL core file</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <rdf:RDF>
            <xsl:namespace name="epo" select="concat($base-ontology-uri, '#')"/> 
            <!--<xsl:namespace name="epor" select="concat($base-rule-uri, '#')"/>
            <xsl:namespace name="epos" select="concat($base-shape-uri, '#')"/>-->
            
            <xsl:namespace name="" select="concat($base-ontology-uri, '#')"/>
            <xsl:attribute name="xml:base" expand-text="true">{$coreArtefactURI}</xsl:attribute>
            
            <xsl:call-template name="ontology-header"/>
            <xsl:apply-templates/>
            <xsl:call-template name="connectorsOwlCore"/>
            <xsl:call-template name="generatePropertiesFromDistinctAttributeNamesInCore"/>
        </rdf:RDF>
    </xsl:template>

    <xd:doc>
        <xd:desc> Ontology header </xd:desc>
    </xd:doc>
    <xsl:template name="ontology-header">

        <owl:Ontology rdf:about="{$coreArtefactURI}">         
            <xsl:for-each select="$namespacePrefixes/*:prefixes/*:prefix/@importURI">              
                <owl:imports rdf:resource="{.}"/>
            </xsl:for-each>      
             
            <dct:title xml:lang="en">
                <xsl:value-of select="$ontologyTitle"/>
            </dct:title>
            <dct:description xml:lang="en">
                <xsl:value-of select="$ontologyDescription"/>
            </dct:description>
            <dct:abstract><xsl:value-of select="$abstractCore"/></dct:abstract>
            <skos:changeNote>This version is automatically generated from <xsl:value-of select="tokenize(base-uri(.), '/')[last()]"/> on 
                <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
            </skos:changeNote>
            <xsl:for-each select="$seeAlsoResources">
                <rdfs:seeAlso rdf:resource="{.}"/>
            </xsl:for-each>
            <dct:created><xsl:value-of select="$createdDate"/></dct:created>
            <dct:issued><xsl:value-of select="$issuedDate"/></dct:issued>
            <owl:versionInfo><xsl:value-of select="$versionInfo"/></owl:versionInfo>   
            <owl:incompatibleWith><xsl:value-of select="$incompatibleWith"/></owl:incompatibleWith>
            <owl:versionIRI><xsl:value-of select="fn:concat($coreArtefactURI,'-',$versionInfo)"/></owl:versionIRI>
            <bibo:status><xsl:value-of select="$ontologyStatus"/></bibo:status>
            <owl:priorVersion><xsl:value-of select="$priorVersion"/></owl:priorVersion>
            <vann:preferredNamespaceUri><xsl:value-of select="$preferredNamespaceUri"/></vann:preferredNamespaceUri>
            <vann:preferredNamespacePrefix><xsl:value-of select="$preferredNamespacePrefix"/></vann:preferredNamespacePrefix> 
        </owl:Ontology>
        
    </xsl:template>

</xsl:stylesheet>