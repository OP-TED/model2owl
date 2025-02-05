<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
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
    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="descriptors-owl-core.xsl"/>


    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Association']"/>



    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Dependency']"/>

    <xd:doc>
        <xd:desc>This will apply transformation rules to Realisations</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Realisation']">
        <xsl:if test="$generateObjectsAndRealisations">
            <xsl:if test="not(f:isExcludedByStatus(.))">
            <!-- Extract prefixes for source and target -->
            <xsl:variable name="sourcePrefix"
                select="fn:substring-before(./source/model/@name, ':')"/>
            <xsl:variable name="targetPrefix"
                select="fn:substring-before(./target/model/@name, ':')"/>

            <!-- Check if either the prefixes match the internal prefixes list (prefixes to be included) or generateReusedConcepts is true -->
            <xsl:if
                test="$generateReusedConceptsOWLcore or ($sourcePrefix = $includedPrefixesList or $targetPrefix = $includedPrefixesList)">
                <xsl:call-template name="classRealisation">
                    <xsl:with-param name="realisation" select="."/>
                </xsl:call-template>
            </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">
        <xsl:if test="not(f:isExcludedByStatus(.))">
        <!--        This reused concepts filter is applied in the propertyGeneralization function due complexity of the function-->
        <xsl:if
            test="
                ./source/model/@type = 'ProxyConnector' and
                ./target/model/@type = 'ProxyConnector'">
            <xsl:call-template name="propertyGeneralization"/>
        </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Applying core layer rules to generalisation connectors with distinct
            targets</xd:desc>
    </xd:doc>
    <xsl:template name="generalisationsWithDistinctTargetsInCoreLayer">
        <xsl:variable name="generalisations"
            select="//connector[./properties/@ea_type = 'Generalization'][not(target/@xmi:idref = preceding::connector[./properties/@ea_type = 'Generalization']/target/@xmi:idref)]"/>
        <xsl:for-each select="$generalisations">
            <xsl:if test="not(f:isExcludedByStatus(.))">
            <xsl:if
                test="
                    ./source/model/@type = 'Class' and
                    ./target/model/@type = 'Class'">
<!--                    This reused concepts filter is applied in the template so that the subclasses are also filtered-->
                    <xsl:call-template name="classGeneralization"/>
            </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.15. Property generalisation — in core ontology layer. Specify sub-property
            axiom for the generalisation between UML association/dependency connectors.</xd:desc>
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
        <xsl:if test="$targetConnector and $sourceConnector">
            <xsl:variable name="targetConnectorTargetUri"
                select="
                    if ($targetConnector/target/role/not(@name) = fn:true()) then
                        ()
                    else
                        f:buildURIfromLexicalQName($targetConnector/target/role/@name)"/>
            <xsl:variable name="sourceConnectorTargetUri"
                select="
                    if ($sourceConnector/target/role/not(@name) = fn:true()) then
                        ()
                    else
                        f:buildURIfromLexicalQName($sourceConnector/target/role/@name)"/>

            <xsl:variable name="targetConnectorTargetName"
                select="
                    if ($targetConnector/target/role/not(@name) = fn:true()) then
                        ()
                    else
                        $targetConnector/target/role/@name"/>
            <xsl:variable name="sourceConnectorTargetName"
                select="
                    if ($sourceConnector/target/role/not(@name) = fn:true()) then
                        ()
                    else
                        $sourceConnector/target/role/@name"/>

            <xsl:if test="$targetConnectorTargetUri and $sourceConnectorTargetUri">
                <!-- Extract prefixes for source and target -->
                <xsl:variable name="sourceConnectorTargetNamePrefix"
                    select="fn:substring-before($sourceConnectorTargetName, ':')"/>
                <xsl:variable name="targetConnectorTargetNamePrefix"
                    select="fn:substring-before($targetConnectorTargetName, ':')"/>
                <!-- Check if either the prefixes match the internal list or generateReusedConcepts is true -->
                <xsl:if
                    test="$generateReusedConceptsOWLcore or $sourceConnectorTargetNamePrefix = $includedPrefixesList">
                    <owl:ObjectProperty rdf:about="{$sourceConnectorTargetUri}">
                        <rdfs:subPropertyOf rdf:resource="{$targetConnectorTargetUri}"/>
                    </owl:ObjectProperty>
                </xsl:if>
            </xsl:if>
            <xsl:variable name="targetConnectorSourceUri"
                select="
                    if ($targetConnector/source/role/not(@name) = fn:true()) then
                        ()
                    else
                        f:buildURIfromLexicalQName($targetConnector/source/role/@name)"/>
            <xsl:variable name="sourceConnectorSourceUri"
                select="
                    if ($sourceConnector/source/role/not(@name) = fn:true()) then
                        ()
                    else
                        f:buildURIfromLexicalQName($sourceConnector/source/role/@name)"/>
            <xsl:variable name="targetConnectorSourceName"
                select="
                    if ($targetConnector/source/role/not(@name) = fn:true()) then
                        ()
                    else
                        $targetConnector/source/role/@name"/>
            <xsl:variable name="sourceConnectorSourceName"
                select="
                    if ($sourceConnector/source/role/not(@name) = fn:true()) then
                        ()
                    else
                        $sourceConnector/source/role/@name"/>

            <xsl:if test="$targetConnectorSourceUri and $sourceConnectorSourceUri">
                <!-- Extract prefixes for source and target -->
                <xsl:variable name="targetConnectorSourceNamePrefix"
                    select="fn:substring-before($targetConnectorSourceName, ':')"/>
                <xsl:variable name="sourceConnectorSourceNamePrefix"
                    select="fn:substring-before($sourceConnectorSourceName, ':')"/>
                <!-- Check if either the prefixes match the internal list or generateReusedConcepts is true -->
                <xsl:if
                    test="$generateReusedConceptsOWLcore or $sourceConnectorSourceNamePrefix = $includedPrefixesList">

                    <owl:ObjectProperty rdf:about="{$sourceConnectorSourceUri}">
                        <rdfs:subPropertyOf rdf:resource="{$targetConnectorSourceUri}"/>
                    </owl:ObjectProperty>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>apply rules to Associations and Dependencies</xd:desc>
    </xd:doc>
    <xsl:template name="connectorsOwlCore">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="distinctNames" select="f:getDistinctConnectorsNames($root)"/>
        <xsl:for-each select="$distinctNames">
            <xsl:if test="not(f:isExcludedByStatus(f:getConnectorByName(., $root)[1]))">
            <xsl:if
                test="
                    f:getConnectorByName(., $root)/source/model/@type != 'ProxyConnector' and f:getConnectorByName(., $root)/target/model/@type != 'ProxyConnector'
                    and f:getConnectorByName(., $root)/properties/@ea_type = ('Association', 'Dependency')">
                <xsl:variable name="connectorElement" select="f:getConnectorByName(., $root)"/>
                <xsl:variable name="connectorRoleName" select="f:getRoleNameFromConnector($connectorElement)"/>
                <xsl:if
                    test="$generateReusedConceptsOWLcore or fn:substring-before($connectorRoleName, ':') = $includedPrefixesList">

                    <xsl:call-template name="genericConnector">
                        <xsl:with-param name="connectorName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                </xsl:if>

            </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.01. Unidirectional association/dependency — in core ontology layer. Specify
            object property declaration axiom for the target end of the
            association/dependency.</xd:desc>
        <xd:param name="root"/>
        <xd:param name="connectorName"/>
    </xd:doc>
    <xsl:template name="genericConnector">
        <xsl:param name="root"/>
        <xsl:param name="connectorName"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:variable name="roleURI" select="f:buildURIfromLexicalQName($connectorName)"/>

        <xsl:variable name="connectorDocumentations" as="xs:string*"
            select="
                fn:distinct-values(
                    for $connector in $connectorsWithSameName
                    return
                        if ($connector/documentation/@value) then
                            fn:normalize-space($connector/documentation/@value)
                        else
                            ()
                )"/>

        <xsl:variable name="documentation"
            select="fn:normalize-space(f:formatDocString(fn:string-join($connectorDocumentations, ' ')))"/>

        <xsl:variable name="connectorNotes" as="xs:string*"
            select="
                for $connector in $connectorsWithSameName
                return
                    if ($connector/target/role/@name = $connectorName and $connector/target/documentation/@value) then
                        fn:concat($connector/target/documentation/@value, ' (', f:getConnectorName($connector), ') ')
                    else
                        if ($connector/source/role/@name = $connectorName and $connector/source/documentation/@value) then
                            fn:concat($connector/source/documentation/@value, ' (', f:getConnectorName($connector), ') ')
                        else
                            ()"/>

        <xsl:variable name="note"
            select="fn:normalize-space(f:formatDocString(fn:string-join($connectorNotes)))"/>


        <owl:ObjectProperty rdf:about="{$roleURI}"/>
        <xsl:call-template name="coreLayerName">
            <xsl:with-param name="elementName" select="$connectorName"/>
            <xsl:with-param name="elementUri" select="$roleURI"/>
        </xsl:call-template>
        <xsl:if test="$documentation">
            <xsl:call-template name="coreLayerDescription">
                <xsl:with-param name="definition" select="$documentation"/>
                <xsl:with-param name="elementUri" select="$roleURI"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="coreDefinedBy">
            <xsl:with-param name="elementUri" select="$roleURI"/>
        </xsl:call-template>

        <xsl:for-each select="$connectorsWithSameName">
            <xsl:variable name="sourceTags" select="./source/tags/tag"/>
            <xsl:variable name="targetTags" select="./target/tags/tag"/>
            <xsl:for-each select="$sourceTags">
                <xsl:call-template name="coreLayerTags">
                    <xsl:with-param name="elementUri" select="$roleURI"/>
                    <xsl:with-param name="tagName" select="./@name"/>
                    <xsl:with-param name="tagValue" select="./@value"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$targetTags">
                <xsl:call-template name="coreLayerTags">
                    <xsl:with-param name="elementUri" select="$roleURI"/>
                    <xsl:with-param name="tagName" select="./@name"/>
                    <xsl:with-param name="tagValue" select="./@value"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:for-each>

    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.14. Class generalisation — in core ontology layer. Specify subclass axiom
            for the generalisation between UML Classes. </xd:desc>
    </xd:doc>

    <xsl:template name="classGeneralization">
        <xsl:variable name="superClass" select="f:getSuperClassFromGeneralization(.)"/>
        <xsl:variable name="superClassURI" select="f:buildURIfromLexicalQName($superClass)"/>
        <xsl:variable name="subClasses" select="f:getSubClassesFromGeneralization(.)"/>
        <xsl:if test="f:getElementByIdRef(./source/@xmi:idref, root(.))">

            <xsl:for-each select="$subClasses">
                <xsl:if test="$generateReusedConceptsOWLcore or fn:substring-before(./@name, ':') = $includedPrefixesList">
                <xsl:variable name="subClassURI" select="f:buildURIFromElement(.)"/>
                <owl:Class rdf:about="{$subClassURI}">
                    <rdfs:subClassOf rdf:resource="{$superClassURI}"/>
                </owl:Class>
                </xsl:if>
            </xsl:for-each>

        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.19. - Declare an individual with a specified class as its type, for a UML
            Realization connector between a UML Object and a UML Class. </xd:desc>
        <xd:param name="realisation"/>
    </xd:doc>

    <xsl:template name="classRealisation">
        <xsl:param name="realisation" as="node()*"/>
        <xsl:variable name="sourceRole" select="$realisation/source/model/@name"/>
        <xsl:variable name="sourceRoleURI" select="f:buildURIfromLexicalQName($sourceRole)"/>
        <xsl:variable name="targetRole" select="$realisation/target/model/@name"/>
        <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
        <xsl:choose>
            <xsl:when test="$realisation/target/model/@type = 'Enumeration'">
                <skos:Concept rdf:about="{$sourceRoleURI}">
                    <skos:inScheme rdf:resource="{$targetRoleURI}"/>
                </skos:Concept>
            </xsl:when>
            <xsl:otherwise>
                <owl:NamedIndividual rdf:about="{$sourceRoleURI}">
                    <rdf:type rdf:resource="{$targetRoleURI}"/>
                </owl:NamedIndividual>
            </xsl:otherwise>
        </xsl:choose>



    </xsl:template>

</xsl:stylesheet>
