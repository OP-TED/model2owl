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
                <xsl:call-template name="realisationHasName">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisationHasRoleName">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisationHasMultiplicity">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisationDirectionChecker">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="realisationSourceTargetTypes">
                    <xsl:with-param name="realisationConnector" select="."/>
                </xsl:call-template>
            
        </xsl:variable>
        <xsl:if test="boolean($realisationChecks)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2>
                        <xsl:value-of select="f:getConnectorName(.)"/>
                    </h2>
                    <dl>
                        <dt> Unmet realisation conventions </dt>
                        <xsl:copy-of select="$realisationChecks"/>
                    </dl>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$realisationChecks"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>




    <xd:doc>
        <xd:desc>[realisation-multiplicity-1] - The realisation has multiplicity. No multiplicity
            can be provided to realisations. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisationHasMultiplicity">
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
                    f:generateErrorMessage('The realisation has multiplicity. No multiplicity can be provided to realisations.',
                    path($realisationConnector),
                    'realisation-multiplicity-1',
                    'CMC-R11',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r11&quot; target=&quot;_blank&quot;&gt;CMC-R11&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[realisation-name-2] - The connector $connectorName$ has a name. No name can be
            provided for realisation relation. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisationHasName">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="realisationHasNoName" select="$realisationConnector/not(@name)"/>
        <xsl:sequence
            select="
                if ($realisationHasNoName = fn:false()) then
                    f:generateErrorMessage(fn:concat('The connector ', $realisationConnector/@name, ' has a name. No name can be provided for realisation relation.'),
                    path($realisationConnector),
                    'realisation-name-2',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[realisation-name-3] - The realisation connector has a role name. No source or
            target roles can be provided to realisations. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisationHasRoleName">
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
                    f:generateErrorMessage('The realisation connector has a role name. No source or target roles can be provided to realisations.',
                    path($realisationConnector),
                    'realisation-name-3',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[realisation-direction-4] - The $direction$ direction is invalid. Realisations must
            employ "Source->Destination" direction only. </xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>
    <xsl:template name="realisationDirectionChecker">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="realisationDirection"
            select="$realisationConnector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($realisationDirection != 'Source -&gt; Destination') then
                    f:generateErrorMessage(fn:concat('The ', $realisationDirection, ' direction is invalid. ',
                    'realisations must employ Source -&gt; Destination direction only.'),
                    path($realisationConnector),
                    'realisation-direction-4',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[realisation-source-target-types-5] - The realisation can be provided only from an
            Object to a Class or Enumeration</xd:desc>
        <xd:param name="realisationConnector"/>
    </xd:doc>

    <xsl:template name="realisationSourceTargetTypes">
        <xsl:param name="realisationConnector"/>
        <xsl:variable name="sourceType" select="$realisationConnector/source/model/@type"/>
        <xsl:variable name="targetType" select="$realisationConnector/target/model/@type"/>
        <xsl:sequence
            select="
                if ($sourceType = 'Object' and ($targetType = 'Class' or $targetType = 'Enumeration')) then
                    ()
                else
                    f:generateErrorMessage('The realisation can be provided only from an Object to a Class or Enumeration.',
                    path($realisationConnector),
                    'realisation-source-target-types-5',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )"
        />
    </xsl:template>

</xsl:stylesheet>