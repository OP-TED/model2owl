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
        <xd:desc>Getting all enumerations with unmet
            conventions </xd:desc>
    </xd:doc>

    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">
        <xsl:variable name="enumerationName">
            <xsl:call-template name="getEnumerationName">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="enumerationConventions" as="item()*">
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
                    <xsl:with-param name="elementType" select="'enumeration'"/>
                </xsl:call-template>
                <xsl:call-template name="stereotypeProvided">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="elementType" select="'enumeration'"/>
                </xsl:call-template>
                <xsl:call-template name="unknownStereotypeProvided">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="elementType" select="'enumeration'"/>
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
                <xsl:call-template name="nonPublicElement">
                    <xsl:with-param name="element" select="."/>
                </xsl:call-template>
                <xsl:call-template name="elementUniqueName">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="isAttribute" select="fn:false()"/>
                </xsl:call-template>
                <!--    End of common checkers rules     -->
                <!--    Start of specific checker rules-->

                <xsl:call-template name="enumerationItemsChecker">
                    <xsl:with-param name="enumeration" select="."/>
                </xsl:call-template>


                <xsl:call-template name="enumerationOutgoingConnectors">
                    <xsl:with-param name="enumeration" select="."/>
                </xsl:call-template>
            
            <xsl:call-template name="enumerationConstraintLevel">
                <xsl:with-param name="enumeration" select="."/>
            </xsl:call-template>
                <!--    End of specific checker rules-->
            
        </xsl:variable>

        <xsl:if test="boolean($enumerationConventions)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2>
                        <xsl:value-of select="$enumerationName"/>
                    </h2>
                    <section>
                        <xsl:if test="boolean($enumerationConventions)">
                            <dl>
                                <dt>Unmet enumeration conventions</dt>
                                <xsl:copy-of select="$enumerationConventions"/>
                            </dl>
                        </xsl:if>
                    </section>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$enumerationConventions"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Getting the enumeration name</xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:template name="getEnumerationName">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationName" select="$enumeration/@name"/>
        <xsl:choose>
            <xsl:when test="$enumeration/not(@name) = fn:true()">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$enumerationName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    
    <xd:doc>
        <xd:desc>[enumeration-attribute-2] The enumeration $value$ shall have no values/attributes defined. 
            An Enumeration stands for a controlled list and its management is out of model scope.  </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    
    <xsl:template name="enumerationItemsChecker">
        <xsl:param name="enumeration"/>
        <xsl:variable name="enumerationNumberOfAttributes"
            select="count($enumeration/attributes/attribute)"/>
        
        <xsl:sequence
            select="
            if ($enumerationNumberOfAttributes > 0) then
            f:generateWarningMessage(fn:concat('The enumeration ', $enumeration/@name,
            ' shall have no values/attributes defined. An Enumeration stands for a controlled list and its management is out of model scope. '),
            path($enumeration),
            'enumeration-attribute-2',
            'CMC-R14',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r14&quot; target=&quot;_blank&quot;&gt;CMC-R14&lt;/a&gt;'
            )
            else
            ()
            "
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[enumeration-connector-3] The enumeration $value should not connect to other elements. 
            An Enumeration stands for an controlled list and can only be referred to. </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    
    <xsl:template name="enumerationOutgoingConnectors">
        <xsl:param name="enumeration"/>
        <xsl:variable name="outgoingConnectors"
            select="fn:count(f:getOutgoingConnectors($enumeration))"/>
        <xsl:sequence
            select="
                if ($outgoingConnectors > 0) then
                    f:generateErrorMessage(fn:concat('The enumeration ', $enumeration/@name,
                    ' should not connect to other elements. An Enumeration stands for an controlled list and can only be referred to.'),
                    path($enumeration),
                    'enumeration-connector-3',
                    'CMC-R14',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r14&quot; target=&quot;_blank&quot;&gt;CMC-R14&lt;/a&gt;'
                    )
                else
                    ()
                "
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[enumeration-constraint-level-4] he enumeration $value$ does not have a correct constraint level (either permissive or restrictive) set as a tag 
            with the $cvConstraintLevelProperty$ key. The permissive level will be used as a fallback value. </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    
    <xsl:template name="enumerationConstraintLevel">
        <xsl:param name="enumeration"/>
        <xsl:sequence
            select="
            if (not(f:hasEnumerationAConstraintLevelProperty($enumeration))) then
            f:generateWarningMessage(fn:concat('The enumeration ', $enumeration/@name,
            ' does not have a correct constraint level (either permissive or restrictive) set as a tag with the ', $cvConstraintLevelProperty, ' key. The permissive level will be used as a fallback value.'),
            path($enumeration),
            'enumeration-constraint-level-4',
            '',
            ''
            )
            else
            ()
            "
        />
    </xsl:template>


   
</xsl:stylesheet>