<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs xd xsl fn f"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 24, 2025</xd:p>
            <xd:p>This module defines how selected XMI elements are transformed
            into JSON-LD context</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../common/checkers.xsl"/>

    <xsl:output method="xml" encoding="UTF-8"/>


    <xd:doc>
        <xd:desc>
            A generic template for declaring elements in the JSON-LD context.
            It generates a mapping from the element name to its URI.
            Suitable for such UML elements as Class, Enumeration and DataType.
            The function skips the namespace prefix if it matches the
            preferred namespace prefix.
            Output should be used in conjunction with the `fn:map` node.
        </xd:desc>
    </xd:doc>
    <xsl:template name="elementDeclaration">
        <xsl:variable name="elementCurie" select="./@name"/>
        <xsl:variable name="elementName">
            <xsl:choose>
                <xsl:when test="f:getPrefix($elementCurie) = f:getMetadataValue('preferredNamespacePrefix')">
                    <xsl:value-of select="f:getLocalSegment($elementCurie)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$elementCurie"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="elementUri" select="f:buildURIfromLexicalQName($elementCurie)"/>
        <fn:string key="{$elementName}"><xsl:value-of select="$elementUri"/></fn:string>        
    </xsl:template>
</xsl:stylesheet>