<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi fn f"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"         
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"    
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 21, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>This module defines how selected XMI elements are transformed into OWL2
                statements</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>
    <xsl:import href="../common/checkers.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>

    <xd:doc>
        <xd:desc> [Rule 2]- (Class in data shape layer). Specify declaration axiom for UML Class as
            SHACL Node Shape where the URI and a label are deterministically generated from the
            class name.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:call-template name="classDeclaration"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 27]-(Enumeration in core ontology layer) .
            instantiation axiom for an UML enumeration.Specify SKOS concept scheme</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']">

        <xsl:variable name="conceptSchemeName" select="f:lexicalQNameToWords(./@name)"/>

        <xsl:variable name="conceptSchemeURI"
            select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>
        <!-- generating the actual CS content -->
        <skos:ConceptScheme rdf:about="{$conceptSchemeURI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$conceptSchemeName"/>
            </rdfs:label>
            <skos:prefLabel>
                <xsl:value-of select="$conceptSchemeName"/>
            </skos:prefLabel>

            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>     
        </skos:ConceptScheme>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 28]-(Enumeration items in core ontology layer) .
            instantiation axiom for an UML enumeration item. Specify SKOS concept</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute">
        
        <xsl:if test="$enableGenerationOfSkosConcept">
        <xsl:variable name="conceptName"
            select="
                if (boolean(./initial/@body)) then
                    ./initial/@body
                else
                    f:lexicalQNameToWords(./@name)"/>
        <xsl:variable name="conceptURI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="notation" select="f:camelCaseString($conceptName)"/>
        <xsl:variable name="conceptSchemeURI"
            select="f:buildURIFromElement(../.., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./documentation/@value)"/>

        <xsl:variable name="initialValue" select="./initial/@body"/>

        <skos:Concept rdf:about="{$conceptURI}">
            <skos:inScheme rdf:resource="{$conceptSchemeURI}"/>
<!--            <skos:notation>
                <xsl:value-of select="$notation"/>
            </skos:notation>-->
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$conceptName"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$conceptName"/>
            </skos:prefLabel>
            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
        </skos:Concept>
            </xsl:if>
    </xsl:template>


<!--    <xd:doc>
        <xd:desc>uml:Package has no equivalent on OWL ontology.</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Package']"/>-->

    <xd:doc>
        <xd:desc>
            <xd:p>[Rule 25]-(Datatype in core ontology layer) .Specify datatype declaration
                axiom.</xd:p>
            <xd:p>p [Rule 26]-(Structured Datatype in core ontology layer) . Specify OWL class
                declaration axiom for UML structured datatype.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:DataType']">
        <xsl:choose>
            <xsl:when test="./not(attributes) = fn:true()">
                <xsl:call-template name="datatypeDeclaration"/>
            </xsl:when>
            <xsl:otherwise>
                 <xsl:call-template name="classDeclaration"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>[Rule 25]-(Datatype in core ontology layer) .Specify datatype declaration
                axiom.</xd:p>           
        </xd:desc>
    </xd:doc>
    <xsl:template name="datatypeDeclaration">
        <xsl:variable name="name" select="f:lexicalQNameToWords(./@name)"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <xsl:variable name="data-type-URI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>
        
        <rdfs:Datatype rdf:about="{$data-type-URI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$name"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$name"/>
            </skos:prefLabel>
            
            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <xsl:if test="fn:contains($data-type-URI, $base-ontology-uri)">
                <rdfs:isDefinedBy rdf:resource="{$coreModuleURI}"/>
            </xsl:if>
        </rdfs:Datatype>
    </xsl:template>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template name="classDeclaration">
        <xsl:variable name="datatypeName" select="f:lexicalQNameToWords(./@name)"/>
        <xsl:variable name="idref" select="./@xmi:idref"/>
        <xsl:variable name="datatypeURI" select="f:buildURIFromElement(., fn:true(), fn:true())"/>
        <xsl:variable name="documentation" select="f:formatDocString(./properties/@documentation)"/>
        
        
        <owl:Class rdf:about="{$datatypeURI}">
            <rdfs:label xml:lang="en">
                <xsl:value-of select="$datatypeName"/>
            </rdfs:label>
            <skos:prefLabel xml:lang="en">
                <xsl:value-of select="$datatypeName"/>
            </skos:prefLabel>
            
            <xsl:if test="$documentation != ''">
                <rdfs:comment xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </rdfs:comment>
                <skos:definition xml:lang="en">
                    <xsl:value-of select="$documentation"/>
                </skos:definition>
            </xsl:if>
            <xsl:if test="fn:contains($datatypeURI, $base-ontology-uri)">
                <rdfs:isDefinedBy rdf:resource="{$coreModuleURI}"/>
            </xsl:if>
        </owl:Class>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute"/>




    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="generatePropertiesFromDistinctAttributeNamesInCore">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="distinctNames" select="f:getDistinctClassAttributeNames($root)"/>
        <xsl:for-each select="$distinctNames">
            <xsl:call-template name="generatePropertyFromAttribute">
                <xsl:with-param name="attributeName" select="."/>
                <xsl:with-param name="root" select="$root"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc>
        <xd:desc> [Rule 4] -(Attribute in core ontology layer). Specify declaration axiom(s) for
            attribute(s) as OWL data or object properties deciding based on their types. The
            attributes with primary types should be treated as data properties, whereas those typed
            with classes or enumerations should be treated as object properties.></xd:desc>
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
        <xsl:variable name="attributeURI"
            select="f:buildURIFromAttribute($attributesWithSameName[1], fn:false(), fn:true())"/>

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
        <xsl:variable name="descriptionsWithAnnotations" as="xs:string" select="fn:string-join($descriptionsWithAnnotationsSequnce)"/>

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
                    $mockUnnamedElement"/>
        <xsl:variable name="className" select="$firstAttribute/../../@name" as="xs:string"/>
        <xsl:variable name="attributeNormalizedLocalName"
            select="fn:concat(fn:substring-before($firstAttribute/@name, ':'), ':has', f:getLocalSegmentForElements($firstAttribute))"/>
        <xsl:variable name="isAttributeWithDependencyName"
            select="f:getConnectorByName($attributeNormalizedLocalName, $root)[source/model/@name = $className]"/>
        
        
        <xsl:if test="not($isAttributeWithDependencyName)">
            <xsl:element name="{$propertyType}">
                <xsl:attribute name="rdf:about" select="$attributeURI"/>
                <rdfs:label xml:lang="en">
                    <xsl:value-of select="$name"/>
                </rdfs:label>
                <skos:prefLabel xml:lang="en">
                    <xsl:value-of select="$name"/>
                </skos:prefLabel>
                <xsl:if test="boolean($descriptionsWithAnnotations)">
                    <rdfs:comment xml:lang="en">
                        <xsl:value-of select="$descriptionsWithAnnotations"/>
                    </rdfs:comment>
                    <skos:definition xml:lang="en">
                        <xsl:value-of select="$descriptionsWithAnnotations"/>
                    </skos:definition>
                </xsl:if>
                <xsl:if test="fn:contains($attributeURI, $base-ontology-uri)">
                    <rdfs:isDefinedBy rdf:resource="{$coreModuleURI}"/>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        
      
    </xsl:template>

</xsl:stylesheet>