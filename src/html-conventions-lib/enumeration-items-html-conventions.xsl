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
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">

    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="../html-conventions-lib/utils-html-conventions.xsl"/>

    <xd:doc>
        <xd:desc>Getting all enumeration items and show only the ones that have unmet conventions
            [enum-attribute-name-51] [enum-attribute-name-52] [enum-attribute-name-60]</xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute">
        <xsl:variable name="enumerationItemChecks" as="item()*">
            <xsl:call-template name="ea-invalidCharacter">
                <xsl:with-param name="enumerationItem" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ea-initialValue">
                <xsl:with-param name="enumerationItem" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ea-missingDescription">
                <xsl:with-param name="enumerationItem" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ea-missingAlias">
                <xsl:with-param name="enumerationItem" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($enumerationItemChecks)">
            <dl>
                <dt>
                    <xsl:call-template name="getEnumerationItemName">
                        <xsl:with-param name="enumerationItem" select="."/>
                    </xsl:call-template>
                </dt>
                <xsl:copy-of select="$enumerationItemChecks"/>
            </dl>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Getting the enumeration item name</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>
    <xsl:template name="getEnumerationItemName">
        <xsl:param name="enumerationItem"/>
        <xsl:variable name="enumerationItemName" select="$enumerationItem/@name"/>
        <xsl:choose>
            <xsl:when test="$enumerationItem/not(@name) = fn:true()">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$enumerationItemName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xd:doc>
        <xd:desc>[enum-attribute-name-51] - The enumeration code $value$ contains invalid
            characters. Enumeration codes (in UML attribute name) should contain only aphanumeric
            charasters and no spaces.</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>

    <xsl:template name="ea-invalidCharacter">
        <xsl:param name="enumerationItem"/>
        <xsl:variable name="enumerationItemName" select="$enumerationItem/@name"/>
        <xsl:sequence
            select="
                if (f:isValidNormalizedString($enumerationItemName)) then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The enumeration code ', $enumerationItemName, ' contains invalid characters. Enumeration codes ',
                    '(in UML attribute name) should contain only aphanumeric charasters and no spaces.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[enum-attribute-name-60] - The enumeration code $attributeName$ has no initial
            value. The enumeration code should have an initial value, which is interpreted as
            preferred label.</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>

    <xsl:template name="ea-initialValue">
        <xsl:param name="enumerationItem"/>
        <xsl:variable name="noInitialValue" select="$enumerationItem/initial/not(@body)"/>
        <xsl:sequence
            select="
                if ($noInitialValue = fn:true()) then
                    f:generateHtmlWarning(fn:concat('The enumeration code ', $enumerationItem/@name, ' has no initial ',
                    'value. The enumeration code should have an initial value, which is interpreted as preferred label.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-description-9] - $elementName$ is missing a description. All concepts
            should be defined or described.</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>

    <xsl:template name="ea-missingDescription">
        <xsl:param name="enumerationItem"/>
        <xsl:variable name="enumerationItemName" select="$enumerationItem/@name"/>
        <xsl:variable name="noEnumerationDescription"
            select="$enumerationItem/documentation/not(@value)"/>
        <xsl:sequence
            select="
                if ($noEnumerationDescription = fn:true()) then
                    f:generateHtmlWarning(fn:concat($enumerationItemName, ' is missing a description. All concepts should be defined or described.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[enum-attribute-name-52] - The enumeration item $attributeName$ has no alias. The
            enumeration item should have an alias, which is interpreted as alternative
            label.</xd:desc>
        <xd:param name="enumerationItem"/>
    </xd:doc>

    <xsl:template name="ea-missingAlias">
        <xsl:param name="enumerationItem"/>
        <xsl:variable name="noAliasValue" select="$enumerationItem/style/not(@value)"/>
        <xsl:sequence
            select="
                if ($noAliasValue = fn:true()) then
                    f:generateHtmlWarning(fn:concat('The enumeration code ', $enumerationItem/@name, ' has no alias. ',
                    'The enumeration code should have an alias, which is interpreted as preferred label.'))
                else
                    ()"
        />
    </xsl:template>

</xsl:stylesheet>