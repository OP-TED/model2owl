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
    xmlns:f="http://https://github.com/costezki/model2owl#" xmlns:sh="http://www.w3.org/ns/shacl#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:functx="http://www.functx.com"
    version="3.0">

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="../common/checkers.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>

    <xd:doc>
        <xd:desc>[Rule 2] - (Class in data shape layer) .Specify declaration axiom for UML Class as
            SHACL Node Shape where the URI and a label are deterministically generated from the
            class name</xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="classDeclaration">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="f:lexicalQNameToWords($class/@name)"/>
        <xsl:variable name="classURI" select="f:buildURIFromElement($class, fn:true(), fn:true())"/>
        <xsl:variable name="documentation"
            select="f:formatDocString($class/properties/@documentation)"/>

        <sh:NodeShape rdf:about="{$classURI}">
            <xsl:call-template name="elementName">
                <xsl:with-param name="name" select="$className"/>
            </xsl:call-template>
            <xsl:if test="$documentation != ''">
                <xsl:call-template name="elementDescription">
                    <xsl:with-param name="description" select="$documentation"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$class/properties/@stereotype = ('Abstract', 'abstract class')">
                <xsl:call-template name="abstractClassDeclaration"/>
            </xsl:if>
            <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
        </sh:NodeShape>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 30]-(Label) Specify a label for UML element</xd:desc>
        <xd:param name="name"/>
    </xd:doc>
    <xsl:template name="elementName">
        <xsl:param name="name"/>
        <sh:name>
            <xsl:value-of select="$name"/>
        </sh:name>
        <rdfs:label xml:lang="en">
            <xsl:value-of select="$name"/>
        </rdfs:label>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 31]-(Description) Specify a description for UML element.</xd:desc>
        <xd:param name="description"/>
    </xd:doc>
    <xsl:template name="elementDescription">
        <xsl:param name="description"/>
        <sh:description>
            <xsl:value-of select="$description"/>
        </sh:description>
        <rdfs:comment xml:lang="en">
            <xsl:value-of select="$description"/>
        </rdfs:comment>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[Rule 3]-(Class in data shape layer) . Specify declaration axiom for UML Class as
            SHACL Node Shape with a SPARQL constraint that selects all instances of this
            class</xd:desc>
    </xd:doc>
    
    <xsl:template name="abstractClassDeclaration">       
            <sh:sparql rdf:parseType="Resource">
                <sh:select>SELECT $this
                    WHERE {
                    $this a skos:Concept .
                    }
                 </sh:select>
            </sh:sparql>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[Rule 7] (Attribute range shape in data shape layer) . Within the SHACL Node Shape
            corresponding to the UML class, specify property constraints, for each UML attribute,
            indicating the range class or datatype.</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:template name="attributeRangeShape">
        <xsl:param name="attribute"/>
        <xsl:variable name="attributeURI"
            select="
            if (fn:starts-with($attribute/@name, 'has') or fn:starts-with($attribute/@name, 'is')) then
            f:buildURIFromElement($attribute, fn:false(), fn:true())
            else
            f:buildURIFromElement($attribute, fn:true(), fn:true())"/>
        <xsl:variable name="attributeName" select="$attribute/@name"/>
        <xsl:if test="f:isAttributeTypeValidForDatatypeProperty($attribute)">
            <xsl:variable name="datatype" select="$attribute/properties/@type"/>
            <xsl:variable name="datatypeURI" select="f:buildURIfromLexicalQName($datatype, fn:false())"/>
        <sh:property>
            <sh:PropertyShape>
                <sh:path
                    rdf:resource="{$attributeURI}"/>
                <sh:name><xsl:value-of select="$attributeName"/></sh:name>
                <sh:datatype
                    rdf:resource="{$datatypeURI}"/>
            </sh:PropertyShape>
        </sh:property>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>