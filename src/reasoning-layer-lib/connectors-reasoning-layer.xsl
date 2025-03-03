<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f functx"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:functx="http://www.functx.com"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="../common/checkers.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>

    <xd:doc>
        <xd:desc>applying the reasoning layer rules to associations</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        <xsl:if test="not(f:isExcludedByStatus(.))">
        <xsl:if
            test="./source/model/@type = 'Class' and ./target/model/@type = 'Class'">
            <xsl:call-template name="connectorMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorAsymetry">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
        </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>applying the reasoning layer rules to dependencies</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <xsl:variable name="connectorRoleName" select="f:getRoleNameFromConnector(.)"/>
        <xsl:if test="not(f:isExcludedByStatus(.))">
        <xsl:if
            test="
                ./source/model/@type = 'Class' and ./target/model/@type = 'Class' and
                ($generateReusedConceptsOWLrestrictions or
                fn:substring-before($connectorRoleName, ':') = $includedPrefixesList)">
            <xsl:call-template name="connectorMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorAsymetry">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
            test="
                ./source/model/@type = 'Class' and ./target/model/@type = 'Enumeration' and
                ($generateReusedConceptsOWLrestrictions or
                fn:substring-before($connectorRoleName, ':') = $includedPrefixesList)">
            <xsl:call-template name="connectorDependencyRange">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
        </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>applying the reasoning layer rules to generalisations</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">
        <xsl:if test="not(f:isExcludedByStatus(.))">
        <!--        Filtering for external/internal concepts are inside the functions below due complexity of the functions-->
        <xsl:call-template name="classEquivalence">
            <xsl:with-param name="generalisation" select="."/>
        </xsl:call-template>
        <xsl:call-template name="propertiesEquivalence">
            <xsl:with-param name="generalisation" select="."/>
        </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <xd:doc>
        <xd:desc>Applying reasoning layer rules to generalisation connectors with distinct
            targets</xd:desc>
    </xd:doc>
    <xsl:template name="generalisationsWithDistinctTargetsInReasoningLayer">
        <xsl:variable name="generalisations"
            select="//connector[./properties/@ea_type = 'Generalization'][not(target/@xmi:idref = preceding::connector[./properties/@ea_type = 'Generalization']/target/@xmi:idref)]"/>
        <xsl:for-each select="$generalisations">
            <xsl:if test="not(f:isExcludedByStatus(.))">
            <xsl:if test="./source/model/@type = 'Class' and ./target/model/@type = 'Class'">
                <!-- Extract prefixes for source and target -->
                <xsl:variable name="sourcePrefix"
                    select="fn:substring-before(./source/model/@name, ':')"/>
                <xsl:variable name="targetPrefix"
                    select="fn:substring-before(./target/model/@name, ':')"/>
                <!-- Check if either the prefixes match the internal list or generateReusedConcepts is true -->
                <xsl:if
                    test="$generateReusedConceptsOWLrestrictions or $sourcePrefix = $includedPrefixesList">
                    <xsl:call-template name="disjointClasses">
                        <xsl:with-param name="generalisation" select="."/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>



    <xd:doc>
        <xd:desc>Applying reasoning layer rules to connectors with distinct names [Dependency and
            Association]</xd:desc>
    </xd:doc>
    <xsl:template name="distinctConnectorsNamesInReasoningLayer">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="distinctNames" select="f:getDistinctConnectorsNames($root)"/>
        <!--        TODO Figure out dependencies to Objects -->
        <xsl:for-each select="$distinctNames">
            <xsl:if test="not(f:isExcludedByStatus(f:getConnectorByName(., $root)[1]))">
            <xsl:if
                test="f:getConnectorByName(., $root)[1]/properties/@ea_type = ('Dependency', 'Association') and f:getConnectorByName(., $root)[1]/target/model/@type != 'Object'">
                <xsl:variable name="connectorElement" select="f:getConnectorByName(., $root)"/>
                <xsl:variable name="connectorRoleName" select="f:getRoleNameFromConnector($connectorElement)"/>
                <xsl:if
                    test="$generateReusedConceptsOWLrestrictions or fn:substring-before($connectorRoleName, ':') = $includedPrefixesList">
                    <xsl:call-template name="connectorDomain">
                        <xsl:with-param name="connectorName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                    <xsl:call-template name="connectorRange">
                        <xsl:with-param name="connectorName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                    <xsl:call-template name="connectorInverse">
                        <xsl:with-param name="connectorName" select="."/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <xd:doc>
        <xd:desc>Rule R.03. Association source — in reasoning layer. Specify object property domain
            for the target end of the association.</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>

    <xsl:template name="connectorDomain">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:variable name="targetRole" select="$connectorName"/>
        <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
        <!--        This will filter out all Dependencies that are from a Class to an Enumeration-->
        <!--<xsl:variable name="filteredConnectorsWithSameName"
            select="$connectorsWithSameName[not(./properties/@ea_type = 'Dependency' and ./source/model/@type = 'Class' and ./target/model/@type = 'Enumeration')]"
        />-->
        <!-- We need to provide Domain for Dependencies relations also (cf. EPO-620)-->
        <xsl:variable name="filteredConnectorsWithSameName" select="$connectorsWithSameName"/>

        <xsl:if test="fn:count($filteredConnectorsWithSameName) = 1">
            <xsl:variable name="classURI"
                select="
                    if ($filteredConnectorsWithSameName/target/role/@name = $connectorName) then
                        f:buildURIfromLexicalQName($filteredConnectorsWithSameName/source/model/@name)
                    else
                        f:buildURIfromLexicalQName($filteredConnectorsWithSameName/target/model/@name)
                    "/>
            <rdf:Description rdf:about="{$targetRoleURI}">
                <rdfs:domain rdf:resource="{$classURI}"/>
            </rdf:Description>
        </xsl:if>
        <xsl:if test="fn:count($filteredConnectorsWithSameName) > 1">
            <xsl:variable name="targetDomains"
                select="$filteredConnectorsWithSameName/target[role/@name = $connectorName]/../source/model/@name"
                as="xs:string*"/>
            <xsl:variable name="sourceDomains"
                select="$filteredConnectorsWithSameName/source[role/@name = $connectorName]/../target/model/@name"
                as="xs:string*"/>
            <xsl:variable name="domains" select="functx:value-union($targetDomains, $sourceDomains)"/>
            <rdf:Description rdf:about="{$targetRoleURI}">

                <xsl:choose>
                    <xsl:when test="fn:count($domains) > 1">
                        <rdfs:domain>
                            <owl:Class>
                                <owl:unionOf rdf:parseType="Collection">
                                    <xsl:for-each select="$domains">
                                        <rdf:Description rdf:about="{f:buildURIfromLexicalQName(.)}"
                                        />
                                    </xsl:for-each>
                                </owl:unionOf>
                            </owl:Class>
                        </rdfs:domain>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$domains">
                            <rdf:domain rdf:resource="{f:buildURIfromLexicalQName(.)}"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc> Rule R.04. Association target — in reasoning layer. Specify object property range
            for the target end of the association.</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>

    <xsl:template name="connectorRange">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:variable name="targetRole" select="$connectorName"/>
        <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
        <!-- This will filter out all Dependencies that are from a Class to an Enumeration-->
        <xsl:variable name="filteredConnectorsWithSameName"
            select="$connectorsWithSameName[not(./properties/@ea_type = 'Dependency' and ./source/model/@type = 'Class' and ./target/model/@type = 'Enumeration')]"/>

        <xsl:if
            test="fn:count($filteredConnectorsWithSameName) = 1 and fn:boolean($filteredConnectorsWithSameName/*[role/@name = $connectorName]/model/@name)">
            <rdf:Description rdf:about="{$targetRoleURI}">
                <rdfs:range
                    rdf:resource="{f:buildURIfromLexicalQName($filteredConnectorsWithSameName/*[role/@name =$connectorName]/model/@name)}"
                />
            </rdf:Description>
        </xsl:if>
        <xsl:if test="fn:count($filteredConnectorsWithSameName) > 1">
            <xsl:variable name="targetRanges"
                select="$filteredConnectorsWithSameName/target[role/@name = $connectorName]/model/@name"
                as="xs:string*"/>
            <xsl:variable name="sourceRanges"
                select="$filteredConnectorsWithSameName/source[role/@name = $connectorName]/model/@name"
                as="xs:string*"/>
            <xsl:variable name="ranges" select="functx:value-union($targetRanges, $sourceRanges)"/>
            <rdf:Description rdf:about="{$targetRoleURI}">


                <xsl:choose>
                    <xsl:when test="fn:count($ranges) > 1">
                        <rdfs:range>
                            <owl:Class>
                                <owl:unionOf rdf:parseType="Collection">
                                    <xsl:for-each select="$ranges">
                                        <rdf:Description rdf:about="{f:buildURIfromLexicalQName(.)}"
                                        />
                                    </xsl:for-each>
                                </owl:unionOf>
                            </owl:Class>
                        </rdfs:range>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$ranges">
                            <rdfs:range rdf:resource="{f:buildURIfromLexicalQName(.)}"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>


            </rdf:Description>
        </xsl:if>


    </xsl:template>



    <xd:doc>
        <xd:desc>Rule R.12. Dependency target — in reasoning layer. Specify object property range
            for the target end of the dependency.</xd:desc>
        <xd:param name="connector"/>
        <xd:param name="root"/>
    </xd:doc>

    <xsl:template name="connectorDependencyRange">
        <xsl:param name="connector"/>
        <xsl:param name="root"/>

        <xsl:variable name="targetRole" select="$connector/target/role/@name"/>
        <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>

        <rdf:Description rdf:about="{$targetRoleURI}">
            <rdfs:range rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
        </rdf:Description>

    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.09. Association asymmetry — in reasoning layer. Specify the asymmetry object
            property axiom for each end of a recursive association.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorAsymetry">
        <xsl:param name="connector"/>
        <xsl:if test="$connector/source/model/@name = $connector/target/model/@name">
            <xsl:variable name="targetRole"
                select="
                    if (boolean($connector/target/role/@name)) then
                        $connector/target/role/@name
                    else
                        fn:error(xs:QName('connectors'), concat($connector/@xmi:idref, ' - connector target role name is empty'))"/>
            <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>


            <rdf:Description rdf:about="{$targetRoleURI}">
                <rdf:type rdf:resource="http://www.w3.org/2002/07/owl#AsymmetricProperty"/>
            </rdf:Description>

        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.11. Association inverse — in reasoning layer . Specify inverse object
            property between the source and target ends of the association.</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>

    <xsl:template name="connectorInverse">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:variable name="bidirectionalConnectors"
            select="$connectorsWithSameName[properties/@direction = 'Bi-Directional' and target/role/@name = $connectorName]"/>
        <xsl:variable name="distinctTargets"
            select="fn:distinct-values($bidirectionalConnectors/target/role/@name)"/>

        <xsl:if test="fn:count($bidirectionalConnectors) = 1">
            <xsl:variable name="targetRole" select="$bidirectionalConnectors/target/role/@name"/>
            <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
            <xsl:variable name="sourceRole"
                select="
                    if (boolean($bidirectionalConnectors/source/role/@name)) then
                        $bidirectionalConnectors/source/role/@name
                    else
                        fn:error(xs:QName('connectors'), concat($bidirectionalConnectors/@xmi:idref, ' - connector source role name is empty'))"/>
            <xsl:variable name="sourceRoleURI" select="f:buildURIfromLexicalQName($sourceRole)"/>
            <rdf:Description rdf:about="{$targetRoleURI}">
                <owl:inverseOf rdf:resource="{$sourceRoleURI}"/>
            </rdf:Description>
        </xsl:if>
        <xsl:if test="fn:count($bidirectionalConnectors) > 1">
            <xsl:for-each select="$distinctTargets">
                <xsl:variable name="targetName" select="."/>
                <xsl:variable name="targetRole" select="$targetName"/>
                <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
                <xsl:variable name="sourcesFound"
                    select="$bidirectionalConnectors/source/role/@name"/>
                <xsl:for-each select="$sourcesFound">
                    <xsl:variable name="sourceRole" select="."/>
                    <xsl:variable name="sourceRoleURI"
                        select="f:buildURIfromLexicalQName($sourceRole)"/>
                    <rdf:Description rdf:about="{$targetRoleURI}">
                        <owl:inverseOf rdf:resource="{$sourceRoleURI}"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>




    <xd:doc>
        <xd:desc>Rule R.16. Equivalent classes — in reasoning layer .Specify equivalent class axiom
            for the generalisation with equivalent or complete stereotype between UML classes. </xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:template name="classEquivalence">
        <xsl:param name="generalisation"/>
        <xsl:if
            test="
                $generalisation/properties/@stereotype = ('equivalent', 'complete') and
                $generalisation/source/model/@type = 'Class' and $generalisation/target/model/@type = 'Class'">
            <xsl:variable name="sourceClassURI"
                select="f:buildURIfromLexicalQName($generalisation/source/model/@name)"/>
            <xsl:variable name="targetClassURI"
                select="f:buildURIfromLexicalQName($generalisation/target/model/@name)"/>
            <!-- Variables for the prefixes in source and target -->
            <xsl:variable name="sourcePrefix"
                select="fn:substring-before($generalisation/source/model/@name, ':')"/>
            <xsl:variable name="targetPrefix"
                select="fn:substring-before($generalisation/target/model/@name, ':')"/>
            <xsl:if
                test="
                    $generateReusedConceptsOWLrestrictions or
                    $sourcePrefix = $includedPrefixesList">

                <rdf:Description rdf:about="{$sourceClassURI}">
                    <owl:equivalentClass rdf:resource="{$targetClassURI}"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Rule R.17. Equivalent properties — in reasoning layer. Specify equivalent property
            axiom for the generalisation with equivalent or complete stereotype between UML
            properties. </xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:template name="propertiesEquivalence">
        <xsl:param name="generalisation"/>
        <xsl:if
            test="
                $generalisation/properties/@stereotype = ('equivalent', 'complete') and
                $generalisation/source/model/@type = 'ProxyConnector' and $generalisation/target/model/@type = 'ProxyConnector'">
            <xsl:variable name="targetIdref" select="$generalisation/target/@xmi:idref"
                as="xs:string"/>
            <xsl:variable name="sourceIdref" select="$generalisation/source/@xmi:idref"
                as="xs:string"/>
            <xsl:variable name="targetElement"
                select="f:getElementByIdRef($targetIdref, root($generalisation))"/>
            <xsl:variable name="sourceElement"
                select="f:getElementByIdRef($sourceIdref, root($generalisation))"/>
            <xsl:variable name="targetConnectorIdref" select="$targetElement/@classifier"
                as="xs:string"/>
            <xsl:variable name="sourceConnectorIdref" select="$sourceElement/@classifier"
                as="xs:string"/>
            <xsl:variable name="targetConnector"
                select="f:getConnectorByIdRef($targetConnectorIdref, root($generalisation))"/>
            <xsl:variable name="sourceConnector"
                select="f:getConnectorByIdRef($sourceConnectorIdref, root($generalisation))"/>

            <xsl:variable name="targetConnectorTargetRoleURI"
                select="f:buildURIfromLexicalQName($targetConnector/target/role/@name)"/>
            <xsl:variable name="targetConnectorSourceRoleURI"
                select="f:buildURIfromLexicalQName($targetConnector/source/role/@name)"/>
            <xsl:variable name="sourceConnectorTargetRoleURI"
                select="f:buildURIfromLexicalQName($sourceConnector/target/role/@name)"/>
            <xsl:variable name="sourceConnectorSourceRoleURI"
                select="f:buildURIfromLexicalQName($sourceConnector/source/role/@name)"/>


            <xsl:if
                test="
                    $generateReusedConceptsOWLrestrictions or
                    fn:substring-before($sourceConnector/source/model/@name, ':') = $includedPrefixesList">
                <rdf:Description rdf:about="{$sourceConnectorSourceRoleURI}">
                    <owl:equivalentProperty rdf:resource="{$targetConnectorSourceRoleURI}"/>
                </rdf:Description>
            </xsl:if>
            <xsl:if
                test="
                    $generateReusedConceptsOWLrestrictions or
                    fn:substring-before($targetConnector/source/model/@name, ':') = $includedPrefixesList">
                <rdf:Description rdf:about="{$sourceConnectorTargetRoleURI}">
                    <owl:equivalentProperty rdf:resource="{$targetConnectorTargetRoleURI}"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc> Rule R.06. Association multiplicity — in reasoning layer, Rule R.07. Association
            multiplicity "one" — in reasoning layer . For the association target multiplicity, where
            min and max are different than * (any) and multiplicity is not [1..1], specify a
            subclass axiom where the source class specialises an anonymous restriction of properties
            formulated according to cases provided by Rule 9.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorMultiplicity">
        <xsl:param name="connector"/>
        <xsl:variable name="targetMultiplicity"
            select="f:normalizeMultiplicity($connector/target/type/@multiplicity)"/>
        <xsl:variable name="targetMultiplicityMin"
            select="f:getMultiplicityMinFromString($targetMultiplicity)"/>
        <xsl:variable name="targetMultiplicityMax"
            select="f:getMultiplicityMaxFromString($targetMultiplicity)"/>
        <xsl:variable name="sourceMultiplicity"
            select="f:normalizeMultiplicity($connector/source/type/@multiplicity)"/>
        <xsl:variable name="sourceMultiplicityMin"
            select="f:getMultiplicityMinFromString($sourceMultiplicity)"/>
        <xsl:variable name="sourceMultiplicityMax"
            select="f:getMultiplicityMaxFromString($sourceMultiplicity)"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name)"/>
        <xsl:variable name="sourceRole"
            select="
                if (boolean($connector/source/role/@name)) then
                    $connector/source/role/@name
                else
                    ()
                "/>
        <xsl:variable name="sourceRoleURI"
            select="
                if (boolean($sourceRole)) then
                    f:buildURIfromLexicalQName($sourceRole)
                else
                    ()"/>
        <xsl:variable name="targetClassURI"
            select="f:buildURIfromLexicalQName($connector/target/model/@name)"/>
        <xsl:variable name="targetRole"
            select="
                if (boolean($connector/target/role/@name)) then
                    $connector/target/role/@name
                else
                    fn:error(xs:QName('connectors'), concat($connector/@xmi:idref, ' - connector target role name is empty'))"/>
        <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:variable name="datatypeURI" select="f:buildURIfromLexicalQName('xsd:integer')"/>
        <!--        this is first restriction content-->
        <xsl:variable name="sourceDestinationRestrictionContent" as="item()*">
            <xsl:choose>
                <xsl:when
                    test="
                        boolean($targetMultiplicityMax) and
                        boolean($targetMultiplicityMin) and
                        $targetMultiplicityMin = $targetMultiplicityMax">
                    <owl:cardinality rdf:datatype="{$datatypeURI}">
                        <xsl:value-of select="$targetMultiplicityMin"/>
                    </owl:cardinality>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="boolean($targetMultiplicityMax)">
                        <owl:maxCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$targetMultiplicityMax"/>
                        </owl:maxCardinality>
                    </xsl:if>
                    <xsl:if test="boolean($targetMultiplicityMin)">
                        <owl:minCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$targetMultiplicityMin"/>
                        </owl:minCardinality>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if
            test="
                $connectorDirection = 'Source -&gt; Destination' and
                boolean($targetMultiplicity) and boolean($sourceDestinationRestrictionContent)">
            <rdf:Description rdf:about="{$sourceClassURI}">
                <rdfs:subClassOf>
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$targetRoleURI}"/>
                        <xsl:copy-of select="$sourceDestinationRestrictionContent"/>
                    </owl:Restriction>
                </rdfs:subClassOf>
            </rdf:Description>
            <xsl:if test="$targetMultiplicityMin = '1' and $targetMultiplicityMax = '1'">
                <rdf:Description rdf:about="{$targetRoleURI}">
                    <rdf:type rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
        <!--        end of first restrictions content-->

        <!--        this is second restriction content-->
        <xsl:variable name="sourceInBidirectionalRestrictionContent" as="item()*">
            <xsl:choose>
                <xsl:when
                    test="
                        boolean($targetMultiplicityMax) and
                        boolean($targetMultiplicityMin) and
                        $targetMultiplicityMin = $targetMultiplicityMax">
                    <owl:cardinality rdf:datatype="{$datatypeURI}">
                        <xsl:value-of select="$targetMultiplicityMin"/>
                    </owl:cardinality>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="boolean($targetMultiplicityMax)">
                        <owl:maxCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$targetMultiplicityMax"/>
                        </owl:maxCardinality>
                    </xsl:if>
                    <xsl:if test="boolean($targetMultiplicityMin)">
                        <owl:minCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$targetMultiplicityMin"/>
                        </owl:minCardinality>
                    </xsl:if>

                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($targetMultiplicity) and boolean($sourceInBidirectionalRestrictionContent)">
            <rdf:Description rdf:about="{$sourceClassURI}">
                <rdfs:subClassOf>
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$targetRoleURI}"/>
                        <xsl:copy-of select="$sourceInBidirectionalRestrictionContent"/>
                    </owl:Restriction>
                </rdfs:subClassOf>
            </rdf:Description>
            <xsl:if test="$targetMultiplicityMin = '1' and $targetMultiplicityMax = '1'">
                <rdf:Description rdf:about="{$targetRoleURI}">
                    <rdf:type rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
        <!--        end of second restrictions content-->
        <!--        this is third restriction content-->
        <xsl:variable name="targetInBidirectionalRestrictionContent" as="item()*">
            <xsl:choose>
                <xsl:when
                    test="
                        boolean($sourceMultiplicityMax) and
                        boolean($sourceMultiplicityMin) and
                        $sourceMultiplicityMin = $sourceMultiplicityMax">
                    <owl:cardinality rdf:datatype="{$datatypeURI}">
                        <xsl:value-of select="$sourceMultiplicityMin"/>
                    </owl:cardinality>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="boolean($sourceMultiplicityMax)">
                        <owl:maxCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$sourceMultiplicityMax"/>
                        </owl:maxCardinality>
                    </xsl:if>
                    <xsl:if test="boolean($sourceMultiplicityMin)">
                        <owl:minCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$sourceMultiplicityMin"/>
                        </owl:minCardinality>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($sourceMultiplicity) and boolean($targetInBidirectionalRestrictionContent)">
            <rdf:Description rdf:about="{$targetClassURI}">
                <rdfs:subClassOf>
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$sourceRoleURI}"/>
                        <xsl:copy-of select="$targetInBidirectionalRestrictionContent"/>
                    </owl:Restriction>
                </rdfs:subClassOf>
            </rdf:Description>
            <xsl:if test="$sourceMultiplicityMin = '1' and $sourceMultiplicityMax = '1'">
                <rdf:Description rdf:about="{$sourceRoleURI}">
                    <rdf:type rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
        <!--       end of third restriction content-->
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.18. Disjoint classes — in reasoning layer. Specify a disjoint classes axiom
            for all "sibling" classes, i.e. for multiple UML Classes that have generalisation
            connectors to the same UML Class. </xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>

    <xsl:template name="disjointClasses">
        <xsl:param name="generalisation"/>

        <xsl:variable name="superClass" select="f:getSuperClassFromGeneralization($generalisation)"/>
        <xsl:variable name="superClassURI" select="f:buildURIfromLexicalQName($superClass)"/>
        <xsl:variable name="subClasses" select="f:getSubClassesFromGeneralization($generalisation)"/>
        <xsl:if
            test="f:getElementByIdRef($generalisation/source/@xmi:idref, root($generalisation)) and count($subClasses) > 1">

            <rdf:Description>
                <rdf:type rdf:resource="http://www.w3.org/2002/07/owl#AllDisjointClasses"/>
                <owl:members rdf:parseType="Collection">
                    <xsl:for-each select="$subClasses">
                        <xsl:variable name="subClassURI" select="f:buildURIFromElement(.)"/>
                        <rdf:Description rdf:about="{$subClassURI}"/>
                    </xsl:for-each>
                </owl:members>
            </rdf:Description>

        </xsl:if>

    </xsl:template>

    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Realisation']"/>

</xsl:stylesheet>


