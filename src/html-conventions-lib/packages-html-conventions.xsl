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
        <xd:desc>Getting all packages and show only the ones that have unmet conventions</xd:desc>
    </xd:doc>
    
    <xsl:template match="element[@xmi:type = 'uml:Package']">
        <xsl:variable name="packageChecks" as="item()*">
            <xsl:call-template name="packageNameChecker">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($packageChecks)">
        <dl>
            <dt>
                <xsl:call-template name="getPackageName">
                    <xsl:with-param name="package" select="."/>
                </xsl:call-template>
            </dt>
            <xsl:copy-of select="$packageChecks"/>
        </dl>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Getting the package name</xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    <xsl:template name="getPackageName">
        <xsl:param name="package"/>
        <xsl:value-of select="$package/@name"/>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return warning when a package name is not a normalized string</xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    
    <xsl:template name="packageNameChecker">
        <xsl:param name="package"/>
        <xsl:variable name="packageName" select="$package/@name"/>
        <xsl:if test="not(f:isValidNormalizedString($packageName))">
            <xsl:sequence select="f:generateHtmlWarning('The name of the package is not a normalized string')"/>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return warning when a package is empty - NOT YET IMPLEMENTED</xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    
</xsl:stylesheet>