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
    <xsl:import href="utils-html-conventions.xsl"/>
    <xsl:import href="../common/fetchers.xsl"/>


    <xsl:template name="infoBox">
        <h1>Class names used in the model</h1>
        <ul class="list-group">
            <xsl:call-template name="listOfClassNamesAndOccurrences"/>
        </ul>
        <h1>Class attributes names used in the model</h1>
        <ul class="list-group">
            <xsl:call-template name="listOfClassAttributeNamesAndOccurences"/>
        </ul>
        <h1>Connectors names used in the model</h1>
        <ul class="list-group">
            <xsl:call-template name="listOfConnectorsAndOccurrences"/>
        </ul>
    </xsl:template>


    <xsl:template name="listOfClassNamesAndOccurrences">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="classNames" select="f:getDistinctClassNames($root)"/>
        <xsl:for-each select="$classNames">
            <xsl:variable name="occurences"
                select="
                    if (fn:count((f:getElementByName(., $root))) > 1) then
                        fn:concat(' (', fn:string(fn:count((f:getElementByName(., $root)))), ')')
                    else
                        ()"/>
            <li class="list-group-item">
                <xsl:value-of select="."/>
                <xsl:value-of select="$occurences"/>
            </li>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="listOfClassAttributeNamesAndOccurences">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="attributeNames" select="f:getDistinctClassAttributeNames($root)"/>
        <xsl:for-each select="$attributeNames">
            <xsl:variable name="occurences"
                select="
                    if (fn:count((f:getClassAttributeByName(., $root))) > 1) then
                        fn:concat(' (', fn:string(fn:count((f:getClassAttributeByName(., $root)))), ')')
                    else
                        ()"/>
            <xsl:variable name="attributeName" select="."/>
            <xsl:variable name="hrefAttributeName"
                select="
                    if (fn:contains($attributeName, ':')) then
                        f:camelCaseString(fn:substring-after($attributeName, ':'))
                    else
                        f:camelCaseString($attributeName)"/>
            <li class="list-group-item">
                <a class="btn btn-link" data-toggle="collapse" href="#collapse{$hrefAttributeName}"
                    role="button" aria-expanded="false" aria-controls="collapse{$hrefAttributeName}">
                    <xsl:value-of select="$attributeName"/>
                    <xsl:value-of select="$occurences"/>
                </a>
                <div class="collapse" id="collapse{$hrefAttributeName}">
                    <div class="card card-body">
                        <ul>
                            <xsl:call-template name="moreDetailsForAttributes">
                                <xsl:with-param name="attributeName" select="$attributeName"/>
                                <xsl:with-param name="root" select="$root"/>
                            </xsl:call-template>
                        </ul>
                    </div>
                </div>
            </li>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="moreDetailsForAttributes">
        <xsl:param name="attributeName"/>
        <xsl:param name="root"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:if test="fn:count($attributesWithSameName) > 1">
            <xsl:for-each select="$attributesWithSameName">
                <xsl:variable name="className" select="./parent::attributes/parent::element/@name"/>
                <xsl:variable name="attributeType" select="./properties/@type"/>
                <li>
                    <xsl:value-of select="fn:concat($className, ' (', $attributeType, ')')"/>
                </li>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>


    <xsl:template name="listOfConnectorsAndOccurrences">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="connectorNames" select="f:getDistinctConnectorsNames($root)"/>
        <xsl:for-each select="$connectorNames">
            <xsl:variable name="occurences"
                select="
                    if (fn:count((f:getConnectorByName(., $root))) > 1) then
                        fn:concat(' (', fn:string(fn:count((f:getConnectorByName(., $root)))), ')')
                    else
                        ()"/>
            <xsl:variable name="connectorName" select="."/>
            <xsl:variable name="hrefConnectorName"
                select="
                    if (fn:contains($connectorName, ':')) then
                        f:camelCaseString(fn:substring-after($connectorName, ':'))
                    else
                        f:camelCaseString($connectorName)"/>
            <li class="list-group-item">
                <a class="btn btn-link" data-toggle="collapse" href="#collapse{$hrefConnectorName}"
                    role="button" aria-expanded="false" aria-controls="collapse{$hrefConnectorName}">
                    <xsl:value-of select="$connectorName"/>
                    <xsl:value-of select="$occurences"/>
                </a>
                <div class="collapse" id="collapse{$hrefConnectorName}">
                    <div class="card card-body">
                        <ul>
                            <xsl:call-template name="moreDetailsForConnectors">
                                <xsl:with-param name="connectorName" select="$connectorName"/>
                                <xsl:with-param name="root" select="$root"/>
                            </xsl:call-template>
                        </ul>
                    </div>
                </div>
            </li>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="moreDetailsForConnectors">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:if test="fn:count($connectorsWithSameName) > 1">
            <xsl:for-each select="$connectorsWithSameName">
                <xsl:variable name="targetClass"
                    select="f:getElementByIdRef(./target/@xmi:idref, $root)/@name"/>
                <xsl:variable name="sourceClass"
                    select="f:getElementByIdRef(./source/@xmi:idref, $root)/@name"/>
                <xsl:variable name="targetMultiplicity" select="./target/type/@multiplicity"/>
                <xsl:variable name="sourceMultiplicity" select="./source/type/@multiplicity"/>
                <xsl:if test="./target/role/@name = $connectorName">
                    <li>
                        <xsl:value-of
                            select="fn:concat($sourceClass, ' -&gt; ', $targetClass, ' (', $targetMultiplicity, ')')"
                        />
                    </li>
                </xsl:if>
                <xsl:if test="./source/role/@name = $connectorName">
                    <xsl:value-of
                        select="fn:concat($sourceClass, ' (,', $sourceMultiplicity, ')', ' -&lt; ', $targetClass)"
                    />
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>