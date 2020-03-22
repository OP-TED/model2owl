<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines a common set of string formatting and transformation functions</xd:p>
        </xd:desc>
    </xd:doc>


    <xd:doc>
        <xd:desc/>
        <xd:param name="input">Format the Documentation string</xd:param>
    </xd:doc>
    <xsl:template name="formatDocString" as="item()*">
        <xsl:param name="input"/>
        <xsl:variable name="doc0"
            select="fn:replace($input, '&lt;a href', '&lt;xref scope=&#x0022;external&#x0022; href')"/>
        <xsl:variable name="doc1" select="fn:replace($doc0, '&lt;/a&gt;', '&lt;/xref&gt;')"/>
        <xsl:variable name="doc2" select="fn:replace($doc1, 'font color', 'foreign otherprops')"/>
        <xsl:variable name="doc3" select="fn:replace($doc2, '&lt;/font&gt;', '&lt;/foreign&gt;')"/>
        <xsl:variable name="doc4" select="fn:replace($doc3, 'nbsp', '#x00A0')"/>
        <xsl:variable name="doc5" select="fn:replace($doc4, '\$inet://', '')"/>
        <xsl:value-of select="$doc5"/>
    </xsl:template>

</xsl:stylesheet>