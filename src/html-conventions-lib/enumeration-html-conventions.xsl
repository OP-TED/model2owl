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
        <xd:desc>Getting all enumerations and items and show only the ones with unmet conventions</xd:desc>
    </xd:doc>
    
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">
        <xsl:variable name="enumeration">
            <xsl:call-template name="getEnumerationName">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="enumerationConventions" as="item()*">
            <xsl:call-template name="enumerationNameChecker">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="enumerationNameCaseChecker">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="enumerationItemsChecker">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="enumerationItemConventions" as="item()*">
            <xsl:apply-templates select="attributes/attribute"/>
        </xsl:variable>
        <xsl:if test="boolean($enumerationConventions) or boolean($enumerationItemConventions)">
        <h2>
            <xsl:value-of select="$enumeration"/>
        </h2>
        <section>
            <xsl:if test="boolean($enumerationConventions)">
            <section>
                <dl>
                    <dt>Unmet enumeration conventions</dt>
                    <xsl:copy-of select="$enumerationConventions"/>
                </dl>
            </section>
            </xsl:if>
            <xsl:if test="boolean($enumerationItemConventions)">
            <section>
                <xsl:copy-of select="$enumerationItemConventions"/>
            </section>
            </xsl:if>
        </section>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Getting the enumeration name</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="getEnumerationName">
        <xsl:param name="enumeration"/>
        <xsl:value-of select="$enumeration/@name"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when enumeration name is not a valid Qname</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    
    <xsl:template name="enumerationNameChecker">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:if test="f:isValidQname($enumerationName) = fn:false()">
            <xsl:sequence select="f:generateHtmlWarning('The name of this enumeration is not a valid Qname. Please change')"/>
        </xsl:if>
    </xsl:template>
    

    <xd:doc>
        <xd:desc>Return warning when Enumeration Qname is not with capitalized letter </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    
    <xsl:template name="enumerationNameCaseChecker">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:if test="not(f:isQNameUpperCasedCamelCase($enumerationName))">
            <xsl:sequence select="f:generateHtmlWarning('The first letter of the local segment from 
                the Qname of the class is lower-cased. Please change it to upper-case')"/>
        </xsl:if>
    </xsl:template>
        
    <xd:doc>
        <xd:desc>Return warning when an Enumeration doesn't have items </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    
    <xsl:template name="enumerationItemsChecker">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationNumberOfAttributes" select="count($enumeration/attributes/attribute)"/>
        <xsl:if test="$enumerationNumberOfAttributes = 0">
            <xsl:sequence select="f:generateHtmlWarning('This enumeration has no items')"/>
        </xsl:if>
    </xsl:template>
    
    
</xsl:stylesheet>