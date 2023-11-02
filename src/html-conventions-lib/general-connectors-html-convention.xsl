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

    <xsl:template name="connectorNamingFormat">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (not(f:isValidQname($targetRoleName))) then
                        f:generateWarningMessage(fn:concat('The target role name ', $targetRoleName, ' does not match the pattern. ',
                        'The name should respect the syntax prefix:localSegment (similar to the XML QName).'),
                        'The role names does not match the pattern. The name should
                        respect the syntax prefix:localSegment (similar to the XML QName).',
                        path($connector),
                        'connector-name-1'
                        )
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (not(f:isValidQname($targetRoleName)) and not(f:isValidQname($sourceRoleName))) then
                        f:generateWarningMessage(fn:concat('The target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' does not match the pattern. ',
                        'The name should respect the syntax prefix:localSegment (similar to the XML QName).'),
                        'The role names does not match the pattern. The name should
                        respect the syntax prefix:localSegment (similar to the XML QName).',
                        path($connector),
                        'connector-name-1'
                        )
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
    <xsl:template name="connectorMissingNamePrefix">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isNamePrefixMissing($targetRoleName)) then
                        f:generateWarningMessage(fn:concat('The target role name ', $targetRoleName, ' is missing a prefix. ',
                        'The name should comprise a prefix respecing the syntax prefix:localSegment.'),
                        'The role names is missing a prefix. The name should comprise a
                        prefix respecing the syntax prefix:localSegment',
                        path($connector),
                        'connector-name-2'
                        )
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isNamePrefixMissing($targetRoleName) or f:isNamePrefixMissing($sourceRoleName)) then
                        f:generateWarningMessage(fn:concat('The target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' is missing a prefix. ',
                        'The name should comprise a prefix respecing the syntax prefix:localSegment.'),
                        'The role names is missing a prefix. The name should comprise a
                        prefix respecing the syntax prefix:localSegment',
                        path($connector),
                        'connector-name-2'
                        )
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
    <xsl:template name="connectorMissingLocalSegmentName">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isNameLocalSegmentMissing($targetRoleName)) then
                        f:generateWarningMessage(fn:concat('The target role name ', $targetRoleName,
                        ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'),
                        'The role names is missing a local segment. Please provide one
                        respecing the syntax prefix:localSegment',
                        path($connector),
                        'connector-name-3'
                        )
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isNameLocalSegmentMissing($targetRoleName) or f:isNameLocalSegmentMissing($sourceRoleName)) then
                        f:generateWarningMessage(fn:concat('The target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'),
                        'The role names is missing a local segment. Please provide one
                        respecing the syntax prefix:localSegment',
                        path($connector),
                        'connector-name-3'
                        )
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
    <xsl:template name="connectorInvalidNamePrefix">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isInvalidNamePrefix($targetRoleName)) then
                        f:generateErrorMessage(fn:concat('The target role name ', $targetRoleName,
                        ' , is invalid. Please provide a short prefix name ',
                        'containing only alphanumeric characters [a-zA-Z0-9]+.'),
                        'The name prefix is invalid in $value$. Please provide a short
                        prefix name containing only alphanumeric characters [a-zA-Z0-9]+',
                        path($connector),
                        'common-name-4]'
                        )
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isInvalidNamePrefix($targetRoleName) or f:isInvalidNamePrefix($sourceRoleName)) then
                        f:generateErrorMessage(fn:concat('The target role name prefix ', $targetRoleName, ' or source role name prefix ', $sourceRoleName,
                        ' , is invalid. Please provide a short prefix name ',
                        'containing only alphanumeric characters [a-zA-Z0-9]+.'),
                        'The name prefix is invalid in $value$. Please provide a short
                        prefix name containing only alphanumeric characters [a-zA-Z0-9]+',
                        path($connector),
                        'common-name-4]'
                        )
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

    <xsl:template name="connectorUndefinedPrefix">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">
            <xsl:sequence
                select="
                    if (f:isValidNamespace($targetRoleName)) then
                        ()
                    else
                        f:generateWarningMessage(fn:concat('The target role name ', $targetRoleName,
                        ' is not defined. A prefix must be associated to a namespace URI.'),
                        'The prefix $value$ is not defined. A prefix must be associated to a
                        namespace URI.',
                        path($connector),
                        'common-name-5'
                        )
                    "
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isValidNamespace($targetRoleName) and f:isValidNamespace($sourceRoleName)) then
                        ()
                    else
                        f:generateWarningMessage(fn:concat('The target role name prefix ', $targetRoleName, ' or source role name prefix ', $sourceRoleName,
                        ' is not defined. A prefix must be associated to a namespace URI.'),
                        'The prefix $value$ is not defined. A prefix must be associated to a
                        namespace URI.',
                        path($connector),
                        'common-name-5'
                        )
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
    <xsl:template name="connectorInvalidNameLocalSegment">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isInvalidLocalSegmentName($targetRoleName)) then
                        f:generateErrorMessage(fn:concat('The local name from target role name ', $targetRoleName,
                        ' , is invalid. Please provide a concise label using ',
                        'alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase, or possibly with ',
                        'tokens delimited by single spaces.'),
                        'The local name segment is invalid in $value$. Please provide a
                        concise label using alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase,
                        or possibly with tokens delimited by single spaces.',
                        path($connector),
                        'common-name-6'
                        )
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isInvalidLocalSegmentName($targetRoleName) or f:isInvalidLocalSegmentName($sourceRoleName)) then
                        f:generateErrorMessage(fn:concat('The local name segment from target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' , is invalid. Please provide a concise label using ',
                        'alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase, or possibly with ',
                        'tokens delimited by single spaces.'),
                        'The local name segment is invalid in $value$. Please provide a
                        concise label using alphanumeric characters [a-zA-Z0-9_\-\s]+, preferably in CamelCase,
                        or possibly with tokens delimited by single spaces.',
                        path($connector),
                        'common-name-6'
                        )
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
    <xsl:template name="connectorInvalidFirstCharacterInLocalSegment">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">
            <xsl:sequence
                select="
                    if (f:isValidFirstCharacterInLocalSegment($targetRoleName)) then
                        ()
                    else
                        f:generateErrorMessage(fn:concat('The local name from target role name ', $targetRoleName,
                        ' starts with an invalid character. The local segment ',
                        'must start with a letter or underscore.'),
                        'The local name segment $value$ starts with an invalid character.
                        The local segment must start with a letter or underscore.',
                        path($connector),
                        'common-name-7'
                        )
                    "
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isValidFirstCharacterInLocalSegment($targetRoleName) and f:isValidFirstCharacterInLocalSegment($sourceRoleName)) then
                        ()
                    else
                        f:generateErrorMessage(fn:concat('The local name segment from target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' starts with an invalid character. The local segment ',
                        'must start with a letter or underscore.'),
                        'The local name segment $value$ starts with an invalid character.
                        The local segment must start with a letter or underscore.',
                        path($connector),
                        'common-name-7'
                        )
                    "
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-8] - The local name segment $value$ contains token delimiters. It is
            best if the names are camel cased and delimiters removed. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorDelimitersInTheLocalSegment">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRoleName" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRoleName" select="$connector/target/role/@name"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">

            <xsl:sequence
                select="
                    if (f:isDelimitersInLocalSegment($targetRoleName)) then
                        f:generateErrorMessage(fn:concat('The local name segment from target role name ', $targetRoleName,
                        ' contains token delimiters. It is best if the names ',
                        'are camel cased and delimiters removed.'),
                        'The local name segment $value$ contains token delimiters. It is
                        best if the names are camel cased and delimiters removed.',
                        path($connector),
                        'common-name-8'
                        )
                    else
                        ()"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (f:isInvalidLocalSegmentName($targetRoleName) or f:isInvalidLocalSegmentName($sourceRoleName)) then
                        f:generateErrorMessage(fn:concat('The local name segment from target role name ', $targetRoleName, ' or source role name ', $sourceRoleName,
                        ' contains token delimiters. It is best if the names ',
                        'are camel cased and delimiters removed.'),
                        'The local name segment $value$ contains token delimiters. It is
                        best if the names are camel cased and delimiters removed.',
                        path($connector),
                        'common-name-8'
                        )
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
    <xsl:template name="connectorUnknownStereotypeProvided">
        <xsl:param name="connector"/>
        <xsl:variable name="isStereotypeValid" select="f:isConnectorStereotypeValid($connector)"/>
        <xsl:sequence
            select="
                if ($isStereotypeValid)
                then
                    ()
                else
                    f:generateWarningMessage(fn:concat(
                    'The stereotype applied to ', f:getConnectorName($connector),
                    'is not known and will be ignored. '),
                    'The $stereotypeName$ stareotype applied to $elementName$
                    is not known and will be ignored.',
                    path($connector),
                    'connector-stereotype-9'
                    )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-stereotype-10] - The $stereotypeName$ stareotype is applied to
            connector. Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorStereotypeProvided">
        <xsl:param name="connector"/>
        <xsl:variable name="hasStereotype"
            select="$connector/properties/@stereotype or $connector/*/role/@stereotype"/>
        <xsl:sequence
            select="
                if ($hasStereotype)
                then
                    f:generateInfoMessage(fn:concat('The ', $hasStereotype,
                    ' stareotype is applied to ', f:getConnectorName($connector),
                    '. Stereotypes are discouraged in the current practice with some exceptions. '),
                    'The $stereotypeName$ stareotype is applied to
                    connector. Stereotypes are discouraged in the current practice with some exceptions.',
                    path($connector),
                    'connector-stereotype-10'
                    )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-description-11] - The connector is missing a description. All concepts and properties 
            should be defined and/or described.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorMissingDescription">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorDirection" select="f:getConnectorDirection($connector)"/>
        <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">
            <xsl:sequence
                select="
                    if ($connector/target/documentation/@value or $connector/documentation/@value) then
                        ()
                    else
                        f:generateWarningMessage('The connector is missing a description. It is recommended 
                    to define and describe all the relations.',
                    'The connector is missing a description. All concepts and properties 
                    should be defined and/or described.',
                    path($connector),
                    'connector-description-11'
                    )"
            />
        </xsl:if>
        <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (($connector/target/documentation/@value and $connector/source/documentation/@value) or $connector/documentation/@value) then
                        ()
                    else
                        f:generateWarningMessage('The connector is missing a description.It is recommended 
                    to define and describe all the relations.',
                    'The connector is missing a description. All concepts and properties 
                    should be defined and/or described.',
                    path($connector),
                    'connector-description-11'
                    )"/>

        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-tag-12] - The tag $tagName$ must be an URI. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorInvalidTagName">
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
                        f:generateErrorMessage(fn:concat('The source tag ', $tag/@name, ' must be an URI.'),
                        'The tag $tagName$ must be an URI.',
                        path($connector),
                        'connector-tag-12'
                        )"/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if (f:isValidTagName($tag/@name)) then
                        ()
                    else
                        f:generateErrorMessage(fn:concat('The target tag ', $tag/@name, ' must be an URI.'),
                        'The tag $tagName$ must be an URI.',
                        path($connector),
                        'connector-tag-12'
                        )"/>

    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-tag-prefix-13] - The Tag name prefix $value$ is not defined. A prefix
            must be associated to a namespace URI. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorMissingPrefixTagName">
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
                            f:generateWarningMessage(fn:concat('The prefix for source role ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'),
                            'The Tag name prefix $value$ is not defined. A prefix
                            must be associated to a namespace URI.',
                            path($connector),
                            'connector-tag-prefix-13'
                            )
                    else
                        f:generateWarningMessage(fn:concat('The prefix for source role ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'),
                        'The Tag name prefix $value$ is not defined. A prefix
                        must be associated to a namespace URI.',
                        path($connector),
                        'connector-tag-prefix-13'
                        )
                "/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if (fn:contains($tag/@name, ':')) then
                        if ((f:isValidNamespace($tag/@name)) or (fn:substring-before($tag/@name, ':') = '')) then
                            ()
                        else
                            f:generateWarningMessage(fn:concat('The prefix for target role ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'),
                            'The Tag name prefix $value$ is not defined. A prefix
                            must be associated to a namespace URI.',
                            path($connector),
                            'connector-tag-prefix-13'
                            )
                    else
                        f:generateWarningMessage(fn:concat('The prefix for target role ', $tag/@name, ' is not defined. A prefix must be associated to a namespace URI.'),
                        'The Tag name prefix $value$ is not defined. A prefix
                        must be associated to a namespace URI.',
                        path($connector),
                        'connector-tag-prefix-13'
                        )
                "/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-tag-14] - The tag $tagName$ must have a value. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorMissingTagValue">
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
                        f:generateErrorMessage(fn:concat('The source tag ', $tag/@name, ' must have a value'),
                        'The tag $tagName$ must have a value.',
                        path($connector),
                        'connector-tag-14'
                        )"/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if ($tag/@value) then
                        ()
                    else
                        f:generateErrorMessage(fn:concat('The target tag ', $tag/@name, ' must have a value'),
                        'The tag $tagName$ must have a value.',
                        path($connector),
                        'connector-tag-14'
                        )"/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-tag-15] - The tag $tagName$ must have a valid name. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorMissingTagName">
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
                        f:generateErrorMessage(fn:concat('The source tag ', $tag/@name, ' must have a valid name'),
                        'The tag $tagName$ must have a valid name.',
                        path($connector),
                        'connector-tag-15'
                        )"/>
        <xsl:sequence
            select="
                for $tag in $targetTags
                return
                    if ($tag/@name) then
                        ()
                    else
                        f:generateErrorMessage(fn:concat('The target tag ', $tag/@name, ' must have a valid name'),
                        'The tag $tagName$ must have a valid name.',
                        path($connector),
                        'connector-tag-15'
                        )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-target-tag-16] - The connector $connectorName$ target role has tag annotations
            but no name. The connector must have a target role to sustain annotations. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorTargetTags">
        <xsl:param name="connector"/>
        <xsl:variable name="numberOfTags" select="fn:count($connector/target/tags/tag)"/>
        <xsl:variable name="targetName" select="$connector/target/role/@name"/>
        <xsl:sequence
            select="
                if (($numberOfTags > 0) and not(boolean($targetName))) then
                    f:generateWarningMessage(fn:concat('The connector ', f:getConnectorName($connector), ' target role has tag annotations but no name. The connector must have a target role to sustain annotations.'),
                    'The connector $connectorName$ target role has tag annotations
                    but no name. The connector must have a target role to sustain annotations.',
                    path($connector),
                    'connector-target-tag-16'
                    )
                else
                    ()
                "
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-source-tag-17] - The connector $connectorName$ source role has tag annotations
            but no name. The connector must have a source role to sustain annotations. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorSourceTags">
        <xsl:param name="connector"/>
        <xsl:variable name="numberOfTags" select="fn:count($connector/source/tags/tag)"/>
        <xsl:variable name="sourceName" select="$connector/source/role/@name"/>
        <xsl:sequence
            select="
                if (($numberOfTags > 0) and not(boolean($sourceName))) then
                    f:generateWarningMessage(fn:concat('The connector ', f:getConnectorName($connector), ' source role has tag annotations but no name. The connector must have a source role to sustain annotations.'),
                    'The connector $connectorName$ source role has tag annotations
                    but no name. The connector must have a source role to sustain annotations.',
                    path($connector),
                    'connector-source-tag-17'
                    )
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
    <xsl:template name="connectorTags">
        <xsl:param name="connector"/>
        <xsl:variable name="numberOfTags" select="fn:count(f:getElementTags($connector))"/>
        <xsl:sequence
            select="
                if ($numberOfTags > 0) then
                    f:generateWarningMessage(fn:concat('The connector ', f:getConnectorName($connector), ' has tag annotations.',
                    'The connector is not transformed into a property and therefore any tag will be ignored.'),
                    'The connector $connectorName$ has tag annotations. The
                    connector is not transformed into a property and therefore any tag will be ignored.',
                    path($connector),
                    'connector-tag-18'
                    )
                else
                    ()
                "
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-name-19] - The connector has a general name, and it should not. The
            names must be provided as connector source and target roles, not as connector name. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorGeneralNameProvided">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorHasNoName" select="$connector/not(@name)"/>
        <xsl:sequence
            select="
                if ($connectorHasNoName) then
                    ()
                else
                    f:generateErrorMessage(fn:concat('The connector has a general name (', $connector/@name, '), and it ',
                    'should not. The names must be provided as connector source and target roles, not as ',
                    'connector name.'),
                    'The connector has a general name, and it should not. The
                    names must be provided as connector source and target roles, not as connector name.',
                    path($connector),
                    'connector-name-19'
                    )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-target-20] - The connector $connectorName$ has no target role. The
            connectors must have target roles.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorMissingTargetRole">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
                if ($connector/target/role/not(@name)) then
                    f:generateErrorMessage(fn:concat('The connector ', f:getConnectorName($connector),
                    ' has no target role. The connectors must have target roles.'),
                    'The connector $connectorName$ has no target role. The
                    connectors must have target roles.',
                    path($connector),
                    'connector-target-20'
                    )
                else
                    ()"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-direction-21] - The connector $connectorName$ employs invalid direction $direction$. 
            Connectors must employ "Source->Destination" or "Bidirectional" directions only.  </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorInvalidRelationshipDirection">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($connectorDirection = ('Source -&gt; Destination', 'Bi-Directional')) then
                    ()
                else
                    f:generateErrorMessage(fn:concat('The connector ', f:getConnectorName($connector),
                    ' employ invalid direction ', $connectorDirection,
                    '. Connectors must employ Source->Destination or Bi-directional directions only.'),
                    'The connector $connectorName$ employs invalid direction $direction$. 
                    Connectors must employ Source->Destination or Bidirectional directions only. ',
                    path($connector),
                    'connector-direction-21'
                    )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-multiplicity-22] - The target role of $connectorName$ has no
            multiplicity. Cardinality must be provided for each role.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorMissingTargetMultiplicity">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
                if ($connector/target/type/not(@multiplicity)) then
                    f:generateWarningMessage(fn:concat('The target role of ', f:getConnectorName($connector),
                    ' has no multiplicity. Cardinality must be provided for each role.'),
                    'The target role of $connectorName$ has no
                    multiplicity. Cardinality must be provided for each role.',
                    path($connector),
                    'connector-multiplicity-22'
                    )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-multiplicity-23] - The connector $connectorName$ has target multiplicity
            invalidly stated. Multiplicity must be specified in the form ['min'..'max'].</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorInvalidTargetMultiplicityFormat">
        <xsl:param name="connector"/>
        <xsl:variable name="multiplicityValue" select="$connector/target/type/@multiplicity"/>
        <xsl:if test="boolean($multiplicityValue)">
            <xsl:sequence
                select="
                    if (fn:matches($multiplicityValue, '^[0-9]..[0-9]$') or 
                    fn:matches($multiplicityValue, '^[0-9]..\*$') or
                    fn:matches($multiplicityValue, '^[0-9]')) then
                        ()
                    else
                        f:generateWarningMessage(fn:concat('The connector ', f:getConnectorName($connector),
                        ' has target multiplicity invalidly stated. Multiplicity must be specified in the form [min..max].'),
                        'The connector $connectorName$ has target multiplicity
                        invalidly stated. Multiplicity must be specified in the form [min..max].',
                        path($connector),
                        'connector-multiplicity-23'
                        )
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

    <xsl:template name="connectorDirectionAndRolesOutOfSync">
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
                        f:generateErrorMessage(fn:concat('The connector direction and roles are out of sync.',
                        ' The connector direction and roles are out of sync. When the connector direction is',
                        ' Source->Destination then only a target role is expected, while for Bi-Directional',
                        ' direction source and a target roles are expected.'),
                        'The connector direction and roles are out of sync. When
                        the connector direction is Source->Destination then only a target role is expected,
                while for Bi-Directional direction source and a target roles are expected.',
                path($connector),
                        'connector-direction-24'
                        )"
            />
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <xsl:sequence
                select="
                    if (not($missingTargetRole) and not($missingSourceRole)) then
                        ()
                    else
                        f:generateErrorMessage(fn:concat('The connector direction and roles are out of sync.',
                        ' The connector direction and roles are out of sync. When the connector direction is',
                        ' Source->Destination then only a target role is expected, while for Bi-Directional',
                        ' direction source and a target roles are expected.'),
                        'The connector direction and roles are out of sync. When
                        the connector direction is Source->Destination then only a target role is expected,
                        while for Bi-Directional direction source and a target roles are expected.',
                        path($connector),
                        'connector-direction-24'
                        )"
            />
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-name-25] - The name $value$ is not unique. The Connector role names can be reused within the model,
            but only as connector role names on the same type of connector. I.e. the  name of 
            (dependecy and association) connector roles should not be reused as the name of 
            elements  (Class, Datatype, Enumeration, Object) or attributes. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="connectorUniqueName">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRole" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRole" select="$connector/target/role/@name"/>

        <xsl:if test="boolean($sourceRole)">
            <xsl:variable name="elementsFound"
                select="f:getElementByName($sourceRole, root($connector))"/>
            <xsl:variable name="attributesFound"
                select="f:getAttributeByName($sourceRole, root($connector))"/>

            <xsl:sequence
                select="
                    if (count($elementsFound) > 0 or count($attributesFound) > 0) then
                        f:generateErrorMessage(fn:concat('The connector source role name ', $sourceRole, ' is not unique.',
                        'The Connector role names can be reused within the model, but only as connector role names on the same type of connector.', 
                        'I.e. the  name of (dependecy and association) connector roles should not be reused as the name of elements  (Class, Datatype, Enumeration, Object) or attributes.'),
                        'The name $value$ is not unique. The Connector role names can be reused within the model,
                        but only as connector role names on the same type of connector. I.e. the  name of 
                        (dependecy and association) connector roles should not be reused as the name of 
                        elements  (Class, Datatype, Enumeration, Object) or attributes.',
                        path($connector),
                        'connector-name-25'
                        )
                    else
                        ()
                    
                    "
            />
        </xsl:if>
        <xsl:if test="boolean($targetRole)">
            <xsl:variable name="elementsFound"
                select="f:getElementByName($targetRole, root($connector))"/>
            <xsl:variable name="attributesFound"
                select="f:getAttributeByName($targetRole, root($connector))"/>

            <xsl:sequence
                select="
                    if (count($elementsFound) > 0 or count($attributesFound) > 0) then
                        f:generateErrorMessage(fn:concat('The connector target role name ', $targetRole, ' is not unique.',
                        'The Connector role names can be reused within the model, but only as connector role names on the same type of connector.', 
                        'I.e. the  name of (dependecy and association) connector roles should not be reused as the name of elements  (Class, Datatype, Enumeration, Object) or attributes.'),
                        'The name $value$ is not unique. The Connector role names can be reused within the model,
                        but only as connector role names on the same type of connector. I.e. the  name of 
                        (dependecy and association) connector roles should not be reused as the name of 
                        elements  (Class, Datatype, Enumeration, Object) or attributes.',
                        path($connector),
                        'connector-name-25'
                        )
                    else
                        ()
                    
                    "
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[connector-name-26] - The name $value$ is not unique. The Connector role names can be reused within the model, 
            but only as connector role names on the same type of connector. 
            I.e. the  name of a dependecy role should not be reused as the name of association role, 
            and the name of association role should not be reused as the  name of a dependecy role.
          </xd:desc>
        <xd:param name="connector"/>
        <xd:param name="isDependency"/>
    </xd:doc>
    <xsl:template name="connectorRoleCrossTypeReuseCheck">
        <xsl:param name="isDependency"/>
        <xsl:param name="connector"/>
        <xsl:variable name="sourceRole" select="$connector/source/role/@name"/>
        <xsl:variable name="targetRole" select="$connector/target/role/@name"/>


        <xsl:if test="boolean($sourceRole)">
            <xsl:choose>
                <xsl:when test="$isDependency = fn:true()">
                    <xsl:variable name="connectorsFound"
                        select="f:getConnectorByName($sourceRole, root($connector))/properties[@ea_type = 'Association']"/>

                    <xsl:sequence
                        select="
                            if (count($connectorsFound) > 0) then
                            f:generateErrorMessage(fn:concat('The connector source role name ', $sourceRole, ' is not unique.',
                            'The Connector role names can be reused within the model, but only as connector role names on the same type of connector.', 
                            ' I.e. the  name of a dependecy role should not be reused as the name of association role, and the name of association role should not be reused as the  name of a dependecy role.'),
                            'The name $value$ is not unique. The Connector role names can be reused within the model, 
                            but only as connector role names on the same type of connector. 
                            I.e. the  name of a dependecy role should not be reused as the name of association role, 
                            and the name of association role should not be reused as the  name of a dependecy role.',
                            path($connector),
                            'connector-name-26'
                            )
                            else
                                ()
                            
                            "
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="connectorsFound"
                        select="f:getConnectorByName($sourceRole, root($connector))/properties[@ea_type = 'Dependency']"/>

                    <xsl:sequence
                        select="
                            if (count($connectorsFound) > 0) then
                            f:generateErrorMessage(fn:concat('The connector source role name ', $sourceRole, ' is not unique.',
                            'The Connector role names can be reused within the model, but only as connector role names on the same type of connector.', 
                            ' I.e. the  name of a dependecy role should not be reused as the name of association role, and the name of association role should not be reused as the  name of a dependecy role.'),
                            'The name $value$ is not unique. The Connector role names can be reused within the model, 
                            but only as connector role names on the same type of connector. 
                            I.e. the  name of a dependecy role should not be reused as the name of association role, 
                            and the name of association role should not be reused as the  name of a dependecy role.',
                            path($connector),
                            'connector-name-26'
                            )
                            else
                                ()
                            
                            "
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="boolean($targetRole)">
            <xsl:choose>
                <xsl:when test="$isDependency = fn:true()">
                    <xsl:variable name="connectorsFound"
                        select="f:getConnectorByName($targetRole, root($connector))/properties[@ea_type = 'Association']"/>

                    <xsl:sequence
                        select="
                            if (count($connectorsFound) > 0) then
                            f:generateErrorMessage(fn:concat('The connector source role name ', $targetRole, ' is not unique.',
                            'The Connector role names can be reused within the model, but only as connector role names on the same type of connector.', 
                            ' I.e. the  name of a dependecy role should not be reused as the name of association role, and the name of association role should not be reused as the  name of a dependecy role.'),
                            'The name $value$ is not unique. The Connector role names can be reused within the model, 
                            but only as connector role names on the same type of connector. 
                            I.e. the  name of a dependecy role should not be reused as the name of association role, 
                            and the name of association role should not be reused as the  name of a dependecy role.',
                            path($connector),
                            'connector-name-26'
                            )
                            else
                                ()
                            
                            "
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="connectorsFound"
                        select="f:getConnectorByName($targetRole, root($connector))/properties[@ea_type = 'Dependency']"/>

                    <xsl:sequence
                        select="
                            if (count($connectorsFound) > 0) then
                            f:generateErrorMessage(fn:concat('The connector source role name ', $targetRole, ' is not unique.',
                            'The Connector role names can be reused within the model, but only as connector role names on the same type of connector.', 
                            ' I.e. the  name of a dependecy role should not be reused as the name of association role, and the name of association role should not be reused as the  name of a dependecy role.'),
                            'The name $value$ is not unique. The Connector role names can be reused within the model, 
                            but only as connector role names on the same type of connector. 
                            I.e. the  name of a dependecy role should not be reused as the name of association role, 
                            and the name of association role should not be reused as the  name of a dependecy role.',
                            path($connector),
                            'connector-name-26'
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