<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi fn f"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI elements are transformed into OWL2
                statements</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="descriptors-owl-core.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>


    <xd:doc>
        <xd:desc> Selector to run core layer transformation rules for classes</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:if
            test="not(fn:contains(f:buildURIfromLexicalQName(./@name), $base-ontology-uri)) and $generateReusedConcepts">
            <xsl:call-template name="classDeclaration"/>
        </xsl:if>
        <xsl:if test="fn:contains(f:buildURIfromLexicalQName(./@name), $base-ontology-uri)">
            <xsl:call-template name="classDeclaration"/>
        </xsl:if>

    </xsl:template>

    <xd:doc>
        <xd:desc>Rule C.01 Specify declaration axiom for UML Class as OWL Class where the URI and a
            label are deterministically generated from the class name. The label and, if available,
            the description are ascribed to the class.</xd:desc>
    </xd:doc>
    <xsl:template name="classDeclaration">
        <xsl:variable name="className" select="./@name"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <xsl:variable name="classURI" select="f:buildURIFromElement(.)"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>

        <owl:Class rdf:about="{$classURI}"/>

        <xsl:call-template name="coreLayerName">
            <xsl:with-param name="elementName" select="$className"/>
            <xsl:with-param name="elementUri" select="$classURI"/>
        </xsl:call-template>
        <xsl:if test="$documentation != ''">
            <xsl:call-template name="coreLayerDescription">
                <xsl:with-param name="definition" select="$documentation"/>
                <xsl:with-param name="elementUri" select="$classURI"/>
            </xsl:call-template>
        </xsl:if>
        <!--   TODO ADD COMMENT RULE T05-->

        <xsl:call-template name="coreDefinedBy">
            <xsl:with-param name="elementUri" select="$classURI"/>
        </xsl:call-template>

    </xsl:template>

    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute"/>




    <xd:doc>
        <xd:desc> Getting all distinct attributes and run core layer transformation rules for class
            attributes</xd:desc>
    </xd:doc>
    <xsl:template name="generatePropertiesFromDistinctAttributeNamesInCore">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="distinctNames" select="f:getDistinctClassAttributeNames($root)"/>
        <xsl:for-each select="$distinctNames">
            <xsl:if
                test="not(fn:contains(f:buildURIfromLexicalQName(.), $base-ontology-uri)) and $generateReusedConcepts">
                <xsl:call-template name="generatePropertyFromAttribute">
                    <xsl:with-param name="attributeName" select="."/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="fn:contains(f:buildURIfromLexicalQName(.), $base-ontology-uri)">
                <xsl:call-template name="generatePropertyFromAttribute">
                    <xsl:with-param name="attributeName" select="."/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc> Rule C.04. Class attribute — in core ontology layer - Specify declaration axiom(s)
            for attribute(s) of a UML Class as OWL data or object properties, deciding based on
            their types. The attributes with primary types should be treated as data properties,
            whereas those typed with classes or enumerations should be treated as object
            properties.></xd:desc>
        <xd:param name="attributeName"/>
        <xd:param name="root"/>
    </xd:doc>


    <xsl:template name="generatePropertyFromAttribute">
        <xsl:param name="attributeName"/>
        <xsl:param name="root"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:variable name="distinctAttributeTypesFound"
            select="fn:distinct-values($attributesWithSameName/properties/@type)"/>
        <xsl:variable name="attributeURI" select="f:buildURIFromElement($attributesWithSameName[1])"/>

        <!--    begin aggregate definitions-->
        <xsl:variable name="definitionValues" select="$attributesWithSameName/documentation/@value"/>
        <xsl:variable name="descriptionsWithAnnotationsSequnce" as="xs:string*"
            select="
                for $attribute in $attributesWithSameName
                return
                    if ($attribute/documentation/@value) then
                        fn:concat(f:formatDocString($attribute/documentation/@value), ' (', $attribute/../../@name, ') ')
                    else
                        ()"/>
        <xsl:variable name="descriptionsWithAnnotations" as="xs:string"
            select="fn:string-join($descriptionsWithAnnotationsSequnce)"/>

        <!--    end agrregate definitions-->
        <xsl:variable name="firstAttribute" select="$attributesWithSameName[1]"/>
        <!--   decide what type of property is defined -->
        <xsl:variable name="propertyType"
            select="
                if (f:isAttributeTypeValidForDatatypeProperty($firstAttribute)) then
                    'owl:DatatypeProperty'
                else
                    if (f:isAttributeTypeValidForObjectProperty($firstAttribute)) then
                        'owl:ObjectProperty'
                    else
                        'rdf:Property'"/>

        <xsl:variable name="name"
            select="
                if (boolean($firstAttribute/@name)) then
                    f:lexicalQNameToWords($firstAttribute/@name)
                else
                    fn:error(xs:QName('attribute'), concat($firstAttribute/@xmi:idref, ' - Attribute with no name'))"/>
        <xsl:variable name="className" select="$firstAttribute/../../@name" as="xs:string"/>
        <xsl:variable name="isAttributeWithDependencyName"
            select="f:getConnectorByName($firstAttribute/@name, $root)[source/model/@name = $className]"/>

        <xsl:if test="not($isAttributeWithDependencyName)">
            <xsl:element name="{$propertyType}">
                <xsl:attribute name="rdf:about" select="$attributeURI"/>
            </xsl:element>


            <xsl:call-template name="coreLayerName">
                <xsl:with-param name="elementName" select="$attributeName"/>
                <xsl:with-param name="elementUri" select="$attributeURI"/>
            </xsl:call-template>

            <xsl:if test="boolean($descriptionsWithAnnotations)">
                <xsl:call-template name="coreLayerDescription">
                    <xsl:with-param name="definition" select="$descriptionsWithAnnotations"/>
                    <xsl:with-param name="elementUri" select="$attributeURI"/>
                </xsl:call-template>
            </xsl:if>

            <!--   TODO ADD COMMENT RULE T05-->

            <xsl:call-template name="coreDefinedBy">
                <xsl:with-param name="elementUri" select="$attributeURI"/>
            </xsl:call-template>


        </xsl:if>


    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:desc> Selector to run core layer transformation rules for data types Rule D.02. will
                be applied using class declaration template </xd:desc>
        </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:DataType']">
        <xsl:if
            test="not(fn:contains(f:buildURIfromLexicalQName(./@name), $base-ontology-uri)) and $generateReusedConcepts">
            <xsl:choose>
                <xsl:when test="./not(attributes) = fn:true()">
                    <xsl:call-template name="datatypeDeclaration"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="classDeclaration"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="fn:contains(f:buildURIfromLexicalQName(./@name), $base-ontology-uri)">
            <xsl:choose>
                <xsl:when test="./not(attributes) = fn:true()">
                    <xsl:call-template name="datatypeDeclaration"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="classDeclaration"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p> Rule D.01. Datatype — in core ontology layer.Specify datatype declaration
                axiom.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="datatypeDeclaration">
        <xsl:variable name="dataTypeName" select="./@name"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <xsl:variable name="dataTypeURI" select="f:buildURIFromElement(.)"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>

        <rdfs:Datatype rdf:about="{$dataTypeURI}"/>

        <xsl:call-template name="coreLayerName">
            <xsl:with-param name="elementName" select="$dataTypeName"/>
            <xsl:with-param name="elementUri" select="$dataTypeURI"/>
        </xsl:call-template>
        <xsl:if test="$documentation != ''">
            <xsl:call-template name="coreLayerDescription">
                <xsl:with-param name="definition" select="$documentation"/>
                <xsl:with-param name="elementUri" select="$dataTypeURI"/>
            </xsl:call-template>
        </xsl:if>
        <!--   TODO ADD COMMENT RULE T05-->

        <xsl:call-template name="coreDefinedBy">
            <xsl:with-param name="elementUri" select="$dataTypeURI"/>
        </xsl:call-template>

    </xsl:template>



    <xd:doc>
        <xd:desc>Rule D.03. Enumeration — in core ontology layer. Specify SKOS concept scheme
            instantiation axiom for a UML enumeration. </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">
        <xsl:if test="$enableGenerationOfConceptSchemes">
            <xsl:variable name="conceptSchemeName" select="./@name"/>

            <xsl:variable name="conceptSchemeURI" select="f:buildURIFromElement(.)"/>
            <xsl:variable name="documentation"
                select="f:formatDocString(./properties/@documentation)"/>


            <xsl:if
                test="not(fn:contains($conceptSchemeURI, $base-ontology-uri)) and $generateReusedConcepts">
                <skos:ConceptScheme rdf:about="{$conceptSchemeURI}"/>

                <xsl:call-template name="coreLayerName">
                    <xsl:with-param name="elementName" select="$conceptSchemeName"/>
                    <xsl:with-param name="elementUri" select="$conceptSchemeURI"/>
                </xsl:call-template>
                <xsl:if test="$documentation != ''">
                    <xsl:call-template name="coreLayerDescription">
                        <xsl:with-param name="definition" select="$documentation"/>
                        <xsl:with-param name="elementUri" select="$conceptSchemeURI"/>
                    </xsl:call-template>
                </xsl:if>
                <!--   TODO ADD COMMENT RULE T05-->

                <xsl:call-template name="coreDefinedBy">
                    <xsl:with-param name="elementUri" select="$conceptSchemeURI"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="fn:contains($conceptSchemeURI, $base-ontology-uri)">
                <skos:ConceptScheme rdf:about="{$conceptSchemeURI}"/>
                
                <xsl:call-template name="coreLayerName">
                    <xsl:with-param name="elementName" select="$conceptSchemeName"/>
                    <xsl:with-param name="elementUri" select="$conceptSchemeURI"/>
                </xsl:call-template>
                <xsl:if test="$documentation != ''">
                    <xsl:call-template name="coreLayerDescription">
                        <xsl:with-param name="definition" select="$documentation"/>
                        <xsl:with-param name="elementUri" select="$conceptSchemeURI"/>
                    </xsl:call-template>
                </xsl:if>
                <!--   TODO ADD COMMENT RULE T05-->
                
                <xsl:call-template name="coreDefinedBy">
                    <xsl:with-param name="elementUri" select="$conceptSchemeURI"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>

    </xsl:template>



    <xd:doc>
        <xd:desc>Rule D.05. Enumeration items — in core ontology layer. Specify SKOS concept
            instantiation axiom for each UML enumeration item. </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute">

        <xsl:if test="$enableGenerationOfSkosConcept">
            <xsl:variable name="enumerationAttributeName"
                select="
                    if (boolean(./initial/@body)) then
                        ./initial/@body
                    else
                        ./@name"/>
            <xsl:variable name="enumerationAttributeURI" select="f:buildURIFromElement(.)"/>
            <xsl:variable name="enumerationURI" select="f:buildURIFromElement(../..)"/>
            <xsl:variable name="documentation" select="f:formatDocString(./documentation/@value)"/>

            <xsl:if
                test="not(fn:contains($enumerationAttributeURI, $base-ontology-uri)) and $generateReusedConcepts">
                
                <skos:Concept rdf:about="{$enumerationAttributeURI}">
                    <skos:inScheme rdf:resource="{$enumerationURI}"/>

                </skos:Concept>

                <xsl:call-template name="coreLayerName">
                    <xsl:with-param name="elementName" select="$enumerationAttributeName"/>
                    <xsl:with-param name="elementUri" select="$enumerationAttributeURI"/>
                </xsl:call-template>
                <xsl:if test="$documentation != ''">
                    <xsl:call-template name="coreLayerDescription">
                        <xsl:with-param name="definition" select="$documentation"/>
                        <xsl:with-param name="elementUri" select="$enumerationAttributeURI"/>
                    </xsl:call-template>
                </xsl:if>
                <!--   TODO ADD COMMENT RULE T05-->

                <xsl:call-template name="coreDefinedBy">
                    <xsl:with-param name="elementUri" select="$enumerationAttributeURI"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="fn:contains($enumerationAttributeURI, $base-ontology-uri)">
                
                <skos:Concept rdf:about="{$enumerationAttributeURI}">
                    <skos:inScheme rdf:resource="{$enumerationURI}"/>
                    
                </skos:Concept>
                
                <xsl:call-template name="coreLayerName">
                    <xsl:with-param name="elementName" select="$enumerationAttributeName"/>
                    <xsl:with-param name="elementUri" select="$enumerationAttributeURI"/>
                </xsl:call-template>
                <xsl:if test="$documentation != ''">
                    <xsl:call-template name="coreLayerDescription">
                        <xsl:with-param name="definition" select="$documentation"/>
                        <xsl:with-param name="elementUri" select="$enumerationAttributeURI"/>
                    </xsl:call-template>
                </xsl:if>
                <!--   TODO ADD COMMENT RULE T05-->
                
                <xsl:call-template name="coreDefinedBy">
                    <xsl:with-param name="elementUri" select="$enumerationAttributeURI"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <!--    <xd:doc>
        <xd:desc>uml:Package has no equivalent on OWL ontology.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Package']"/>-->







</xsl:stylesheet>