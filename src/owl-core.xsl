<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sh="http://www.w3.org/ns/shacl#"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi fn f sh"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" xmlns:vann="http://purl.org/vocab/vann/"
    xmlns:cc="http://creativecommons.org/ns#" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:org="http://www.w3.org/ns/org#" version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module constructs the core OWL ontology</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="common/selectors.xsl"/>
    <xsl:import href="owl-core-lib/connectors-owl-core.xsl"/>
    <xsl:import href="owl-core-lib/elements-owl-core.xsl"/>
    <xsl:import href="../config/config-proxy.xsl"/>

    <xsl:output name="core-ePO.rdf" method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>
    
    <xd:doc>
        <xd:desc>The main template for OWL core file</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <rdf:RDF>
            <xsl:namespace name="epo" select="concat($base-ontology-uri, '#')"/>

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
            
            <owl:imports rdf:resource="http://purl.org/dc/terms/"/>
            <owl:imports rdf:resource="http://www.w3.org/2004/02/skos/core"/>
            
            <dct:description xml:lang="en">
                <xsl:value-of select="$description-core-module"/>
            </dct:description>
            <vann:preferredNamespacePrefix>epo</vann:preferredNamespacePrefix>
            <vann:preferredNamespaceUri>
                <xsl:value-of select="fn:concat($base-ontology-uri, $defaultDelimiter)"/>                
            </vann:preferredNamespaceUri>
            <dct:license rdf:resource="http://creativecommons.org/licenses/by-sa/4.0/"/>
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$title-core-module"/>
            </rdfs:label>
            <dct:title xml:lang="en">
                <xsl:value-of select="$title-core-module"/>
            </dct:title>
            
            <owl:versionInfo><xsl:value-of select="$title-core-module"/> version generated automatically on <xsl:value-of
                    select="
                        format-date(current-date(),
                        '[D01]/[M01]/[Y0001]')"
                /></owl:versionInfo>
            <!--            <dct:contributor>
                <foaf:Person rdf:about="http://costezki.ro/eugeniu#">
                    <foaf:name>Eugeniu Costetchi</foaf:name>
                    <foaf:homepage rdf:resource="http://costezki.ro"/>
                    <foaf:firstName>Eugeniu</foaf:firstName>
                    <foaf:lastName>Costetchi</foaf:lastName>
                </foaf:Person>
            </dct:contributor>-->
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