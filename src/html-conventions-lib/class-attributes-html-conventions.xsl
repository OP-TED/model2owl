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

    
    <!--
    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="utils-html-conventions.xsl"/>-->
    <xsl:import href="common-elements-html-conventions.xsl"/>

    <xd:doc>
        <xd:desc>Getting all class attributes and show only the ones that have unmet conventions
 </xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">
        <xsl:variable name="classAttributeName">
            <xsl:call-template name="getClassAttributeName">
                <xsl:with-param name="classAttribute" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="classAttributeChecks" as="item()*">

                <!--    Start of common checkers rules     -->
                <xsl:call-template name="namingFormat">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="missingName">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="missingNamePrefix">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="missingLocalSegmentName">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="invalidNamePrefix">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="undefinedPrefix">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="invalidNameLocalSegment">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="invalidFirstCharacterInLocalSegment">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="delimitersInTheLocalSegment">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="missingDescription">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="elementType" select="'classAttribute'"/>
                </xsl:call-template>
                <xsl:call-template name="stereotypeProvided">
                    <xsl:with-param name="elementType" select="'classAttribute'"/>
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="unknownStereotypeProvided">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="elementType" select="'classAttribute'"/>
                </xsl:call-template>
                <xsl:call-template name="invalidTagName">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="missingTagValue">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="missingTagName">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="missingPrefixTagName">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="namePlural">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="elementUniqueName">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="isAttribute" select="fn:true()"/>
                </xsl:call-template>
                <!--    End of common checkers rules     -->
                <!--    Start of specific checker rules-->

                <xsl:call-template name="classAttributeNameStartsWithLowerCase">
                    <xsl:with-param name="classAttribute" select="."/>
                </xsl:call-template>
                <xsl:call-template name="classAttributeMultiplicityIncorrectFormat">
                    <xsl:with-param name="classAttribute" select="."/>
                </xsl:call-template>
                <xsl:call-template name="classAttributeIncorrectDatatype">
                    <xsl:with-param name="classAttribute" select="."/>
                </xsl:call-template>
                <xsl:call-template name="classAttributeMissingMultiplicity">
                    <xsl:with-param name="classAttribute" select="."/>
                </xsl:call-template>
                <xsl:call-template name="classAttributeNonPublic">
                    <xsl:with-param name="classAttribute" select="."/>
                </xsl:call-template>
                <!--    End of specific checker rules-->
            
        </xsl:variable>
        <xsl:if test="boolean($classAttributeChecks)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <dl id="attribute-{$classAttributeName}">
                        <dt>
                            <xsl:value-of select="$classAttributeName"/>
                        </dt>
                        <xsl:copy-of select="$classAttributeChecks"/>
                    </dl>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$classAttributeChecks"/>
                </xsl:otherwise>
            </xsl:choose>




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
        <xd:desc>[class-attribute-name-1] - The attribute name $value$ is invalid. The attribute
            name must start with a lower case.</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>

    <xsl:template name="classAttributeNameStartsWithLowerCase">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeName" select="$classAttribute/@name"/>
        <xsl:sequence
            select="
                if (f:isValidQname($classAttributeName))
                then
                    if (f:isQNameLowerCasedCamelCase($classAttributeName) = fn:false())
                    then
                        f:generateErrorMessage(fn:concat('The attribute name ', $classAttributeName, ' is invalid. The attribute name must start with a lower case.'),
                        path($classAttribute),
                        'class-attribute-name-1',
                        'CMC-R4',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r4&quot; target=&quot;_blank&quot;&gt;CMC-R4&lt;/a&gt;
                         &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-general-conventions.html#sec:gc-r4&quot; target=&quot;_blank&quot;&gt;GC-R4&lt;/a&gt;'
                        )
                    else
                        ()
                else
                    if (fn:contains($uppercaseLetters, fn:substring($classAttributeName, 1, 1)))
                    then
                        f:generateErrorMessage(fn:concat('The attribute name ', $classAttributeName, ' is invalid. The attribute name must start with a lower case.'),
                        path($classAttribute),
                        'class-attribute-name-1',
                        'CMC-R4',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r4&quot; target=&quot;_blank&quot;&gt;CMC-R4&lt;/a&gt;
                        &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-general-conventions.html#sec:gc-r4&quot; target=&quot;_blank&quot;&gt;GC-R4&lt;/a&gt;'
                        )
                    else
                        ()"/>

    </xsl:template>
    
    <xd:doc>
        <xd:desc>[class-attribute-multiplicity-2] - The attribute $attributeName$ multiplicity is
            incorrect. Multiplicity must be specified in the form ['min'..'max'] and the values
            should be defined with a digit or *</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="classAttributeMultiplicityIncorrectFormat">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeMultiplicityMin" select="$classAttribute/bounds/@lower"/>
        <xsl:variable name="classAttributeMultiplicityMax" select="$classAttribute/bounds/@upper"/>
        <xsl:sequence
            select="
            if (fn:matches($classAttributeMultiplicityMin, '[0-9\*]') and fn:matches($classAttributeMultiplicityMax, '[0-9\*]')) then
            ()
            else
            f:generateErrorMessage(fn:concat('The attribute ', $classAttribute/@name, ' multiplicity is incorrect. ',
            'Multiplicity must be specified in the form [min..max] and the values should ',
            'be defined with a digit or *'),
            path($classAttribute),
            'class-attribute-multiplicity-2',
            'CMC-R11',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r11&quot; target=&quot;_blank&quot;&gt;CMC-R11&lt;/a&gt;'
            )
            "
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[class-attribute-type-3] - The attribute type $attributeType$ is invalid. 
            Attributes must use datatypes that are either: (a) XSD or RDF datatypes or 
            (b) belonging to a shortlist of custom URIs (datatypes or classes). </xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>

    <xsl:template name="classAttributeIncorrectDatatype">
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
                    f:generateErrorMessage(fn:concat('The attribute type ', $classAttribute/properties/@type,
                    ' type is invalid. Attributes must use types that are either: (a) XSD or RDF datatypes or',
                    ' (b) belonging to a shortlist of custom URIs (datatypes or classes).'),
                    path($classAttribute),
                    'class-attribute-type-3',
                    'CMC-R10',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r10&quot; target=&quot;_blank&quot;&gt;CMC-R10&lt;/a&gt;'
                    )
                "
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[class-attribute-multiplicity-4] - The attribute $attributeName$ multiplicity is missing. Multiplicity must be specified in the form ['min'..'max'] 
            and the values should be defined with a digit or *</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="classAttributeMissingMultiplicity">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="classAttributeMultiplicityMin" select="$classAttribute/bounds/@lower"/>
        <xsl:variable name="classAttributeMultiplicityMax" select="$classAttribute/bounds/@upper"/>
        <xsl:sequence
            select="
            if ($classAttributeMultiplicityMin and $classAttributeMultiplicityMax) then
            ()
            else
            f:generateWarningMessage(fn:concat('The attribute ', $classAttribute/@name, ' multiplicity is missing. ',
            'Multiplicity must be specified in the form [min..max] and the values should ',
            'be defined with a digit or *'),
            path($classAttribute),
            'class-attribute-multiplicity-4',
            'CMC-R11',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r11&quot; target=&quot;_blank&quot;&gt;CMC-R11&lt;/a&gt;
            &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r10&quot; target=&quot;_blank&quot;&gt;CMC-R10&lt;/a&gt;'
            )"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[class-attribute-visibility-5] - The attribute type $attributeType$ is non-public. Attributes shall be public</xd:desc>
        <xd:param name="classAttribute"/>
    </xd:doc>
    <xsl:template name="classAttributeNonPublic">
        <xsl:param name="classAttribute"/>
        <xsl:variable name="attributeScope" select="$classAttribute/@scope"/>
        <xsl:sequence
            select="
            if ($attributeScope = 'Public') then
            ()
            else
            f:generateErrorMessage(fn:concat('The attribute ', $classAttribute/@name, ' is non-public. Attributes shall be public '),
            path($classAttribute),
            'class-attribute-visibility-5',
            'CMC-R13',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r13&quot; target=&quot;_blank&quot;&gt;CMC-R13&lt;/a&gt;'
            )"
        />
    </xsl:template>


  
    
</xsl:stylesheet>