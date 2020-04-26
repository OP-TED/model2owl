<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI connectors are transformed into OWL2 statements</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../common/fetchers.xsl"/>
    <xsl:import href="../common/utils.xsl"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">
        
        <xsl:variable name="sourceElementURI"
            select="f:buildURIFromElement(f:getElementByIdRef(./source/@xmi:idref, root(.)), fn:true(), fn:true())"
        />
        <xsl:variable name="targetElementURI"
            select="f:buildURIFromElement(f:getElementByIdRef(./target/@xmi:idref, root(.)), fn:true(), fn:true())"
        />
                
                
        <owl:Class rdf:about="{$sourceElementURI}">
            <xsl:choose>
                <xsl:when test=" fn:lower-case(./properties/@stereotype)= ('equivalent','complete')">
                    <owl:equivalentClass rdf:resource="{$targetElementURI}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdfs:subClassOf rdf:resource="{$targetElementURI}"/>        
                </xsl:otherwise>
            </xsl:choose>
            
            
        </owl:Class>
        
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        
        <xsl:variable name="targetRole" select="./target/role/@name"/>
        <xsl:variable name="sourceRole" select="./source/role/@name"/>
        
        <owl:ObjectProperty rdf:about="">
            <rdfs:label xml:lang="en"></rdfs:label>
            <skos:prefLabel xml:lang="en"></skos:prefLabel>
            <skos:definition rdf:datatype="http://www.w3.org/1999/02/22-rdf-syntax-ns#HTML"></skos:definition>
            <rdfs:comment rdf:datatype="http://www.w3.org/1999/02/22-rdf-syntax-ns#HTML"></rdfs:comment>
        </owl:ObjectProperty>
    </xsl:template>
    
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <p>This is a generalization</p>
    </xsl:template>

</xsl:stylesheet>
