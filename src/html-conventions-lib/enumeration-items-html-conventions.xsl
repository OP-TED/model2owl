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
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">
    
    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="../html-conventions-lib/utils-html-conventions.xsl"/>
    
    <xd:doc>
        <xd:desc>Getting all unmet conventions for Enumerations items  </xd:desc>
    </xd:doc>
    
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute">
        <h1>
            <xsl:call-template name="getEnumerationName">
                <xsl:with-param name="enumerationItem" select="."/>
            </xsl:call-template>
        </h1>
        <dl>
            <dt>
                <xsl:call-template name="getEnumerationItemName">
                    <xsl:with-param name="enumerationItem" select="."/>
                </xsl:call-template>
            </dt>
            <xsl:call-template name="enumerationNameConventionChecker">
                <xsl:with-param name="enumerationItem" select="."/>
            </xsl:call-template>
        </dl>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Getting the Enumeration name</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>
    <xsl:template name="getEnumerationName">
        <xsl:param name="enumerationItem"/>
        <xsl:value-of select="$enumerationItem/parent::attributes/parent::element/@name"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Getting the enumeration item name</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>
    <xsl:template name="getEnumerationItemName">
        <xsl:param name="enumerationItem"/>
        <xsl:value-of select="$enumerationItem/@name"/>
    </xsl:template>
    

    
    <xd:doc>
        <xd:desc>Return warning when the enumeration item name is not a normalized string</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>
    
    <xsl:template name="enumerationNameConventionChecker">
        <xsl:param name="enumerationItem"/>
        <xsl:variable name="enumerationItemName" select="$enumerationItem/@name"/>
        <xsl:if test="not(f:isValidNormalizedString($enumerationItemName))">
            <xsl:sequence select="f:generateHtmlWarning('The name of this item is not a normalized string. Please change the item name')"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when the enumeration item doesn't have an initial value</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>
    
    <xsl:template name="enumerationItemInitialValueChecker">
        <xsl:param name="enumerationItem"/>
        <xsl:variable name="noInitialValue" select="$enumerationItem/initial/not(@body)"/>
        <xsl:if test="$noInitialValue = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning('No initial value found. Please add one')"/>
        </xsl:if>
    </xsl:template>
    

    
</xsl:stylesheet>