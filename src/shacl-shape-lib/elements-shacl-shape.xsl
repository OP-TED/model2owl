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
        <xd:desc>[Rule 2] - (Class in data shape layer). Specify declaration axiom for UML Class as
            SHACL Node Shape where the URI and a label are deterministically generated from the
            class name and rules 3,7,8 </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:variable name="class" select="."/>
        <xsl:variable name="classURI" select="f:buildURIFromElement($class, fn:true(), fn:true())"/>
        <xsl:variable name="documentation"
            select="f:formatDocString($class/properties/@documentation)"/>

        <sh:NodeShape rdf:about="{$classURI}">
            <sh:targetClass rdf:resource="{$classURI}"/>
            <xsl:call-template name="elementName">
                <xsl:with-param name="name" select="f:lexicalQNameToWords($class/@name)"/>
            </xsl:call-template>
            <xsl:if test="$documentation != ''">
                <xsl:call-template name="elementDescription">
                    <xsl:with-param name="description" select="$documentation"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if
                test="$class/properties/@stereotype = ('Abstract', 'abstract class', 'abstract')">
                <xsl:call-template name="abstractClassDeclaration">
                    <xsl:with-param name="classURI" select="$classURI"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="attributes/attribute"/>
            <xsl:if test="fn:contains($classURI, $base-ontology-uri)">
                <rdfs:isDefinedBy rdf:resource="{$coreModuleURI}"/>
            </xsl:if>

        </sh:NodeShape>
    </xsl:template>


<!--TODO What are we doing with the rules below vvv-->

<!--    <xd:doc>
        <xd:desc>Applying rules 7 and 8 to attributes</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute">
        <xsl:variable name="className" select="./../../@name" as="xs:string"/>
        <xsl:variable name="attributeNormalizedLocalName"
            select="fn:concat(fn:substring-before(./@name, ':'), ':has', f:getLocalSegmentForElements(.))"/>
        <xsl:variable name="isAttributeWithDependencyName"
            select="f:getConnectorByName($attributeNormalizedLocalName, root(.))[source/model/@name = $className]"/>
<!-\-        generating only for attributes that don't have a coresponding relation (dependency)-\->
        <xsl:if test="not($isAttributeWithDependencyName)">
            <xsl:call-template name="attributeRangeShape">
                <xsl:with-param name="attribute" select="."/>
            </xsl:call-template>
            <xsl:call-template name="attributeMultiplicity">
                <xsl:with-param name="attribute" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>-->


    <xd:doc>
        <xd:desc>[Rule 30]-(Label) Specify a label for UML element</xd:desc>
        <xd:param name="name"/>
    </xd:doc>
    <xsl:template name="elementName">
        <xsl:param name="name"/>
        <sh:name>
            <xsl:value-of select="$name"/>
        </sh:name>
        <rdfs:label xml:lang="en">
            <xsl:value-of select="$name"/>
        </rdfs:label>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 31]-(Description) Specify a description for UML element.</xd:desc>
        <xd:param name="description"/>
    </xd:doc>
    <xsl:template name="elementDescription">
        <xsl:param name="description"/>
        <sh:description>
            <xsl:value-of select="$description"/>
        </sh:description>
        <rdfs:comment xml:lang="en">
            <xsl:value-of select="$description"/>
        </rdfs:comment>
    </xsl:template>

    <xd:doc>
        <xd:desc>[Rule 3]-(Class in data shape layer) . Specify declaration axiom for UML Class as
            SHACL Node Shape with a SPARQL constraint that selects all instances of this
            class</xd:desc>
        <xd:param name="classURI"/>
    </xd:doc>

    <xsl:template name="abstractClassDeclaration">
        <xsl:param name="classURI"/>
        <sh:sparql rdf:parseType="Resource">
            <sh:select>SELECT ?this WHERE { ?this a &lt;<xsl:value-of select="$classURI"/>&gt; . }
            </sh:select>
        </sh:sparql>
    </xsl:template>

  <!--  <xd:doc>
        <xd:desc>[Rule 7] (Attribute range shape in data shape layer) . Within the SHACL Node Shape
            corresponding to the UML class, specify property constraints, for each UML attribute,
            indicating the range class or datatype.</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:template name="attributeRangeShape">
        <xsl:param name="attribute"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromAttribute($attribute, fn:false(), fn:true())"/>
        <xsl:variable name="attributeName" select="f:lexicalQNameToWords($attribute/@name)"/>
        <xsl:variable name="attributeType" select="$attribute/properties/@type"/>
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
                    f:buildURIfromLexicalQName('skos:Concept', fn:true(), fn:true())
                    else
                    f:buildURIfromLexicalQName($datatype, fn:true(), fn:false())"
            />

            <sh:property>
                <sh:PropertyShape>
                    <sh:path rdf:resource="{$attributeURI}"/>
                    <sh:name>
                        <xsl:value-of select="$attributeName"/>
                    </sh:name>
                    <sh:datatype rdf:resource="{$datatypeURI}"/>
                </sh:PropertyShape>
            </sh:property>

        </xsl:if>
        <xsl:if
            test="
                count(f:getElementByName($attributeType, root($attribute))) > 0 and
                f:getElementByName($attributeType, root($attribute))/@xmi:type = 'uml:Class' and not(f:isAttributeTypeValidForDatatypeProperty($attribute))">
            <xsl:variable name="classURI"
                select="
                    if ($attributeType = $controlledListType) then
                    f:buildURIfromLexicalQName('skos:Concept', fn:true(), fn:true())
                    else
                    f:buildURIfromLexicalQName($attributeType, fn:true(), fn:false())"/>
            <sh:property>
                <sh:PropertyShape>
                    <sh:path rdf:resource="{$attributeURI}"/>
                    <sh:name>
                        <xsl:value-of select="$attributeName"/>
                    </sh:name>
                    <sh:class rdf:resource="{$classURI}"/>
                </sh:PropertyShape>
            </sh:property>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule 8 (Attribute multiplicity in data shape layer) . Within the SHACL Node Shape
            corresponding to the UML class, specify property constraints, corresponding to each
            attribute, indicating the minimum and maximum cardinality, only where min and max are
            different from * (any) and multiplicity is not [1..1]. </xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>

    <xsl:template name="attributeMultiplicity">
        <xsl:param name="attribute"/>
        <xsl:variable name="attributeMultiplicityMin" select="f:getAttributeValueToDisplay($attribute/bounds/@lower)"/>
        <xsl:variable name="attributeMultiplicityMax" select="f:getAttributeValueToDisplay($attribute/bounds/@upper)"/>
        <xsl:variable name="datatypeURI"
            select="f:buildURIfromLexicalQName('xsd:integer', fn:false(), fn:true())"/>
        <xsl:variable name="attributeURI"
            select="f:buildURIFromAttribute($attribute, fn:false(), fn:true())"/>
        <xsl:variable name="attributeName" select="f:lexicalQNameToWords($attribute/@name)"/>
        
        <xsl:variable name="propertyRestriction" as="item()*">
            <xsl:if test="boolean($attributeMultiplicityMin) and boolean($attributeMultiplicityMax)">
                <sh:minCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMin"/>
                </sh:minCount>
                <sh:maxCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMax"/>
                </sh:maxCount>
            </xsl:if>
            
            <xsl:if test="not(boolean($attributeMultiplicityMin)) and boolean($attributeMultiplicityMax)">
                <sh:maxCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMax"/>
                </sh:maxCount>
            </xsl:if>
            <xsl:if test="not(boolean($attributeMultiplicityMax)) and boolean($attributeMultiplicityMin)">
                <sh:minCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$attributeMultiplicityMin"/>
                </sh:minCount>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="boolean($propertyRestriction)">
            <sh:property>
                <sh:PropertyShape>
                    <sh:path rdf:resource="{$attributeURI}"/>
                    <sh:name>
                        <xsl:value-of select="$attributeName"/>
                    </sh:name>
                    <xsl:copy-of select="$propertyRestriction"/>
                </sh:PropertyShape>
            </sh:property>
        </xsl:if>
    </xsl:template>-->
    
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
    <xsl:template match="element[@xmi:type = 'uml:Class']/attributes/attribute"/>
    
    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = 'uml:Enumeration']/attributes/attribute"/>
</xsl:stylesheet>