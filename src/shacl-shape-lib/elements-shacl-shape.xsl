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
    <xsl:import href="descriptors-shacl-shape.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"
        cdata-section-elements="lines"/>


    <xd:doc>
        <xd:desc>Rule C.02. Class — in data shape layer. Specify a SHACL NodeShape declaration axiom 
            for each UML Class. The URIs of the node shape and of the OWL class they refer to, 
            are deterministically generated from the UML Class name. </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:variable name="class" select="."/>
        <xsl:variable name="shapeClassUri"
            select="fn:concat($base-shape-uri, $defaultDelimiter, replace($class/@name, ':', '-'))"/>
        <xsl:variable name="classURI" select="f:buildURIFromElement($class)"/>
        <xsl:variable name="documentation"
            select="f:formatDocString($class/properties/@documentation)"/>

        <sh:NodeShape rdf:about="{$shapeClassUri}">
            <sh:targetClass rdf:resource="{$classURI}"/>
            <xsl:if test="fn:contains($classURI, $base-ontology-uri)">
                <rdfs:isDefinedBy rdf:resource="{$coreArtefactURI}"/>
            </xsl:if>
            <xsl:if test="$class/properties/@stereotype = ('Abstract', 'abstract class', 'abstract')">
                <xsl:call-template name="abstractClassDeclaration">
                    <xsl:with-param name="classURI" select="$classURI"/>
                </xsl:call-template>
            </xsl:if>
            
            
            
            
        <xsl:call-template name="shapeLayerName">
            <xsl:with-param name="elementName" select="$class/@name"/>
            <xsl:with-param name="uri" select="$shapeClassUri"/>
        </xsl:call-template>
        <xsl:if test="$documentation != ''">
            <xsl:call-template name="shapeLayerDescription">
                <xsl:with-param name="definition" select="$documentation"/>
                <xsl:with-param name="uri" select="$shapeClassUri"/>
                <xsl:with-param name="rdfsComment" select="fn:true()"/>
            </xsl:call-template>
        </xsl:if>
            
            
        </sh:NodeShape>



<!--        <xsl:apply-templates select="attributes/attribute"/>-->

    </xsl:template>



        <xd:doc>
        <xd:desc>Applying shape layer rules to attributes</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">
        <xsl:variable name="className" select="./../../@name" as="xs:string"/>
<!--        <xsl:variable name="attributeNormalizedLocalName"
            select="fn:concat(fn:substring-before(./@name, ':'), ':has', f:getLocalSegmentForElements(.))"/>-->
        <xsl:variable name="isAttributeWithDependencyName"
            select="f:getConnectorByName(./@name, root(.))[source/model/@name = $className]"/>
<!--        generating only for attributes that don't have a coresponding relation (dependency)-->
        <xsl:if test="not($isAttributeWithDependencyName)">
            <xsl:call-template name="classAttributeDeclaration">
                <xsl:with-param name="attribute" select="."/>
                <xsl:with-param name="className" select="$className"/>
            </xsl:call-template>
            <xsl:call-template name="attributeRangeShape">
                <xsl:with-param name="attribute" select="."/>
                <xsl:with-param name="className" select="$className"/>
            </xsl:call-template>
            <xsl:call-template name="attributeMultiplicity">
                <xsl:with-param name="attribute" select="."/>
                <xsl:with-param name="className" select="$className"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Rule C.06. Class attribute — in data shape layer. 
            Specify a SHACL PropertyShape declaration axiom for each attribute.</xd:desc>
       
        <xd:param name="attribute"/>
        <xd:param name="className"/>
    </xd:doc>
    
    <xsl:template name="classAttributeDeclaration">
        <xsl:param name="attribute"/>
        <xsl:param name="className"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromElement($attribute)"/>
        <xsl:variable name="documentation" select="$attribute/documentation/@value"/>
        <xsl:variable name="normalisedAttributeName" select="replace($attribute/@name, ':', '-')"/>
        <xsl:variable name="normalisedClassName" select="replace($className, ':', '-')"/>
        <xsl:variable name="shapePropertyUri"
            select="fn:concat($base-shape-uri, $defaultDelimiter, $normalisedClassName, '-', $normalisedAttributeName)"/>
        <xsl:variable name="shapeClassUri"
            select="fn:concat($base-shape-uri, $defaultDelimiter, replace($className, ':', '-'))"/>
        
        <rdf:Description rdf:about="{$shapeClassUri}">
            <sh:property rdf:resource="{$shapePropertyUri}"/>
        </rdf:Description>
        <sh:PropertyShape rdf:about="{$shapePropertyUri}">
            <sh:path rdf:resource="{$attributeURI}"/>
        </sh:PropertyShape>
        
        <xsl:call-template name="shapeLayerName">
            <xsl:with-param name="elementName" select="$attribute/@name"/>
            <xsl:with-param name="uri" select="$shapePropertyUri"/>
        </xsl:call-template>
        <xsl:if test="$documentation != ''">
            <xsl:call-template name="shapeLayerDescription">
                <xsl:with-param name="definition" select="$documentation"/>
                <xsl:with-param name="uri" select="$shapeClassUri"/>
                <xsl:with-param name="rdfsComment" select="fn:false()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
   

    <xd:doc>
        <xd:desc>Rule C.03. Abstract class — in data shape layer. Specify a SHACL NodeShape declaration axiom
            for each abstract UML Class, with a SPARQL constraint that selects all instances of this class.</xd:desc>
        <xd:param name="classURI"/>
    </xd:doc>

    <xsl:template name="abstractClassDeclaration">
        <xsl:param name="classURI"/>
        <sh:sparql rdf:parseType="Resource">
            <sh:select>SELECT ?this WHERE { ?this a &lt;<xsl:value-of select="$classURI"/>&gt; . }
            </sh:select>
        </sh:sparql>
    </xsl:template>

      <xd:doc>
          <xd:desc>Rule C.08. Attribute type — in data shape layer . Within the SHACL PropertyShape corresponding to an attribute of a UML Class, 
              specify property constraints indicating the range class or datatype.</xd:desc>
        <xd:param name="attribute"/>
          <xd:param name="className"/>
      </xd:doc>
    <xsl:template name="attributeRangeShape">
        <xsl:param name="attribute"/>
        <xsl:param name="className"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromElement($attribute)"/>
        <xsl:variable name="attributeName" select="f:lexicalQNameToWords($attribute/@name)"/>
        <xsl:variable name="attributeType" select="$attribute/properties/@type"/>
        <xsl:variable name="normalisedAttributeName" select="replace($attribute/@name, ':', '-')"/>
        <xsl:variable name="normalisedClassName" select="replace($className, ':', '-')"/>
        <xsl:variable name="shapePropertyUri"
            select="fn:concat($base-shape-uri, $defaultDelimiter, $normalisedClassName, '-', $normalisedAttributeName)"/>
        
        <xsl:if test="f:isAttributeTypeValidForDatatypeProperty($attribute)">
            <xsl:variable name="datatype"
                select="
                    if (boolean(f:getUmlDataTypeValues($attributeType, $umlDataTypesMapping))) then
                        f:getUmlDataTypeValues($attributeType, $umlDataTypesMapping)
                    else
                        $attributeType"/>
            <xsl:variable name="datatypeURI"
                select="
                    if ($attributeType = $controlledListType) then
                    f:buildURIfromLexicalQName('skos:Concept')
                    else
                    f:buildURIfromLexicalQName($datatype)"
            />
            
            <rdf:Description rdf:about="{$shapePropertyUri}">
                <sh:datatype rdf:resource="{$datatypeURI}"/>
            </rdf:Description>

        </xsl:if>
        <xsl:if
            test="
                count(f:getElementByName($attributeType, root($attribute))) > 0 and
                f:getElementByName($attributeType, root($attribute))/@xmi:type = 'uml:Class' and not(f:isAttributeTypeValidForDatatypeProperty($attribute))">
            <xsl:variable name="classURI"
                select="
                    if ($attributeType = $controlledListType) then
                    f:buildURIfromLexicalQName('skos:Concept')
                    else
                    f:buildURIfromLexicalQName($attributeType)"/>
            
            <rdf:Description rdf:about="{$shapePropertyUri}">
                <sh:class rdf:resource="{$classURI}"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule C.11. Attribute range shape — in data shape layer . Within the SHACL Node Shape
            corresponding to the UML class, specify property constraints, corresponding to each
            attribute, indicating the minimum and maximum cardinality, only where min and max are
            different from * (any) and multiplicity is not [1..1]. 
            1. exact cardinality, e.g. [2..2]
            2. minimum cardinality only, e.g. [1..*]
            3. maximum cardinality only, e.g. [*..2] 
            4. minimum and maximum cardinality , e.g. [1..2]
        
        
        </xd:desc>
        <xd:param name="attribute"/>
        <xd:param name="className"/>
    </xd:doc>

    <xsl:template name="attributeMultiplicity">
        <xsl:param name="attribute"/>
        <xsl:param name="className"/>
        <xsl:variable name="attributeMultiplicityMin"
            select="f:getAttributeValueToDisplay($attribute/bounds/@lower)"/>
        <xsl:variable name="attributeMultiplicityMax"
            select="f:getAttributeValueToDisplay($attribute/bounds/@upper)"/>
        <xsl:variable name="datatypeURI" select="f:buildURIfromLexicalQName('xsd:integer')"/>
        <xsl:variable name="attributeURI" select="f:buildURIFromElement($attribute)"/>
        <xsl:variable name="attributeName" select="f:lexicalQNameToWords($attribute/@name)"/>

        <xsl:variable name="normalisedAttributeName" select="replace($attribute/@name, ':', '-')"/>
        <xsl:variable name="normalisedClassName" select="replace($className, ':', '-')"/>
        <xsl:variable name="shapePropertyUri"
            select="fn:concat($base-shape-uri, $defaultDelimiter, $normalisedClassName, '-', $normalisedAttributeName)"/>

        <xsl:variable name="propertyRestriction" as="item()*">
            <xsl:if test="boolean($attributeMultiplicityMin) and boolean($attributeMultiplicityMax)">
                <sh:minCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMin"/>
                </sh:minCount>
                <sh:maxCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMax"/>
                </sh:maxCount>
            </xsl:if>

            <xsl:if
                test="not(boolean($attributeMultiplicityMin)) and boolean($attributeMultiplicityMax)">
                <sh:maxCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMax"/>
                </sh:maxCount>
            </xsl:if>
            <xsl:if
                test="not(boolean($attributeMultiplicityMax)) and boolean($attributeMultiplicityMin)">
                <sh:minCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMin"/>
                </sh:minCount>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="boolean($propertyRestriction)">
            <rdf:Description rdf:about ="{$shapePropertyUri}">
                <xsl:copy-of select="$propertyRestriction"/>
            </rdf:Description>         
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']"/>

    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:DataType']"/>


    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute"/>
</xsl:stylesheet>