<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://publications.europa.eu/ns/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xd xsl fn"
    version="3.0">

    <xsl:import href="../../config-proxy.xsl"/>
    <xsl:output version="1.0" encoding="UTF-8" indent="yes" /> 

    <xd:doc>
        <xd:desc>
            A template for generating enriched namespaces XML file that
            contains internal model2owl namespaces which are constructed
            based on the model2owl configuration.
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <prefixes>
            <xsl:for-each select="/*:prefixes/*:prefix">
                <prefix name="{./@name}" value="{./@value}">
                    <xsl:if test="boolean(./@importURI)">
                        <xsl:attribute name="importURI">
                            <xsl:value-of select="./@importURI" />
                        </xsl:attribute>
                    </xsl:if>
                </prefix>
            </xsl:for-each>
            <prefix name="{fn:concat($moduleReference, '-res')}" 
                value="{fn:concat($base-restriction-uri,$defaultDelimiter)}"/>
            <prefix name="{fn:concat($moduleReference, '-shape')}" 
                value="{fn:concat($base-shape-uri,$defaultDelimiter)}"/>
        </prefixes>
    </xsl:template>
</xsl:stylesheet>
