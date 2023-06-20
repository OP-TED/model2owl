<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi fn f"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sh="http://www.w3.org/ns/shacl#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI elements are transformed into OWL2
                statements</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:import href="../common/utils.xsl"/>

    <xd:doc>
        <xd:desc>Rule T.02. Label — in data shape layer. Specify a label for the SHACL shape, based on the name of the UML element.</xd:desc>
        <xd:param name="uri"/>
        <xd:param name="elementName"/>
    </xd:doc>
    <xsl:template name="shapeLayerName">
        <xsl:param name="elementName"/>
        <xsl:param name="uri"/>
        
        <rdf:Description rdf:about = "{$uri}">
            <rdfs:label><xsl:value-of select="$elementName"/></rdfs:label>
        </rdf:Description>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule T.04. Description — in data shape layer
            Specify an annotation (comment or description) for the SHACL shape based on the note on the UML element.</xd:desc>
        <xd:param name="definition"/>
        <xd:param name="uri"/>
        <xd:param name="rdfsComment"/>
    </xd:doc>
    <xsl:template name="shapeLayerDescription">
        <xsl:param name="definition"/>
        <xsl:param name="uri"/>
        <xsl:param name="rdfsComment"/>
        
        <rdf:Description rdf:about="{$uri}">
            <xsl:choose>
                <xsl:when test="$rdfsComment=fn:true()">
                    <rdfs:comment><xsl:value-of select="$definition"/></rdfs:comment>
                </xsl:when>
                <xsl:otherwise>
                    <sh:description><xsl:value-of select="$definition"/></sh:description>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule T.05. Comment - Specify annotation axiom for UML Comment associated to a UML
            element</xd:desc>
        <xd:param name="comment"/>
        <xd:param name="uri"/>
        <xd:param name="rdfsComment"/>
    </xd:doc>
    <xsl:template name="shapeLayerComment">
        <xsl:param name="comment"/>
        <xsl:param name="uri"/>
        <xsl:param name="rdfsComment"/>
        <rdf:Description rdf:about="{$uri}">
            <xsl:choose>
                <xsl:when test="$rdfsComment=fn:true()">
                    <rdfs:comment><xsl:value-of select="$comment"/></rdfs:comment>
                </xsl:when>
                <xsl:otherwise>
                    <sh:description><xsl:value-of select="$comment"/></sh:description>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Rule T.09. Defined by - Specify if UML element is defined by the core
            ontology</xd:desc>
        <xd:param name="uri"/>
    </xd:doc>
        
    <xsl:template name="shapeLayerDefinedBy">
        <xsl:param name="uri"/>
        <xsl:if test="fn:contains($uri, $base-ontology-uri)">
            <rdf:Description rdf:about="{$uri}">
                <rdfs:isDefinedBy rdf:resource="{$coreArtefactURI}"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>