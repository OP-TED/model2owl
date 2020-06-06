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
        <xd:desc>applying the rules to associations</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        <xsl:if test="./source/model/@type = 'Class' and ./target/model/@type = 'Class'">
            <xsl:call-template name="connectorRange">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorAsymmetry">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>applying the rules to dependencies</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <xsl:if test="./source/model/@type = 'Class' and ./target/model/@type = 'Class'">
            <xsl:call-template name="connectorRange">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorAsymmetry">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>Rule 12 (Association source in reasnoning layer) .Specify object property domain
            for the target end of the association.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <xsl:template name="connectorSource">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name, fn:true())"/>
        <xsl:variable name="sourceRoleURI"
            select="f:buildURIfromLexicalQName($connector/source/role/@name, fn:false())"/>
        <xsl:variable name="targetClassURI"
            select="f:buildURIfromLexicalQName($connector/target/model/@name, fn:true())"/>
        <xsl:variable name="targetRoleURI"
            select="f:buildURIfromLexicalQName($connector/target/role/@name, fn:false())"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
            <owl:ObjectProperty rdf:about="{$targetRoleURI}">
                <rdfs:domain rdf:resource="{$sourceClassURI}"/>
            </owl:ObjectProperty>
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <owl:ObjectProperty rdf:about="{$targetRoleURI}">
                <rdfs:domain rdf:resource="{$sourceClassURI}"/>
            </owl:ObjectProperty>
            <owl:ObjectProperty rdf:about="{$sourceRoleURI}">
                <rdfs:domain rdf:resource="{$targetClassURI}"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Rule 13 (Association target in reasnoning layer) . Specify object property range
            for the target end of the association.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="connectorTarget">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name, fn:true())"/>
        <xsl:variable name="sourceRoleURI"
            select="f:buildURIfromLexicalQName($connector/source/role/@name, fn:false())"/>
        <xsl:variable name="targetClassURI"
            select="f:buildURIfromLexicalQName($connector/target/model/@name, fn:true())"/>
        <xsl:variable name="targetRoleURI"
            select="f:buildURIfromLexicalQName($connector/target/role/@name, fn:false())"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
            <owl:ObjectProperty rdf:about="{$targetRoleURI}">
                <rdfs:range rdf:resource="{$targetClassURI}"/>
            </owl:ObjectProperty>
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <owl:ObjectProperty rdf:about="{$targetRoleURI}">
                <rdfs:range rdf:resource="{$targetClassURI}"/>
            </owl:ObjectProperty>
            <owl:ObjectProperty rdf:about="{$sourceRoleURI}">
                <rdfs:range rdf:resource="{$sourceClassURI}"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Rule 19 (Association asymmetry in reasnoning layer) . Specify the asymmetry object
            property axiom for each end of a recursive association.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="connectorAsymetry">
        <xsl:param name="connector"/>
        <xsl:if test="$connector/source/model/@name = $connector/target/model/@name">
            <xsl:variable name="targetRoleURI"
                select="f:buildURIfromLexicalQName($connector/target/role/@name, fn:false())"/>
            <owl:AsymmetricProperty
                rdf:about="{$targetRoleURI}"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Rule 20 (Association inverse in reasnoning layer) . Specify inverse object property
            between the source and target ends of the association.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:template name="connectorInverse">
        <xsl:param name="connector"/>
        <xsl:if test="$connector/properties/@direction = 'Bi-Directional'">
            <xsl:variable name="targetRoleURI"
                select="f:buildURIfromLexicalQName($connector/target/role/@name, fn:false())"/>
            <xsl:variable name="sourceRoleURI"
                select="f:buildURIfromLexicalQName($connector/source/role/@name, fn:false())"/>
            <owl:AsymmetricProperty
                rdf:about="{$targetRoleURI}"/>
            
            <owl:ObjectProperty
                rdf:about="{$targetRoleURI}">
                <owl:inverseOf
                    rdf:resource="{$sourceRoleURI}"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Rule 23 (Equivalent classes in reasnoning layer) .Specify equivalent class axiom
            for the generalisation with equivalent or complete stereotype between UML
            classes.
        </xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:template name="classEquivalence">
        <xsl:param name="generalisation"/>
        <xsl:if test="$generalisation/properties/@stereotype = ('equivalent','complete') and
            $generalisation/source/model/@type = 'Class' and $generalisation/target/model/@type = 'Class'">
            <xsl:variable name="sourceClassURI"
                select="f:buildURIfromLexicalQName($generalisation/source/model/@name, fn:true())"/>
            <xsl:variable name="targetClassURI"
                select="f:buildURIfromLexicalQName($generalisation/target/model/@name, fn:true())"/>
            <owl:Class rdf:about="{$sourceClassURI}">
                <owl:equivalentClass
                    rdf:resource="{$targetClassURI}"/>
            </owl:Class>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Rule 24 (Equivalent properties in reasnoning layer) .Specify equivalent property
            axiom for the generalisation with equivalent or complete stereotype between UML
            properties. </xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:template name="propertiesEquivalence">
        <xsl:param name="generalisation"/>
        <xsl:if test="$generalisation/properties/@stereotype = ('equivalent','complete') and
            $generalisation/source/model/@type = 'ProxyConnector' and $generalisation/target/model/@type = 'ProxyConnector'">
            <xsl:variable name="targetIdref" select="$generalisation/target/@xmi:idref" as="xs:string"/>
            <xsl:variable name="sourceIdref" select="$generalisation/source/@xmi:idref" as="xs:string"/>
            <xsl:variable name="targetElement" select="f:getElementByIdRef($targetIdref, root($generalisation))"/>
            <xsl:variable name="sourceElement" select="f:getElementByIdRef($sourceIdref, root($generalisation))"/>
            <xsl:variable name="targetConnectorIdref" select="$targetElement/@classifier" as="xs:string"/>
            <xsl:variable name="sourceConnectorIdref" select="$sourceElement/@classifier" as="xs:string"/>
            <xsl:variable name="targetConnector"
                select="f:getConnectorByIdRef($targetConnectorIdref, root($generalisation))"/>
            <xsl:variable name="sourceConnector"
                select="f:getConnectorByIdRef($sourceConnectorIdref, root($generalisation))"/>
            <xsl:variable name="targetConnectorTargetRoleURI" select="f:buildURIfromLexicalQName($targetConnector/target/role/@name, fn:false())"/>
            <xsl:variable name="targetConnectorSourceRoleURI" select="f:buildURIfromLexicalQName($targetConnector/source/role/@name, fn:false())"/>
            <xsl:variable name="sourceConnectorTargetRoleURI" select="f:buildURIfromLexicalQName($sourceConnector/target/role/@name,fn:false())"/>
            <xsl:variable name="sourceConnectorSourceRoleURI" select="f:buildURIfromLexicalQName($sourceConnector/source/role/@name, fn:false())"/>
            <owl:ObjectProperty
                rdf:about="{$sourceConnectorSourceRoleURI}">
                <owl:equivalentProperty
                    rdf:resource="{$targetConnectorSourceRoleURI}"/>
            </owl:ObjectProperty>
            <owl:ObjectProperty
               rdf:about="{$sourceConnectorTargetRoleURI}">
                <owl:equivalentProperty
                    rdf:resource="{$targetConnectorTargetRoleURI}"/>
            </owl:ObjectProperty>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc> Rule 16 (Association multiplicity in reasnoning layer) . For the association
            target multiplicity, where min and max are different than * (any) and multiplicity is
            not [1..1], specify a subclass axiom where the source class specialises an anonymous
            restriction of properties formulated according to cases provided by Rule 9.</xd:desc>
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
            select="f:buildURIfromLexicalQName($connector/source/model/@name, fn:true())"/>
        <xsl:variable name="sourceRole"
            select="
                if (boolean($connector/source/role/@name)) then
                    f:lexicalQNameToWords($connector/source/role/@name)
                else
                    ()
                "/>
        <xsl:variable name="sourceRoleURI"
            select="
                if (boolean($sourceRole)) then
                    f:buildURIfromLexicalQName($sourceRole, fn:false())
                else
                    ()"/>
        <xsl:variable name="targetClassURI"
            select="f:buildURIfromLexicalQName($connector/target/model/@name, fn:true())"/>
        <xsl:variable name="targetRole"
            select="
                if (boolean($connector/target/role/@name)) then
                    f:lexicalQNameToWords($connector/target/role/@name)
                else
                    concat($mockUnknownPrefix, ':', $mockUnnamedElement)"/>
        <xsl:variable name="targetRoleURI"
            select="f:buildURIfromLexicalQName($targetRole, fn:false())"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:variable name="datatypeURI"
            select="f:buildURIfromLexicalQName('xsd:integer', fn:false())"/>
        <xsl:if
            test="
                $connectorDirection = 'Source -&gt; Destination' and
                boolean($targetMultiplicity)">
            <owl:Class rdf:about="{$sourceClassURI}">
                <rdfs:subClassOf>
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$targetRoleURI}"/>
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
                        <xsl:if test="$targetMultiplicityMin = $targetMultiplicityMax">
                            <owl:Cardinality rdf:datatype="{$datatypeURI}">
                                <xsl:value-of select="$targetMultiplicityMin"/>
                            </owl:Cardinality>
                        </xsl:if>
                    </owl:Restriction>
                </rdfs:subClassOf>
            </owl:Class>
            <xsl:if test="$targetMultiplicityMin = 1 and $targetMultiplicityMax = 1">
                <rdf:Description
                    rdf:about="{$targetRoleURI}">
                    <rdf:type
                        rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($targetMultiplicity)">
            <owl:Class rdf:about="{$sourceClassURI}">
                <rdfs:subClassOf>
                    <owl:Restriction>
                        <owl:onProperty rdf:resource="{$targetRoleURI}"/>
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
                        <xsl:if test="$targetMultiplicityMin = $targetMultiplicityMax">
                            <owl:Cardinality rdf:datatype="{$datatypeURI}">
                                <xsl:value-of select="$targetMultiplicityMin"/>
                            </owl:Cardinality>
                        </xsl:if>
                    </owl:Restriction>
                </rdfs:subClassOf>
            </owl:Class>
            <xsl:if test="$targetMultiplicityMin = 1 and $targetMultiplicityMax = 1">
                <rdf:Description
                    rdf:about="{$targetRoleURI}">
                    <rdf:type
                        rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($sourceMultiplicity)">
                <owl:Class rdf:about="{$targetClassURI}">
                    <rdfs:subClassOf>
                        <owl:Restriction>
                            <owl:onProperty rdf:resource="{$sourceRoleURI}"/>
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
                            <xsl:if test="$sourceMultiplicityMin = $sourceMultiplicityMax">
                                <owl:Cardinality rdf:datatype="{$datatypeURI}">
                                    <xsl:value-of select="$sourceMultiplicityMin"/>
                                </owl:Cardinality>
                            </xsl:if>
                        </owl:Restriction>
                    </rdfs:subClassOf>
                </owl:Class>
            <xsl:if test="$sourceMultiplicityMin = 1 and $sourceMultiplicityMax = 1">
                <rdf:Description
                    rdf:about="{$sourceRoleURI}">
                    <rdf:type
                        rdf:resource="http://www.w3.org/2002/07/owl#FunctionalProperty"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    



</xsl:stylesheet>
