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
        <xd:desc>[common-name-1] - The name $elementName$ does not match the pattern. The name
            should respect the syntax "prefix:localSegment" (similar to the XML QName).</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    
    <xsl:template name="namingFormat">
        <xsl:param name="element"/>
        <xsl:variable name="elementName" select="$element/@name"/>
        <xsl:if test="f:isValidQname($elementName) = fn:false()">
            <xsl:sequence
                select="
                f:generateHtmlWarning(fn:concat('The name ', $elementName, ' does not match the pattern. ',
                'The name should respect the syntax prefix:localSegment (similar to the XML QName).'))"
            />
        </xsl:if>
    </xsl:template>
    
    
    
    
    <xd:doc>
        <xd:desc>[common-name-2] - The name of the element $IdRef$ is missing. Please provide one
            respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="missingName">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isElementNameMissing($element)) then
            f:generateHtmlError(fn:concat('The name of the element ', $element/@xmi:idref,
            ' is missing. Please provide one respecing the syntax prefix:localSegment.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-3] - The name of element $elementName$ is missing a prefix. The name
            should comprise a prefix respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="missingNamePrefix">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isElementNamePrefixMissing($element)) then
            f:generateHtmlWarning(fn:concat('The name of element ', $element/@name,
            ' is missing a prefix. The name should comprise a prefix respecing the syntax prefix:localSegment.'))
            else
            ()"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-name-4] - The name of $elementName$ is missing a local segment. Please
            provide one respecing the syntax "prefix:localSegment".".</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="missingLocalSegmentName">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isElementNameLocalSegmentMissing($element)) then
            f:generateHtmlError(fn:concat('The name of element ', $element/@name,
            ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'))
            else
            ()"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-name-5] - The name prefix is invalid in $value$. Please provide a short
            prefix name containing only alphanumeric characters [a-zA-Z0-9]+.</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="invalidNamePrefix">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isInvalidNamePrefix($element)) then
            f:generateHtmlError(fn:concat('The name prefix ', fn:substring-before($element/@name, ':'),
            ' , is invalid. Please provide a short prefix name ',
            'containing only alphanumeric characters [a-zA-Z0-9]+.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-6]-The prefix $value$ is not defined. A prefix must be associated to
            a namespace URI. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    
    <xsl:template name="undefinedPrefix">
        <xsl:param name="element"/>
        <xsl:variable name="elementName" select="$element/@name"/>
        <xsl:if test="not(f:isValidNamespace($elementName))">
            <xsl:sequence
                select="
                f:generateHtmlWarning(fn:concat('The prefix ', fn:substring-before($elementName, ':'),
                ' is not defined. A prefix must be associated to a namespace URI.'))"
            />
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-7] - The local name segment is invalid in $value$. Please provide a
            concise label using alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase,
            or possibly with tokens delimited by single spaces.</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="invalidNameLocalSegment">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isInvalidLocalSegmentName($element)) then
            f:generateHtmlError(fn:concat('The local name segment ', fn:substring-after($element/@name, ':'),
            ' , is invalid. Please provide a concise label using ',
            'alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase, or possibly with ',
            'tokens delimited by single spaces.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-8] - The local name segment $value$ starts with an invalid character.
            The local segment must start with a letter or underscore. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="invalidFirstCharacterInLocalSegment">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isValidFirstCharacterInLocalSegment($element)) then
            ()
            else
            f:generateHtmlError(fn:concat('The local name segment ', f:getLocalSegmentForElements($element),
            ' starts with an invalid character. The local segment ',
            'must start with a letter or underscore.'))"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-name-9] - The local name segment $value$ contains token delimiters. It is
            best if the names are camel cased and delimiters removed. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="delimitersInTheLocalSegment">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isDelimitersInLocalSegment($element)) then
            f:generateHtmlWarning(fn:concat('The local name segment ', f:getLocalSegmentForElements($element),
            ' contains token delimiters. It is best if the names ',
            'are camel cased and delimiters removed.'))
            else
            ()
            "
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-description-10] - $elementName$ is missing a description. All concepts
            should be defined or described.</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    
    <xsl:template name="missingDescription">
        <xsl:param name="element"/>
        <xsl:variable name="elementName" select="$element/@name"/>
        <xsl:variable name="noElementDescription" select="$element/properties/not(@documentation)"/>
        <xsl:sequence
            select="
            if ($noElementDescription = fn:true()) then
            f:generateHtmlWarning(fn:concat($elementName, ' is missing a description. All concepts should be defined or described.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-stereotype-11] - The $stereotypeName$ stareotype is applied to
            $elementName$. Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="stereotypeProvided">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
            if (f:isElementStereotypeValid($element))
            then
            ()
            else
            f:generateHtmlWarning(fn:concat('The ', $element/properties/@stereotype,
            ' stareotype is applied to ', $element/@name,
            '. Stereotypes are discouraged in the current practice with some exceptions. '))"
        />
    </xsl:template>
    
</xsl:stylesheet>