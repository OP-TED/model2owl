<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sh="http://www.w3.org/ns/shacl#"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi fn f sh dc foaf"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"    
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" 
    xmlns:vann="http://purl.org/vocab/vann/"
    xmlns:cc="http://creativecommons.org/ns#" 
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:org="http://www.w3.org/ns/org#" 
    xmlns:schema="https://schema.org/"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module constructs the core OWL ontology</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="owl-core-lib/owl-core-selectors.xsl"/>
    <xsl:import href="owl-core-lib/connectors-owl-core.xsl"/>
    <xsl:import href="owl-core-lib/elements-owl-core.xsl"/>
    <!-- xsl:import href="../config/config-proxy.xsl"/ -->

    <xsl:output name="core-ePO.rdf" method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>    
    
    
    <xd:doc>
        <xd:desc>The main template for OWL core file</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <rdf:RDF>
            <xsl:namespace name="epo" select="concat($base-ontology-uri, '#')"/> 
            <xsl:namespace name="epor" select="concat($base-rule-uri, '#')"/>
            <xsl:namespace name="epos" select="concat($base-shape-uri, '#')"/>
            
            <xsl:namespace name="" select="concat($base-ontology-uri, '#')"/>
            <xsl:attribute name="xml:base" expand-text="true">{$coreModuleURI}</xsl:attribute>
            
            <xsl:call-template name="ontology-header"/>
            <xsl:apply-templates/>
            <xsl:call-template name="connectorsOwlCore"/>
            <xsl:call-template name="generatePropertiesFromDistinctAttributeNamesInCore"/>
        </rdf:RDF>
    </xsl:template>

    <xd:doc>
        <xd:desc> Ontology header </xd:desc>
    </xd:doc>
    <xsl:template name="ontology-header">

        <owl:Ontology rdf:about="{$coreModuleURI}">
            <!-- imports some common resources from metadata.xml (next to the xmi input file)-->
            <xsl:for-each select="$m//imports/@resource">
                <owl:imports rdf:resource="{.}"/>
            </xsl:for-each>            
             
            <dct:title xml:lang="en">
                <xsl:value-of select="$ontologyTitle"/>
            </dct:title>
            <dct:description xml:lang="en">
                <xsl:value-of select="$ontologyDescription"/>
            </dct:description>            
            
            
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$ontologyTitle"/>
            </rdfs:label>            
            
            <owl:versionIRI rdf:resource="{fn:concat($coreModuleURI,'#',tokenize(base-uri(.), '/')[last()],'-',format-date(current-date(),
                '[Y0001]-[M01]-[D01]'))}"/>            
            
            <rdfs:comment>This version is automatically generated from <xsl:value-of select="tokenize(base-uri(.), '/')[last()]"/> on <xsl:value-of
                select="
                format-date(current-date(),
                '[Y0001]-[M01]-[D01]')"/>
            </rdfs:comment>
            
            <dct:date rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                <xsl:value-of select="format-date(current-date(),
                    '[Y0001]-[M01]-[D01]')"/>
            </dct:date>
            
            <xsl:copy-of select="$commonMetadata"></xsl:copy-of>
            <vann:preferredNamespaceUri>
                <xsl:value-of select="fn:concat($base-ontology-uri, $defaultDelimiter)"/>                
            </vann:preferredNamespaceUri>
        </owl:Ontology>
        
    </xsl:template>

</xsl:stylesheet>