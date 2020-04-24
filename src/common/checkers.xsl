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
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:functx="http://www.functx.com"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>A set of useful boolean test functions</xd:desc>
    </xd:doc>

    <xsl:import href="utils.xsl"/>

    <xsl:variable name="allowedCharacters" select="'[a-zA-Z0-9-_:]'"/>
    <xsl:variable name="allowedStrings" select="'^[\w\d-_:]+$'"/>
    <xsl:variable name="uppercaseLetters" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xd:doc>
        <xd:desc>Checks any string if it is normalized and it contains only allowed characters </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isValidNormalizedString" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:sequence select="xs:boolean(fn:matches($input, $allowedStrings))"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks any string is a valid Qname </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isValidQname" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="fn:contains($input, ':')">
                <xsl:choose>
                    <xsl:when
                        test="
                            (f:isValidNormalizedString($input)) and
                            (fn:string-length(fn:substring-before($input, ':')) > 0) and
                            (fn:string-length(fn:substring-after($input, ':')) > 0)">
                        <xsl:sequence select="fn:true()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="fn:false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if the first letter of the local segment is lower-case or upper-case </xd:desc>
        <xd:param name="input"/>
    </xd:doc>


    <xsl:function name="f:firstLetterFromQnameLocalSegment" as="xs:string">
        <xsl:param name="input"/>
        <xsl:variable name="localNameFromQName" select="fn:substring-after($input, ':')"/>
        <xsl:variable name="firstLetter" select="fn:substring($localNameFromQName, 1, 1)"/>
        <xsl:variable name="startsWithCapitalizedLetter"
            select="fn:contains($uppercaseLetters, $firstLetter)"/>
        <xsl:choose>
            <xsl:when test="$startsWithCapitalizedLetter = fn:true()">
                <xsl:value-of select="'upper-case'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'lower-case'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if local segment from any Qname is camelCase with first letter upper-cased </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isQNameUpperCasedCamelCase" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:variable name="inputIsNormalizedString" select="f:isValidNormalizedString($input)"/>
        <xsl:variable name="letterType" select="f:firstLetterFromQnameLocalSegment($input)"/>
        <xsl:choose>
            <xsl:when test="($letterType = 'upper-case') and ($inputIsNormalizedString = fn:true())">
                <xsl:sequence select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if local segment from any Qname is camelCase with first letter lower-cased </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isQNameLowerCasedCamelCase" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:variable name="inputIsNormalizedString" select="f:isValidNormalizedString($input)"/>
        <xsl:variable name="letterType" select="f:firstLetterFromQnameLocalSegment($input)"/>

        <xsl:choose>
            <xsl:when test="($letterType = 'lower-case') and ($inputIsNormalizedString = fn:true())">
                <xsl:sequence select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <xd:doc>
        <xd:desc>Check if the namespace is valid</xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isValidNamespace" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:variable name="prefixToCheck" select="fn:substring-before($input, ':')"/>
        <xsl:variable name="returnedNamespace"
            select="f:getNamespaceValues($prefixToCheck, $namespacePrefixes)"/>
        <xsl:choose>
            <xsl:when test="$returnedNamespace != ''">
                <xsl:sequence select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Check if the data-type is among the valid ones</xd:desc>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:function name="f:isValidDataType" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:sequence
            select="
                if (boolean(f:getUmlDataTypeValues($input, $umlDataTypesMapping)) or
                boolean(f:getXsdRdfDataTypeValues($input, $xsdAndRdfDataTypes)))
                then
                    fn:true()
                else
                    fn:false()
                "/>


    </xsl:function>




    <xd:doc>
        <xd:desc> Check if the attribute type is acceptable as the range of an object property. It
            is eitehr an element of the model of type ('uml:Class', 'uml:Enumeration') or it is
            listed as an exeception in $acceptableTypesForObjectProperties</xd:desc>
        <xd:param name="attributeElement"/>
    </xd:doc>
    <xsl:function name="f:isAttributeTypeValidForObjectProperty">
        <xsl:param name="attributeElement" as="node()"/>
        <xsl:variable name="acceptableElementTypes" select="('uml:Class', 'uml:Enumeration')"/>
        <xsl:sequence
            select="
                if ($attributeElement/properties/@type = $acceptableTypesForObjectProperties or
                f:getElementByName($attributeElement/properties/@type, root($attributeElement))/@xmi:type = $acceptableElementTypes)
                then
                    fn:true()
                else
                    fn:false()"/>

    </xsl:function>

    <xd:doc>
        <xd:desc> Check if the attribute type is acceptable as the range of an datatype property. It
            must be listed as a valid XSD datatype or an UML type. </xd:desc>
        <xd:param name="attributeElement"/>
    </xd:doc>
    <xsl:function name="f:isAttributeTypeValidForDatatypeProperty">
        <xsl:param name="attributeElement"/>
        <xsl:sequence
            select="
                if (f:isValidDataType($attributeElement/properties/@type)) then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>


    <xsl:function name="f:isConnectorStereotypeValid">
        <xsl:param name="connector" as="node()"/>

    </xsl:function>

    <xsl:function name="f:isElementStereotypeValid">
        <xsl:param name="element" as="node()"/>

    </xsl:function>

    <xd:doc>
        <xd:desc>check attribute stereotype whether it is acceptable or not</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:function name="f:isAttributeStereotypeValid">
        <xsl:param name="attribute" as="node()"/>
        <xsl:sequence
            select="
                if (not(boolean($attribute/stereotype/@stereotype)) or
                $attribute/stereotype/@stereotype = $stereotypeValidOnAttributes)
                then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>

</xsl:stylesheet>