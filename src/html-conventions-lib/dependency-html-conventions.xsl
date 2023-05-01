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


    <xsl:import href="general-connectors-html-convention.xsl"/>
 



    <xd:doc>
        <xd:desc>Getting all dependencies and show only the ones that have unmet conventions
            [dependency-direction-64]</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
            <xsl:variable name="dependencyChecks" as="item()*">
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
                    <xsl:call-template name="dependency-invalidDirection">
                        <xsl:with-param name="dependencyConnector" select="."/>
                    </xsl:call-template>
                    <xsl:call-template name="dependency-sourceTargetTypes">
                        <xsl:with-param name="dependencyConnector" select="."/>
                    </xsl:call-template>
                    <!--    End of specific checker rules-->  
                </xsl:if>
            </xsl:variable>
            <xsl:if test="boolean($dependencyChecks)">
                <h2>
                    <xsl:value-of select="f:getConnectorName(.)"/>
                </h2>
                <dl>
                    <dt> Unmet dependency conventions </dt>
                    <xsl:copy-of select="$dependencyChecks"/>
                </dl>
            </xsl:if>
 
    </xsl:template>



    <xd:doc>
        <xd:desc>[dependency-direction-64] - The direction is not 'Source->Destination'. Dependecy
            direction can be only 'Source->Destination'. </xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    <xsl:template name="dependency-invalidDirection">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="dependencyDirection" select="$dependencyConnector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($dependencyDirection != 'Source -&gt; Destination') then
                    f:generateHtmlError('The direction is not Source -&gt; Destination. Dependecy direction can be only Source -&gt; Destination. ')
                else
                    ()"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[dependency-source-target-types-3] - Dependecies can be provided only 
            between classes and enumerations.</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    
    <xsl:template name="dependency-sourceTargetTypes">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="sourceType" select="$dependencyConnector/source/model/@type"/>
        <xsl:variable name="targetType" select="$dependencyConnector/target/model/@type"/>
        <xsl:sequence
            select="
            if ($sourceType = 'Class' and $targetType = 'Enumeration') then
            ()
            else
            f:generateHtmlError('Dependecies can be provided only between classes and enumerations.')"
        />
    </xsl:template>


</xsl:stylesheet>