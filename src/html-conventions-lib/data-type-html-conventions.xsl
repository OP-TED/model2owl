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

    <!--
    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="utils-html-conventions.xsl"/>-->
    <xsl:import href="common-elements-html-conventions.xsl"/>



    <xd:doc>
        <xd:desc>Getting all data-types and show only the ones that have unmet conventions
        </xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:DataType']">
        <xsl:variable name="dataTypeName">
            <xsl:call-template name="getDataTypeName">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dataTypeChecks" as="item()*">
            <!--    Start of common checkers rules     -->
            <xsl:call-template name="namingFormat">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingNamePrefix">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingLocalSegmentName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalidNamePrefix">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="undefinedPrefix">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalidNameLocalSegment">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalidFirstCharacterInLocalSegment">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="delimitersInTheLocalSegment">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingDescription">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="elementType" select="'dataType'"/>
            </xsl:call-template>
            <xsl:call-template name="stereotypeProvided">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="elementType" select="'dataType'"/>
            </xsl:call-template>
            <xsl:call-template name="unknownStereotypeProvided">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="elementType" select="'dataType'"/>
            </xsl:call-template>
            <xsl:call-template name="invalidTagName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingTagValue">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingTagName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingPrefixTagName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="namePlural">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <!--    End of common checkers rules     -->   
            <!--    Start of specific checker rules-->
            
            <xsl:call-template name="d-incorrectDataType">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-uniqueName">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-attributeChecker">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-outgoingConnectors">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <!--    End of specific checker rules-->

        </xsl:variable>
        <xsl:if test="boolean($dataTypeChecks)">
            <h2><xsl:value-of select="$dataTypeName"/></h2>
            <dl>
                <dt>
                    Unmet data-type conventions
                </dt>
                <xsl:copy-of select="$dataTypeChecks"/>
            </dl>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Getting the datatype name</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="getDataTypeName">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="dataTypeName" select="$dataTypeElement/@name"/>
        <xsl:choose>
            <xsl:when test="$dataTypeElement/not(@name) = fn:true() or $dataTypeElement/@name = ''">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$dataTypeName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[datatype-name-1] - The name $value$ is not unique. The Concept names should be
            unique within the model; while the relations may repeat but should not overlap with
            concept names. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-uniqueName">
        <xsl:param name="dataTypeElement"/>
        <xsl:if test="boolean($dataTypeElement/@name)">
            <xsl:variable name="elementsFound"
                select="f:getElementByName($dataTypeElement/@name, root($dataTypeElement))"/>
            <xsl:variable name="connectorsFound"
                select="f:getConnectorByName($dataTypeElement/@name, root($dataTypeElement))"/>
            <xsl:sequence
                select="
                if (count($elementsFound) > 1 or count($connectorsFound) > 0) then
                f:generateHtmlError(fn:concat('The name ', $dataTypeElement/@name, ' is not unique. The Concept names ',
                'should be unique within the model; while the relations may repeat ',
                'but should not overlap with concept names. '))
                else
                ()
                
                "
            />
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[datatype-name-2] - The datatype is not an XSD or RDF datatype. 
            It is recommended to use XSD and RDF datatypes mainly. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-incorrectDataType">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="dataTypeElementName" select="$dataTypeElement/@name"/>
        <xsl:variable name="rdfOrXsdDataType"
            select="f:getXsdRdfDataTypeValues($dataTypeElementName, $xsdAndRdfDataTypes)"/>
        <xsl:if test="$rdfOrXsdDataType = ''">
            <xsl:sequence
                select="f:generateHtmlWarning(fn:concat('The datatype', $dataTypeElementName, 
                'is not an XSD or RDF datatype.  It is recommended to use XSD and RDF datatypes mainly.'))"
            />
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[datatype-attribute-3] The datatype $value$ is not atomic. 
         Complex datatypes where attributes/components are specified shall be represented as classes. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    
    <xsl:template name="d-attributeChecker">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="dataTypeNumberOfAttributes"
            select="count($dataTypeElement/attributes/attribute)"/>
        
        <xsl:sequence
            select="
            if ($dataTypeNumberOfAttributes > 0) then
            f:generateHtmlWarning(fn:concat('The datatype ', $dataTypeElement/@name,
            ' is not atomic. Complex datatypes where attributes/components are specified shall be represented as classes.'))
            else
            ()
            "
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[datatype-connector-4] The datatype $value should not connect to othe elements.
            A Datatype can only be referred to. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    
    <xsl:template name="d-outgoingConnectors">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="outgoingConnectors"
            select="fn:count(f:getOutgoingConnectors($dataTypeElement))"/>
        <xsl:sequence
            select="
            if ($outgoingConnectors > 0) then
            f:generateHtmlError(fn:concat('The datatype ', $dataTypeElement/@name,
            ' should not connect to othe elements. A Datatype can only be referred to.'))
            else
            ()
            "
        />
    </xsl:template>

   
    

    

</xsl:stylesheet>