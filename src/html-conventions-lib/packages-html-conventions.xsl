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
        <xd:desc>Getting all packages and show only the ones that have unmet conventions
            [package-name-43] [package-name-46]</xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Package']">
        <xsl:variable name="packageChecks" as="item()*">
            <xsl:call-template name="p-invalidName">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
            <xsl:call-template name="p-missingDescription">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
            <xsl:call-template name="p-stereotypeProvided">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
            <xsl:call-template name="p-missingName">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($packageChecks)">
            <dl>
                <dt>
                    <xsl:call-template name="getPackageName">
                        <xsl:with-param name="package" select="."/>
                    </xsl:call-template>
                </dt>
                <xsl:copy-of select="$packageChecks"/>
            </dl>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Getting the package name</xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    <xsl:template name="getPackageName">
        <xsl:param name="package"/>
        <xsl:variable name="packageName" select="$package/@name"/>
        <xsl:choose>
            <xsl:when test="$package/not(@name) = fn:true()">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$packageName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc>[package-name-43] - The package name $packageName$ contains invalid characters.
            Package name shall be a short alphanumeric string representing an acronym or a short
            name. Spaces are not premitted as packages could be used as namespace
            perfixes.</xd:desc>
        <xd:param name="package"/>
    </xd:doc>

    <xsl:template name="p-invalidName">
        <xsl:param name="package"/>
        <xsl:variable name="packageName" select="$package/@name"/>
        <xsl:if test="boolean($packageName)">
            <xsl:sequence
                select="
                    if (fn:matches($packageName, '^[\w\d]+$')) then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The package name ', $packageName, 'contains invalid characters. Package name shall be a short ',
                        'alphanumeric string representing an acronym or a short name. ',
                        'Spaces are not premitted as packages could be used as namespace perfixes.'))"
            />
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-description-9] - $elementName$ is missing a description. All concepts
            should be defined or described.</xd:desc>
        <xd:param name="package"/>
    </xd:doc>

    <xsl:template name="p-missingDescription">
        <xsl:param name="package"/>
        <xsl:variable name="packageName" select="$package/@name"/>
        <xsl:variable name="noPackageDescription" select="$package/properties/not(@documentation)"/>
        <xsl:sequence
            select="
                if ($noPackageDescription = fn:true()) then
                    f:generateHtmlWarning(fn:concat($packageName, ' is missing a description. All concepts should be defined or described.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-stereotype-10] - The $stereotypeName$ stareotype is applied to
            $elementName$. Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    <xsl:template name="p-stereotypeProvided">
        <xsl:param name="package"/>
        <xsl:sequence
            select="
                if (f:isElementStereotypeValid($package))
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The ', $package/properties/@stereotype,
                    ' stareotype is applied to ', $package/@name,
                    '. Stereotypes are discouraged in the current practice with some exceptions. '))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[package-name-46] - The name of the package $IdRef$ is missing.  Packages must be named".</xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    <xsl:template name="p-missingName">
        <xsl:param name="package"/>
        <xsl:sequence
            select="
            if (f:isElementNameMissing($package)) then
            f:generateHtmlError(fn:concat('The name of the package ', $package/@xmi:idref,
            ' is missing.  Packages must be named.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>Return warning when a package is empty - NOT YET IMPLEMENTED</xd:desc>
        <xd:param name="package"/>
    </xd:doc>

</xsl:stylesheet>