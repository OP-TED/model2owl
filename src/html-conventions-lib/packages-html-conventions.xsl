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
        <xd:desc>Getting all packages and show only the ones that have unmet conventions</xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Package']">
        <xsl:variable name="packageChecks" as="item()*">
            <xsl:call-template name="packageInvalidName">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
            <xsl:call-template name="packageMissingName">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
            <xsl:call-template name="packageEmpty">
                <xsl:with-param name="package" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($packageChecks)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2>
                        <xsl:call-template name="getPackageName">
                            <xsl:with-param name="package" select="."/>
                        </xsl:call-template>
                    </h2>
                    <dl>
                        <dt> Unmet package conventions </dt>
                        <xsl:copy-of select="$packageChecks"/>
                    </dl>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$packageChecks"/>
                </xsl:otherwise>
            </xsl:choose>
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
            <xsl:when test="$package/not(@name) = fn:true() or $package/@name = ''">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$packageName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc>[package-name-1] - The package name $packageName$ contains invalid characters.
            Package name shall be a short alphanumeric string representing an acronym or a short
            name. </xd:desc>
        <xd:param name="package"/>
    </xd:doc>

    <xsl:template name="packageInvalidName">
        <xsl:param name="package"/>
        <xsl:variable name="packageName" select="$package/@name"/>
        <xsl:if test="boolean($packageName)">
            <xsl:sequence
                select="
                if (fn:matches($packageName, '^[a-zA-Z0-9 ]*$')) then
                        ()
                    else
                        f:generateWarningMessage(fn:concat('The package name ', $packageName, ' contains invalid characters. Package name shall be a short ',
                        'alphanumeric string representing an acronym or a short name.'),
                        'The package name $packageName$ contains invalid characters.
                        Package name shall be a short alphanumeric string representing an acronym or a short
                        name.',
                        'elements/element[@xmi:type = uml:Package]',
                        'package-name-1'
                        )"
            />
        </xsl:if>
    </xsl:template>

   

    <xd:doc>
        <xd:desc>[package-name-2] - The name of the package $IdRef$ is missing.  Packages must be named.</xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    <xsl:template name="packageMissingName">
        <xsl:param name="package"/>
        <xsl:sequence
            select="
            if (f:isElementNameMissing($package)) then
            f:generateErrorMessage(fn:concat('The name of the package ', $package/@xmi:idref,
            ' is missing.  Packages must be named.'),
            'The name of the package $IdRef$ is missing.  Packages must be named.',
            'elements/element[@xmi:type = uml:Package]',
            'package-name-2'
            )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[package-owned-elements-3] - The package $packageName$ is empty.
            Packages must contain child classes and conenctors (i.e. owned elements). </xd:desc>
        <xd:param name="package"/>
    </xd:doc>
    <xsl:template name="packageEmpty">
        <xsl:param name="package"/>
        <xsl:sequence
            select="
                if (count(f:getPackageElements($package)) > 0) then
                    ()
                else
                f:generateWarningMessage(fn:concat('The package ',$package/@name ,' is empty. Packages must contain child classes and conenctors (i.e. owned elements).'),
                'The package $packageName$ is empty.
                Packages must contain child classes and conenctors (i.e. owned elements).',
                'elements/element[@xmi:type = uml:Package]',
                'package-owned-elements-3'
                )"
        />
    </xsl:template>

</xsl:stylesheet>