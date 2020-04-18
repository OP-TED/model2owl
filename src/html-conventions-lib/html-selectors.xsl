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
            <xd:p>This module defines a common set of selectors that shall be used regardless of the
                constructed output</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>
    
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="xmi:XMI">
        <xsl:apply-templates select="/xmi:XMI/xmi:Extension/elements"/>
        <xsl:apply-templates select="/xmi:XMI/xmi:Extension/connectors"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p> This template selects target element definitions</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="elements">
        
        <h1 class="selector-heading">Classes</h1>
        <xsl:apply-templates select="element[@xmi:type = 'uml:Class']"/>
        <h1 class="selector-heading">Enumerations</h1>
        <xsl:apply-templates select="element[@xmi:type = 'uml:Enumeration']"/>
        <h1 class="selector-heading">Data-types</h1>
        <xsl:apply-templates select="element[@xmi:type = 'uml:DataType']"/>
        <h1 class="selector-heading">Packages</h1>
        <xsl:apply-templates select="element[@xmi:type = 'uml:Package']"/>        
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p> This template selects target connector definitions</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="connectors">
        <h1 class="selector-heading">Generalizations</h1>
        <xsl:apply-templates select="connector[./properties/@ea_type = 'Generalization']"/>
        <h1 class="selector-heading">Associations</h1>
        <xsl:apply-templates select="connector[./properties/@ea_type = 'Association']"/>
        <h1 class="selector-heading">Dependencies</h1>
        <xsl:apply-templates select="connector[./properties/@ea_type = 'Dependency']"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>This is the default template for all selected elements and connectors</xd:desc>
    </xd:doc>
    <xsl:template match="*">
        <p>Default for &lt;<xsl:value-of select="./name()"/>&gt; type "<xsl:value-of select="./@xmi:type | ./properties/@ea_type"/>"</p>
    </xsl:template>
    
</xsl:stylesheet>