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
                if (f:isInvalidElementNamePrefix($element)) then
                    f:generateHtmlError(fn:concat('The name prefix ', fn:substring-before($element/@name, ':'),
                    ' , is invalid. Please provide a short prefix name ',
                    'containing only alphanumeric characters [a-zA-Z0-9]+.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-6]-The prefix $value$ is not defined. A prefix must be associated to a
            namespace URI. </xd:desc>
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
                if (f:isInvalidElementLocalSegmentName($element)) then
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
                if (f:isValidElementFirstCharacterInLocalSegment($element)) then
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
                if (f:isDelimitersInElementLocalSegment($element)) then
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
        <xd:param name="elementType"/>
    </xd:doc>

    <xsl:template name="missingDescription">
        <xsl:param name="element"/>
        <xsl:param name="elementType"/>
        <xsl:variable name="elementName" select="$element/@name"/>
        <xsl:variable name="noElementDescription"
            select="
                if ($elementType = ('class', 'enumeration', 'dataType', 'package')) then
                    $element/properties/not(@documentation)
                else
                    $element/documentation/not(@value)"/>
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
        <xd:param name="elementType"/>
    </xd:doc>
    <xsl:template name="stereotypeProvided">
        <xsl:param name="element"/>
        <xsl:param name="elementType"/>
        <xsl:variable name="hasStereotype"
            select="
                if ($elementType = ('class', 'enumeration', 'dataType', 'package')) then
                    $element/properties/@stereotype
                else
                    $element/stereotype/@stereotype"/>
        <xsl:sequence
            select="
                if ($hasStereotype)
                then
                    f:generateHtmlInfo(fn:concat('The ', $element/*/@stereotype,
                    ' stareotype is applied to ', $element/@name,
                    '. Stereotypes are discouraged in the current practice with some exceptions. '))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-stereotype-12] - The $stereotypeName$ stareotype applied to $elementName$
            is not known and will be ignored. </xd:desc>
        <xd:param name="element"/>
        <xd:param name="elementType"/>
    </xd:doc>
    <xsl:template name="unknownStereotypeProvided">
        <xsl:param name="element"/>
        <xsl:param name="elementType"/>
        <xsl:variable name="isStereotypeValid"
            select="
                if ($elementType = ('class', 'enumeration', 'dataType', 'package')) then
                    f:isElementStereotypeValid($element)
                else
                    f:isAttributeStereotypeValid($element)"/>
        <xsl:sequence
            select="
                if ($isStereotypeValid)
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The ', $element/*/@stereotype,
                    ' stareotype applied to ', $element/@name,
                    'is not known and will be ignored. '))"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-tag-13] - The tag $tagName$ of element $elementName$ must be an URI. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="invalidTagName">
        <xsl:param name="element"/>
        <xsl:variable name="tags" select="f:getElementTags($element)"/>
        <xsl:sequence
            select="
                for $tag in $tags
                return
                    if (f:isValidTagName($tag/@name)) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The tag ', $tag/@name, ' of element ', $element/@name, ' must be an URI.'))"/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[common-tag-14] - The tag $tagName$ of element $elementName$ must have a value. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="missingTagValue">
        <xsl:param name="element"/>
        <xsl:variable name="tags" select="f:getElementTags($element)"/>
        <xsl:sequence
            select="
                for $tag in $tags
                return
                    if ($tag/@value) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The tag ', $tag/@name, ' of element ', $element/@name, ' must have a value'))"/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[common-tag-15] - The tag $tagName$ of element $elementName$ must have a valid
            name. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="missingTagName">
        <xsl:param name="element"/>
        <xsl:variable name="tags" select="f:getElementTags($element)"/>
        <xsl:sequence
            select="
                for $tag in $tags
                return
                    if ($tag/@name) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The tag ', $tag/@name, ' of element ', $element/@name, ' must have a valid name'))"/>

    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-16] - The name $value is possibly in plural grammatical number. Names
            shall be usually provided in singular number. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="namePlural">
        <xsl:param name="element"/>
        <xsl:variable name="elementName" select="$element/@name"/>
        <xsl:sequence
            select="
                if (fn:ends-with($elementName, 'es') or fn:ends-with($elementName, 's')) then
                    f:generateHtmlWarning('The class name is possibly in plural grammatical number. Names shall be usually provided in singular number.')
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-tag-prefix-17] - The Tag name prefix $value$ is not defined. A prefix must
            be associated to a namespace URI. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="missingPrefixTagName">
        <xsl:param name="element"/>
        <xsl:variable name="tags" select="f:getElementTags($element)"/>
        <xsl:sequence
            select="
                for $tag in $tags
                return
                    if (fn:contains($tag/@name, ':')) then
                        if ((f:isValidNamespace($tag/@name)) or (fn:substring-before($tag/@name, ':') = '')) then
                            ()
                        else
                            f:generateHtmlError(fn:concat('The prefix for ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'))
                    else
                        f:generateHtmlError(fn:concat('The prefix for ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'))
                "/>

    </xsl:template>

</xsl:stylesheet>