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
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>Finds the first ancestor packagedElement of type='uml:Package' corresponding to a
            given input element</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:getContainingPackageName" as="xs:string">                
        <xsl:param name="element" as="node()"/>        
        <xsl:variable name="root" select="root($element)"/>
        <xsl:sequence
            select="$root//(ownedAttribute | packagedElement)[@xmi:id = $element/@xmi:idref]/ancestor::packagedElement[@xmi:type = 'uml:Package'][position() = 1]/@name"
        />        
    </xsl:function>
    
    
    
    <xd:doc>
        <xd:desc>fetch the xmi:element with a given name</xd:desc>
        <xd:param name="name"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getElementByName" as="node()*">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="$root//elements/element[@name=$name]"/>
    </xsl:function>
    
    
</xsl:stylesheet>