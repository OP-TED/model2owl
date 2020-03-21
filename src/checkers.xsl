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
    <xsl:variable name="umlDataTypesMapping" select="fn:doc('../test/testData/umlToXsdDataTypes.xml')"/>
    <xsl:variable name="xsdAndRdfDataTypes" select="fn:doc('../test/testData/xsdAndRdfDataTypes.xml')"/>

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
        <xd:desc>Check if the namespace is valid</xd:desc>
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
    
    <xd:doc>
        <xd:desc>Lookup a data-type in the xsd and rdf accepted data-type document (usually an external file with xsd and rdf
            data-types definitions) and return false or the data-type name if it exists</xd:desc>
        <xd:param name="qname"/>
        <xd:param name="dataTypesDefinitions"/>
    </xd:doc>
    <xsl:template name="getXsdRdfDataTypeValues">
        <xsl:param name="qname"/>
        <xsl:param name="dataTypesDefinitions"/>
        
        <xsl:variable name ="dataType" select="$dataTypesDefinitions/*:datatypes/*:datatype/@qname = $qname"/> 
        <xsl:choose>
            <xsl:when test="$dataType">
                <xsl:value-of select="$dataTypesDefinitions/*:datatypes/*:datatype[@qname=$qname]/@qname"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Lookup an uml data-type in the docmuents that presents a mapping with the xsd data-type(usually an external file with
            mapping between uml data-type and xsd data-type) and if found convert data-type from uml to xsd or return false</xd:desc>
        <xd:param name="qname"/>
        <xd:param name="umlDataTypeMappings"/>
    </xd:doc>
    <xsl:template name="getUmlDataTypeValues">
        <xsl:param name="qname"/>
        <xsl:param name="umlDataTypeMappings"/>
        
        <xsl:variable name ="dataType" select="$umlDataTypeMappings/*:mappings/*:mapping/from/@qname = $qname"/> 
        <xsl:choose>
            <xsl:when test="$dataType">
                <xsl:value-of select="$umlDataTypeMappings/*:mappings/*:mapping/*:to[../from/@qname = $qname]/@qname"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Check if the data-type is valid</xd:desc>
        <xd:param name="input"/>
    </xd:doc>
    
    <xsl:template name="isValidDataType">
        <xsl:param name="input"/>
        <xsl:variable name="umlDatatype">
            <xsl:call-template name="getUmlDataTypeValues">
                <xsl:with-param name="qname" select="$input"/>
                <xsl:with-param name="umlDataTypeMappings" select="$umlDataTypesMapping"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="xsdRdfDataType">
            <xsl:call-template name="getXsdRdfDataTypeValues">
                <xsl:with-param name="qname" select="$input"/>
                <xsl:with-param name="dataTypesDefinitions" select="$xsdAndRdfDataTypes"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="($umlDatatype != 'false') or ($xsdRdfDataType != 'false')">
                <xsl:value-of select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>