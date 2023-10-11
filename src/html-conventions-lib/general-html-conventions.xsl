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
        <xd:desc>Applying general conventions templates </xd:desc>
    </xd:doc>

    <xsl:template name="generalConventions">
        <xsl:variable name="root" select="root()"/>
        
        <xsl:if test="$reportType = 'HTML'">
           <h1 id="generalConventions">General conventions</h1> 
        </xsl:if>
 
        <xsl:variable name="generalChecks" as="item()*">
            <xsl:call-template name="connectorTypes">
                <xsl:with-param name="root" select="$root"/>
            </xsl:call-template>
            <xsl:call-template name="elementTypes">
                <xsl:with-param name="root" select="$root"/>
            </xsl:call-template>
            <xsl:call-template name="undefinedPrefixes">
                <xsl:with-param name="root" select="$root"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($generalChecks)">
            <xsl:copy-of select="$generalChecks"/>
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>[general-connector-type-1] Only associations, dependecies, generalisations and
            realisation connectors are supported. </xd:desc>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="connectorTypes">
        <xsl:param name="root"/>
        <xsl:variable name="usedConnectorTypes"
            select="fn:distinct-values($root//connectors/connector/properties/@ea_type)"/>
        <xsl:variable name="supportedConnectorTypes"
            select="('Association', 'Dependency', 'Generalization', 'Realisation')"/>
        <xsl:variable name="unsupportedConnectorTypes"
            select="$usedConnectorTypes[not(. = $supportedConnectorTypes)]"/>
        <xsl:sequence
            select="
                if (count($unsupportedConnectorTypes) > 0) then
                    f:generateFormattedWarningMessage('Only associations, dependecies, generalisations and realisation connectors are supported. The following connector types were found in model and are not supported', $unsupportedConnectorTypes,
                    'Only associations, dependecies, generalisations and
                    realisation connectors are supported.',
                    '//connectors/connector/properties/@ea_type',
                    'general-connector-type-1'
                    )
                else
                    ()
                "
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[general-element-type-2] Only Class, Package, Datatype, Enumeration, and Object
            elements are supported </xd:desc>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="elementTypes">
        <xsl:param name="root"/>
        <xsl:variable name="usedElementTypes"
            select="fn:distinct-values($root//elements/element/@xmi:type)"/>
        <xsl:variable name="supportedElementTypes"
            select="('uml:Class', 'uml:Enumeration', 'uml:DataType', 'uml:Package', 'uml:Object')"/>
        <xsl:variable name="unsupportedElementTypes"
            select="$usedElementTypes[not(. = $supportedElementTypes)]"/>
        <xsl:sequence
            select="
                if (count($unsupportedElementTypes) > 0) then
                    f:generateFormattedWarningMessage('Only Class, Package, Datatype, Enumeration, and Object elements are supported. The following element types were found in model and are not supported', $unsupportedElementTypes,
                    'Only Class, Package, Datatype, Enumeration, and Object
                    elements are supported',
                    '//elements/element/@xmi:type',
                    'general-element-type-2'
                    )
                else
                    ()
                "
        />
    </xsl:template>



    <xd:doc>
        <xd:desc>[general-prefix-3] The prefixes $[list of undefined prefixes] are not defined.
            All used namespaces shall be defined ("prefix" = "base URI"), including the default one
            (""="base URI"). </xd:desc>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="undefinedPrefixes">
        <xsl:param name="root"/>
        <xsl:variable name="listOfUsedPrefixes" select="f:getAllNamespacesUsed($root)"/>
        <xsl:variable name="areAllPrefixesDefined"
            select="f:isAllNamespacesDefined($listOfUsedPrefixes)"/>
        <xsl:sequence
            select="
                if ($areAllPrefixesDefined instance of xs:boolean) then
                    ()
                else
                    f:generateFormattedErrorMessage(fn:concat('Not all prefixes ',
                    ' are defined. All used namespaces shall be defined (prefix = base URI), including the default one. Here is the list of undefined prefixes'), $areAllPrefixesDefined,
                    'The prefixes $[list of undefined prefixes] are not defined.
                    All used namespaces shall be defined (prefix = base URI), including the default one.',
                    '/',
                    'general-prefix-3'
                    )"
        />
    </xsl:template>


</xsl:stylesheet>