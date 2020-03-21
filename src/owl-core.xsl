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
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">

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
    
    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>
    
    <xsl:variable name="base-uri" select="'http://publications.europa.eu/ontology/ePO'"/>
    <xsl:variable name="date" select="replace(string(current-time()), '([\D])', 'x')"/>
    
    <xd:doc>
        <xd:desc>The main template for OWL core file</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <rdf:RDF>
            <xsl:namespace name="epo" select="concat($base-uri, '#')"/>
            <xsl:attribute name="xml:base" expand-text="true">{$base-uri}</xsl:attribute>
            <xsl:call-template name="ontology-header"/>
            <xsl:apply-templates/>            
        </rdf:RDF>
    </xsl:template>    
    
    <xd:doc>
        <xd:desc> Ontology header </xd:desc>
    </xd:doc>
    <xsl:template name="ontology-header">
        <owl:Ontology rdf:about="">
            <owl:imports rdf:resource="http://purl.org/dc/terms/"/>
            <rdfs:comment xml:lang="en">This is the eProcurement ontology definition.</rdfs:comment>
            <dct:license rdf:resource="http://creativecommons.org/licenses/by-sa/3.0/"/>
            <rdfs:label xml:lang="en">eProcurement ontology</rdfs:label>
            <owl:versionInfo>eProcurement Ontology version 0.0.2 (auto generated)</owl:versionInfo>
            <dct:contributor rdf:resource="http://costezki.ro/eugeniu"/>
            <owl:imports rdf:resource="http://www.w3.org/2004/02/skos/core"/>
            <rdfs:seeAlso rdf:resource="https://op.europa.eu/en/web/eu-vocabularies/e-procurement"/>
            <dct:creator
                rdf:resource="http://publications.europa.eu/resource/authority/corporate-body/PUBL"/>
            <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                <xsl:value-of select="$date"/>
            </dct:modified>
        </owl:Ontology>
    </xsl:template>    
    
</xsl:stylesheet>