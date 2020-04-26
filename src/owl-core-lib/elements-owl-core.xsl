<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f functx"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:functx="http://www.functx.com"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI elements are transformed into OWL2
                statements</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="../common/checkers.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>

    <xd:doc>
        <xd:desc>Generate a OWL class definition</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:variable name="className" select="f:lexicalQNameToWords(./@name)"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <xsl:variable name="classURI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>
        

        <owl:Class rdf:about="{$classURI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$className"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$className"/>
            </skos:prefLabel>
            
            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </owl:Class>
    </xsl:template>

    <xd:doc>
        <xd:desc>Generate the skos:ConceptScheme definition</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">

        <xsl:variable name="conceptSchemeName" select="f:lexicalQNameToWords(./@name)"/>

        <xsl:variable name="conceptSchemeURI"
            select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>
        <!-- generating the actual CS content -->
        <skos:ConceptScheme rdf:about="{$conceptSchemeURI}">
            <skos:prefLabel>
                <xsl:value-of select="$conceptSchemeName"/>
            </skos:prefLabel>

            <xsl:if test="$documentation != ''">
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </skos:ConceptScheme>
    </xsl:template>

    <xd:doc>
        <xd:desc>Generate the skos:Concept for each attribute in an enumeration</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute">
        <xsl:variable name="conceptName"
            select="
                if (boolean(./initial/@body)) then
                    ./initial/@body
                else
                    f:lexicalQNameToWords(./@name)"/>
        <xsl:variable name="conceptURI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="notation" select="f:camelCaseString($conceptName)"/>
        <xsl:variable name="conceptSchemeURI"
            select="f:buildURIFromElement(../.., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./documentation/@value)"/>

        <xsl:variable name="initialValue" select="./initial/@body"/>

        <skos:Concept rdf:about="{$conceptURI}">
            <skos:inScheme rdf:resource="{$conceptSchemeURI}"/>
            <skos:notation>
                <xsl:value-of select="$notation"/>
            </skos:notation>

            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$conceptName"/>
            </skos:prefLabel>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </skos:Concept>
    </xsl:template>


<!--    <xd:doc>
        <xd:desc>uml:Package has no equivalent on OWL ontology.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Package']"/>-->

    <xd:doc>
        <xd:desc>Generate a rdfs:Datatype definition</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:DataType']">
        <xsl:variable name="name" select="f:lexicalQNameToWords(./@name)"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <xsl:variable name="URI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>

        <rdfs:Datatype rdf:about="{$URI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$name"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$name"/>
            </skos:prefLabel>

            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </rdfs:Datatype>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">

        <xsl:variable name="typeElement"
            select="f:getElementByName(./properties/@type, root(.))/@type"/>
        <xsl:variable name="umlDatatype"
            select="f:getUmlDataTypeValues(./properties/@type, $umlDataTypesMapping)"/>
        <xsl:variable name="xsdRdfDataType"
            select="f:getXsdRdfDataTypeValues(./properties/@type, $xsdAndRdfDataTypes)"/>

        <xsl:variable name="name"
            select="
                if (boolean(./@name)) then
                    f:lexicalQNameToWords(./@name)
                else
                    $mockUnnamedElement"
        />
        
        <xsl:variable name="documentation" select="f:formatDocString(./documentation/@value)"/>
        <!-- TODO: inject the 'has' prefix here if needed -->
        <xsl:variable name="URI"
            select="
                if (fn:starts-with(./@name, 'has') or fn:starts-with(./@name, 'is')) then
                    f:buildURIFromElement(., fn:false(), fn:true())
                else
                    f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="propertyType"
            select="
                if (f:isAttributeTypeValidForDatatypeProperty(.)) then
                    'owl:DatatypeProperty'
                else
                    if (f:isAttributeTypeValidForObjectProperty(.)) then
                        'owl:ObjectProperty'
                    else
                        'rdf:Property'"
        />
        <xsl:element name="{$propertyType}">
            <xsl:attribute name="rdf:about" select="$URI"/>
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$name"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$name"/>
            </skos:prefLabel>
            <rdfs:comment >
                <xsl:value-of select="./@xmi:idref"/>
            </rdfs:comment>
            <xsl:if test="boolean($documentation)">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>