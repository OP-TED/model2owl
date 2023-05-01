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
    <xsl:import href="general-connectors-html-convention.xsl"/>
    
    
    
    <xd:doc>
        <xd:desc>Getting all associations and show only the ones that have unmet conventions</xd:desc>
    </xd:doc>
    
    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        <xsl:variable name="associationChecks" as="item()*">
            <xsl:if test="f:checkIfConnectorTargetAndSourceElementsExists(.)">
                <!--    Start of common connectors checkers rules     -->
                <xsl:call-template name="co-namingFormat">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingNamePrefix">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingLocalSegmentName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-invalidNamePrefix">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-undefinedPrefix">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-invalidNameLocalSegment">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-invalidFirstCharacterInLocalSegment">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-delimitersInTheLocalSegment">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-unknownStereotypeProvided">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-stereotypeProvided">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-invalidTagName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingPrefixTagName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingTagValue">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingTagName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-targetTags">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-sourceTags">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>   
                <xsl:call-template name="co-tags">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>           
                <xsl:call-template name="co-generalNameProvided">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingDescription">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingTargetRole">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-invalidRelationshipDirection">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-missingTargetMultiplicity">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-invalidTargetMultiplicityFormat">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="co-directionAndRolesOutOfSync">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template> 
                <!--    End of common connectors checkers rules     -->  
                <!--    Start of specific checker rules-->
                <xsl:if test="f:getConnectorDirection(.) = 'Bi-Directional'">

                   <xsl:call-template name="association-missingSourceMultiplicity">
                       <xsl:with-param name="connector" select="."/>
                   </xsl:call-template>
                   <xsl:call-template name="association-invalidSourceMultiplicityFormat">
                       <xsl:with-param name="connector" select="."/>
                   </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="association-sourceTargetTypes">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <!--    End of specific checker rules-->  
            </xsl:if>
        </xsl:variable>
        <xsl:if test="boolean($associationChecks)">
            <h2><xsl:value-of select="f:getConnectorName(.)"/></h2>
        <dl>
            <dt>
                Unmet association conventions
            </dt>
            <xsl:copy-of select="$associationChecks"/>
        </dl>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[association-multiplicity-1] - The target role of $connectorName$ has no
            multiplicity. Cardinality must be provided for each role.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="association-missingSourceMultiplicity">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
            if ($connector/source/type/not(@multiplicity)) then
            f:generateHtmlError(fn:concat('The source role of ', f:getConnectorName($connector),
            ' has no multiplicity. Cardinality must be provided for each role.'))
            else
            ()"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[association-multiplicity-2] - The connector $connectorName$ has source multiplicity
            invalidly stated. Multiplicity must be specified in the form ['min'..'max'].</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="association-invalidSourceMultiplicityFormat">
        <xsl:param name="connector"/>
        <xsl:variable name="multiplicityValue" select="$connector/source/type/@multiplicity"/>
        <xsl:if test="boolean($multiplicityValue)">
            <xsl:sequence
                select="
                if (fn:matches($multiplicityValue, '^[0-9]..[0-9]$') or fn:matches($multiplicityValue, '^[0-9]..\*$')) then
                ()
                else
                f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector),
                ' has source multiplicity invalidly stated. Multiplicity must be specified in the form [min..max].'))
                "
            />
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[association-source-target-types-3] - Associations can be 
            provided only between classes to classes and classes to objects..</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="association-sourceTargetTypes">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceType" select="$connector/source/model/@type"/>
        <xsl:variable name="targetType" select="$connector/target/model/@type"/>
        <xsl:sequence
            select="
                if ($sourceType = 'Class' and $targetType = ('Class', 'Object')) then
                    ()
                else
                f:generateHtmlError('Associations can be provided only between classes to classes and classes to objects.')"
        />
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>