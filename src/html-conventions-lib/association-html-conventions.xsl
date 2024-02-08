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
                <xsl:call-template name="connectorSourceTags">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorTags">
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
                <xsl:if test="f:getConnectorDirection(.) = 'Bi-Directional'">

                    <xsl:call-template name="associationMissingSourceMultiplicity">
                        <xsl:with-param name="connector" select="."/>
                    </xsl:call-template>
                    <xsl:call-template name="associationInvalidSourceMultiplicityFormat">
                        <xsl:with-param name="connector" select="."/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="associationSourceTargetTypes">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorUniqueName">
                    <xsl:with-param name="connector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="connectorRoleCrossTypeReuseCheck">
                    <xsl:with-param name="connector" select="."/>
                    <xsl:with-param name="isDependency" select="fn:false()"/>
                </xsl:call-template>
                <!--    End of specific checker rules-->
            </xsl:if>
        </xsl:variable>
        <xsl:if test="boolean($associationChecks)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2>
                        <xsl:value-of select="f:getConnectorName(.)"/>
                    </h2>
                    <dl>
                        <dt> Unmet association conventions </dt>
                        <xsl:copy-of select="$associationChecks"/>
                    </dl>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$associationChecks"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[association-multiplicity-1] - The target role of $connectorName$ has no
            multiplicity. Cardinality must be provided for each role.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="associationMissingSourceMultiplicity">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
            if ($connector/source/type/not(@multiplicity)) then
            f:generateErrorMessage(fn:concat('The source role of ', f:getConnectorName($connector),
            ' has no multiplicity. Cardinality must be provided for each role.'),
            path($connector),
            'association-multiplicity-1',
            'CMC-R11',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r11&quot; target=&quot;_blank&quot;&gt;CMC-R11&lt;/a&gt;
            &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
            )
            else
            ()"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[association-multiplicity-2] - The connector $connectorName$ has source multiplicity
            invalidly stated. Multiplicity must be specified in the form ['min'..'max'].</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="associationInvalidSourceMultiplicityFormat">
        <xsl:param name="connector"/>
        <xsl:variable name="multiplicityValue" select="$connector/source/type/@multiplicity"/>
        <xsl:if test="boolean($multiplicityValue)">
            <xsl:sequence
                select="
                if (fn:matches($multiplicityValue, '^[0-9]..[0-9]$') or fn:matches($multiplicityValue, '^[0-9]..\*$')) then
                ()
                else
                f:generateWarningMessage(fn:concat('The connector ', f:getConnectorName($connector),
                ' has source multiplicity invalidly stated. Multiplicity must be specified in the form [min..max].'),
                path($connector),
                'association-multiplicity-2',
                'CMC-R11',
                '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r11&quot; target=&quot;_blank&quot;&gt;CMC-R11&lt;/a&gt;'
                
                )
                "
            />
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[association-source-target-types-3] - Associations can be 
            provided only between classes to classes and classes to objects.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="associationSourceTargetTypes">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceType" select="$connector/source/model/@type"/>
        <xsl:variable name="targetType" select="$connector/target/model/@type"/>
        <xsl:sequence
            select="
                if ($sourceType = 'Class' and $targetType = ('Class', 'Object')) then
                    ()
                else
                f:generateErrorMessage('Associations can be provided only between classes to classes and classes to objects.',
                path($connector),
                'association-source-target-types-3',
                'CMC-R12',
                '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                )"
        />
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>