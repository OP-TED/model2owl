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

    <xsl:variable name="elementTypes"
        select="('class', 'enumeration', 'dataType', 'package', 'object')"/>


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
                    f:generateErrorMessage(fn:concat('The name ', $elementName, ' does not match the pattern. ',
                    'The name should respect the syntax prefix:localSegment (similar to the XML QName).'),
                    path($element),
                    'common-name-1',
                    'CMC-R3',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;'
                    )"
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
                    f:generateErrorMessage(fn:concat('The name of the element ', $element/@xmi:idref,
                    ' is missing. Please provide one respecing the syntax prefix:localSegment.'),
                    path($element),
                    'common-name-2',
                    'CMC-R3',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;'
                    )
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
                    f:generateErrorMessage(fn:concat('The name of element ', $element/@name,
                    ' is missing a prefix. The name should comprise a prefix respecing the syntax prefix:localSegment.'),
                    path($element),
                    'common-name-3',
                    'CMC-R5',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;'
                    )
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
                    f:generateErrorMessage(fn:concat('The name of element ', $element/@name,
                    ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'),
                    path($element),
                    'common-name-4',
                    'CMC-R5',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;'
                    )
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
                    f:generateErrorMessage(fn:concat('The name prefix ', fn:substring-before($element/@name, ':'),
                    ' , is invalid. Please provide a short prefix name ',
                    'containing only alphanumeric characters [a-zA-Z0-9]+.'),
                    path($element),
                    'common-name-5',
                    'CMC-R5',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;'
                    )
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
                    f:generateErrorMessage(fn:concat('The prefix ', fn:substring-before($elementName, ':'),
                    ' is not defined. A prefix must be associated to a namespace URI.'),
                    path($element),
                    'common-name-6',
                    'CMC-R5',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;'
                    )"
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
                    f:generateErrorMessage(fn:concat('The local name segment ', fn:substring-after($element/@name, ':'),
                    ' , is invalid. Please provide a concise label using ',
                    'alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase, or possibly with ',
                    'tokens delimited by single spaces.'),
                    path($element),
                    'common-name-7',
                    'CMC-R4',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r4&quot; target=&quot;_blank&quot;&gt;CMC-R4&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;'
                    )
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
                    f:generateErrorMessage(fn:concat('The local name segment ', f:getLocalSegmentForElements($element),
                    ' starts with an invalid character. The local segment ',
                    'must start with a letter or underscore.'),
                    path($element),
                    'common-name-8',
                    'CMC-R4',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r4&quot; target=&quot;_blank&quot;&gt;CMC-R4&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;'
                    )"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-9] - The local name segment $value$ contains token delimiters. 
            It is best if the names are camel-cased and delimiters removed. </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="delimitersInTheLocalSegment">
        <xsl:param name="element"/>
        <xsl:sequence
            select="
                if (f:isDelimitersInElementLocalSegment($element)) then
                    f:generateErrorMessage(fn:concat('The local name segment ', f:getLocalSegmentForElements($element),
                    ' contains token delimiters. It is best if the names ',
                    'are camel cased and delimiters removed.'),
                    path($element),
                    'common-name-9',
                    'CMC-R4',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r4&quot; target=&quot;_blank&quot;&gt;CMC-R4&lt;/a&gt;'
                    )
                else
                    ()
                "
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-description-10] - $elementName$ is missing a description. 
            All concepts and properties should be defined and/or described.</xd:desc>
        <xd:param name="element"/>
        <xd:param name="elementType"/>
    </xd:doc>

    <xsl:template name="missingDescription">
        <xsl:param name="element"/>
        <xsl:param name="elementType"/>
        <xsl:variable name="elementName" select="$element/@name"/>
        <xsl:variable name="noElementDescription"
            select="
                if ($elementType = $elementTypes) then
                    $element/properties/not(@documentation)
                else
                    $element/documentation/not(@value)"/>
        <xsl:sequence
            select="
                if ($noElementDescription = fn:true()) then
                    f:generateWarningMessage(fn:concat($elementName, ' is missing a description. All concepts should be defined or described.'),
                    path($element),
                    'common-description-10',
                    'GC-R5',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-general-conventions.html#sec:gc-r5&quot; target=&quot;_blank&quot;&gt;GC-R5&lt;/a&gt;'
                    )
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
                if ($elementType = $elementTypes) then
                    $element/properties/@stereotype
                else
                    $element/stereotype/@stereotype"/>
        <xsl:sequence
            select="
                if ($hasStereotype)
                then
                    f:generateInfoMessage(fn:concat('The ', $element/*/@stereotype,
                    ' stareotype is applied to ', $element/@name,
                    '. Stereotypes are discouraged in the current practice with some exceptions. '),
                    path($element),
                    'common-stereotype-11',
                    'CMC-R17',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r17&quot; target=&quot;_blank&quot;&gt;CMC-R17&lt;/a&gt;'
                    )
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
                if ($elementType = $elementTypes) then
                    f:isElementStereotypeValid($element)
                else
                    f:isAttributeStereotypeValid($element)"/>
        <xsl:sequence
            select="
                if ($isStereotypeValid)
                then
                    ()
                else
                    f:generateWarningMessage(fn:concat('The ', $element/*/@stereotype,
                    ' stareotype applied to ', $element/@name,
                    'is not known and will be ignored. '),
                    path($element),
                    'common-stereotype-12',
                    'CMC-R17',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r17&quot; target=&quot;_blank&quot;&gt;CMC-R17&lt;/a&gt;'
                    )"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-tag-13] - The tag $tagName$ of element $elementName$ must be one of the following formats:
            namespace:localName
            namespace:localName@en
            namespace:localName^^xsd:integer
            namespace:localName&lt;&gt;
        </xd:desc>
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
                    f:generateErrorMessage(fn:concat('The tag ', $tag/@name, ' of element ', $element/@name, ' must be one of the following formats: namespace:localName, namespace:localName@en, namespace:localName^^xsd:integer, namespace:localName&lt;&gt;.'),
                        path($element),
                        'common-tag-13',
                        'CMC-R6',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r6&quot; target=&quot;_blank&quot;&gt;CMC-R6&lt;/a&gt;'
                        )"/>

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
                        f:generateErrorMessage(fn:concat('The tag ', $tag/@name, ' of element ', $element/@name, ' must have a value'),
                        path($element),
                        'common-tag-14]',
                        'CMC-R6',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r6&quot; target=&quot;_blank&quot;&gt;CMC-R6&lt;/a&gt;'
                        )"/>

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
                        f:generateErrorMessage(fn:concat('The tag ', $tag/@name, ' of element ', $element/@name, ' must have a valid name'),
                        path($element),
                        'common-tag-15',
                        'CMC-R6',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r6&quot; target=&quot;_blank&quot;&gt;CMC-R6&lt;/a&gt;'
                        )"/>

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
                f:generateInfoMessage(fn:concat('The name (', $elementName,') is possibly in plural grammatical number. Names shall be usually provided in singular number.'),
                    path($element),
                    'common-name-16',
                    'GC-R4',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-general-conventions.html#sec:gc-r4&quot; target=&quot;_blank&quot;&gt;GC-R4&lt;/a&gt;'
                    )
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
                            f:generateErrorMessage(fn:concat('The prefix for ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'),
                            path($element),
                            'common-tag-prefix-17',
                            'CMC-R3',
                            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;
                            &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;
                            &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r6&quot; target=&quot;_blank&quot;&gt;CMC-R6&lt;/a&gt;'
                            )
                    else
                        f:generateErrorMessage(fn:concat('The prefix for ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'),
                        path($element),
                        'common-tag-prefix-17',
                        'CMC-R3',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r3&quot; target=&quot;_blank&quot;&gt;CMC-R3&lt;/a&gt;
                        &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;
                        &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r6&quot; target=&quot;_blank&quot;&gt;CMC-R6&lt;/a&gt;'
                        )
                "/>

    </xsl:template>

    <xd:doc>
        <xd:desc>[common-visibility-18] - The element $name$ is non-public. All elements shall be
            public.</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:template name="nonPublicElement">
        <xsl:param name="element"/>
        <xsl:variable name="elementScope" select="$element/@scope"/>
        <xsl:sequence
            select="
            if ($elementScope = 'public') then
            ()
            else
            f:generateErrorMessage(fn:concat('The element ', $element/@name, ' is non-public. All elements shall be public '),
            path($element),
            'common-visibility-18',
            'CMC-R13',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r13&quot; target=&quot;_blank&quot;&gt;CMC-R13&lt;/a&gt;'
            )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-19] - The name $value$ is not unique. The Concept names should be unique within the model. 
            The following list specifies the names of the which things are not to be reused as the names of which other things:
            (a) elements (Class, Datatype, Enumeration, Object) -> elements, attributes, connector roles (dependency and association);
            (b) attributes -> elements, connector roles (dependency and association) </xd:desc>
        <xd:param name="element"/>
        <xd:param name="isAttribute"/>
    </xd:doc>
    <xsl:template name="elementUniqueName">
        <xsl:param name="element"/>
        <xsl:param name="isAttribute"/>
        <xsl:if test="boolean($element/@name)">
            <xsl:variable name="elementsFound"
                select="f:getElementByName($element/@name, root($element))"/>
            <xsl:variable name="connectorsFound"
                select="f:getConnectorByName($element/@name, root($element))"/>
            <xsl:variable name="attributesFound"
                select="f:getAttributeByName($element/@name, root($element))"/>
            <xsl:choose>
                <xsl:when test="$isAttribute = fn:true()">
                    <xsl:sequence
                        select="
                            if (count($elementsFound) > 0 or count($connectorsFound) > 0) then
                                f:generateErrorMessage(fn:concat('The name ', $element/@name, ' is not unique. The Concept names ',
                                'should be unique within the model. ',
                                'The following specifies the names of the which things are not to be reused as the names of which other things: ',
                                'attributes -> elements, connector roles (dependency and association)'
                                ),
                                path($element),
                                'common-name-19',
                                'CMC-R5',
                                '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;'
                                )
                            else
                                ()
                            
                            "
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence
                        select="
                        if (count($elementsFound) > 1 or count($connectorsFound) > 0 or count($attributesFound) > 0) then
                                f:generateErrorMessage(fn:concat('The name ', $element/@name, ' is not unique. The Concept names ',
                                'should be unique within the model. ',
                                'The following specifies the names of the which things are not to be reused as the names of which other things: ',
                                'elements (Class, Datatype, Enumeration, Object) -> elements, attributes, connector roles (dependency and association)'),
                                path($element),
                                'common-name-19',
                                'CMC-R5',
                                '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r5&quot; target=&quot;_blank&quot;&gt;CMC-R5&lt;/a&gt;'
                                )
                            else
                                ()  
                            "
                    />
                </xsl:otherwise>
            </xsl:choose>

        </xsl:if>
    </xsl:template>

</xsl:stylesheet>