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
        <xd:desc>[connector-name-27] - The connector has a general name, and it should not. The
            names must be provided as connector source and target roles, not as connector name. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-generalNameProvided">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorHasNoName" select="$connector/not(@name)"/>
        <xsl:sequence
            select="
                if ($connectorHasNoName) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The connector has a general name, and it ',
                    'should not. The names must be provided as connector source and target roles, not as ',
                    'connector name.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-description-28] - The connector $connectorName$ has no description. It
            is recommended to define and describe all the relations.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:template name="co-missingDescription">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorHasNoDescription" select="$connector/documentation/not(@value)"/>
        <xsl:sequence
            select="
                if ($connectorHasNoDescription) then
                    f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector), ' has no description. It is recommended ',
                    'to define and describe all the relations.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-source-29] - The connector $connectorName$ has no target role. The
            connectors must have target roles.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-missingTargetRole">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
                if ($connector/target/role/not(@name)) then
                    f:generateHtmlError(fn:concat('The connector ', f:getConnectorName($connector),
                    ' has no target role. The connectors must have target roles.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-source-30] - The connector $connectorName$ has no inverse. It is
            recommended that each relation (here UML connector) includes a definition of its
            inverse.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-missingInverseRelation">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
                if ($connector/source/role/not(@name)) then
                    f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector),
                    ' has no inverse. It is recommended that each relation (here UML connector) includes a definition of its inverse.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-source-31] - The connector $connectorName$ employ invalid direction
            $direction$. Connectors must employ "Source->Destination" or "Bi-directional" directions
            only. </xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-invalidRelationshipDirection">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($connectorDirection = ('Source -&gt; Destination', 'Bi-Directional')) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The connector ', f:getConnectorName($connector), ' employ invalid direction ', $connectorDirection,
                    '. Connectors must employ Source->Destination or Bi-directional directions only.'))"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-multiplicity-32] - The target role of $connectorName$ has no
            multiplicity. Cardinality must be provided for each role.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-missingTargetMultiplicity">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
                if ($connector/target/type/not(@multiplicity)) then
                    f:generateHtmlError(fn:concat('The target role of ', f:getConnectorName($connector),
                    ' has no multiplicity. Cardinality must be provided for each role.'))
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-multiplicity-34] - The connector $connectorName$ has target multiplicity
            invalidly stated. Multiplicity must be specified in the form ['min'..'max'].</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-invalidTargetMultiplicityFormat ">
        <xsl:param name="connector"/>
        <xsl:variable name="multiplicityValue" select="$connector/target/type/@multiplicity"/>
        <xsl:sequence
            select="
                if (fn:matches($multiplicityValue, '^[0-9]..[0-9]$') or fn:matches($multiplicityValue, '^[0-9]..\*$')) then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector),
                    ' has target multiplicity invalidly stated. Multiplicity must be specified in the form [min..max].'))
                "
        />
    </xsl:template>
 
    <xd:doc>
        <xd:desc>[connector-multiplicity-33] - The target role of $connectorName$ has no
            multiplicity. Cardinality must be provided for each role.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="co-missingSourceMultiplicity">
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
        <xd:desc>[connector-multiplicity-35] - The connector $connectorName$ has source multiplicity
            invalidly stated. Multiplicity must be specified in the form ['min'..'max'].</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="co-invalidSourceMultiplicityFormat">
        <xsl:param name="connector"/>
        <xsl:variable name="multiplicityValue" select="$connector/target/type/@multiplicity"/>
        <xsl:sequence
            select="
            if (fn:matches($multiplicityValue, '^[0-9]..[0-9]$') or fn:matches($multiplicityValue, '^[0-9]..\*$')) then
            ()
            else
            f:generateHtmlWarning(fn:concat('The connector ', f:getConnectorName($connector),
            ' has source multiplicity invalidly stated. Multiplicity must be specified in the form [min..max].'))
            "
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[connector-direction-63] - The connector $connectorName$ has no inverse. It is
            recommended that each relation (here UML connector) includes a definition of its
            inverse.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="co-directionAndRolesOutOfSync">
        <xsl:param name="connector"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:variable name="missingSourceRole" select="$connector/source/role/not(@name)"/>
        <xsl:variable name="missingTargetRole" select="$connector/target/role/not(@name)"/>
        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
        <xsl:sequence
            select="
                if (not($missingTargetRole) and $missingSourceRole) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The connector ', f:getConnectorName($connector), ' has no inverse. It is recommended that each relation ',
                    '(here UML connector) includes a definition of its inverse.'))"/>
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
        <xsl:sequence
            select="
                if (not($missingTargetRole) and not($missingSourceRole)) then
                    ()
                else
                    f:generateHtmlError(fn:concat('The connector ', f:getConnectorName($connector), ' has no inverse. It is recommended that each relation ',
                    '(here UML connector) includes a definition of its inverse.'))"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>