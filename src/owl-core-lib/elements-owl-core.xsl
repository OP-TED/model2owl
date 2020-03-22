<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:f="http://https://github.com/costezki/model2owl#" 
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI elements are transformed into OWL2 statements</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:import href="../common/utils.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>

    <xd:doc>
        <xd:desc>Generate a OWL class definition</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']">

        <!-- TODO: un-CamelCase the name to a normalised string-->
        <xsl:variable name="className" select="./@name"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <!-- TODO: chnge to the propoer URI -->
        <xsl:variable name="classURI" select="f:buildURIfromLexicalQName(./@name)"/>
        <xsl:variable name="documentation" select="./properties/@documentation"/>

        <owl:Class rdf:about="{$classURI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$className"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$className"/>
            </skos:prefLabel>
            <xsl:choose>
                <xsl:when test="$documentation != ''">
                    <rdfs:comment rdf:datatype="http://www.w3.org/1999/02/22-rdf-syntax-ns#HTML">
                        <!-- TODO: format the documentation -->
                        <xsl:value-of select="$documentation"/>
                    </rdfs:comment>
                </xsl:when>
            </xsl:choose>
        </owl:Class>
    </xsl:template>

    <xd:doc>
        <xd:desc>Generate the skos:ConceptScheme definition</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">
        <!-- TODO: un-CamelCase the name to a normalised string-->
        <xsl:variable name="conceptSchemeName" select="./@name"/>
        <!-- TODO: chnge to the propoer URI -->
        <xsl:variable name="conceptSchemeURI" select="./@name"/>
        <xsl:variable name="documentation" select="./properties/@documentation"/>
        <!-- generating the actual CS content -->
        <skos:ConceptScheme rdf:about="{$conceptSchemeURI}">
            <skos:prefLabel>
                <xsl:value-of select="$conceptSchemeName"/>
            </skos:prefLabel>
            <xsl:choose>
                <xsl:when test="$documentation">
                    <skos:definition>
                        <xsl:value-of select="$documentation"/>
                    </skos:definition>
                </xsl:when>
            </xsl:choose>
        </skos:ConceptScheme>
    </xsl:template>

    <xd:doc>
        <xd:desc>Generate the skos:Concept for each attribute in an enumeration</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute">
        <!-- TODO: un-CamelCase the name to a normalised string-->
        <xsl:variable name="conceptName" select="./@name"/>
        <!-- TODO: chnge to the propoer URI -->
        <xsl:variable name="conceptURI" select="./@name"/>

        <xsl:variable name="conceptSchemeURI" select="../../@name"/>

        <skos:Concept rdf:about="{$conceptURI}">
            <skos:inScheme rdf:resource="{$conceptSchemeURI}"/>
            <skos:notation>
                <xsl:value-of select="$conceptName"/>
            </skos:notation>
            <xsl:choose>
                <xsl:when test="./initial/@body">
                    <skos:prefLabel xml:lang="en">
                        <xsl:value-of select="./initial/@body"/>
                    </skos:prefLabel>
                </xsl:when>
                <xsl:otherwise>
                    <skos:prefLabel xml:lang="en">
                        <xsl:value-of select="$conceptName"/>
                    </skos:prefLabel>
                </xsl:otherwise>
            </xsl:choose>
        </skos:Concept>
    </xsl:template>


    <xd:doc>
        <xd:desc>uml:Package has no equivalent on OWL ontology.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Package']"/>

    <xd:doc>
        <xd:desc>Generate a rdfs:Datatype definition</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:DataType']">
        <!-- TODO: un-CamelCase the name to a normalised string-->
        <xsl:variable name="name" select="./@name"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <!-- TODO: chnge to the propoer URI -->
        <xsl:variable name="URI" select="./@name"/>
        <xsl:variable name="documentation" select="./properties/@documentation"/>

        <rdfs:Datatype rdf:about="{$URI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$name"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$name"/>
            </skos:prefLabel>
            <xsl:choose>
                <xsl:when test="$documentation != ''">
                    <rdfs:comment rdf:datatype="http://www.w3.org/1999/02/22-rdf-syntax-ns#HTML">
                        <!-- TODO: format the documentation -->
                        <xsl:value-of select="$documentation"/>
                    </rdfs:comment>
                </xsl:when>
            </xsl:choose>
        </rdfs:Datatype>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">
        <p>This is a class attribute</p>
    </xsl:template>



</xsl:stylesheet>