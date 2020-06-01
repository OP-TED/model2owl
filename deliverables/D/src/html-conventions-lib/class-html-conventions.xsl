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
        <xd:desc>Getting all classes and attributes and show only the ones with unmet conventions
            [class->common-name-11] [class->common-description-12] [class->common-stereotype-13]
        </xd:desc>
    </xd:doc>



    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:variable name="class">
            <xsl:call-template name="getClassName">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="classConventions" as="item()*">
            <xsl:call-template name="c-missingName">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-missingNamePrefix">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-missingLocalSegmentName">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-invalidFirstCharacterInLocalSegment">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-invalidNamePrefix">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-invalidNameLocalSegment">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-delimitersInTheLocalSegment">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-uniqueName">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-stereotypeProvided">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-classIsNotPascalNamed">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-underspecifiedClass">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-disconnectedClass">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-missingDescription">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-namingFormat">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="c-undefinedPrefix">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>

        </xsl:variable>
        <xsl:variable name="classAttributeConventions" as="item()*">
            <xsl:apply-templates select="attributes/attribute"/>
        </xsl:variable>
        <xsl:if test="boolean($classConventions) or boolean($classAttributeConventions)">
            <h2>
                <xsl:value-of select="$class"/>
            </h2>
            <section>
                <xsl:if test="boolean($classConventions)">
                    <dl>
                        <dt>Unmet class conventions</dt>
                        <xsl:copy-of select="$classConventions"/>
                    </dl>
                </xsl:if>
                <xsl:if test="boolean($classAttributeConventions)">
                    <xsl:copy-of select="$classAttributeConventions"/>
                </xsl:if>
            </section>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Getting the class name</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="getClassName">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:choose>
            <xsl:when test="$class/not(@name) = fn:true() or $class/@name = ''">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$className"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>[class-connectors-16] - The class $className$ is not connected to anything. A class
            should be connected to otehr elements.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="c-disconnectedClass">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (boolean(f:getOutgoingConnectors($class)) or boolean(f:getIncommingConnectors($class)))
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The class ', $class/@name,
                    ' is not connected to anything. A class should be connected to other elements.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-description-9] - $elementName$ is missing a description. All concepts
            should be defined or described.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="c-missingDescription">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:variable name="noClassDescription" select="$class/properties/not(@documentation)"/>
        <xsl:sequence
            select="
                if ($noClassDescription = fn:true()) then
                    f:generateHtmlWarning(fn:concat($className, ' is missing a description. All concepts should be defined or described.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[class-attributes-15] - The class $className$ nas no attributes provided. A class
            should define some attributes.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="c-underspecifiedClass">
        <xsl:param name="class"/>
        <xsl:variable name="classNumberOfAttributes" select="count($class/attributes/attribute)"/>
        <xsl:sequence
            select="
                if ($classNumberOfAttributes = 0) then
                    f:generateHtmlWarning(fn:concat('The class ', $class/@name, ' has no attributes provided. A class should define some attributes.'))
                else
                    ()"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[class-name-14] - The class name $value$ is invalid. The class name must start with
            a capital case. </xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="c-classIsNotPascalNamed">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:sequence
            select="
                if (f:isValidQname($className))
                then
                    if (f:isQNameUpperCasedCamelCase($className) = fn:false())
                    then
                        f:generateHtmlWarning(fn:concat('The class name ', $className, ' is invalid. The class name must start with a capital case.'))
                    else
                        ()
                else
                    if (fn:contains($uppercaseLetters, fn:substring($className, 1, 1)))
                    then
                        ()
                    else
                        f:generateHtmlWarning(fn:concat('The class name ', $className, ' is invalid. The class name must start with a capital case.'))"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-stereotype-10] - The $stereotypeName$ stareotype is applied to
            $elementName$. Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-stereotypeProvided">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isElementStereotypeValid($class))
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The ', $class/properties/@stereotype,
                    ' stareotype is applied to ', $class/@name,
                    '. Stereotypes are discouraged in the current practice with some exceptions. '))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-57]-The prefix $value$ is not defined. A prefix must be associated to
            a namespace URI. </xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="c-undefinedPrefix">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:if test="not(f:isValidNamespace($className))">
            <xsl:sequence
                select="
                    f:generateHtmlWarning(fn:concat('The prefix ', fn:substring-before($className, ':'),
                    ' is not defined. A prefix must be associated to a namespace URI.'))"
            />
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-58] - The name $elementName$ does not match the pattern. The name
            should respect the syntax "prefix:localSegment" (similar to the XML QName).</xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="c-namingFormat">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:if test="f:isValidQname($className) = fn:false()">
            <xsl:sequence
                select="
                    f:generateHtmlWarning(fn:concat('The name ', $className, ' does not match the pattern. ',
                    'The name should respect the syntax prefix:localSegment (similar to the XML QName).'))"
            />
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>[common-name-1] - The name of the element $IdRef$ is missing. Please provide one
            respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-missingName">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isElementNameMissing($class)) then
                    f:generateHtmlError(fn:concat('The name of the element ', $class/@xmi:idref,
                    ' is missing. Please provide one respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-2] - The name of element $elementName$ is missing a prefix. The name
            should comprise a prefix respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-missingNamePrefix">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isElementNamePrefixMissing($class)) then
                    f:generateHtmlWarning(fn:concat('The name of element ', $class/@name,
                    ' is missing a prefix. The name should comprise a prefix respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-3] - The name of $elementName$ is missing a local segment. Please
            provide one respecing the syntax "prefix:localSegment".".</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-missingLocalSegmentName">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isElementNameLocalSegmentMissing($class)) then
                    f:generateHtmlError(fn:concat('The name of element ', $class/@name,
                    ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-4] - The name prefix is invalid in $value$. Please provide a short
            prefix name containing only alphanumeric characters [a-zA-Z0-9]+.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-invalidNamePrefix">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isInvalidNamePrefix($class)) then
                    f:generateHtmlError(fn:concat('The name prefix ', fn:substring-before($class/@name, ':'),
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
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-invalidNameLocalSegment">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isInvalidLocalSegmentName($class)) then
                    f:generateHtmlError(fn:concat('The local name segment ', fn:substring-after($class/@name, ':'),
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
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-invalidFirstCharacterInLocalSegment">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isValidFirstCharacterInLocalSegment($class)) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The local name segment ', f:getLocalSegmentForElements($class),
                    ' starts with an invalid character. The local segment ',
                    'must start with a letter or underscore.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-7] - The local name segment $value$ contains token delimiters. It is
            best if the names are camel cased and delimiters removed. </xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-delimitersInTheLocalSegment">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (f:isDelimitersInLocalSegment($class)) then
                    f:generateHtmlWarning(fn:concat('The local name segment ', f:getLocalSegmentForElements($class),
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
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="c-uniqueName">
        <xsl:param name="class"/>
        <xsl:if test="boolean($class/@name)">
            <xsl:variable name="elementsFound"
                select="f:getElementByName($class/@name, root($class))"/>
            <xsl:variable name="connectorsFound"
                select="f:getConnectorByName($class/@name, root($class))"/>
            <xsl:sequence
                select="
                    if (count($elementsFound) > 1 or count($connectorsFound) > 0) then
                        f:generateHtmlError(fn:concat('The name ', $class/@name, ' is not unique. The Concept names ',
                        'should be unique within the model; while the relations may repeat ',
                        'but should not overlap with concept names. '))
                    else
                        ()
                    
                    "
            />
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>