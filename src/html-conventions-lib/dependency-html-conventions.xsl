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
        <xd:desc>Getting all dependencies and show only the ones that have unmet conventions</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <xsl:variable name="dependencyChecks" as="item()*">
            <xsl:if test="f:checkIfConnectorTargetAndSourceElementsExists(.)">
                <!--    Start of common connectors checkers rules     -->
                <xsl:call-template name="connectorNamingFormat">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingNamePrefix">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingLocalSegmentName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorInvalidNamePrefix">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorUndefinedPrefix">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorInvalidNameLocalSegment">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorInvalidFirstCharacterInLocalSegment">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorDelimitersInTheLocalSegment">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorUnknownStereotypeProvided">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorStereotypeProvided">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorInvalidTagName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingPrefixTagName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingTagValue">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingTagName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorTargetTags">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorGeneralNameProvided">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingDescription">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingTargetRole">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorInvalidRelationshipDirection">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorMissingTargetMultiplicity">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorInvalidTargetMultiplicityFormat">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorDirectionAndRolesOutOfSync">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <!--    End of common connectors checkers rules     -->
                <!--    Start of specific checker rules-->
                <xsl:call-template name="dependencyInvalidDirection">
                    <xsl:with-param name="dependencyConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="dependencySourceTargetTypes">
                    <xsl:with-param name="dependencyConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorUniqueName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorRoleCrossTypeReuseCheck">
                    <xsl:with-param name="connector" select="."/>
                    <xsl:with-param name="isDependency" select="fn:true()"/>
                </xsl:call-template>
            </xsl:if>
                <!--    End of specific checker rules-->
            
        </xsl:variable>
        <xsl:if test="boolean($dependencyChecks)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2>
                        <xsl:value-of select="f:getConnectorName(.)"/>
                    </h2>
                    <dl>
                        <dt> Unmet dependency conventions </dt>
                        <xsl:copy-of select="$dependencyChecks"/>
                    </dl>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$dependencyChecks"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

    </xsl:template>



    <xd:doc>
        <xd:desc>[dependency-direction-1] - The direction is not 'Source->Destination'. Dependecy
            direction can be only 'Source->Destination'. </xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    <xsl:template name="dependencyInvalidDirection">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="dependencyDirection" select="$dependencyConnector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($dependencyDirection != 'Source -&gt; Destination') then
                    f:generateWarningMessage('The direction is not Source -&gt; Destination. Dependecy direction can be only Source -&gt; Destination. ',
                    path($dependencyConnector),
                    'dependency-direction-1',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )
                else
                    ()"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[dependency-source-target-types-2] - Dependecies can be provided only between classes 
            and enumerations or objects.</xd:desc>
        <xd:param name="dependencyConnector"/>
    </xd:doc>
    
    <xsl:template name="dependencySourceTargetTypes">
        <xsl:param name="dependencyConnector"/>
        <xsl:variable name="sourceType" select="$dependencyConnector/source/model/@type"/>
        <xsl:variable name="targetType" select="$dependencyConnector/target/model/@type"/>
        <xsl:sequence
            select="
                if ($sourceType = 'Class' and $targetType = ('Enumeration', 'Object')) then
                    ()
                else
                f:generateErrorMessage('Dependecies can be provided only between classes and enumerations or objects.',
                path($dependencyConnector),
                'dependency-source-target-types-2',
                'CMC-R12',
                '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                )"
        />
    </xsl:template>


</xsl:stylesheet>