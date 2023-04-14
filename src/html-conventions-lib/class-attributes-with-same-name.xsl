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
    <xsl:import href="../common/formatters.xsl"/>

    <xd:doc>
        <xd:desc>Applying the checkers to a group of class attributes with same name
            [class-attributes-reuse-definition-4] [class-attributes-reuse-multiplicity-5]
            [class-attributes-reuse-data-types-6] </xd:desc>
    </xd:doc>

    <xsl:template name="classAttributesWithSameName">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="distinctNames" select="f:getDistinctClassAttributeNames($root)"/>
        <h1>Class attributes with multiple usages</h1>
        <xsl:for-each select="$distinctNames">
            <xsl:sort select="." lang="en"/>
            <xsl:if test="fn:count(f:getClassAttributeByName(., $root)) > 1">
                <xsl:variable name="attributeChecks" as="item()*">
                    <xsl:call-template name="checkMultiplicityOfAttributesWithSameName">
                        <xsl:with-param name="attributeName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                    <xsl:call-template name="checkDefinitionOfAttributesWithSameName">
                        <xsl:with-param name="attributeName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                    <xsl:call-template name="checkDatatypeOfAttributesWithSameName">
                        <xsl:with-param name="attributeName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="boolean($attributeChecks)">
                    <dt>
                        <xsl:value-of select="."/>
                    </dt>
                    <xsl:copy-of select="$attributeChecks"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>[class-attributes-reuse-definition-4] Check the definition values from a group of
            class attributes with same name</xd:desc>
        <xd:param name="attributeName"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="checkDefinitionOfAttributesWithSameName">
        <xsl:param name="attributeName"/>
        <xsl:param name="root"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:variable name="definitionValues" select="$attributesWithSameName/documentation/@value"/>
        <xsl:variable name="descriptionsWithAnnotations" as="xs:string*"
            select="
                for $attribute in $attributesWithSameName
                return
                    if ($attribute/documentation/@value) then
                        fn:concat(f:formatDocString($attribute/documentation/@value), ' (', $attribute/../../@name, ') ')
                    else
                        ()"/>

        <xsl:variable name="allAttributesHaveDefinition"
            select="fn:count($attributesWithSameName) = fn:count($definitionValues)"/>
        <xsl:sequence
            select="
                if (f:areStringsEqual($definitionValues) and $allAttributesHaveDefinition) then
                    ()
                else
                    if (fn:boolean($definitionValues)) then
                        f:generateFormattedHtmlWarning(fn:concat('The attribute ', $attributeName, ' is defined differently in reuse contexts. ',
                        'When a property is reused in multiple contexts, the meaning given by the definition is expected to be the same.',
                        'In this case, multiple definitions are found: '), $descriptionsWithAnnotations)
                    else
                        ()"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[class-attributes-reuse-multiplicity-5 ]Check the multiplicity values from a group
            of class attributes with same name</xd:desc>
        <xd:param name="attributeName"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="checkMultiplicityOfAttributesWithSameName">
        <xsl:param name="attributeName"/>
        <xsl:param name="root"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:variable name="lowerBoundValues" select="$attributesWithSameName/bounds/@lower"/>
        <xsl:variable name="upperBoundValues" select="$attributesWithSameName/bounds/@upper"/>
        <xsl:variable name="allAttributesHaveMultiplicityValue"
            select="fn:count($attributesWithSameName) = fn:count($lowerBoundValues) and fn:count($lowerBoundValues) = fn:count($upperBoundValues)"/>
        <xsl:sequence
            select="
                if (f:areStringsEqual($lowerBoundValues) and f:areStringsEqual($upperBoundValues) and $allAttributesHaveMultiplicityValue) then
                    ()
                else
                    f:generateHtmlInfo(fn:concat('The attribute ', $attributeName, ' is has different multiplicities in reuse contexts.
                When a property is reused in multiple contexts, the multiplicity is expected to be the same. Please check the nomenclature above for a summary.'))"
        />
    </xsl:template>





    <xd:doc>
        <xd:desc>[class-attributes-reuse-data-types-6] Check the data-type from a group of class
            attributes with same name</xd:desc>
        <xd:param name="attributeName"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:template name="checkDatatypeOfAttributesWithSameName">
        <xsl:param name="attributeName"/>
        <xsl:param name="root"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:variable name="datatypeValues" select="$attributesWithSameName/properties/@type"/>

        <xsl:variable name="datatypeWithAnnotations" as="xs:string*"
            select="
                for $attribute in $attributesWithSameName
                return
                    if ($attribute/properties/@type) then
                        fn:concat($attribute/properties/@type, ' (', $attribute/../../@name, ') ')
                    else
                        ()"/>

        <xsl:variable name="allAttributesHaveDatatype"
            select="fn:count($attributesWithSameName) = fn:count($datatypeValues)"/>

        <xsl:sequence
            select="
                if (f:areStringsEqual($datatypeValues) and fn:boolean($datatypeValues) and $allAttributesHaveDatatype) then
                    ()
                else
                    if (fn:boolean($datatypeValues)) then
                        f:generateFormattedHtmlError(fn:concat('The attribute ', $attributeName, ' is has different datatypes in reuse contexts.',
                        'When a property is reused in multiple contexts, the data-type is expected to be the same.',
                        'In this case, multiple data-types are found: '), $datatypeWithAnnotations)
                    else
                        ()"
        />
    </xsl:template>


</xsl:stylesheet>