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
    <xsl:import href="general-connectors-html-convention.xsl"/>



    <xd:doc>
        <xd:desc>Getting all dependencies and show only the ones that have unmet
            conventions [dependency-direction-64]</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <xsl:variable name="dependencyChecks" as="item()*">
            <xsl:call-template name="co-generalNameProvided">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-missingDescription">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-missingTargetRole">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-missingInverseRelation">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-invalidRelationshipDirection">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-missingTargetMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-missingSourceMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-invalidTargetMultiplicityFormat">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-invalidSourceMultiplicityFormat">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="co-directionAndRolesOutOfSync">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-invalidDirection">
                <xsl:with-param name="dependencyConnector" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($dependencyChecks)">
            <dl>
                <dt>
                    <xsl:value-of select="f:getConnectorName(.)"/>
                </dt>
                <xsl:copy-of select="$dependencyChecks"/>
            </dl>
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>[dependency-direction-64] - The direction is not 'Source->Destination'. Dependecy
            direction can be only 'Source->Destination'. </xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    <xsl:template name="d-invalidDirection">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="dependencyDirection" select="$dependencyConnector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($dependencyDirection != 'Source -&gt; Destination') then
                    f:generateHtmlWarning('The direction is not Source -&gt; Destination. Dependecy direction can be only Source -&gt; Destination. ')
                else
                    ()"
        />
    </xsl:template>


</xsl:stylesheet>