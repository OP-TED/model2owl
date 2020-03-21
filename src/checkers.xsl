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


    <!-- Global variables   -->
    <xsl:variable name="allowedCharacters" select="'[a-zA-Z0-9-_:]'"/>
    <xsl:variable name="allowedStrings" select="'^[\w\d-_:]+$'"/>
    <xsl:variable name="uppercaseLetters" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="namespacePrefixes" select="fn:doc('../test/testData/namespaces.xml')"/>

    <xd:doc>
        <xd:desc>Checks any string if it is normalized and it contains only allowed characters </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:template name="isValidNormalizedString" as="item()*">
        <xsl:param name="input"/>
        <xsl:value-of select="fn:matches($input, $allowedStrings)"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>Checks if the first letter of the local segment is lower-case or upper-case </xd:desc>
        <xd:param name="input"/>
    </xd:doc>


    <xsl:template name="firstLetterFromQnameLocalSegment">
        <xsl:param name="input"/>
        <xsl:variable name="localNameFromQName" select="fn:substring-after($input, ':')"/>
        <xsl:variable name="firstLetter" select="fn:substring($localNameFromQName, 1, 1)"/>
        <xsl:variable name="startsWithCapitalizedLetter"
            select="fn:contains($uppercaseLetters, $firstLetter)"/>
        <xsl:choose>
            <xsl:when test="$startsWithCapitalizedLetter = fn:true()">
                <xsl:value-of select="'upper-case'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'lower-case'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>Checks if local segment from any Qname is camelCase with first letter upper-cased </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:template name="isQNameUpperCasedCamelCase">
        <xsl:param name="input"/>
        <xsl:variable name="inputIsNormalizedString">
            <xsl:call-template name="isValidNormalizedString">
                <xsl:with-param name="input" select="$input"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="letterType">
            <xsl:call-template name="firstLetterFromQnameLocalSegment">
                <xsl:with-param name="input" select="$input"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="($letterType = 'upper-case') and ($inputIsNormalizedString = fn:true())">
                <xsl:value-of select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Checks if local segment from any Qname is camelCase with first letter lower-cased </xd:desc>
        <xd:param name="input"/>
    </xd:doc>
    
    <xsl:template name="isQNameLowerCasedCamelCase">
        <xsl:param name="input"/>
        <xsl:variable name="inputIsNormalizedString">
            <xsl:call-template name="isValidNormalizedString">
                <xsl:with-param name="input" select="$input"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="letterType">
            <xsl:call-template name="firstLetterFromQnameLocalSegment">
                <xsl:with-param name="input" select="$input"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="($letterType = 'lower-case') and ($inputIsNormalizedString = fn:true())">
                <xsl:value-of select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Lookup a prefix in the namespaceDefinitions (usually an external file with namespace
            definitions) and return the namespace corresponding to the prefix or false if is an invalid prefix</xd:desc>
        <xd:param name="prefix"/>
        <xd:param name="namespaceDefinitions"/>
    </xd:doc>
    <xsl:template name="getNamespaceValues">
        <xsl:param name="prefix"/>
        <xsl:param name="namespaceDefinitions"/>
        
        <xsl:variable name ="prefixNamespace" select="$namespaceDefinitions/*:prefixes/*:prefix/@value[../@name = $prefix]"/> 
        <xsl:choose>
            <xsl:when test="$prefixNamespace">
                <xsl:value-of select="$prefixNamespace"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc></xd:desc>
        <xd:param name="input"/>
    </xd:doc>
    
    <xsl:template name="isValidNamespace">
        <xsl:param name="input"/>
        <xsl:variable name="prefixToCheck" select="fn:substring-before($input, ':')"/>
        <xsl:variable name="checkIfNamespaceExists">
            <xsl:call-template name="getNamespaceValues">
                <xsl:with-param name="namespaceDefinitions" select="$namespacePrefixes"/>
                <xsl:with-param name="prefix" select="$prefixToCheck"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$checkIfNamespaceExists != 'false'">
                <xsl:value-of select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>       
    </xsl:template>

</xsl:stylesheet>