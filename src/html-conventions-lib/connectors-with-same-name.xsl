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

    <xd:doc>
        <xd:desc>Applying the checkers to a group of connectors with same name
            [connectors-with-same-name-multiplicity-68]
            [connectors-with-same-name-definition-69]
            [connectors-with-same-name-definition-70]</xd:desc>
    </xd:doc>

    <xsl:template name="connectorsWithSameName">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="distinctNames" select="f:getDistinctConnectorsNames($root)"/>
        <h1>Connectors with multiple usages</h1>
        <xsl:for-each select="$distinctNames">  
            <xsl:sort select="." lang="en"/>
            <xsl:if test="fn:count(f:getConnectorByName(., $root)) > 1">
                <xsl:variable name="connectorsChecks" as="item()*">
                    <xsl:call-template name="checkMultiplicityOfConnectorsWithSameName">
                        <xsl:with-param name="connectorName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                    <xsl:call-template name="checkDefinitionOfConnectorsWithSameName">
                        <xsl:with-param name="connectorName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="boolean($connectorsChecks)">
                    <dt>
                        <xsl:value-of select="."/>
                    </dt>
                    <xsl:copy-of select="$connectorsChecks"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>



    <xd:doc>
        <xd:desc>[connectors-with-same-name-multiplicity-68]Check the multiplicity values from a group of connectors with same name</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="checkMultiplicityOfConnectorsWithSameName">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:variable name="multiplicityValues"
            select="$connectorsWithSameName/*[role/@name = $connectorName]/type/@multiplicity"/>
        <xsl:variable name="allConnectorsHaveMultiplicityValue"
            select="fn:count($connectorsWithSameName) = fn:count($multiplicityValues)"/>
        <xsl:sequence
            select="
                if (f:areStringsEqual($multiplicityValues) and $allConnectorsHaveMultiplicityValue) then
                    ()
                else
                f:generateHtmlWarning('When a property is reused in multiple contexts, the multiplicity is expected to be the same. Please check the nomenclature above for a summary.')"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[connectors-with-same-name-definition-69] [connectors-with-same-name-definition-70] Check the definition values from a group of connectors with same name</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="checkDefinitionOfConnectorsWithSameName">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:variable name="definitionValues"
            select="$connectorsWithSameName/*[role/@name = $connectorName]/../documentation/@value"/>

        <xsl:variable name="descriptionsWithAnnotations" as="xs:string*"
            select="
                for $connector in $connectorsWithSameName
                return
                    if ($connector/documentation/@value) then
                        fn:concat($connector/documentation/@value, ' (', f:getConnectorName($connector), ') ')
                    else
                        ()"/>

        <xsl:variable name="allConnectorsHaveDefinition"
            select="fn:count($connectorsWithSameName) = fn:count($definitionValues)"/>
        <xsl:sequence
            select="
                if (f:areStringsEqual($definitionValues) and fn:boolean($definitionValues and $allConnectorsHaveDefinition)) then
                f:generateHtmlInfo(fn:concat('The property is reused in multiple contexts, the meaning given by the definition is the same.  ',
                    'Here is the property usage: ',
                    fn:string-join($descriptionsWithAnnotations, ',')))
                else
                    if (fn:boolean($definitionValues)) then
                    f:generateHtmlWarning(fn:concat('When a property is reused in multiple contexts, the meaning given by the definition is expected to be the same. ',
                                                    'In this case, multiple definitions are found: ',
                                                    fn:string-join($descriptionsWithAnnotations, ',')))
                    else
                        ()"
        />
    </xsl:template>

</xsl:stylesheet>