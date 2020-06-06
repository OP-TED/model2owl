<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f functx"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:f="http://https://github.com/costezki/model2owl#" xmlns:sh="http://www.w3.org/ns/shacl#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:functx="http://www.functx.com"
    version="3.0">

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="../common/checkers.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>



    <xd:doc>
        <xd:desc>..................</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">
        <xsl:call-template name="attributeDomain">
            <xsl:with-param name="attribute" select="."/>
        </xsl:call-template>
        <xsl:call-template name="attributeRange">
            <xsl:with-param name="attribute" select="."/>
        </xsl:call-template>
        <xsl:call-template name="attributeMultiplicity">
            <xsl:with-param name="attribute" select="."/>
        </xsl:call-template>
        <xsl:call-template name="attributeMultiplicityOne">
            <xsl:with-param name="attribute" select="."/>
        </xsl:call-template>
    </xsl:template>


    <xd:doc>
        <xd:desc>Rule 5 (Attribute domain in reasnoning layer) Specify data (or object) property
            domains for attribute(s).</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>

    <xsl:template name="attributeDomain">
        <xsl:param name="attribute"/>
        <xsl:variable name="className" select="$attribute/../../@name"/>
        <xsl:variable name="classURI" select="f:buildURIfromLexicalQName($className, fn:true())"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromAttribute($attribute, fn:false(), fn:true())"/>
        <rdf:Description rdf:about="{$attributeURI}">
            <rdfs:domain rdf:resource="{$classURI}"/>
        </rdf:Description>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule 6 (Attribute type in reasnoning layer) . Specify data (or object) property
            range for attribute(s).</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>

    <xsl:template name="attributeRange">
        <xsl:param name="attribute"/>
        <xsl:variable name="className" select="$attribute/../../@name"/>
        <xsl:variable name="classURI" select="f:buildURIfromLexicalQName($className, fn:true())"/>
        <xsl:variable name="attributeType" select="$attribute/properties/@type"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromAttribute($attribute, fn:false(), fn:true())"/>
        <xsl:if test="f:isAttributeTypeValidForDatatypeProperty($attribute)">
            <xsl:variable name="attributeTypeURI"
                select="f:buildURIfromLexicalQName($attributeType, fn:false())"/>
            <owl:DatatypeProperty rdf:about="{$attributeURI}">
                <rdfs:range rdf:resource="{$attributeTypeURI}"/>
            </owl:DatatypeProperty>
        </xsl:if>
        <xsl:if
            test="
                f:isAttributeTypeValidForObjectProperty($attribute) or
                boolean(f:getElementByName($attributeType, root($attribute)))">
            <xsl:variable name="classURI"
                select="f:buildURIFromElement(f:getElementByName($attributeType, root($attribute)), fn:true(), fn:true())"/>
            <owl:ObjectProperty rdf:about="{$attributeURI}">
                <rdfs:range rdf:resource="{$classURI}"/>
            </owl:ObjectProperty>
        </xsl:if>

    </xsl:template>

    <xd:doc>
        <xd:desc>Rule 9 (Attribute multiplicity in reasnoning layer).For each attribute multiplicity
            of the form ( min .. max ), where min and max are diferent than * (any), specify a
            subclass axiom where the OWL class, corresponding to the UML class, specialises an
            anonymous restriction of properties formulated according to the cases</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>

    <xsl:template name="attributeMultiplicity">
        <xsl:param name="attribute"/>
        <xsl:variable name="attributeMultiplicityMin" select="$attribute/bounds/@lower"/>
        <xsl:variable name="attributeMultiplicityMax" select="$attribute/bounds/@upper"/>
        <xsl:variable name="className" select="$attribute/../../@name"/>
        <xsl:variable name="classURI" select="f:buildURIfromLexicalQName($className, fn:true())"/>
        <xsl:variable name="datatypeURI"
            select="f:buildURIfromLexicalQName('xsd:integer', fn:false())"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromAttribute($attribute, fn:false(), fn:true())"/>
        <owl:Class rdf:about="{$classURI}">
            <rdfs:subClassOf>
                <xsl:if test="$attributeMultiplicityMin != '*' and $attributeMultiplicityMax != '*'">
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
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="$attributeMultiplicityMin = '*'">
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$attributeURI}"/>
                        <owl:maxCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$attributeMultiplicityMax"/>
                        </owl:maxCardinality>
                    </owl:Restriction>
                </xsl:if>
                <xsl:if test="$attributeMultiplicityMax = '*'">
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$attributeURI}"/>
                        <owl:minCardinality rdf:datatype="{$datatypeURI}">
                            <xsl:value-of select="$attributeMultiplicityMin"/>
                        </owl:minCardinality>
                    </owl:Restriction>
                </xsl:if>
            </rdfs:subClassOf>
        </owl:Class>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule 10 (Attribute multiplicity one in reasnoning layer) . For each attribute that
            has multiplicity exactly one, i.e. [1..1], specify functional property axiom.</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:template name="attributeMultiplicityOne">
        <xsl:param name="attribute"/>
        <xsl:variable name="attributeMultiplicityMin" select="$attribute/bounds/@lower"/>
        <xsl:variable name="attributeMultiplicityMax" select="$attribute/bounds/@upper"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromAttribute($attribute, fn:false(), fn:true())"/>
        <xsl:if test="$attributeMultiplicityMin = 1 and $attributeMultiplicityMax = 1">
            <rdf:Description
                rdf:about="{$attributeURI}">
                <rdf:type
                    rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>(Enumeration in reasnoning layer) . Concept instantiation in RDF/XML For an UML
            enumeration, specify an equivalent class restriction covering the set of individuals
            that are skos:inScheme of this enumeration.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">
        <xsl:variable name="enumerationURI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <owl:Class rdf:about="{$enumerationURI}">
            <rdfs:subClassOf rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
            <owl:equivalentClass>
                <owl:Restriction>
                    <owl:onProperty rdf:resource="http://www.w3.org/2004/02/skos/core#inScheme"/>
                    <owl:hasValue rdf:resource="{$enumerationURI}"/>
                </owl:Restriction>
            </owl:equivalentClass>
        </owl:Class>
    </xsl:template>




</xsl:stylesheet>