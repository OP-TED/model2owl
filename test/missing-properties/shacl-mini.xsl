<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f functx"
                xmlns:uml="http://www.omg.org/spec/UML/20131001"
                xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
                xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:f="https://github.com/costezki/model2owl#"
                xmlns:sh="http://www.w3.org/ns/shacl#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:functx="http://www.functx.com"
                version="3.0">

    <!-- Match the root element -->
    <xsl:output method="text" indent="yes"/>

    <!-- Template to match the root element -->
    <xsl:template match="/">
        <xsl:text>@prefix a4g: &lt;http://data.europa.eu/a4g/ontology#&gt; .&#xA;</xsl:text>
        <xsl:text>@prefix sh: &lt;http://www.w3.org/ns/shacl#&gt; .&#xA;</xsl:text>
        <xsl:text>@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .&#xA;&#xA;</xsl:text>


        <xsl:apply-templates select="//packagedElement[@xmi:type='uml:Class']"/>
        <xsl:apply-templates select="//connector"/>
    </xsl:template>

    <xsl:template match="packagedElement[@xmi:type='uml:Class']">
        a4g:<xsl:value-of select="@name"/>Shape a sh:NodeShape ;
        sh:targetClass a4g:<xsl:value-of select="@name"/> ;
        <xsl:apply-templates select="ownedAttribute"/>
        .
    </xsl:template>

    <xsl:template match="ownedAttribute">
        sh:property [
        a sh:PropertyShape ;
        sh:path a4g:<xsl:value-of select="substring-after(@name, ':')"/> ;
        <xsl:choose>
            <xsl:when test="lowerValue/@value">
                sh:minCount <xsl:value-of select="lowerValue/@value"/> ;
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="upperValue/@value != '*'">
                sh:maxCount <xsl:value-of select="upperValue/@value"/> ;
            </xsl:when>
        </xsl:choose>
        sh:nodeKind sh:IRI ;
        ] ;
    </xsl:template>
    <xsl:template match="connector">
        <xsl:text># </xsl:text>
        <xsl:value-of select="source/model/@name"/>
        <xsl:text> | </xsl:text>
        <xsl:value-of select="target/role/@name"/>
        <xsl:text> | </xsl:text>
        <xsl:value-of select="target/model/@name"/>
        <xsl:text> | </xsl:text>
        <xsl:value-of select="target/type/@multiplicity"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>


</xsl:stylesheet>
