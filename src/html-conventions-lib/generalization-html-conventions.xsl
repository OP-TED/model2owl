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
        <xd:desc>Getting all generalizations and returning a warning for all unmet conventions  </xd:desc>
    </xd:doc>
    
    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">
        <dl>
            <dt>
                Generalization ID: <xsl:value-of select="@xmi:idref"/>
            </dt>
            <xsl:call-template name="generalizationNameChecker">
                <xsl:with-param name="generalizationConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="generalizationDirectionChecker">
                <xsl:with-param name="generalizationConnector" select="."/>
            </xsl:call-template>
        </dl>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the generalization has a name</xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="generalizationNameChecker">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="generalizationHasNoName" select="$generalizationConnector/not(@name)"/>
        <xsl:if test="$generalizationHasNoName = fn:false()">
            <xsl:sequence select="f:generateHtmlWarning('A generalization should not have a name. Please remove the name')"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return a warning if the generalization has a different direction than Source -> Destination</xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="generalizationDirectionChecker">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="generalizationDirection" select="$generalizationConnector/properties/@direction"/>
        <xsl:if test="$generalizationDirection != 'Source -&gt; Destination'">
            <xsl:sequence select="f:generateHtmlWarning(fn:concat($generalizationDirection, ' is not a valid direction for a generalization. Please rectify this'))"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>