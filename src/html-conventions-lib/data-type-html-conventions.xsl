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
    <xsl:import href="../html-conventions-lib/utils-html-conventions.xsl"/>



    <xd:doc>
        <xd:desc>Getting all data-types and show only the ones that have unmet conventions
            [datatype-name-61
        </xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:DataType']">
        <xsl:variable name="dataTypeName">
            <xsl:call-template name="getDataTypeName">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dataTypeChecks" as="item()*">
            <xsl:call-template name="d-incorrectDataType">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-stereotypeProvided">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-missingDescription">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-missingName">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-missingNamePrefix">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-missingLocalSegmentName">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-invalidNamePrefix">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-invalidNameLocalSegment">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-invalidFirstCharacterInLocalSegment">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-delimitersInTheLocalSegment">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-uniqueName">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-undefinedPrefix">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
            <xsl:call-template name="d-namingFormat">
                <xsl:with-param name="dataTypeElement" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($dataTypeChecks)">
            <dl>
                <dt>
                    <xsl:value-of select="$dataTypeName"/>
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
            <xsl:when test="$dataTypeElement/not(@name) = fn:true()">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$dataTypeName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>[datatype-name-61] - This is not a valid xsd or rdf data-type. Is this suppose to be a Class instead?</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-incorrectDataType">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="dataTypeElementName" select="$dataTypeElement/@name"/>
        <xsl:variable name="rdfOrXsdDataType"
            select="f:getXsdRdfDataTypeValues($dataTypeElementName, $xsdAndRdfDataTypes)"/>
        <xsl:if test="$rdfOrXsdDataType = ''">
            <xsl:sequence
                select="f:generateHtmlWarning('This is not a valid xsd or rdf data-type. Is this suppose to be a Class instead?')"
            />
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-stereotype-10] - The $stereotypeName$ stareotype is applied to
            $elementName$. Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-stereotypeProvided">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
                if (f:isElementStereotypeValid($dataTypeElement))
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The ', $dataTypeElement/properties/@stereotype,
                    ' stareotype is applied to ', $dataTypeElement/@name,
                    '. Stereotypes are discouraged in the current practice with some exceptions. '))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-description-9] - $elementName$ is missing a description. All concepts
            should be defined or described.</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>

    <xsl:template name="d-missingDescription">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="dataTypeElementName" select="$dataTypeElement/@name"/>
        <xsl:variable name="noDescription" select="$dataTypeElement/properties/not(@documentation)"/>
        <xsl:sequence
            select="
                if ($noDescription = fn:true()) then
                    f:generateHtmlWarning(fn:concat($dataTypeElementName, ' is missing a description. All concepts should be defined or described.'))
                else
                    ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-1] - The name of the element $IdRef$ is missing. Please provide one
            respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-missingName">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
            if (f:isElementNameMissing($dataTypeElement)) then
            f:generateHtmlError(fn:concat('The name of the element ', $dataTypeElement/@xmi:idref,
            ' is missing. Please provide one respecing the syntax prefix:localSegment.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-2] - The name of element $elementName$ is missing a prefix. The name
            should comprise a prefix respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-missingNamePrefix">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
            if (f:isElementNamePrefixMissing($dataTypeElement)) then
            f:generateHtmlWarning(fn:concat('The name of element ', $dataTypeElement/@name,
            ' is missing a prefix. The name should comprise a prefix respecing the syntax prefix:localSegment.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-3] - The name of $elementName$ is missing a local segment. Please
            provide one respecing the syntax "prefix:localSegment".".</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-missingLocalSegmentName">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
            if (f:isElementNameLocalSegmentMissing($dataTypeElement)) then
            f:generateHtmlError(fn:concat('The name of element ', $dataTypeElement/@name,
            ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-4] - The name prefix is invalid in $value$. Please provide a short
            prefix name containing only alphanumeric characters [a-zA-Z0-9]+.</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-invalidNamePrefix">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
            if (f:isInvalidNamePrefix($dataTypeElement)) then
            f:generateHtmlError(fn:concat('The name prefix ', fn:substring-before($dataTypeElement/@name, ':'),
            ' , is invalid. Please provide a short prefix name ',
            'containing only alphanumeric characters [a-zA-Z0-9]+.'))
            else
            ()"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-name-5] - The local name segment is invalid in $value$. Please provide a
            concise label using alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase,
            or possibly with tokens delimited by single spaces.</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-invalidNameLocalSegment">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
            if (f:isInvalidLocalSegmentName($dataTypeElement)) then
            f:generateHtmlError(fn:concat('The local name segment ', fn:substring-after($dataTypeElement/@name, ':'),
            ' , is invalid. Please provide a concise label using ',
            'alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase, or possibly with ',
            'tokens delimited by single spaces.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-6] - The local name segment $value$ starts with an invalid character.
            The local segment must start with a letter or underscore. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-invalidFirstCharacterInLocalSegment">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
            if (f:isValidFirstCharacterInLocalSegment($dataTypeElement)) then
            ()
            else
            f:generateHtmlError(fn:concat('The local name segment ', f:getLocalSegmentForElements($dataTypeElement),
            ' starts with an invalid character. The local segment ',
            'must start with a letter or underscore.'))"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-name-7] - The local name segment $value$ contains token delimiters. It is
            best if the names are camel cased and delimiters removed. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    <xsl:template name="d-delimitersInTheLocalSegment">
        <xsl:param name="dataTypeElement"/>
        <xsl:sequence
            select="
            if (f:isDelimitersInLocalSegment($dataTypeElement)) then
            f:generateHtmlWarning(fn:concat('The local name segment ', f:getLocalSegmentForElements($dataTypeElement),
            ' contains token delimiters. It is best if the names ',
            'are camel cased and delimiters removed.'))
            else
            ()
            "
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-8] - The name $value$ is not unique. The Concept names should be
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
        <xd:desc>[common-name-57]-The prefix $value$ is not defined. A prefix must be associated to
            a namespace URI. </xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    
    <xsl:template name="d-undefinedPrefix">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="dataTypeElementName" select="$dataTypeElement/@name"/>
        <xsl:if test="not(f:isValidNamespace($dataTypeElementName))">
            <xsl:sequence
                select="
                f:generateHtmlWarning(fn:concat('The prefix ', fn:substring-before($dataTypeElementName, ':'),
                ' is not defined. A prefix must be associated to a namespace URI.'))"
            />
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-name-58] - The name $elementName$ does not match the pattern. The name
            should respect the syntax "prefix:localSegment" (similar to the XML QName).</xd:desc>
        <xd:param name="dataTypeElement"/>
    </xd:doc>
    
    <xsl:template name="d-namingFormat">
        <xsl:param name="dataTypeElement"/>
        <xsl:variable name="dataTypeElementName" select="$dataTypeElement/@name"/>
        <xsl:if test="f:isValidQname($dataTypeElementName) = fn:false()">
            <xsl:sequence
                select="
                f:generateHtmlWarning(fn:concat('The name ', $dataTypeElementName, ' does not match the pattern. ', 
                'The name should respect the syntax prefix:localSegment (similar to the XML QName).'))"
            />
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>