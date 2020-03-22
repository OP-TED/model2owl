<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:functx="http://www.functx.com"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    version="3.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>A set of useful utilities</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:import href="../config-parameters.xsl"/>
    
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
        <xd:desc>Lookup a prefix in the namespaceDefinitions (usually an external file with namespace
            definitions) and return the namespace corresponding to the prefix or false if is an invalid prefix</xd:desc>
        <xd:param name="prefix"/>
        <xd:param name="namespaceDefinitions"/>
    </xd:doc>
    <xsl:template name="getNamespaceValues">
        <xsl:param name="prefix"/>
        <xsl:param name="namespaceDefinitions" select="$namespacePrefixes"/>
        
        <xsl:variable name ="prefixNamespace" select="$namespaceDefinitions/*:prefixes/*:prefix/@value[../@name = $prefix]"/>
        <xsl:value-of select="$prefixNamespace"/>
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
        <xd:desc/>
        <xd:param name="lexicalQName"/>
    </xd:doc>
    <xsl:function name="f:buildQNameFromLexicalQName" as="xs:QName">
        <xsl:param name="lexicalQName" as="xs:string"/>
        
        <xsl:variable name="prefix" select="fn:substring-before($lexicalQName,':')"/>
        
        <xsl:variable name="namespaceURI" as="xs:string">
            <xsl:call-template name="getNamespaceValues">
                <xsl:with-param name="prefix" select="$prefix"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="fn:QName($namespaceURI,$lexicalQName)"/>
    </xsl:function>
    

    <xd:doc>
        <xd:desc> generate the element URI pased on the parent package name</xd:desc>
        <xd:param name="lexicalQName"/>
    </xd:doc>
    <xsl:template name="buildURIfromLexicalQName">
        <xsl:param name="lexicalQName"/>
        
        <xsl:variable name="prefix" select="fn:substring-before($lexicalQName,':')"/>
        <xsl:variable name="local" select="fn:substring-after($lexicalQName,':')"/>
            
        <xsl:variable name="namespaceURI">
            <xsl:call-template name="getNamespaceValues">
                <xsl:with-param name="prefix" select="$prefix"/>
            </xsl:call-template>
        </xsl:variable>
        
        

    </xsl:template>



</xsl:stylesheet>