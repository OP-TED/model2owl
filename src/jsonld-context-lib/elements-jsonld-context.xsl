<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs xd xsl xmi fn f"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 24, 2025</xd:p>
            <xd:p>This module defines how selected XMI elements are transformed
            into JSON-LD context.</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="common-jsonld-context.xsl"/>
    
    <xsl:output method="xml" encoding="UTF-8"/>

    <xd:doc>
        <xd:desc>
            Selector to run JSON-LD context transformation rules for classes and
            attributes.
        </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:if test="not(f:isExcludedByStatus(.))">
            <xsl:variable name="classPrefix" select="f:getPrefix(./@name)"/>
            <!-- Check if the class should be processed -->
            <xsl:if test="$generateReusedConceptsJSONLDcontext or $classPrefix = $includedPrefixesList">
                <xsl:call-template name="classDeclaration"/>
                <xsl:call-template name="generatePropertiesFromClassAttributes"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Rule C.03. Class — in JSON-LD context layer.
            Specify a term for each UML class by assigning an absolute URI of
            the class to the class name. Create the term mapping as a top-level
            entry of the context object.
        </xd:desc>
    </xd:doc>
    <xsl:template name="classDeclaration">
        <xsl:call-template name="elementDeclaration"/>
    </xsl:template>


    <xd:doc>
        <xd:desc>
            Generates attribute node objects for class attributes that are not
            excluded based on their status or origin.
        </xd:desc>
    </xd:doc>
    <xsl:template name="generatePropertiesFromClassAttributes">
        <xsl:variable name="class" select="."/>
        <xsl:for-each select="$class/attributes/attribute">
            <!-- Use the first found attribute -->
            <xsl:variable name="attribute" select="."/>
            <xsl:variable name="attributeName" select="$attribute/@name"/>
            <xsl:if test="not(f:isExcludedByStatus($attribute))">
                <!-- Extract the prefix from the attribute name -->
                <xsl:variable name="attributePrefix" select="f:getPrefix($attributeName)"/>
                <!-- Check if the attribute should be processed -->
                <xsl:if
                    test="$generateReusedConceptsJSONLDcontext or $attributePrefix = $includedPrefixesList">
                    <xsl:call-template name="attributeGeneration">
                        <xsl:with-param name="class" select="$class"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Generates a node object for the class attribute. Includes the
            attribute URI mapping, type, and container information.
        </xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="attributeGeneration">
        <xsl:param name="class"/>
        <xsl:variable name="attribute" select="."/>
        <xsl:variable name="attrCurie" select="$attribute/@name"/>
        <xsl:variable name="classCurie" select="$class/@name"/>
        <xsl:variable name="attrName" select="f:getLocalSegment($attrCurie)"/>
        <xsl:variable name="className" select="f:getLocalSegment($classCurie)"/>
        <fn:map key="{$className}.{$attrName}">
            <xsl:call-template name="attributeDeclaration">
                <xsl:with-param name="attrCurie" select="$attrCurie"/>
            </xsl:call-template>
            <xsl:call-template name="attributeTypeDeclaration">
                <xsl:with-param name="attribute" select="$attribute"/>
            </xsl:call-template>
            <xsl:call-template name="attributeContainerDeclaration">
                <xsl:with-param name="attribute" select="$attribute"/>
            </xsl:call-template>
        </fn:map>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            C.08. Attribute — in JSON-LD context layer.
            For each UML class attribute, specify a datatype property by
            creating a property URI mapping with an absolute attribute URI in a
            node object. Set the term definition as a top-level entry of the
            context object.
            </xd:desc>
        <xd:param name="attrCurie"/>
    </xd:doc>
    <xsl:template name="attributeDeclaration">
        <xsl:param name="attrCurie"/>
        <xsl:variable name="attrUri" select="f:buildURIfromLexicalQName($attrCurie)"/>
        <fn:string key="@id"><xsl:value-of select="$attrUri"/></fn:string>   
    </xsl:template>

    <xd:doc>
        <xd:desc>
            C.11. Class attribute type — in JSON-LD context layer
            For each UML class attribute, specify its range by creating a type
            coercion entry with an absolute URI of the attribute datatype in a
            node object. Set the term definition as a top-level entry of the
            context object.
        </xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:template name="attributeTypeDeclaration">
        <xsl:param name="attribute"/>
        <xsl:variable name="attrType" select="$attribute/properties/@type"/>
        <xsl:variable name="attributeTypeChecked"
            select="
                if (boolean(f:getUmlDataTypeValues($attrType, $umlDataTypesMapping))) then
                    f:getUmlDataTypeValues($attrType, $umlDataTypesMapping)
                else
                    $attrType"/>
        <xsl:variable name="attrTypeUri"
            select="
                if ($attrType = $controlledListType) then
                    f:buildURIfromLexicalQName('skos:Concept')
                else
                    f:buildURIfromLexicalQName($attributeTypeChecked)"/>
        <fn:string key="@type"><xsl:value-of select="$attrTypeUri"/></fn:string>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            C.15. Class attribute container — in JSON-LD context layer.
            Specify a default container type for a class attribute that can
            accept more than a one value by setting the fixed @set keyword as a
            value for the @container key. Set the container type entry inside a
            term definition created as a top-level entry of the context object.
        </xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:template name="attributeContainerDeclaration">
        <xsl:param name="attribute"/>
        <xsl:variable name="canHaveMultVals"
            select="f:areMultipleAttributeValuesAllowed($attribute)"/>
        <xsl:if test="$canHaveMultVals = fn:true()">
            <fn:string key="@container">@set</fn:string>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>