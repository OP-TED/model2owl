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
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:vann="http://purl.org/vocab/vann/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:cc="http://creativecommons.org/ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:import href="config-parameters.xsl"/>
    <xsl:import href="reasoning-layer-lib/reasoning-layer-selectors.xsl"/>
    <xsl:import href="reasoning-layer-lib/elements-reasoning-layer.xsl"/>
    <xsl:import href="reasoning-layer-lib/connectors-reasoning-layer.xsl"/>



    <xsl:output name="ext-ePO.rdf" method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>

    <xsl:variable name="moduleURI" select="fn:concat($base-uri, '/', 'ext')"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="/">
        <rdf:RDF>
            <xsl:namespace name="epo" select="concat($base-uri, '#')"/>
            <xsl:attribute name="xml:base" expand-text="true">{$moduleURI}</xsl:attribute>
            <xsl:call-template name="ontology-header"/>
            <xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>

    <xd:doc>
        <xd:desc> Ontology header </xd:desc>
    </xd:doc>
    <xsl:template name="ontology-header">

        <xsl:variable name="title">eProcurement extended ontology</xsl:variable>
        <xsl:variable name="description">This module provides the inference-related definitions for
            the eProcurement ontology.</xsl:variable>


        <owl:Ontology rdf:about="">

            <!--<owl:imports rdf:resource="{$base-uri}/core"/>-->

            <owl:imports rdf:resource="http://purl.org/dc/terms/"/>
            <owl:imports rdf:resource="http://www.w3.org/2004/02/skos/core"/>
            <owl:imports rdf:resource="http://datashapes.org/dash"/>
            <owl:imports rdf:resource="http://www.w3.org/ns/shacl#"/>

            <dct:description xml:lang="en">
                <xsl:value-of select="$description"/>
            </dct:description>
            <vann:preferredNamespacePrefix>epo</vann:preferredNamespacePrefix>
            <vann:preferredNamespaceUri>
                <xsl:value-of select="fn:concat($base-uri, $defaultDelimiter)"/>
            </vann:preferredNamespaceUri>
            <dct:license rdf:resource="http://creativecommons.org/licenses/by-sa/4.0/"/>
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$title"/>
            </rdfs:label>
            <dct:title xml:lang="en">
                <xsl:value-of select="$title"/>
            </dct:title>
            <!--<skos:prefLabel xml:lang="en"><xsl:value-of select="$title"/></skos:prefLabel>-->
            <!--<owl:versionIRI><xsl:value-of select="$base-uri"/></owl:versionIRI>-->
            <owl:versionInfo><xsl:value-of select="$title"/> version generated automatically on
                    <xsl:value-of
                    select="
                        format-date(current-date(),
                        '[D01]/[M01]/[Y0001]')"
                /></owl:versionInfo>
            <rdfs:seeAlso rdf:resource="https://op.europa.eu/en/web/eu-vocabularies/e-procurement"/>
            <rdfs:seeAlso
                rdf:resource="https://joinup.ec.europa.eu/solution/eprocurement-ontology/about"/>
            <rdfs:seeAlso
                rdf:resource="https://github.com/eprocurementontology/eprocurementontology"/>
            <cc:attributionName>PublicationsOffice of the European Union</cc:attributionName>
            <cc:attributionURL
                rdf:resource="http://publications.europa.eu/resource/authority/corporate-body/PUBL"/>

            <dct:date rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                <xsl:value-of select="fn:current-date()"/>
            </dct:date>
        </owl:Ontology>
    </xsl:template>

</xsl:stylesheet>