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
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
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
        <xd:desc>Rule T.01. Label - Specify a label for UML element</xd:desc>
        <xd:param name="elementName"/>
        <xd:param name="elementUri"/>
    </xd:doc>
    <xsl:template name="coreLayerName">
        <xsl:param name="elementName"/>
        <xsl:param name="elementUri"/>
        <rdf:Description rdf:about="{$elementUri}">
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$elementName"/>
            </skos:prefLabel>
        </rdf:Description>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule T.03. Description - Specify a description for UML element</xd:desc>
        <xd:param name="definition"/>
        <xd:param name="elementUri"/>
    </xd:doc>
    <xsl:template name="coreLayerDescription">
        <xsl:param name="definition"/>
        <xsl:param name="elementUri"/>
        <rdf:Description rdf:about="{$elementUri}">
            <skos:definition xml:lang="en">
                <xsl:value-of select="$definition"/>
            </skos:definition>
        </rdf:Description>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule T.05. Comment - Specify annotation axiom for UML Comment associated to a UML
            element</xd:desc>
        <xd:param name="comment"/>
        <xd:param name="elementUri"/>
    </xd:doc>
    <xsl:template name="coreLayerComment">
        <xsl:param name="comment"/>
        <xsl:param name="elementUri"/>
        <rdf:Description rdf:about="{$elementUri}">
            <rdfs:comment xml:lang="en">
                <xsl:value-of select="$comment"/>
            </rdfs:comment>
        </rdf:Description>
    </xsl:template>


    <xd:doc>
        <xd:desc>Rule T.08. Annotate all locally defined OWL concepts with the name of the (core) ontology that defines them.</xd:desc>
        <xd:param name="elementUri"/>
    </xd:doc>
    <xsl:template name="coreDefinedBy">
        <xsl:param name="elementUri"/>
        <xsl:if test="fn:contains($elementUri, $base-ontology-uri)">
            <rdf:Description rdf:about="{$elementUri}">
                <rdfs:isDefinedBy rdf:resource="{$coreArtefactURI}"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>