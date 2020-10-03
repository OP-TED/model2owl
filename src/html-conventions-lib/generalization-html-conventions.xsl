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
    <xsl:import href="../../config/config-proxy.xsl"/>



    <xd:doc>
        <xd:desc>Getting all generalizations and show only the ones that have unmet conventions
            [generalisation-hierarchy-38]
            [generalisation-hierarchy-39] 
            [generalisation-multiplicity-40]
            [generalisation-name-41] 
            [generalisation-name-42]
            [generalisation-direction-62]
        </xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">
            <xsl:variable name="generalizationChecks" as="item()*">
                <xsl:call-template name="g-classWithSingleChild">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="g-inverseInheritance">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="g-hasName">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="g-hasRoleName">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="g-hasMultiplicity">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="g-directionChecker">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="boolean($generalizationChecks)">
                <h2>
                    <xsl:value-of select="f:getConnectorName(.)"/>
                </h2>
                <dl>
                    <dt> Unmet generalization conventions </dt>
                    <xsl:copy-of select="$generalizationChecks"/>
                </dl>
            </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[generalisation-hierarchy-38] - The class $parent$ has only one sub-class $child$.
            Class inheritance should be built employing at least two subclasses for each class or
            not at all. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="g-classWithSingleChild">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="idRefTarget" select="$generalizationConnector/target/@xmi:idref"/>
        <xsl:variable name="targetElement"
            select="f:getElementByIdRef($idRefTarget, root($generalizationConnector))"/>
        <xsl:sequence
            select="
                if (count(f:getIncommingConnectors($targetElement)[properties/@ea_type = 'Generalization']) > 1) then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The class ', $generalizationConnector/target/model/@name, ' has only one sub-class ',
                    $generalizationConnector/source/model/@name, '. Class inheritance should be built employing at least two subclasses for each class or',
                    ' not at all.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-hierarchy-39] - The classes $class1$ and $class2$ inherit one
            another. Sub-class relation must be established in one direction only, forming a
            hierarchy. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>

    <xsl:template name="g-inverseInheritance">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="idRefTarget" select="$generalizationConnector/target/@xmi:idref"/>
        <xsl:variable name="targetElement"
            select="f:getElementByIdRef($idRefTarget, root($generalizationConnector))"/>
        <xsl:variable name="idRefSource" select="$generalizationConnector/source/@xmi:idref"/>
        <xsl:sequence
            select="
                if (boolean(f:getOutgoingConnectors($targetElement)[target/@xmi:idref = $idRefSource and properties/@ea_type = 'Generalization'])) then
                    f:generateHtmlError(fn:concat('The classes ', $generalizationConnector/target/model/@name, ' and ', $generalizationConnector/source/model/@name, ' inherit one ',
                    'another. Sub-class relation must be established in one direction only, forming a hierarchy.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-name-40] - The generalisation has multiplicity. No multiplicity can
            be provided to generalisations. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="g-hasMultiplicity">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="hasNoTargetMultiplicity"
            select="$generalizationConnector/target/type/not(@multiplicity)"/>
        <xsl:variable name="hasNoSourceMultiplicity"
            select="$generalizationConnector/source/type/not(@multiplicity)"/>
        <xsl:sequence
            select="
                if ($hasNoTargetMultiplicity and $hasNoSourceMultiplicity) then
                    ()
                else
                    f:generateHtmlError('The generalisation has multiplicity. No multiplicity can be provided to generalisations.')"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[generalisation-name-41] - The connector $connectorName$ has a name. No name can be
            provided for generalisation relation. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="g-hasName">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="generalizationHasNoName" select="$generalizationConnector/not(@name)"/>
        <xsl:sequence
            select="
                if ($generalizationHasNoName = fn:false()) then
                    f:generateHtmlError(fn:concat('The connector ', $generalizationConnector/@name, ' has a name. No name can be provided for generalisation relation.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-name-42] - The generalisation connector has a role name. No source
            or target roles can be provided to generalisations. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="g-hasRoleName">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="hasNoTargetRoleName"
            select="$generalizationConnector/target/role/not(@name)"/>
        <xsl:variable name="hasNoSourceRoleName"
            select="$generalizationConnector/source/role/not(@name)"/>
        <xsl:sequence
            select="
                if ($hasNoTargetRoleName and $hasNoSourceRoleName) then
                    ()
                else
                    f:generateHtmlError('The generalisation connector has a role name. No source or target roles can be provided to generalisations.')"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-direction-62] - The $direction$ direction is invalid. Generalisations must employ "Source->Destination" direction only. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="g-directionChecker">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="generalizationDirection"
            select="$generalizationConnector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($generalizationDirection != 'Source -&gt; Destination') then
                    f:generateHtmlError(fn:concat('The ', $generalizationDirection, ' direction is invalid. ',
                                        'Generalisations must employ Source -&gt; Destination direction only.'))
                else
                    ()"
        />
    </xsl:template>

</xsl:stylesheet>