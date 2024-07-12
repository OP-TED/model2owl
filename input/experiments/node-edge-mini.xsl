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

    <!-- Match the root element -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Template to match the root element -->
    <xsl:template match="/">
        <result>
            <xsl:apply-templates select="//packagedElement[@xmi:type='uml:Class']"/>
            <xsl:apply-templates select="//connector"/>
        </result>
    </xsl:template>

    <xsl:template match="packagedElement[@xmi:type='uml:Class']">
        <node>
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:apply-templates select="ownedAttribute"/>
        </node>
    </xsl:template>

    <xsl:template match="ownedAttribute">
        <attribute>
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <quantifiers>
                <xsl:attribute name="lowerValue">
                    <xsl:value-of select="lowerValue/@value"/>
                </xsl:attribute>
                <xsl:attribute name="upperValue">
                    <xsl:value-of select="upperValue/@value"/>
                </xsl:attribute>
            </quantifiers>
        </attribute>
    </xsl:template>

    <xsl:template match="connector">
        <edge>
            <source>
                <xsl:attribute name="name">
                    <xsl:value-of select="source/model/@name"/>
                </xsl:attribute>
            </source>
            <predicate>
                <xsl:attribute name="name">
                    <xsl:value-of select="target/role/@name"/>
                </xsl:attribute>
            </predicate>
            <target>
                <xsl:attribute name="name">
                    <xsl:value-of select="target/model/@name"/>
                </xsl:attribute>
            </target>
            <quantifiers>
                <xsl:attribute name="raw">
                    <xsl:value-of select="target/type/@multiplicity"/>
                </xsl:attribute>
            </quantifiers>
        </edge>
    </xsl:template>
</xsl:stylesheet>
