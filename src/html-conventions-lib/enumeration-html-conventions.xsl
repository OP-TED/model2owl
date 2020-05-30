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
        <xd:desc>Getting all enumerations and items and show only the ones with unmet
            conventions [enumeration-name-59]</xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">
        <xsl:variable name="enumeration">
            <xsl:call-template name="getEnumerationName">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="enumerationConventions" as="item()*">
            <xsl:call-template name="e-missingDescription">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-itemsChecker">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-stereotypeProvided">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-missingName">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-missingNamePrefix">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-missingLocalSegmentName">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-invalidNamePrefix">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-invalidNameLocalSegment">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-invalidFirstCharacterInLocalSegment">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-delimitersInTheLocalSegment">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-uniqueName">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-undefinedPrefix">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-namingFormat">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
            <xsl:call-template name="e-enumerationIsNotPascalNamed">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="enumerationItemConventions" as="item()*">
            <xsl:apply-templates select="attributes/attribute"/>
        </xsl:variable>
        <xsl:if test="boolean($enumerationConventions) or boolean($enumerationItemConventions)">
            <h2>
                <xsl:value-of select="$enumeration"/>
            </h2>
            <section>
                <xsl:if test="boolean($enumerationConventions)">
                    <dl>
                        <dt>Unmet enumeration conventions</dt>
                        <xsl:copy-of select="$enumerationConventions"/>
                    </dl>
                </xsl:if>
                <xsl:if test="boolean($enumerationItemConventions)">
                    <xsl:copy-of select="$enumerationItemConventions"/>
                </xsl:if>
            </section>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Getting the enumeration name</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="getEnumerationName">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:choose>
            <xsl:when test="$enumeration/not(@name) = fn:true()">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$enumerationName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc>Return warning when an Enumeration doesn't have items </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>

    <xsl:template name="e-itemsChecker">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationNumberOfAttributes"
            select="count($enumeration/attributes/attribute)"/>
        <xsl:if test="$enumerationNumberOfAttributes = 0">
            <xsl:sequence select="f:generateHtmlWarning('This enumeration has no items')"/>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-description-9] - $elementName$ is missing a description. All concepts
            should be defined or described.</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>

    <xsl:template name="e-missingDescription">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:variable name="noEnumerationDescription"
            select="$enumeration/properties/not(@documentation)"/>
        <xsl:sequence
            select="
                if ($noEnumerationDescription = fn:true()) then
                    f:generateHtmlInfo(fn:concat($enumerationName, ' is missing a description. All concepts should be defined or described.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-stereotype-10] - The $stereotypeName$ stareotype is applied to
            $elementName$. Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-stereotypeProvided">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isElementStereotypeValid($enumeration))
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The ', $enumeration/properties/@stereotype,
                    ' stareotype is applied to ', $enumeration/@name,
                    '. Stereotypes are discouraged in the current practice with some exceptions. '))"
        />
    </xsl:template>
   
    <xd:doc>
        <xd:desc>[common-name-1] - The name of the element $IdRef$ is missing. Please provide one
            respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-missingName">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isElementNameMissing($enumeration)) then
                    f:generateHtmlError(fn:concat('The name of the element ', $enumeration/@xmi:idref,
                    ' is missing. Please provide one respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-2] - The name of element $elementName$ is missing a prefix. The name
            should comprise a prefix respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-missingNamePrefix">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isElementNamePrefixMissing($enumeration)) then
                    f:generateHtmlWarning(fn:concat('The name of element ', $enumeration/@name,
                    ' is missing a prefix. The name should comprise a prefix respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-3] - The name of $elementName$ is missing a local segment. Please
            provide one respecing the syntax "prefix:localSegment".".</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-missingLocalSegmentName">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isElementNameLocalSegmentMissing($enumeration)) then
                    f:generateHtmlError(fn:concat('The name of element ', $enumeration/@name,
                    ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-4] - The name prefix is invalid in $value$. Please provide a short
            prefix name containing only alphanumeric characters [a-zA-Z0-9]+.</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-invalidNamePrefix">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isInvalidNamePrefix($enumeration)) then
                    f:generateHtmlError(fn:concat('The name prefix ', fn:substring-before($enumeration/@name, ':'),
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
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-invalidNameLocalSegment">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isInvalidLocalSegmentName($enumeration)) then
                    f:generateHtmlError(fn:concat('The local name segment ', fn:substring-after($enumeration/@name, ':'),
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
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-invalidFirstCharacterInLocalSegment">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isValidFirstCharacterInLocalSegment($enumeration)) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The local name segment ', f:getLocalSegmentForElements($enumeration),
                    ' starts with an invalid character. The local segment ',
                    'must start with a letter or underscore.'))"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-7] - The local name segment $value$ contains token delimiters. It is
            best if the names are camel cased and delimiters removed. </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-delimitersInTheLocalSegment">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
                if (f:isDelimitersInLocalSegment($enumeration)) then
                    f:generateHtmlWarning(fn:concat('The local name segment ', f:getLocalSegmentForElements($enumeration),
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
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="e-uniqueName">
        <xsl:param name="enumeration"/>
        <xsl:if test="boolean($enumeration/@name)">
            <xsl:variable name="elementsFound"
                select="f:getElementByName($enumeration/@name, root($enumeration))"/>
            <xsl:variable name="connectorsFound"
                select="f:getConnectorByName($enumeration/@name, root($enumeration))"/>
            <xsl:sequence
                select="
                    if (count($elementsFound) > 1 or count($connectorsFound) > 0) then
                        f:generateHtmlError(fn:concat('The name ', $enumeration/@name, ' is not unique. The Concept names ',
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
        <xd:param name="enumeration"/>
    </xd:doc>

    <xsl:template name="e-undefinedPrefix">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:if test="not(f:isValidNamespace($enumerationName))">
            <xsl:sequence
                select="
                    f:generateHtmlWarning(fn:concat('The prefix ', fn:substring-before($enumerationName, ':'),
                    ' is not defined. A prefix must be associated to a namespace URI.'))"
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-58] - The name $elementName$ does not match the pattern. The name
            should respect the syntax "prefix:localSegment" (similar to the XML QName).</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>

    <xsl:template name="e-namingFormat">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:if test="f:isValidQname($enumerationName) = fn:false()">
            <xsl:sequence
                select="
                    f:generateHtmlWarning(fn:concat('The name ', $enumerationName, ' does not match the pattern. ',
                    'The name should respect the syntax prefix:localSegment (similar to the XML QName).'))"
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[enumeration-name-59] - The enumeration name $value$ is invalid. The enumeration
            name must start with a capital case. </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>

    <xsl:template name="e-enumerationIsNotPascalNamed">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:sequence
            select="
                if (f:isValidQname($enumerationName))
                then
                    if (f:isQNameUpperCasedCamelCase($enumerationName) = fn:false())
                    then
                        f:generateHtmlWarning(fn:concat('The class name ', $enumerationName, ' is invalid. The class name must start with a capital case.'))
                    else
                        ()
                else
                    if (fn:contains($uppercaseLetters, fn:substring($enumerationName, 1, 1)))
                    then
                        ()
                    else
                        f:generateHtmlWarning(fn:concat('The class name ', $enumerationName, ' is invalid. The class name must start with a capital case.'))"
        />
    </xsl:template>
</xsl:stylesheet>