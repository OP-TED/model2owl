<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI connectors are transformed into OWL2
                statements</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../common/fetchers.xsl"/>
    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">
        <xsl:choose>
            <xsl:when
                test="
                    ./source/model/@type = 'ProxyConnector' and
                    ./target/model/@type = 'ProxyConnector'">
                <xsl:call-template name="propertyGeneralization"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="classGeneralization"/>
            </xsl:otherwise>
        </xsl:choose>
            </xsl:template>

    <xd:doc>
        <xd:desc>Rule 22 (Property generalisation in core ontology layer) . Specify sub-property
            axiom for the generalisation between UML associations and dependencies.</xd:desc>
    </xd:doc>
    <xsl:template name="propertyGeneralization">
        <xsl:variable name="targetIdref" select="./target/@xmi:idref" as="xs:string"/>
        <xsl:variable name="sourceIdref" select="./source/@xmi:idref" as="xs:string"/>
        <xsl:variable name="targetElement" select="f:getElementByIdRef($targetIdref, root(.))"/>
        <xsl:variable name="sourceElement" select="f:getElementByIdRef($sourceIdref, root(.))"/>
        <xsl:variable name="targetConnectorIdref" select="$targetElement/@classifier" as="xs:string"/>
        <xsl:variable name="sourceConnectorIdref" select="$sourceElement/@classifier" as="xs:string"/>
        <xsl:variable name="targetConnector"
            select="f:getConnectorByIdRef($targetConnectorIdref, root(.))"/>
        <xsl:variable name="sourceConnector"
            select="f:getConnectorByIdRef($sourceConnectorIdref, root(.))"/>
        <xsl:variable name="targetConnectorTargetUri"
            select="
                if ($targetConnector/target/role/not(@name) = fn:true()) then
                    ()
                else
                    f:buildURIfromLexicalQName($targetConnector/target/role/@name, fn:false())"/>
        <xsl:variable name="sourceConnectorTargetUri"
            select="
                if ($sourceConnector/target/role/not(@name) = fn:true()) then
                    ()
                else
                    f:buildURIfromLexicalQName($sourceConnector/target/role/@name, fn:false())"/>
        <xsl:if test="$targetConnectorTargetUri and $sourceConnectorTargetUri">
            <owl:ObjectProperty rdf:about="{$sourceConnectorTargetUri}">
                <rdfs:subPropertyOf rdf:resource="{$targetConnectorTargetUri}"/>
            </owl:ObjectProperty>
        </xsl:if>
        <xsl:variable name="targetConnectorSourceUri"
            select="
                if ($targetConnector/source/role/not(@name) = fn:true()) then
                    ()
                else
                    f:buildURIfromLexicalQName($targetConnector/source/role/@name, fn:false())"/>
        <xsl:variable name="sourceConnectorSourceUri"
            select="
                if ($sourceConnector/source/role/not(@name) = fn:true()) then
                    ()
                else
                    f:buildURIfromLexicalQName($sourceConnector/source/role/@name, fn:false())"/>
        <xsl:if test="$targetConnectorSourceUri and $sourceConnectorSourceUri">
            <owl:ObjectProperty rdf:about="{$sourceConnectorSourceUri}">
                <rdfs:subPropertyOf rdf:resource="{$targetConnectorSourceUri}"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>apply rules to Associations</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        <xsl:call-template name="genericConnector"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>apply generic connector rules to Dependencies. TODO: otherwise come disjoint
            property cases needs to be accounted for in te future. </xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <xsl:variable name="targetType" select="./target/model/@type"/>
        <xsl:variable name="sourceType" select="./source/model/@type"/>
        <xsl:if test="$targetType != 'ProxyConnector' and $sourceType != 'ProxyConnector'">
            <xsl:call-template name="genericConnector"/>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule 11 (Unidirectional association in core ontology layer) . Specify object
            property declaration axiom for the target end of the association.</xd:desc>
    </xd:doc>
    <xsl:template name="genericConnector">
        <xsl:variable name="targetRoleURI"
            select="
                if (./target/role/@name) then
                    f:buildURIFromElement(./target/role, false(), fn:true())
                else
                    ()"/>
        <xsl:variable name="sourceRole"
            select="
                if (./source/role/@name) then
                    f:buildURIFromElement(./source/role, false(), fn:true())
                else
                    ()"/>

        <xsl:variable name="connectorDocumentation"
            select="f:formatDocString(./documentation/@value)"/>

        <xsl:if test="$targetRoleURI">
            <xsl:variable name="name" select="f:lexicalQNameToWords(./target/role/@name)"/>
            <xsl:variable name="note" select="f:formatDocString(./target/documentation/@value)"/>

            <owl:ObjectProperty rdf:about="{$targetRoleURI}">
                <rdfs:label xml:lang="en">
                    <xsl:value-of select="$name"/>
                </rdfs:label>
                <skos:prefLabel xml:lang="en">
                    <xsl:value-of select="$name"/>
                </skos:prefLabel>
                <xsl:if test="$connectorDocumentation">
                    <skos:definition xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </skos:definition>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </rdfs:comment>
                </xsl:if>
                <xsl:if test="$note">
                    <skos:scopeNote xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </skos:scopeNote>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </rdfs:comment>
                </xsl:if>
                <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
            </owl:ObjectProperty>
        </xsl:if>

        <xsl:if test="$sourceRole">
            <xsl:variable name="name" select="f:lexicalQNameToWords(./source/role/@name)"/>
            <xsl:variable name="note" select="f:formatDocString(./source/documentation/@value)"/>

            <owl:ObjectProperty rdf:about="{$sourceRole}">
                <rdfs:label xml:lang="en">
                    <xsl:value-of select="$name"/>
                </rdfs:label>
                <skos:prefLabel xml:lang="en">
                    <xsl:value-of select="$name"/>
                </skos:prefLabel>
                <xsl:if test="$connectorDocumentation">
                    <skos:definition xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </skos:definition>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$connectorDocumentation"/>
                    </rdfs:comment>
                </xsl:if>
                <xsl:if test="$note">
                    <skos:scopeNote xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </skos:scopeNote>
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$note"/>
                    </rdfs:comment>
                </xsl:if>
                <rdfs:isDefinedBy rdf:resource="{$base-uri}"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 21]-(Class generalisation in core ontology layer) . Specify subclass axiom
            for the generalisation between UML classes. Sibling classes must be disjoint with one
            another</xd:desc>
    </xd:doc>

    <xsl:template name="classGeneralization">
        <xsl:variable name="superClass" select="f:getSuperClassFromGeneralization(.)"/>
        <xsl:variable name="superClassURI"
            select="f:buildURIFromElement($superClass, fn:true(), fn:true())"/>
        <xsl:variable name="subClasses" select="f:getSubClassesFromGeneralization(.)"/>
        <xsl:variable name="subclass" select="f:getElementByIdRef(./source/@xmi:idref, root(.))"/>
        <xsl:variable name="subclassURI" select="f:buildURIFromElement($subclass, fn:true(), fn:true())"/>
        <xsl:choose>
            <xsl:when test="count($subClasses) = 1">
                <xsl:variable name="subClassURI"
                    select="f:buildURIFromElement($subClasses, fn:true(), fn:true())"/>
                <owl:Class rdf:about="{$subClassURI}">
                    <rdfs:subClassOf rdf:resource="{$superClassURI}"/>
                </owl:Class>
            </xsl:when>
            <xsl:otherwise>
                <owl:Class rdf:about="{$subclassURI}">
                    <rdfs:subClassOf rdf:resource="{$superClassURI}"/>
                </owl:Class>
                <xsl:for-each select="$subClasses">
                    <xsl:variable name="siblingURI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
                    <xsl:if test="$siblingURI != $subclassURI">
                        <rdf:Description rdf:about="{$subclassURI}">
                        <owl:disjointWith rdf:resource="{$siblingURI}"/>
                        </rdf:Description>
                    </xsl:if>
                </xsl:for-each> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
