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
        <xd:desc>[Rule 3] - (Class in data shape layer). Specify declaration axiom for UML Class
            as SHACL Node Shape with a SPARQL constraint that selects all instances of this class</xd:desc>
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
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </owl:Class>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 27]-(Enumeration in core ontology layer) .
            instantiation axiom for an UML enumeration.Specify SKOS concept scheme</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">

        <xsl:variable name="conceptSchemeName" select="f:lexicalQNameToWords(./@name)"/>

        <xsl:variable name="conceptSchemeURI"
            select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>
        <!-- generating the actual CS content -->
        <skos:ConceptScheme rdf:about="{$conceptSchemeURI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$conceptSchemeName"/>
            </rdfs:label>
            <skos:prefLabel>
                <xsl:value-of select="$conceptSchemeName"/>
            </skos:prefLabel>

            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </skos:ConceptScheme>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 28]-(Enumeration items in core ontology layer) .
            instantiation axiom for an UML enumeration item. Specify SKOS concept</xd:desc>
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
<!--            <skos:notation>
                <xsl:value-of select="$notation"/>
            </skos:notation>-->
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$conceptName"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$conceptName"/>
            </skos:prefLabel>
            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </skos:Concept>
    </xsl:template>


<!--    <xd:doc>
        <xd:desc>uml:Package has no equivalent on OWL ontology.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Package']"/>-->

    <xd:doc>
        <xd:desc>Apply rules to data-types</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:DataType']">
        <xsl:choose>
            <xsl:when test="./not(attributes) = fn:true()">
                <xsl:call-template name="datatypeDeclaration"/>
            </xsl:when>
            <xsl:otherwise>
                 <xsl:call-template name="structuredDatatypes"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[Rule 25]-(Datatype in core ontology layer) .Specify datatype declaration axiom</xd:desc>
    </xd:doc>
    <xsl:template name="datatypeDeclaration">
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
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </rdfs:Datatype>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[Rule 26]-(Structured Datatype in core ontology layer) .
            Specify OWL class declaration axiom for UML structured datatype.</xd:desc>
    </xd:doc>
    <xsl:template name="structuredDatatypes">
        <xsl:variable name="datatypeName" select="f:lexicalQNameToWords(./@name)"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <xsl:variable name="datatypeURI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>
        
        
        <owl:Class rdf:about="{$datatypeURI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$datatypeName"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$datatypeName"/>
            </skos:prefLabel>
            
            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </owl:Class>
    </xsl:template>
    
    <xd:doc>
        <xd:desc> [Rule 4] -(Attribute in core ontology layer). Specify declaration axiom(s) for
            attribute(s) as OWL data or object properties deciding based on their types. The
            attributes with primary types should be treated as data properties, whereas those typed
            with classes or enumerations should be treated as object properties.></xd:desc>
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