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
        <xd:desc>[connector-name-1] - The role names does not match the pattern. The name should
            respect the syntax "prefix:localSegment" (similar to the XML QName).</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-namingFormat">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (not(f:isValidQname($targetRoleName))) then
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName, ' does not match the pattern. ',
                        'The name should respect the syntax prefix:localSegment (similar to the XML QName).'))
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (not(f:isValidQname($targetRoleName)) and not(f:isValidQname($sourceRoleName))) then
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' does not match the pattern. ',
                        'The name should respect the syntax prefix:localSegment (similar to the XML QName).'))
                    else
                        ()"
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-name-2] - The role names is missing a prefix. The name should comprise a
            prefix respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-missingNamePrefix">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isNamePrefixMissing($targetRoleName)) then
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName, ' is missing a prefix. ',
                        'The name should comprise a prefix respecing the syntax prefix:localSegment.'))
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isNamePrefixMissing($targetRoleName) or f:isNamePrefixMissing($sourceRoleName)) then
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' is missing a prefix. ',
                        'The name should comprise a prefix respecing the syntax prefix:localSegment.'))
                    else
                        ()"
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-name-3] - The role names is missing a local segment. Please provide one
            respecing the syntax "prefix:localSegment"</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-missingLocalSegmentName">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isNameLocalSegmentMissing($targetRoleName)) then
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName,
                        ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'))
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isNameLocalSegmentMissing($targetRoleName) or f:isNameLocalSegmentMissing($sourceRoleName)) then
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'))
                    else
                        ()"
            />
        </xsl:if>

    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-4] - The name prefix is invalid in $value$. Please provide a short
            prefix name containing only alphanumeric characters [a-zA-Z0-9]+.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-invalidNamePrefix">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isInvalidNamePrefix($targetRoleName)) then
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName,
                        ' , is invalid. Please provide a short prefix name ',
                        'containing only alphanumeric characters [a-zA-Z0-9]+.'))
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isInvalidNamePrefix($targetRoleName) or f:isInvalidNamePrefix($sourceRoleName)) then
                        f:generateHtmlWarning(fn:concat('The target role name prefix ', $targetRoleName, ' or source role name prefix ', $sourceRoleName,
                        ' , is invalid. Please provide a short prefix name ',
                        'containing only alphanumeric characters [a-zA-Z0-9]+.'))
                    else
                        ()"
            />
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-5]-The prefix $value$ is not defined. A prefix must be associated to a
            namespace URI. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-undefinedPrefix">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">
            <xsl:sequence
                select="
                    if (f:isValidNamespace($targetRoleName)) then
                        ()
                    else
                        f:generateHtmlWarning(fn:concat('The target role name ', $targetRoleName,
                        ' is not defined. A prefix must be associated to a namespace URI.'))
                    "
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isValidNamespace($targetRoleName) and f:isValidNamespace($sourceRoleName)) then
                        ()
                    else
                        f:generateHtmlWarning(fn:concat('The target role name prefix ', $targetRoleName, ' or source role name prefix ', $sourceRoleName,
                        ' is not defined. A prefix must be associated to a namespace URI.'))
                    "
            />
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-6] - The local name segment is invalid in $value$. Please provide a
            concise label using alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase,
            or possibly with tokens delimited by single spaces.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-invalidNameLocalSegment">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isInvalidLocalSegmentName($targetRoleName)) then
                        f:generateHtmlWarning(fn:concat('The local name from target role name ', $targetRoleName,
                        ' , is invalid. Please provide a concise label using ',
                        'alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase, or possibly with ',
                        'tokens delimited by single spaces.'))
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isInvalidLocalSegmentName($targetRoleName) or f:isInvalidLocalSegmentName($sourceRoleName)) then
                        f:generateHtmlWarning(fn:concat('The local name segment from target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' , is invalid. Please provide a concise label using ',
                        'alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase, or possibly with ',
                        'tokens delimited by single spaces.'))
                    else
                        ()"
            />
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-7] - The local name segment $value$ starts with an invalid character.
            The local segment must start with a letter or underscore. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-invalidFirstCharacterInLocalSegment">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">
            <xsl:sequence
                select="
                    if (f:isValidFirstCharacterInLocalSegment($targetRoleName)) then
                        ()
                    else
                        f:generateHtmlWarning(fn:concat('The local name from target role name ', $targetRoleName,
                        ' starts with an invalid character. The local segment ',
                        'must start with a letter or underscore.'))
                    "
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isValidFirstCharacterInLocalSegment($targetRoleName) and f:isValidFirstCharacterInLocalSegment($sourceRoleName)) then
                        ()
                    else
                        f:generateHtmlWarning(fn:concat('The local name segment from target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' starts with an invalid character. The local segment ',
                        'must start with a letter or underscore.'))
                    "
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-8] - The local name segment $value$ contains token delimiters. It is
            best if the names are camel cased and delimiters removed. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-delimitersInTheLocalSegment">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isDelimitersInLocalSegment($targetRoleName)) then
                        f:generateHtmlWarning(fn:concat('The local name segment from target role name ', $targetRoleName,
                        ' contains token delimiters. It is best if the names ',
                        'are camel cased and delimiters removed.'))
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isInvalidLocalSegmentName($targetRoleName) or f:isInvalidLocalSegmentName($sourceRoleName)) then
                        f:generateHtmlWarning(fn:concat('The local name segment from target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' contains token delimiters. It is best if the names ',
                        'are camel cased and delimiters removed.'))
                    else
                        ()"
            />
        </xsl:if>
    </xsl:template>





    <xd:doc>
        <xd:desc>[connector-stereotype-9] - The $stereotypeName$ stareotype applied to $elementName$
            is not known and will be ignored. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-unknownStereotypeProvided">
        <xsl:param name="connector"/>
        <xsl:variable name="isStereotypeValid" select="f:isConnectorStereotypeValid($connector)"/>
        <xsl:sequence
            select="
                if ($isStereotypeValid)
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat(
                    'The stereotype applied to ', f:getConnectorName($connector),
                    'is not known and will be ignored. '))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-stereotype-10] - The $stereotypeName$ stareotype is applied to connector.
            Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-stereotypeProvided">
        <xsl:param name="connector"/>
        <xsl:variable name="hasStereotype"
            select="$connector/properties/@stereotype or $connector/*/role/@stereotype"/>
        <xsl:sequence
            select="
                if ($hasStereotype)
                then
                    f:generateHtmlInfo(fn:concat('The ', $hasStereotype,
                    ' stareotype is applied to ', f:getConnectorName($connector),
                    '. Stereotypes are discouraged in the current practice with some exceptions. '))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-description-11] - The connector is missing a description. All connectors
            should be defined or described.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-missingDescription">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorDirection" select="f:getConnectorDirection($connector)"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">
            <xsl:sequence
                select="
                    if ($connector/target/documentation/@value or $connector/documentation/@value) then
                        ()
                    else
                        f:generateHtmlWarning('The connector is missing a description. It is recommended 
                    to define and describe all the relations.')"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (($connector/target/documentation/@value and $connector/source/documentation/@value) or $connector/documentation/@value) then
                        ()
                    else
                        f:generateHtmlWarning('The connector is missing a description.It is recommended 
                    to define and describe all the relations.')"/>

        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-tag-invalid-name-12] - The tag $tagName$ must be an URI. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-invalidTagName">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceTags" select="$connector/source/tags/tag"/>
        <xsl:variable name="targetTags" select="$connector/target/tags/tag"/>
        <xsl:sequence
            select="
                for $tag in $sourceTags
                return
                    if (f:isValidTagName($tag/@name)) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The source tag ', $tag/@name, ' must be an URI.'))"/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if (f:isValidTagName($tag/@name)) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The target tag ', $tag/@name, ' must be an URI.'))"/>

    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-tag-prefix-13] - The Tag name prefix $value$ is not defined. A prefix
            must be associated to a namespace URI. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-missingPrefixTagName">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceTags" select="$connector/source/tags/tag"/>
        <xsl:variable name="targetTags" select="$connector/target/tags/tag"/>
        <xsl:sequence
            select="
                for $tag in $sourceTags
                return
                    if (fn:contains($tag/@name, ':')) then
                        if ((f:isValidNamespace($tag/@name)) or (fn:substring-before($tag/@name, ':') = '')) then
                            ()
                        else
                            f:generateHtmlError(fn:concat('The prefix for source ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'))
                    else
                        f:generateHtmlError(fn:concat('The prefix for source ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'))
                "/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if (fn:contains($tag/@name, ':')) then
                        if ((f:isValidNamespace($tag/@name)) or (fn:substring-before($tag/@name, ':') = '')) then
                            ()
                        else
                            f:generateHtmlError(fn:concat('The prefix for target ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'))
                    else
                        f:generateHtmlError(fn:concat('The prefix for target ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'))
                "/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-tag-value-14] - The tag $tagName$ must have a value. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-missingTagValue">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceTags" select="$connector/source/tags/tag"/>
        <xsl:variable name="targetTags" select="$connector/target/tags/tag"/>
        <xsl:sequence
            select="
                for $tag in $sourceTags
                return
                    if ($tag/@value) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The source tag ', $tag/@name, ' must have a value'))"/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if ($tag/@value) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The target tag ', $tag/@name, ' must have a value'))"/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-tag-name-15] - The tag $tagName$ must have a valid name. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-missingTagName">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceTags" select="$connector/source/tags/tag"/>
        <xsl:variable name="targetTags" select="$connector/target/tags/tag"/>
        <xsl:sequence
            select="
                for $tag in $sourceTags
                return
                    if ($tag/@name) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The source tag ', $tag/@name, ' must have a valid name'))"/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if ($tag/@name) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The target tag ', $tag/@name, ' must have a valid name'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-tag-16] - The connector $connectorName$ target role has tag annotations
            but no name. The connector must have a target role to sustain annotations. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-targetTags">
        <xsl:param name="connector"/>
        <xsl:variable name="numberOfTags" select="fn:count($connector/target/tags/tag)"/>
        <xsl:variable name="targetName" select="$connector/target/role/@name"/>
        <xsl:sequence
            select="
            if (($numberOfTags > 0) and not(boolean($targetName))) then
                    f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector), ' target role has tag annotations but no name. The connector must have a target role to sustain annotations.'))
                else
                    ()
                "
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-tag-17] - The connector $connectorName$ source role has tag annotations
            but no name. The connector must have a source role to sustain annotations. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-sourceTags">
        <xsl:param name="connector"/>
        <xsl:variable name="numberOfTags" select="fn:count($connector/source/tags/tag)"/>
        <xsl:variable name="sourceName" select="$connector/source/role/@name"/>
        <xsl:sequence
            select="
                if (($numberOfTags > 0) and not(boolean($sourceName))) then
                    f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector), ' source role has tag annotations but no name. The connector must have a source role to sustain annotations.'))
                else
                    ()
                "
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-tag-18] - The connector $connectorName$ has tag annotations. The
            connector is not transformed into a property and therefore any tag will be ignored. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-tags">
        <xsl:param name="connector"/>
        <xsl:variable name="numberOfTags" select="fn:count(f:getElementTags($connector))"/>
        <xsl:sequence
            select="
                if ($numberOfTags > 0) then
                    f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector), ' has tag annotations.', 
            'The connector is not transformed into a property and therefore any tag will be ignored.'))
                else
                    ()
                "
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-name-19] - The connector has a general name, and it should not. The names
            must be provided as connector source and target roles, not as connector name. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-generalNameProvided">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorHasNoName" select="$connector/not(@name)"/>
        <xsl:sequence
            select="
                if ($connectorHasNoName) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The connector has a general name, and it ',
                    'should not. The names must be provided as connector source and target roles, not as ',
                    'connector name.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-target-20] - The connector $connectorName$ has no target role. The
            connectors must have target roles.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-missingTargetRole">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
                if ($connector/target/role/not(@name)) then
                    f:generateHtmlError(fn:concat('The connector ', f:getConnectorName($connector),
                    ' has no target role. The connectors must have target roles.'))
                else
                    ()"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-direction-21] - The connector $connectorName$ employ invalid direction
            $direction$. Connectors must employ "Source->Destination" or "Bi-directional" directions
            only. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-invalidRelationshipDirection">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($connectorDirection = ('Source -&gt; Destination', 'Bi-Directional')) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The connector ', f:getConnectorName($connector),
                    ' employ invalid direction ', $connectorDirection,
                    '. Connectors must employ Source->Destination or Bi-directional directions only.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-multiplicity-22] - The target role of $connectorName$ has no
            multiplicity. Cardinality must be provided for each role.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-missingTargetMultiplicity">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
                if ($connector/target/type/not(@multiplicity)) then
                    f:generateHtmlWarning(fn:concat('The target role of ', f:getConnectorName($connector),
                    ' has no multiplicity. Cardinality must be provided for each role.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-multiplicity-23] - The connector $connectorName$ has target multiplicity
            invalidly stated. Multiplicity must be specified in the form ['min'..'max'].</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-invalidTargetMultiplicityFormat ">
        <xsl:param name="connector"/>
        <xsl:variable name="multiplicityValue" select="$connector/target/type/@multiplicity"/>
        <xsl:if test="boolean($multiplicityValue)">
            <xsl:sequence
                select="
                    if (fn:matches($multiplicityValue, '^[0-9]..[0-9]$') or fn:matches($multiplicityValue, '^[0-9]..\*$')) then
                        ()
                    else
                        f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector),
                        ' has target multiplicity invalidly stated. Multiplicity must be specified in the form [min..max].'))
                    "
            />
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>[connector-direction-24] - The connector direction and roles are out of sync. When
            the connector direction is "Source->Destination" then only a target role is expected,
            while for "Bi-Directional" direction source and a target roles are expected.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-directionAndRolesOutOfSync">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:variable name="missingSourceRole" select="$connector/source/role/not(@name)"/>
        <xsl:variable name="missingTargetRole" select="$connector/target/role/not(@name)"/>
        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
            <xsl:sequence
                select="
                    if (not($missingTargetRole) and $missingSourceRole) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The connector direction and roles are out of sync.',
                        ' The connector direction and roles are out of sync. When the connector direction is',
                        ' Source->Destination then only a target role is expected, while for Bi-Directional',
                        ' direction source and a target roles are expected.'))"
            />
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (not($missingTargetRole) and not($missingSourceRole)) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The connector direction and roles are out of sync.',
                        ' The connector direction and roles are out of sync. When the connector direction is',
                        ' Source->Destination then only a target role is expected, while for Bi-Directional',
                        ' direction source and a target roles are expected.'))"
            />
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>