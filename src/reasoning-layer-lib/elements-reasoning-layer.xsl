<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi fn f functx"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:functx="http://www.functx.com"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" version="3.0">

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="../common/checkers.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>



    <xd:doc>
        <xd:desc>Applying reasoning layer rule to all attributes</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">
        <xsl:if test="not(f:isExcludedByStatus(.))">
            <xsl:call-template name="attributeMultiplicity">
                <xsl:with-param name="attribute" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Applying reasoning layer rules to attributes with distinct names</xd:desc>
    </xd:doc>
    <xsl:template name="distinctAttributeNamesInReasoningLayer">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="distinctNames" select="f:getDistinctClassAttributeNames($root)"/>
        <xsl:for-each select="$distinctNames">
            <xsl:if test="not(f:isExcludedByStatus(f:getClassAttributeByName(., $root)[1]))">
            <!-- Extract the prefix from the attribute name -->
            <xsl:variable name="attributePrefix" select="fn:substring-before(., ':')"/>

            <!-- Check if the attribute should be processed -->
            <xsl:if
                test="$generateReusedConceptsOWLrestrictions or $attributePrefix = $includedPrefixesList">
                <xsl:call-template name="attributeDomain">
                    <xsl:with-param name="attributeName" select="."/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
                <xsl:call-template name="attributeRange">
                    <xsl:with-param name="attributeName" select="."/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
                <xsl:call-template name="attributeMultiplicityOne">
                    <xsl:with-param name="attributeName" select="."/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
            </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <xd:doc>
        <xd:desc>Rule C.10. Attribute multiplicity "one"  — in reasoning layer . For each attribute
            that has multiplicity exactly one, i.e. [1..1], specify functional property
            axiom.</xd:desc>
        <xd:param name="root"/>
        <xd:param name="attributeName"/>
    </xd:doc>
    <xsl:template name="attributeMultiplicityOne">
        <xsl:param name="attributeName"/>
        <xsl:param name="root"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:variable name="attributeURI" select="f:buildURIFromElement($attributesWithSameName[1])"/>
        <xsl:variable name="attributeMultiplicityMinValues"
            select="$attributesWithSameName/bounds/@lower"/>
        <xsl:variable name="attributeMultiplicityMaxValues"
            select="$attributesWithSameName/bounds/@upper"/>
        <xsl:variable name="areAllMinValuesOne"
            select="f:areStringsEqual($attributeMultiplicityMinValues) and $attributeMultiplicityMinValues[1] = '1'"
            as="xs:boolean"/>
        <xsl:variable name="areAllMaxValuesOne"
            select="f:areStringsEqual($attributeMultiplicityMaxValues) and $attributeMultiplicityMaxValues[1] = '1'"
            as="xs:boolean"/>

        <xsl:if test="$areAllMinValuesOne and $areAllMaxValuesOne">
            <rdf:Description rdf:about="{$attributeURI}">
                <rdf:type rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
            </rdf:Description>
        </xsl:if>

    </xsl:template>

    <xd:doc>
        <xd:desc>Rule C.05. Attribute domain — in reasoning layer. Specify data (or object) property
            domains for attribute(s).</xd:desc>
        <xd:param name="root"/>
        <xd:param name="attributeName"/>
    </xd:doc>

    <xsl:template name="attributeDomain">
        <xsl:param name="root"/>
        <xsl:param name="attributeName"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:variable name="attributeURI" select="f:buildURIFromElement($attributesWithSameName[1])"/>
        <xsl:choose>
            <xsl:when test="fn:count($attributesWithSameName) = 1">
                <rdf:Description rdf:about="{$attributeURI}">
                    <rdfs:domain
                        rdf:resource="{f:buildURIfromLexicalQName($attributesWithSameName/../../@name)}"
                    />
                </rdf:Description>
            </xsl:when>
            <xsl:otherwise>
                <rdf:Description rdf:about="{$attributeURI}">
                    <rdfs:domain>
                        <owl:Class>
                            <owl:unionOf rdf:parseType="Collection">
                                <xsl:for-each select="$attributesWithSameName">
                                    <owl:Class
                                        rdf:about="{f:buildURIfromLexicalQName(./../../@name)}"/>
                                </xsl:for-each>
                            </owl:unionOf>
                        </owl:Class>
                    </rdfs:domain>
                </rdf:Description>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc> Rule C.07. Attribute type — in reasoning layer. Specify data (or object) property
            range for attribute(s).</xd:desc>
        <xd:param name="root"/>
        <xd:param name="attributeName"/>
    </xd:doc>

    <xsl:template name="attributeRange">
        <xsl:param name="root"/>
        <xsl:param name="attributeName"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:variable name="distinctAttributeTypesFound"
            select="fn:distinct-values($attributesWithSameName/properties/@type)"/>
        <xsl:variable name="attributeURI" select="f:buildURIFromElement($attributesWithSameName[1])"/>
        <xsl:choose>
            <xsl:when
                test="fn:count($attributesWithSameName) = 1 or fn:count($distinctAttributeTypesFound) = 1">
                <xsl:variable name="attributeType"
                    select="$attributesWithSameName[1]/properties/@type"/>

                <xsl:variable name="attributeTypeChecked"
                    select="
                        if (boolean(f:getUmlDataTypeValues($attributeType, $umlDataTypesMapping))) then
                            f:getUmlDataTypeValues($attributeType, $umlDataTypesMapping)
                        else
                            $attributeType"/>
                <xsl:variable name="attributeTypeURI"
                    select="
                        if ($attributeType = $controlledListType) then
                            f:buildURIfromLexicalQName('skos:Concept')
                        else
                            f:buildURIfromLexicalQName($attributeTypeChecked)"/>

                <rdf:Description rdf:about="{$attributeURI}">
                    <rdfs:range rdf:resource="{$attributeTypeURI}"/>
                </rdf:Description>
            </xsl:when>
            <xsl:otherwise>
                <rdf:Description rdf:about="{$attributeURI}">
                    <rdfs:range>
                        <owl:Class>
                            <owl:unionOf rdf:parseType="Collection">
                                <xsl:for-each select="$distinctAttributeTypesFound">
                                    <xsl:variable name="attributeTypeURI"
                                        select="
                                            if (. = $controlledListType) then
                                                f:buildURIfromLexicalQName('skos:Concept')
                                            else
                                                f:buildURIfromLexicalQName(.)"/>
                                    <owl:Class rdf:about="{$attributeTypeURI}"/>
                                </xsl:for-each>
                            </owl:unionOf>
                        </owl:Class>
                    </rdfs:range>
                </rdf:Description>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>

    <xd:doc>
        <xd:desc>Rule C.09. Attribute multiplicity — in reasoning layer .For each attribute
            multiplicity of the form ( min .. max ), where min and max are diferent than * (any),
            specify a subclass axiom where the OWL class, corresponding to the UML class,
            specialises an anonymous restriction of properties formulated according to the following
            cases 1. exact cardinality, e.g. [2..2] 2. minimum cardinality only, e.g. [1..*] 3.
            maximum cardinality only, e.g. [*..2] 4. maximum and maximum cardinality , e.g. [1..2] </xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>

    <xsl:template name="attributeMultiplicity">
        <xsl:param name="attribute"/>
        <xsl:variable name="attributeMultiplicityMin"
            select="f:getAttributeValueToDisplay($attribute/bounds/@lower)"/>
        <xsl:variable name="attributeMultiplicityMax"
            select="f:getAttributeValueToDisplay($attribute/bounds/@upper)"/>
        <xsl:variable name="className" select="$attribute/../../@name"/>
        <xsl:variable name="classURI" select="f:buildURIfromLexicalQName($className)"/>
        <xsl:variable name="datatypeURI" select="f:buildURIfromLexicalQName('xsd:integer')"/>
        <xsl:variable name="attributeURI" select="f:buildURIFromElement($attribute)"/>
        <!--if both min and max vaules are present choose whether they are equal or not-->
        <xsl:if test="boolean($attributeMultiplicityMin) and boolean($attributeMultiplicityMax)">
            <rdf:Description rdf:about="{$classURI}">
                <rdfs:subClassOf>
                    <xsl:choose>
                        <xsl:when test="$attributeMultiplicityMin = $attributeMultiplicityMax">
                            <owl:Restriction>
                                <owl:onProperty rdf:resource="{$attributeURI}"/>
                                <owl:cardinality rdf:datatype="{$datatypeURI}">
                                    <xsl:value-of select="$attributeMultiplicityMin"/>
                                </owl:cardinality>
                            </owl:Restriction>
                        </xsl:when>
                        <xsl:otherwise>
                            <owl:Class>
                                <owl:intersectionOf rdf:parseType="Collection">
                                    <owl:Restriction>
                                        <owl:onProperty rdf:resource="{$attributeURI}"/>
                                        <owl:minCardinality rdf:datatype="{$datatypeURI}">
                                            <xsl:value-of select="$attributeMultiplicityMin"/>
                                        </owl:minCardinality>
                                    </owl:Restriction>
                                    <owl:Restriction>
                                        <owl:onProperty rdf:resource="{$attributeURI}"/>
                                        <owl:maxCardinality rdf:datatype="{$datatypeURI}">
                                            <xsl:value-of select="$attributeMultiplicityMax"/>
                                        </owl:maxCardinality>
                                    </owl:Restriction>
                                </owl:intersectionOf>
                            </owl:Class>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdfs:subClassOf>
            </rdf:Description>
        </xsl:if>
        <!--        if only min or max is present choose the value that exist-->
        <xsl:if
            test="not(boolean($attributeMultiplicityMin)) and boolean($attributeMultiplicityMax)">
            <rdf:Description rdf:about="{$classURI}">
                <rdfs:subClassOf>
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$attributeURI}"/>
                        <owl:maxCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$attributeMultiplicityMax"/>
                        </owl:maxCardinality>
                    </owl:Restriction>
                </rdfs:subClassOf>
            </rdf:Description>
        </xsl:if>
        <xsl:if
            test="not(boolean($attributeMultiplicityMax)) and boolean($attributeMultiplicityMin)">
            <rdf:Description rdf:about="{$classURI}">
                <rdfs:subClassOf>
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$attributeURI}"/>
                        <owl:minCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$attributeMultiplicityMin"/>
                        </owl:minCardinality>
                    </owl:Restriction>
                </rdfs:subClassOf>
            </rdf:Description>
        </xsl:if>

    </xsl:template>




    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']"/>


    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:DataType']"/>

    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute"/>





    <xd:doc>
        <xd:desc>Rule D.04. Enumeration — in reasoning layer . For a UML enumeration, specify an
            equivalent class restriction covering the set of individuals that are skos:inScheme of
            this enumeration.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">
        <xsl:if test="$enableGenerationOfConceptSchemes">
            <xsl:if test="not(f:isExcludedByStatus(.))">
            <xsl:variable name="enumerationPrefix" select="fn:substring-before(./@name, ':')"/>
            <!-- Check if the Enumeration should be processed -->
            <xsl:if
                test="$generateReusedConceptsOWLrestrictions or $enumerationPrefix = $includedPrefixesList">
                <xsl:variable name="enumerationURI" select="f:buildURIFromElement(.)"/>
                <owl:Class rdf:about="{$enumerationURI}">
                    <owl:equivalentClass>
                        <owl:Restriction>
                            <owl:onProperty
                                rdf:resource="http://www.w3.org/2004/02/skos/core#inScheme"/>
                            <owl:hasValue rdf:resource="{$enumerationURI}"/>
                        </owl:Restriction>
                    </owl:equivalentClass>
                    <rdfs:subClassOf rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
                </owl:Class>
            </xsl:if>
            </xsl:if> 
        </xsl:if>
    </xsl:template>




</xsl:stylesheet>