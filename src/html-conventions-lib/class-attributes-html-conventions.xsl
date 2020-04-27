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
        <xd:desc>Getting all class attributes and show only the ones that have unmet
            conventions</xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute" name="attributes">
        <xsl:variable name="classAttributeChecks" as="item()*">
            <xsl:call-template name="attributeNameStartsWithLowerCase">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="incorrectDatatype">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="discouragedDatatype">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="multiplicityIncorrectFormat">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="undefinedType">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="stereotypeProvided">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingName">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>



            <!--           <xsl:call-template name="classAttributeNameChecker">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classAttributeNameConventionChecker">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>-->
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
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$attributeName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc>[class-attribute-name-21] - The attribute name $value$ is invalid. The attribute
            name must start with a lower case.</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>

    <xsl:template name="attributeNameStartsWithLowerCase">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:sequence
            select="
                if (f:isValidQname($classAttributeName))
                then
                    if (f:isQNameLowerCasedCamelCase($classAttributeName) = fn:false())
                    then
                        f:generateHtmlWarning(fn:concat('The attribute name ', $classAttributeName, ' is invalid. The attribute name must start with a lower case.'))
                    else
                        ()
                else
                    if (fn:contains($uppercaseLetters, fn:substring($classAttributeName, 1, 1)))
                    then
                        f:generateHtmlWarning(fn:concat('The attribute name ', $classAttributeName, ' is invalid. The attribute name must start with a lower case.'))
                    else
                        ()"/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[class-attribute-type-23] - The attribute $attributeName$ type is incorrect.
            Attributes must use datatypes that are either: (a) UML common types, (b) XSD or RDF
            datatypes or (c) custom datatype or enumeration. </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>

    <xsl:template name="incorrectDatatype">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:sequence
            select="
                if (f:isAttributeTypeValidForDatatypeProperty($classAttribute))
                then
                    ()
                else
                    if (f:isAttributeTypeValidForObjectProperty($classAttribute))
                    then
                        ()
                    else
                        f:generateHtmlError(fn:concat('The attribute ', $classAttributeName,
                        ' type is incorrect. Attributes must use datatypes that are either: ',
                        '(a) UML common types, (b) XSD or RDF datatypes or (c) custom datatype or enumeration.'))
                "
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[class-attribute-type-24] - The attribute $attributeName$ type is deprecated.
            Attributes should use XSD or RDF datatypes.</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="discouragedDatatype">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:sequence
            select="
                if (boolean(f:getUmlDataTypeValues($classAttribute/properties/@type, $umlDataTypesMapping))) then
                    f:generateHtmlWarning(fn:concat('The attribute ', $classAttributeName,
                    ' type is deprecated. Attributes should use XSD or RDF datatypes. The suggested alternative is',
                    f:getUmlDataTypeValues($classAttribute/properties/@type, $umlDataTypesMapping)))
                else
                    ()"/>

    </xsl:template>

    <xd:doc>
        <xd:desc>[class-attribute-type-25] - The attribute $attributeName$ type "typeName" is not
            defined in the model. Every used type should be defined. This applies to The standard
            datatypes (e.g XSD or RDF), which should be re-declared in the model and serving as
            proxies. </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="undefinedType">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:variable name="classAttributeType" select="$classAttribute/properties/@type"/>
        <xsl:variable name="elementsFoundWithAttributeTypeName"
            select="f:getElementByName($classAttributeType, root($classAttribute))"/>
        <xsl:sequence
            select="
                if (count($elementsFoundWithAttributeTypeName) >= 1) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The attribute ', $classAttributeName, ' type ', $classAttributeType,
                    ' is not defined in the model. Every used type should be defined.',
                    ' This applies to The standard datatypes (e.g XSD or RDF), which should ',
                    'be re-declared in the model and serving as proxies.'))"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[class-attribute-multiplicity-22] - The attribute $attributeName$ multiplicity is
            incorrect. Multiplicity must be specified in the form ['min'..'max'] and the values
            should be defined with a digit or *</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="multiplicityIncorrectFormat ">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeMultiplicityMin" select="$classAttribute/bounds/@lower"/>
        <xsl:variable name="classAttributeMultiplicityMax" select="$classAttribute/bounds/@upper"/>
        <xsl:sequence
            select="
                if (fn:matches($classAttributeMultiplicityMin, '[0-9\*]') and fn:matches($classAttributeMultiplicityMax, '[0-9\*]')) then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The attribute ', $classAttribute/@name, ' multiplicity is incorrect. ',
                    'Multiplicity must be specified in the form [min..max] and the values should ',
                    'be defined with a digit or *'))"
        />
    </xsl:template>



    <xd:doc>
        <xd:desc>[common-stereotype-10] - The $stereotypeName$ stareotype is applied to
            $elementName$. Stereotypes are discouraged in the current practice with some exceptions. </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="stereotypeProvided">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
                if (f:isAttributeStereotypeValid($classAttribute))
                then
                    ()
                else
                f:generateHtmlWarning(fn:concat('The ', $classAttribute/stereotype/@stereotype,
                    ' stareotype is applied to ', $classAttribute/@name,
                    '. Stereotypes are discouraged in the current practice with some exceptions. '))"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-description-9] - $elementName$ is missing a description. All concepts
            should be defined or described.</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="missingDescription">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:variable name="noClassDescription" select="$classAttribute/documentation/not(@value)"/>
        <xsl:sequence
            select="
            if ($noClassDescription = fn:true()) then
            f:generateHtmlWarning(fn:concat($classAttributeName, ' is missing a description. All concepts should be defined or described.'))
            else
            ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-name-1] - The name of the element $IdRef$ is missing. Please provide one
            respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="missingName">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
            if (f:isElementNameMissing($classAttribute)) then
            f:generateHtmlError(fn:concat('The name of the element ', $classAttribute/@xmi:idref,
            ' is missing. Please provide one respecing the syntax prefix:localSegment.'))
            else
            ()"
        />
    </xsl:template>

    <!--    <xd:doc>
        <xd:desc>Return warning when class attribute is missing the name</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="classAttributeNameChecker">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="noClassAttributeName" select="$classAttribute/not(@name)"/>
        <xsl:variable name="attributeId" select="$classAttribute/@xmi:idref"/>
        <xsl:if test="$noClassAttributeName = fn:true()">
            <xsl:sequence
                select="f:generateHtmlWarning(fn:concat('There is an attribute without a name.Here is the attribute id: ', $attributeId))"
            />
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
            <xsl:sequence
                select="f:generateHtmlWarning('Class attribute name is not a valid Qname. Please change')"
            />
        </xsl:if>
    </xsl:template>-->


</xsl:stylesheet>