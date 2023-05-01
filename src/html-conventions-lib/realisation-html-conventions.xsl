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
    <xsl:import href="../common/fetchers.xsl"/>
    <xsl:import href="utils-html-conventions.xsl"/>
    <xsl:import href="../../config-proxy.xsl"/>



    <xd:doc>
        <xd:desc>Getting all realisations and show only the ones that have unmet conventions
        </xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Realisation']">
        <xsl:variable name="realisationChecks" as="item()*">


                <xsl:call-template name="realisation-hasName">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisation-hasRoleName">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisation-hasMultiplicity">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisation-directionChecker">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisation-sourceTargetTypes">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
            
        </xsl:variable>
        <xsl:if test="boolean($realisationChecks)">
            <h2>
                <xsl:value-of select="f:getConnectorName(.)"/>
            </h2>
            <dl>
                <dt> Unmet realisation conventions </dt>
                <xsl:copy-of select="$realisationChecks"/>
            </dl>
        </xsl:if>
    </xsl:template>




    <xd:doc>
        <xd:desc>[realisation-multiplicity-1] - The realisation has multiplicity. No multiplicity
            can be provided to realisations. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisation-hasMultiplicity">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="hasNoTargetMultiplicity"
            select="$realisationConnector/target/type/not(@multiplicity)"/>
        <xsl:variable name="hasNoSourceMultiplicity"
            select="$realisationConnector/source/type/not(@multiplicity)"/>
        <xsl:sequence
            select="
                if ($hasNoTargetMultiplicity and $hasNoSourceMultiplicity) then
                    ()
                else
                    f:generateHtmlError('The realisation has multiplicity. No multiplicity can be provided to realisations.')"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[realisation-name-2] - The connector $connectorName$ has a name. No name can be
            provided for realisation relation. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisation-hasName">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="realisationHasNoName" select="$realisationConnector/not(@name)"/>
        <xsl:sequence
            select="
                if ($realisationHasNoName = fn:false()) then
                    f:generateHtmlError(fn:concat('The connector ', $realisationConnector/@name, ' has a name. No name can be provided for realisation relation.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[realisation-name-3] - The realisation connector has a role name. No source or
            target roles can be provided to realisations. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisation-hasRoleName">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="hasNoTargetRoleName"
            select="$realisationConnector/target/role/not(@name)"/>
        <xsl:variable name="hasNoSourceRoleName"
            select="$realisationConnector/source/role/not(@name)"/>
        <xsl:sequence
            select="
                if ($hasNoTargetRoleName and $hasNoSourceRoleName) then
                    ()
                else
                    f:generateHtmlError('The realisation connector has a role name. No source or target roles can be provided to realisations.')"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[realisation-direction-4] - The $direction$ direction is invalid. Realisations must
            employ "Source->Destination" direction only. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisation-directionChecker">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="realisationDirection"
            select="$realisationConnector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($realisationDirection != 'Source -&gt; Destination') then
                    f:generateHtmlError(fn:concat('The ', $realisationDirection, ' direction is invalid. ',
                    'realisations must employ Source -&gt; Destination direction only.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[realisation-source-target-types-5] - realisations can be provided only between
            classes and objects.</xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>

    <xsl:template name="realisation-sourceTargetTypes">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="sourceType" select="$realisationConnector/source/model/@type"/>
        <xsl:variable name="targetType" select="$realisationConnector/target/model/@type"/>
        <xsl:sequence
            select="
            if ($sourceType = 'Object' and ($targetType = 'Class' or $targetType = 'Enumeration')) then
                    ()
                else
                    f:generateHtmlError('Realisations can be provided only between objects and classes or enumerations.')"
        />
    </xsl:template>

</xsl:stylesheet>