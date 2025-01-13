<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    version="3.0">
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
        <xsl:apply-templates select="/xmi:XMI//packagedElement//ownedComment"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>This template target floating comments in the model</xd:desc>
    </xd:doc>
    <xsl:template match="ownedComment">
        <xsl:apply-templates select="ownedComment[@xmi:type = 'uml:Comment']"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p> This template selects target element definitions</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="elements">
        <xsl:apply-templates select="element[@xmi:type = 'uml:Class']"/>
        <xsl:apply-templates select="element[@xmi:type = 'uml:Enumeration']"/>
        <xsl:apply-templates select="element[@xmi:type = 'uml:DataType']"/>
        <!--<xsl:apply-templates select="element[@xmi:type = 'uml:Package']"/>-->        
        <xsl:apply-templates select="element[@xmi:type = 'uml:Class']/attributes/attribute"/>
        <xsl:apply-templates select="element[@xmi:type = 'uml:Enumeration']/attributes/attribute"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p> This template selects target connector definitions</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="connectors">
        <xsl:apply-templates select="connector[./properties/@ea_type = 'Generalization']"/>
        <xsl:apply-templates select="connector[./properties/@ea_type = 'Association']"/>
        <xsl:apply-templates select="connector[./properties/@ea_type = 'Dependency']"/>
        <xsl:apply-templates select="connector[./properties/@ea_type = 'Realisation']"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>This is the default template for all selected elements and connectors</xd:desc>
    </xd:doc>
    <xsl:template match="*">
        <p>Default for &lt;<xsl:value-of select="./name()"/>&gt; type "<xsl:value-of select="./@xmi:type | ./properties/@ea_type"/>"</p>
    </xsl:template>
    
</xsl:stylesheet>