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
                <xsl:value-of select="f:lexicalQNameToWords($elementName)"/>
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
                <xsl:value-of select="fn:normalize-space($definition)"/>
            </skos:definition>
        </rdf:Description>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule T.06. Comment - Specify annotation axiom for UML Comment associated to a UML
            element</xd:desc>
        <xd:param name="comment"/>
        <xd:param name="elementUri"/>
    </xd:doc>
    <xsl:template name="coreLayerComment">
        <xsl:param name="comment"/>
        <xsl:param name="elementUri"/>
        <rdf:Description rdf:about="{$elementUri}">
            <xsl:element name="{$commentProperty}">
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:value-of select="fn:normalize-space($comment)"/>
            </xsl:element>
        </rdf:Description>
    </xsl:template>


    <xd:doc>
        <xd:desc>Rule T.08. Annotate all locally defined OWL concepts with the name of the (core)
            ontology that defines them.</xd:desc>
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
    
    
    <xd:doc>
        <xd:desc>Rule T.07. Tag — in core ontology layer. Specify an annotation axiom on the OWL
            entity for each UML Tag associated to a UML element. If a tag has an associated language
            tag, it should be attached to the value.</xd:desc>
        <xd:param name="elementUri"/>
        <xd:param name="tagName"/>
        <xd:param name="tagValue"/>
    </xd:doc>
    <xsl:template name="coreLayerTags">
        <xsl:param name="tagName"/>
        <xsl:param name="tagValue"/>
        <xsl:param name="elementUri"/>
        <xsl:if test="not($tagName = $excludedTagNamesList)">
        <rdf:Description rdf:about="{$elementUri}">
        <xsl:choose>
            <xsl:when test="fn:contains($tagName, '@')">
                    <xsl:variable name="langTag" select="fn:substring-after($tagName, '@')"/>
                    <xsl:variable name="normalisedTagName"
                        select="fn:substring-before($tagName, '@')"/>
                <xsl:element name="{$normalisedTagName}" namespace="{f:getNamespaceURI(fn:substring-before($tagName, ':'))}">
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="$langTag"/>
                        </xsl:attribute>
                        <xsl:value-of select="$tagValue"/>
                    </xsl:element>
                </xsl:when>
            <xsl:when test="fn:contains($tagName, '^^')">
                <xsl:variable name="datatypeCompactURI" select="fn:substring-after($tagName, '^^')"/>
                <xsl:variable name="datatypePrefix" select="fn:substring-before($datatypeCompactURI, ':')"/>
                <xsl:variable name="datatypeLocalName" select="fn:substring-after($datatypeCompactURI, ':')"/>
                <xsl:variable name="expandedDatatypePrefix" select="f:getNamespaceURI($datatypePrefix)"/>
                <xsl:if test="f:validateTagValue($tagValue,$datatypeCompactURI)">


                <xsl:choose>
                    <xsl:when test="$datatypeCompactURI=$stringDatatypes">
                        <xsl:element name="{fn:substring-before($tagName,'^^')}" namespace="{f:getNamespaceURI(fn:substring-before($tagName, ':'))}">
                            <xsl:value-of select="$tagValue"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{fn:substring-before($tagName,'^^')}" namespace="{f:getNamespaceURI(fn:substring-before($tagName, ':'))}">
                            <xsl:attribute name="rdf:datatype">
                                <xsl:value-of select="fn:concat($expandedDatatypePrefix,$datatypeLocalName)"/>
                            </xsl:attribute>
                            <xsl:value-of select="$tagValue"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:when test="fn:contains($tagName, '&lt;&gt;')">
                <xsl:if test="f:validateTagValue($tagValue,'xsd:anyURI')">
                <xsl:variable name="tagPrefix" select="fn:substring-before($tagName, ':')"/>
                <xsl:element name="{fn:substring-before($tagName,'&lt;&gt;')}" namespace="{f:getNamespaceURI(fn:substring-before($tagName, ':'))}">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="$tagValue"/>
                    </xsl:attribute>
                </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$tagName}" namespace="{f:getNamespaceURI(fn:substring-before($tagName, ':'))}">
                    <xsl:attribute name="xml:lang">
                        <xsl:value-of select="'en'"/>
                    </xsl:attribute>
                    <xsl:value-of select="$tagValue"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>      
        </rdf:Description>
 </xsl:if>
    </xsl:template>




</xsl:stylesheet>