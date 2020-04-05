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
    
    
    <xd:doc>
        <xd:desc>This function will generate a warning message</xd:desc>
        <xd:param name="warningMessage"/>
    </xd:doc>
    <xsl:function name="f:generateHtmlWarning">
        <xsl:param name="warningMessage"/>
        <xsl:sequence>
            <dd><xsl:value-of select="$warningMessage"/></dd>
        </xsl:sequence>        
    </xsl:function>    
    
    <xd:doc>
        <xd:desc>This function will generate an error message</xd:desc>
        <xd:param name="errorMessage"/>
        <xd:param name="elementType"/>
    </xd:doc>
    <xsl:function name="f:generateHtmlError">
        <xsl:param name="elementType"/>
        <xsl:param name="errorMessage"/>
        <xsl:sequence>
            <dd><xsl:value-of select="$errorMessage"/></dd>
        </xsl:sequence>        
    </xsl:function>    
    
    
</xsl:stylesheet>