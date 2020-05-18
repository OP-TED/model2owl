<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI connectors are transformed into OWL2
                statements</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../common/fetchers.xsl"/>
    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">

        <xsl:variable name="sourceElementURI"
            select="f:buildURIFromElement(f:getElementByIdRef(./source/@xmi:idref, root(.)), fn:true(), fn:true())"/>
        <xsl:variable name="targetElementURI"
            select="f:buildURIFromElement(f:getElementByIdRef(./target/@xmi:idref, root(.)), fn:true(), fn:true())"/>
        <owl:Class rdf:about="{$sourceElementURI}">
            <rdfs:subClassOf rdf:resource="{$targetElementURI}"/>
        </owl:Class>


        <!--        <owl:Class rdf:about="{$sourceElementURI}">
            <xsl:choose>
                <xsl:when test=" fn:lower-case(./properties/@stereotype)= ('equivalent','complete')">
                    <owl:equivalentClass rdf:resource="{$targetElementURI}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdfs:subClassOf rdf:resource="{$targetElementURI}"/>        
                </xsl:otherwise>
            </xsl:choose>-->


        <!--</owl:Class>-->

    </xsl:template>

    <xd:doc>
        <xd:desc>apply rules to Associations</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        <xsl:call-template name="genericConnector"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>apply rules to Dependencies</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <xsl:variable name="targetType" select="./target/model/@type"/>
        <xsl:variable name="sourceType" select="./source/model/@type"/>
        <xsl:if test="$targetType != 'ProxyConnector' and $sourceType != 'ProxyConnector'">
            <xsl:call-template name="genericConnector"/>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule 11 (Unidirectional association in core ontology layer) . Specify object
            property declaration axiom for the target end of the association.</xd:desc>
    </xd:doc>
    <xsl:template name="genericConnector">
        <xsl:variable name="targetRoleURI"
            select="
                if (./target/role/@name) then
                    f:buildURIFromElement(./target/role, false(), fn:true())
                else
                    ()"/>
        <xsl:variable name="sourceRole"
            select="
                if (./source/role/@name) then
                    f:buildURIFromElement(./source/role, false(), fn:true())
                else
                    ()"/>

        <xsl:variable name="connectorDocumentation"
            select="f:formatDocString(./documentation/@value)"/>

        <xsl:if test="$targetRoleURI">
            <xsl:variable name="name" select="f:lexicalQNameToWords(./target/role/@name)"/>
            <xsl:variable name="note" select="f:formatDocString(./target/documentation/@value)"/>

            <owl:ObjectProperty rdf:about="{$targetRoleURI}">
                <rdfs:label xml:lang="en">
                    <xsl:value-of select="$name"/>
                </rdfs:label>
                <skos:prefLabel xml:lang="en">
                    <xsl:value-of select="$name"/>
                </skos:prefLabel>
                <xsl:if test="$connectorDocumentation">
                    <skos:definition xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </skos:definition>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </rdfs:comment>
                </xsl:if>
                <xsl:if test="$note">
                    <skos:scopeNote xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </skos:scopeNote>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </rdfs:comment>
                </xsl:if>
            </owl:ObjectProperty>
        </xsl:if>

        <xsl:if test="$sourceRole">
            <xsl:variable name="name" select="f:lexicalQNameToWords(./source/role/@name)"/>
            <xsl:variable name="note" select="f:formatDocString(./source/documentation/@value)"/>

            <owl:ObjectProperty rdf:about="{$sourceRole}">
                <rdfs:label xml:lang="en">
                    <xsl:value-of select="$name"/>
                </rdfs:label>
                <skos:prefLabel xml:lang="en">
                    <xsl:value-of select="$name"/>
                </skos:prefLabel>
                <xsl:if test="$connectorDocumentation">
                    <skos:definition xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </skos:definition>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </rdfs:comment>
                </xsl:if>
                <xsl:if test="$note">
                    <skos:scopeNote xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </skos:scopeNote>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </rdfs:comment>
                </xsl:if>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
