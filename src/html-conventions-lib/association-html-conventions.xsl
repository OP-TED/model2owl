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
        <xd:desc>Getting all associations and show only the ones that have unmet conventions</xd:desc>
    </xd:doc>
    
    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        <xsl:variable name="associationChecks" as="item()*">
            <xsl:call-template name="associationNameChecker">
                <xsl:with-param name="associationConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="associationDirectionChecker">
                <xsl:with-param name="associationConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="associationRoleChecker">
                <xsl:with-param name="associationConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="associationDescriptionChecker">
                <xsl:with-param name="associationConnector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="associationMultiplicityChecker">
                <xsl:with-param name="associationConnector" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($associationChecks)">
        <dl>
            <dt>
                <xsl:value-of select="f:getConnectorName(.)"/>
               <!-- Association ID: <xsl:value-of select="@xmi:idref"/>-->
            </dt>
            <xsl:copy-of select="$associationChecks"/>
        </dl>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Association has a name</xd:desc>
        <xd:param name="associationConnector"/>
    </xd:doc>
    <xsl:template name="associationNameChecker">
        <xsl:param name="associationConnector"/>
        <xsl:variable name="associationHasNoName" select="$associationConnector/not(@name)"/>
        <xsl:if test="$associationHasNoName = fn:false()">
            <xsl:sequence select="f:generateHtmlWarning('An association should not have a name. Please remove the name')"/>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Association has a different direction than Source -> Destination or Bi-Directional</xd:desc>
        <xd:param name="associationConnector"/>
    </xd:doc>
    <xsl:template name="associationDirectionChecker">
        <xsl:param name="associationConnector"/>
        <xsl:variable name="associationDirection" select="f:getAssociationDirection($associationConnector)"/>
        <xsl:if test="$associationDirection != 'Source -&gt; Destination' and $associationDirection != 'Bi-Directional'">
            <xsl:sequence select="f:generateHtmlWarning(fn:concat($associationDirection, ' is not a valid direction for an association. Please rectify this'))"/>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Association has no description</xd:desc>
        <xd:param name="associationConnector"/>
    </xd:doc>
    <xsl:template name="associationDescriptionChecker">
        <xsl:param name="associationConnector"/>
        <xsl:variable name="associationHasNoDescription" select="$associationConnector/documentation/not(@value)"/>
        <xsl:if test="$associationHasNoDescription = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning('This association has no description. Please add one')"/>
        </xsl:if>
    </xsl:template>
    
    
    
    <xd:doc>
        <xd:desc>Get association direction</xd:desc>
        <xd:param name="associationConnector"/>
    </xd:doc>
    <xsl:function name="f:getAssociationDirection">
        <xsl:param name="associationConnector"/>
        <xsl:value-of select="$associationConnector/properties/@direction"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Return a warning if the Association multiplicity in target is different than 1, digit..digit or digit..*</xd:desc>
        <xd:param name="associationConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:multiplicityTargetValueChecker">
        <xsl:param name="associationConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:variable name="associationMultiplicityValue" select="$associationConnector/target/type/@multiplicity"/>
        <xsl:variable name="notMultiplicityAttribute" select="$associationConnector/target/type/not(@multiplicity)"/>
        <xsl:if test="$associationMultiplicityValue != '1' 
            and not(fn:matches($associationMultiplicityValue, '^[0-9]..[0-9]$'))
            and not(fn:matches($associationMultiplicityValue, '^[0-9]..\*$'))">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
        <xsl:if test="$notMultiplicityAttribute = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Association multiplicity in source is different than 1, digit..digit or digit..*</xd:desc>
        <xd:param name="associationConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:multiplicitySourceValueChecker">
        <xsl:param name="associationConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:variable name="associationMultiplicityValue" select="$associationConnector/source/type/@multiplicity"/>
        <xsl:variable name="notMultiplicityAttribute" select="$associationConnector/source/type/not(@multiplicity)"/>
        <xsl:if test="$associationMultiplicityValue != '1' 
            and not(fn:matches($associationMultiplicityValue, '^[0-9]..[0-9]$'))
            and not(fn:matches($associationMultiplicityValue, '^[0-9]..\*$'))">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
        <xsl:if test="$notMultiplicityAttribute = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Return a warning if the Association has no role in target </xd:desc>
        <xd:param name="associationConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:associationTargetRoleChecker">
        <xsl:param name="associationConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:if test="$associationConnector/target/role/not(@name)">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Return a warning if the Association has no role in source </xd:desc>
        <xd:param name="associationConnector"/>
        <xd:param name="warningText"/>
    </xd:doc>
    <xsl:function name="f:associationSourceRoleChecker">
        <xsl:param name="associationConnector"/>
        <xsl:param name="warningText"/> 
        <xsl:if test="$associationConnector/source/role/not(@name)">
            <xsl:sequence select="f:generateHtmlWarning($warningText)"/>
        </xsl:if>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Return warning for an incorrect value for multiplicity</xd:desc>
        <xd:param name="associationConnector"/>
    </xd:doc>
    
    <xsl:template name="associationMultiplicityChecker">
        <xsl:param name="associationConnector"/>
            <xsl:if test="f:getAssociationDirection($associationConnector) = 'Source -&gt; Destination'">
                <xsl:sequence select="f:multiplicityTargetValueChecker($associationConnector, 'The multiplicity value from target is wrong. Please rectify this')"/>
            </xsl:if>
        <xsl:if test="f:getAssociationDirection($associationConnector) = 'Bi-Directional'">
            <xsl:sequence select="f:multiplicityTargetValueChecker($associationConnector, 'The multiplicity value from target is wrong. Please rectify this')"/>
            <xsl:sequence select="f:multiplicitySourceValueChecker($associationConnector, 'The multiplicity value from source is wrong. Please rectify this')"/>
             </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning if it has no role</xd:desc>
        <xd:param name="associationConnector"/>
    </xd:doc>
    
    <xsl:template name="associationRoleChecker">
        <xsl:param name="associationConnector"/>
        <xsl:if test="f:getAssociationDirection($associationConnector) = 'Source -&gt; Destination'">
            <xsl:sequence select="f:associationTargetRoleChecker($associationConnector,'The target role is missing')"/>
        </xsl:if>
        <xsl:if test="f:getAssociationDirection($associationConnector) = 'Bi-Directional'">
            <xsl:sequence select="f:associationSourceRoleChecker($associationConnector, 'The target role is missing')"/>
            <xsl:sequence select="f:associationSourceRoleChecker($associationConnector, 'The source role is missing')"/>
        </xsl:if>
    </xsl:template>
    
    
</xsl:stylesheet>