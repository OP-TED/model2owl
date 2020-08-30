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
        <xd:desc>Applying the checkers to a group of connectors with same name</xd:desc>
    </xd:doc>
    
    <xsl:template name="connectorsWithSameName">
        <xsl:variable name="root" select="/"/>
        <xsl:variable name="distinctNames" select="f:getDistinctConnectorsNames($root)"/>
        <h1>Connectors with the same name</h1>
        <xsl:for-each select="$distinctNames">
            <xsl:if test="fn:count(f:getConnectorByName(.,$root)) > 1">
                <dt><xsl:value-of select="."/></dt>
                <xsl:call-template name="multiplicityForConnectorsWithSameName">
                    <xsl:with-param name="connectorName" select="."/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
                <xsl:call-template name="definitionForConnectorsWithSameName">
                    <xsl:with-param name="connectorName" select="."/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    

    
    
    <xd:doc>
        <xd:desc>Check the multiplicity values from a group of connectors with same name</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="multiplicityForConnectorsWithSameName">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName" select="f:getConnectorByName($connectorName,$root)"/>
        <xsl:variable name="multiplicityValues" select="$connectorsWithSameName/*[role/@name=$connectorName]/type/@multiplicity"/>
        <xsl:sequence
            select="
                if (f:areStringsEqual($multiplicityValues)) then
                    ()
                else
                    f:generateHtmlWarning('The multiplicity value used is not equal for all the connectors with this name')"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Check the definition values from a group of connectors with same name</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="definitionForConnectorsWithSameName">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:variable name="definitionValues"
            select="$connectorsWithSameName/*[role/@name = $connectorName]/../documentation/@value"/>
  
        <xsl:variable name="descriptionsWithAnnotations" as="xs:string*"
            select="
                for $i in $connectorsWithSameName
                return
                    if ($i/documentation/@value) then
                    fn:concat($i/documentation/@value,' (',f:getConnectorName($i), ') ')
                    else
                        ()"
        />

        <xsl:sequence
            select="
                if (f:areStringsEqual($definitionValues) and fn:boolean($definitionValues)) then
                    f:generateHtmlInfo(fn:concat('All the connectors with this name have the same definition. ',
                                                'Here is the usage: ',
                                                fn:string-join($descriptionsWithAnnotations, ',')))
                else
                f:generateHtmlWarning(fn:concat('The definition for the connectors with this name is different. ',
                                                 'Here is the usage: ',
                                                  fn:string-join($descriptionsWithAnnotations, ',')))"
        />
    </xsl:template>
    
</xsl:stylesheet>