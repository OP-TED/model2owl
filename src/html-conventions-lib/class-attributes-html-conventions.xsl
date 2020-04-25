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
        <xd:desc>Getting all class attributes and show only the ones that have unmet conventions</xd:desc>
    </xd:doc>
    
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute" name="attributes">
        <xsl:variable name="classAttributeChecks" as="item()*">
            <xsl:call-template name="classAttributeNameChecker">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classAttributeNameConventionChecker">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classAttributeNameCaseChecker">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classAttributeTypeChecker">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classAttributeTypeSuggestion">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classAttributeStereotypeChecker">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="boolean($classAttributeChecks)">
            <dl>
                <dt>
                    <xsl:call-template name="getClassAttributeName">
                        <xsl:with-param name="classAttribute" select="."/>
                    </xsl:call-template>
                </dt>
                <xsl:copy-of select="$classAttributeChecks"/>
            </dl>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Getting the class attribute name</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="getClassAttributeName">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="attributeName" select="$classAttribute/@name"/>
        <xsl:choose>
            <xsl:when test="$classAttribute/not(@name) = fn:true()">
                <xsl:value-of >No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$attributeName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when class attribute is missing the name</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="classAttributeNameChecker">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="noClassAttributeName" select="$classAttribute/not(@name)"/>
        <xsl:variable name="attributeId" select="$classAttribute/@xmi:idref"/>
        <xsl:if test="$noClassAttributeName = fn:true()">
            <xsl:sequence select="f:generateHtmlWarning(fn:concat('There is an attribute without a name.Here is the attribute id: ', $attributeId))"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when class attribute name is not a valid Qname</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="classAttributeNameConventionChecker">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:if test="f:isValidQname($classAttributeName) = fn:false()">
            <xsl:sequence select="f:generateHtmlWarning('Class attribute name is not a valid Qname. Please change')"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when class attribute Qname is not starting with lower-case letter </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="classAttributeNameCaseChecker">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:if test="not(f:isQNameLowerCasedCamelCase($classAttributeName))">
            <xsl:sequence select="f:generateHtmlWarning('The first letter of the local segment from the Qname is not lower-cased.')"/>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return warning when class attribute type is not correct </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="classAttributeTypeChecker">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:sequence
            select="
                if (f:isAttributeTypeValidForDatatypeProperty($classAttribute))
                then
                    ()
                else if (f:isAttributeTypeValidForObjectProperty($classAttribute))
                    then
                        f:generateHtmlWarning(fn:concat('The attribute ', $classAttributeName, ' type is deprecated. Attributes should use XSD or RDF datatypes.'))
                    else
                        f:generateHtmlError(fn:concat('The attribute ', $classAttributeName, ' type is incorrect. Attributes must use datatypes that are either: (a) UML common types, (b) XSD or RDF datatypes or (c) custom datatype or enumeration.'))
              "
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning with the mapped xsd data-type if the present is an UML data-type</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="classAttributeTypeSuggestion">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeType" select="$classAttribute/properties/@type"/>
        <xsl:variable name="umlDatatype" select="f:getUmlDataTypeValues($classAttributeType,$umlDataTypesMapping)"/>
        <xsl:if test="string($umlDatatype) != ''">
            <xsl:sequence select="f:generateHtmlWarning(fn:concat('This is an UML data-type and you should change it into ',$umlDatatype))"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when attributes have stereotypes</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="classAttributeStereotypeChecker">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="hasStereotype" select="$classAttribute/stereotype/not(@stereotype)"/>
        <xsl:if test="$hasStereotype = fn:false()">
            <xsl:sequence select="f:generateHtmlWarning('Attribute must have no stereotype')"/>
        </xsl:if>
    </xsl:template>
    
    
</xsl:stylesheet>