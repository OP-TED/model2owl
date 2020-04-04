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
        <xd:desc>Getting all Dependencies and returning a warning for all unmet conventions  </xd:desc>
    </xd:doc>
    
    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <dl>
            <dt>
                Dependency ID: <xsl:value-of select="@xmi:idref"/>
            </dt>
            <xsl:call-template name="dependencyNameChecker">
                <xsl:with-param name="dependencyConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="dependencyDirectionChecker">
                <xsl:with-param name="dependencyConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="dependencyRoleChecker">
                <xsl:with-param name="dependencyConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="dependencyDescriptionChecker">
                <xsl:with-param name="dependencyConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="dependencyMultiplicityChecker">
                <xsl:with-param name="dependencyConnector" select="."/>
            </xsl:call-template>
        </dl>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Dependency has a name</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    <xsl:template name="dependencyNameChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="dependencyHasNoName" select="$dependencyConnector/not(@name)"/>
        <xsl:if test="$dependencyHasNoName = fn:false()">
            <xsl:sequence select="f:generateHtmlWarning('An dependency should not have a name. Please remove the name')"/>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Dependency has a different direction than Source -> Destination or Bi-Directional</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    <xsl:template name="dependencyDirectionChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="dependencyDirection" select="f:getDependencyDirection($dependencyConnector)"/>
        <xsl:if test="$dependencyDirection != 'Source -&gt; Destination' and $dependencyDirection != 'Bi-Directional'">
            <xsl:sequence select="f:generateHtmlWarning(fn:concat($dependencyDirection, ' is not a valid direction for an dependency. Please rectify this'))"/>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Dependency has no description</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    <xsl:template name="dependencyDescriptionChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="dependencyHasNoDescription" select="$dependencyConnector/documentation/not(@value)"/>
        <xsl:if test="$dependencyHasNoDescription = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning('This dependency has no description. Please add one')"/>
        </xsl:if>
    </xsl:template>
    
    
    
    <xd:doc>
        <xd:desc>Get dependency direction</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    <xsl:function name="f:getDependencyDirection">
        <xsl:param name="dependencyConnector"/>
        <xsl:value-of select="$dependencyConnector/properties/@direction"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Return a warning if the Dependency multiplicity in target is different than 1, digit..digit or digit..*</xd:desc>
        <xd:param name="dependencyConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:multiplicityTargetValueChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:variable name="dependencyMultiplicityValue" select="$dependencyConnector/target/type/@multiplicity"/>
        <xsl:variable name="notMultiplicityAttribute" select="$dependencyConnector/target/type/not(@multiplicity)"/>
        <xsl:if test="$dependencyMultiplicityValue != '1' 
            and not(fn:matches($dependencyMultiplicityValue, '^[0-9]..[0-9]$'))
            and not(fn:matches($dependencyMultiplicityValue, '^[0-9]..\*$'))">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
        <xsl:if test="$notMultiplicityAttribute = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Dependency multiplicity in source is different than 1, digit..digit or digit..*</xd:desc>
        <xd:param name="dependencyConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:multiplicitySourceValueChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:variable name="dependencyMultiplicityValue" select="$dependencyConnector/source/type/@multiplicity"/>
        <xsl:variable name="notMultiplicityAttribute" select="$dependencyConnector/source/type/not(@multiplicity)"/>
        <xsl:if test="$dependencyMultiplicityValue != '1' 
            and not(fn:matches($dependencyMultiplicityValue, '^[0-9]..[0-9]$'))
            and not(fn:matches($dependencyMultiplicityValue, '^[0-9]..\*$'))">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
        <xsl:if test="$notMultiplicityAttribute = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Dependency has no role in target </xd:desc>
        <xd:param name="dependencyConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:dependencyTargetRoleChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:if test="$dependencyConnector/target/role/not(@name)">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Return a warning if the Dependency has no role in source </xd:desc>
        <xd:param name="dependencyConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:dependencySourceRoleChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:if test="$dependencyConnector/source/role/not(@name)">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Return warning for an incorrect value for multiplicity</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    
    <xsl:template name="dependencyMultiplicityChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:if test="f:getDependencyDirection($dependencyConnector) = 'Source -&gt; Destination'">
            <xsl:sequence select="f:multiplicityTargetValueChecker($dependencyConnector, 'The multiplicity value from target is wrong. Please rectify this')"/>
        </xsl:if>
        <xsl:if test="f:getDependencyDirection($dependencyConnector) = 'Bi-Directional'">
            <xsl:sequence select="f:multiplicityTargetValueChecker($dependencyConnector, 'The multiplicity value from target is wrong. Please rectify this')"/>
            <xsl:sequence select="f:multiplicitySourceValueChecker($dependencyConnector, 'The multiplicity value from source is wrong. Please rectify this')"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning if it has no role</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    
    <xsl:template name="dependencyRoleChecker">
        <xsl:param name="dependencyConnector"/>
        <xsl:if test="f:getDependencyDirection($dependencyConnector) = 'Source -&gt; Destination'">
            <xsl:sequence select="f:dependencyTargetRoleChecker($dependencyConnector,'The target role is missing')"/>
        </xsl:if>
        <xsl:if test="f:getDependencyDirection($dependencyConnector) = 'Bi-Directional'">
            <xsl:sequence select="f:dependencySourceRoleChecker($dependencyConnector, 'The target role is missing')"/>
            <xsl:sequence select="f:dependencySourceRoleChecker($dependencyConnector, 'The source role is missing')"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>