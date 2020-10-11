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
        <xd:desc>Getting all class attributes and show only the ones that have unmet conventions
            [class-attribute-name-21] [class-attribute-multiplicity-22] [class-attribute-type-23]
            [class-attribute-type-24] [class-attribute-type-25] [class-attribute-counter-part-65] </xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">
        <xsl:variable name="classAttributeChecks" as="item()*">
            <xsl:call-template name="ca-attributeNameStartsWithLowerCase">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-incorrectDatatype">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-discouragedDatatype">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-multiplicityIncorrectFormat">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-undefinedType">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-stereotypeProvided">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-missingName">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-missingNamePrefix">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-missingLocalSegmentName">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-invalidNamePrefix">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-invalidNameLocalSegment">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-invalidFirstCharacterInLocalSegment">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-delimitersInTheLocalSegment">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-uniqueName">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-undefinedPrefix">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-namingFormat">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-missingDescription">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-attributeCorrespondingDependecy">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="ca-attributeTypeDateTime">
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

    <xsl:template name="ca-attributeNameStartsWithLowerCase">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:sequence
            select="
                if (f:isValidQname($classAttributeName))
                then
                    if (f:isQNameLowerCasedCamelCase($classAttributeName) = fn:false())
                    then
                        f:generateHtmlInfo(fn:concat('The attribute name ', $classAttributeName, ' is invalid. The attribute name must start with a lower case.'))
                    else
                        ()
                else
                    if (fn:contains($uppercaseLetters, fn:substring($classAttributeName, 1, 1)))
                    then
                        f:generateHtmlInfo(fn:concat('The attribute name ', $classAttributeName, ' is invalid. The attribute name must start with a lower case.'))
                    else
                        ()"/>

    </xsl:template>


    <xd:doc>
        <xd:desc>[class-attribute-type-23] - The attribute $attributeName$ type is incorrect.
            Attributes must use datatypes that are either: (a) UML common types, (b) XSD or RDF
            datatypes or (c) custom datatype or enumeration. </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>

    <xsl:template name="ca-incorrectDatatype">
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
                    f:generateHtmlError(fn:concat('The attribute type ', $classAttribute/properties/@type,
                    ' type is invalid. Attributes must use types that are either: (a) UML common types,',
                    ' (b) XSD or RDF datatypes (c) a custom Datatype or (d) an Enumeration.'))
                "
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[class-attribute-type-24] - The attribute $attributeName$ type is deprecated.
            Attributes should use XSD or RDF datatypes.</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-discouragedDatatype">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:sequence
            select="
                if (boolean(f:getUmlDataTypeValues($classAttribute/properties/@type, $umlDataTypesMapping))) then
                    f:generateHtmlInfo(fn:concat('The attribute type ', $classAttribute/properties/@type,
                    ' is deprecated. Attributes should use XSD or RDF datatypes. The suggested alternative for ', 
                    $classAttribute/properties/@type, ' is ', 
                    f:getUmlDataTypeValues($classAttribute/properties/@type, $umlDataTypesMapping)))
                else
                    ()"
        />

    </xsl:template>

    <xd:doc>
        <xd:desc>[class-attribute-type-25] - The attribute $attributeName$ type "typeName" is not
            defined in the model. Every used type should be defined. This applies to The standard
            datatypes (e.g XSD or RDF), which should be re-declared in the model and serving as
            proxies. </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-undefinedType">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:variable name="classAttributeType" select="$classAttribute/properties/@type"/>
        <xsl:variable name="elementsFoundWithAttributeTypeName"
            select="
                if (boolean($classAttributeType)) then
                    f:getElementByName($classAttributeType, root($classAttribute))
                else
                    ()"
        />
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
    <xsl:template name="ca-multiplicityIncorrectFormat">
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
    <xsl:template name="ca-stereotypeProvided">
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

    <xsl:template name="ca-missingDescription">
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
    <xsl:template name="ca-missingName">
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

    <xd:doc>
        <xd:desc>[common-name-2] - The name of element $elementName$ is missing a prefix. The name
            should comprise a prefix respecing the syntax "prefix:localSegment".</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-missingNamePrefix">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
                if (f:isElementNamePrefixMissing($classAttribute)) then
                    f:generateHtmlWarning(fn:concat('The name of element ', $classAttribute/@name,
                    ' is missing a prefix. The name should comprise a prefix respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-3] - The name of $elementName$ is missing a local segment. Please
            provide one respecing the syntax "prefix:localSegment".".</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-missingLocalSegmentName">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
                if (f:isElementNameLocalSegmentMissing($classAttribute)) then
                    f:generateHtmlError(fn:concat('The name of element ', $classAttribute/@name,
                    ' is missing a local segment. Please provide one respecing the syntax prefix:localSegment.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[common-name-4] - The name prefix is invalid in $value$. Please provide a short
            prefix name containing only alphanumeric characters [a-zA-Z0-9]+.</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-invalidNamePrefix">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
                if (f:isInvalidNamePrefix($classAttribute)) then
                    f:generateHtmlError(fn:concat('The name prefix ', fn:substring-before($classAttribute/@name, ':'),
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
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-invalidNameLocalSegment">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
                if (f:isInvalidLocalSegmentName($classAttribute)) then
                    f:generateHtmlError(fn:concat('The local name segment ', fn:substring-after($classAttribute/@name, ':'),
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
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-invalidFirstCharacterInLocalSegment">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
                if (f:isValidFirstCharacterInLocalSegment($classAttribute)) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The local name segment ', f:getLocalSegmentForElements($classAttribute),
                    ' starts with an invalid character. The local segment ',
                    'must start with a letter or underscore.'))"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[common-name-7] - The local name segment $value$ contains token delimiters. It is
            best if the names are camel cased and delimiters removed. </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-delimitersInTheLocalSegment">
        <xsl:param name="classAttribute"/>
        <xsl:sequence
            select="
                if (f:isDelimitersInLocalSegment($classAttribute)) then
                    f:generateHtmlWarning(fn:concat('The local name segment ', f:getLocalSegmentForElements($classAttribute),
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
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-uniqueName">
        <xsl:param name="classAttribute"/>
        <xsl:if test="boolean($classAttribute/@name)">
        <xsl:variable name="elementsFound"
            select="f:getElementByName($classAttribute/@name, root($classAttribute))"/>
        <xsl:sequence
            select="
                if (count($elementsFound) > 0) then
                    f:generateHtmlError(fn:concat('The name ', $classAttribute/@name, ' is not unique. The Concept names ',
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
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="ca-undefinedPrefix">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:if test="not(f:isValidNamespace($classAttributeName))">
            <xsl:sequence
                select="
                f:generateHtmlWarning(fn:concat('The prefix ', fn:substring-before($classAttributeName, ':'),
                ' is not defined. A prefix must be associated to a namespace URI.'))"
            />
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[common-name-58] - The name $elementName$ does not match the pattern. The name
            should respect the syntax "prefix:localSegment" (similar to the XML QName).</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    
    <xsl:template name="ca-namingFormat">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:if test="f:isValidQname($classAttributeName) = fn:false()">
            <xsl:sequence
                select="
                f:generateHtmlWarning(fn:concat('The name ', $classAttributeName, ' does not match the pattern. ', 
                'The name should respect the syntax prefix:localSegment (similar to the XML QName).'))"
            />
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[class-attribute-counter-part-65] - The attribute $attrName$ is missing its
            counterpart as dependency relation. Attributes of type Code should have a counter-part
            dependency relation with the same name and pointing towards an Enumeration.</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-attributeCorrespondingDependecy">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeType" select="$classAttribute/properties/@type"/>
        <xsl:sequence
            select="
            if ($classAttributeType = $controlledListType) then
                    if (f:hasAttributeCorrespondingDependecy($classAttribute)) then
                        ()
                    else
                    f:generateHtmlError(fn:concat('The attribute ', $classAttribute/@name,
                                                  '  is missing its counterpart as dependency relation.',
                                                  ' Attributes of type Code should have a counter-part ',
                                                  'dependency relation with the same name and pointing ',
                                                  'towards an Enumeration.'))
                else
                    ()"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[class-attribute-type-66] - The attribute uses date or date time reference. Ensure
            that the deadline attributes are typed with xsd:dateTime datatype wherease the date
            references may use simple xsd:date datatype. </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="ca-attributeTypeDateTime">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeType" select="$classAttribute/properties/@type"/>
        <xsl:sequence
            select="
                if ($classAttributeType = ('Date', 'DateTime', 'xsd:date', 'xsd:dateTime')) then
                    f:generateHtmlInfo(fn:concat('The attribute uses date or date time reference. Ensure that the ',
                    'deadline attributes are typed with xsd:dateTime datatype wherease the date references may use ',
                    'simple xsd:date datatype.'))
                else
                    ()"
        />
        
    </xsl:template>
    
</xsl:stylesheet>