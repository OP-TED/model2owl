<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs xd xsl fn f"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 24, 2025</xd:p>
            <xd:p>This module defines how selected XMI connectors are transformed
            into JSON-LD context</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="../common/checkers.xsl"/>
    
    <xsl:output method="xml" encoding="UTF-8"/>

    <xd:doc>
        <xd:desc>
            Generates node objects for associations and dependencies of the
            given class that are not excluded based on their status or origin.
        </xd:desc>
    </xd:doc>
    <xsl:template name="classConnectorsDeclaration">
        <xsl:variable name="class" select="."/>
        <xsl:variable name="supportedConnTypes"
            select="('Association', 'Dependency')"/>
        <xsl:variable name="relations"
            select="f:getOutgoingRelationsByType($class, $supportedConnTypes)"/>
        <xsl:for-each select="$relations//relation">
                <xsl:variable name="relation" select="."/>
                <xsl:variable name="connector"
                    select="f:getConnectorByIdRef($relation/@connectorIdRef, root())"/>
                <xsl:if test="not(f:isExcludedByStatus($connector))">
                    <xsl:if test="$relation/source/@type != 'ProxyConnector'
                        and $relation/target/@type != 'ProxyConnector'">
                        <xsl:variable name="connectorRoleName" select="$relation/@name"/>
                        <xsl:if
                            test="$generateReusedConceptsJSONLDcontext 
                            or f:getPrefix($connectorRoleName) = $includedPrefixesList">
                            <xsl:call-template name="relationGeneration">
                                <xsl:with-param name="relation" select="$relation"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            Generates a node object for the relation. Includes the relation URI
            mapping, type, and container information.
        </xd:desc>
        <xd:param name="relation"/>
    </xd:doc>
    <xsl:template name="relationGeneration">
        <xsl:param name="relation"/>
        <xsl:variable name="relCurie" select="$relation/@name"/>
        <xsl:variable name="relName" select="f:getLocalSegment($relCurie)"/>
        <fn:map key="{$relName}">
            <xsl:call-template name="relationDeclaration">
                <xsl:with-param name="relCurie" select="$relCurie"/>
            </xsl:call-template>
            <xsl:call-template name="relationTypeDeclaration"/>
            <xsl:call-template name="relationContainerDeclaration">
                <xsl:with-param name="multiplicity" select="$relation/@multiplicity"/>
            </xsl:call-template>
        </fn:map>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            R.03. Association and dependency — in JSON-LD context layer.
            For each UML association/dependency, specify an object property by
            creating a property URI mapping with an absolute URI of a target end
            in a node object. Set the term definition as a top-level entry
            inside the class’s inner context object. For bidirectional
            connectors, additionally specify an extended term definition for the
            source end.
        </xd:desc>
        <xd:param name="relCurie"/>
    </xd:doc>
    <xsl:template name="relationDeclaration">
        <xsl:param name="relCurie"/>
        <xsl:variable name="relUri" select="f:buildURIfromLexicalQName($relCurie)"/>
        <fn:string key="@id"><xsl:value-of select="$relUri"/></fn:string>   
    </xsl:template>

    <xd:doc>
        <xd:desc>
            R.07. Association and dependency range — in JSON-LD context layer.
            For each UML association/dependency, specify the object property
            range by creating a type coercion entry in a node object. Set the
            fixed @id keyword as a value to indicate that that the value of the
            term should be interpreted as an URI. Set the term definition as a
            top-level entry inside the class’s inner context object. For
            bidirectional connectors, additionally specify the object property
            range for the source end.
        </xd:desc>
    </xd:doc>
    <xsl:template name="relationTypeDeclaration">
        <fn:string key="@type">@id</fn:string>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            R.11. Association and dependency container — in JSON-LD context layer.
            Specify a default container type for each UML association/dependency
            that can accept more than a one value, setting the fixed @set
            keyword as a value for the @container key. Set the container type
            entry for an association/dependency target end, inside a term
            definition created as a top-level entry of the context object. For
            bidirectional connectors, additionally specify the container type
            for the source end.
        </xd:desc>
        <xd:param name="multiplicity"/>
    </xd:doc>
    <xsl:template name="relationContainerDeclaration">
        <xsl:param name="multiplicity"/>
        <xsl:variable name="canHaveMultVals"
            select="f:areMultipleValuesForRelationRangeAllowed($multiplicity)"/>
        <xsl:if test="$canHaveMultVals = fn:true()">
            <fn:string key="@container">@set</fn:string>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>