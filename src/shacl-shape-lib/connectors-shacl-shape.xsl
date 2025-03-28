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
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Generalization']"/>

    <xd:doc>
        <xd:desc>applying the rules to associations</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Association']">
        <xsl:variable name="connectorRoleName" select="f:getRoleNameFromConnector(.)"/>
        <xsl:if test="not(f:isExcludedByStatus(.))">
        <xsl:if
            test="
                not(./source/model/@type = 'ProxyConnector' or ./target/model/@type = 'ProxyConnector') and (
                $generateReusedConceptsSHACL = fn:true()
                or
                fn:substring-before($connectorRoleName, ':') = $includedPrefixesList)">
            <xsl:call-template name="connectorRange">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorAsymmetry">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorDeclaration">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
        </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>applying the rules to dependencies</xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Dependency']">
        <xsl:variable name="connectorRoleName" select="f:getRoleNameFromConnector(.)"/>
        <xsl:if test="not(f:isExcludedByStatus(.))">
        <xsl:if
            test="
                not(./source/model/@type = 'ProxyConnector' or ./target/model/@type = ('ProxyConnector', 'Object')) and (
                $generateReusedConceptsSHACL = fn:true()
                or
                fn:substring-before($connectorRoleName, ':') = $includedPrefixesList)">

                <xsl:if
                    test="not(./source/model/@type = 'Class' and ./target/model/@type = 'Enumeration')">
                    <xsl:call-template name="connectorRange">
                        <xsl:with-param name="connector" select="."/>
                    </xsl:call-template>
                </xsl:if>
            
            <xsl:call-template name="connectorMultiplicity">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <xsl:call-template name="connectorDeclaration">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>
            <!--            <xsl:call-template name="connectorAsymmetry">
                <xsl:with-param name="connector" select="."/>
            </xsl:call-template>-->
        </xsl:if>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Rule R.02. Unidirectional association — in data shape layer. 
            Specify PropertyShape declaration axiom for each association/dependency.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    
    <xsl:template name="connectorDeclaration">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name)"/>
        <xsl:variable name="sourceClassName" select="$connector/source/model/@name"/>
        <xsl:variable name="sourceNodeShapeURI" select="f:buildShapeURI($sourceClassName)"/>

        <xsl:variable name="sourceDocumentation"
            select="
                if (boolean($connector/source/documentation/@value)) then
                    $connector/source/documentation/@value
                else
                    if (boolean($connector/documentation/@value)) then
                        $connector/documentation/@value
                    else
                        ()
                "/>
        <xsl:variable name="targetDocumentation"
            select="
                if (boolean($connector/target/documentation/@value)) then
                    $connector/target/documentation/@value
                else
                    if (boolean($connector/documentation/@value)) then
                        $connector/documentation/@value
                    else
                        ()
                "/>
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
        <xsl:variable name="targetClassName" select="$connector/target/model/@name"/>
        <xsl:variable name="targetNodeShapeURI" select="f:buildShapeURI($targetClassName)"/>
        <xsl:variable name="targetRole"
            select="
                if (boolean($connector/target/role/@name)) then
                    $connector/target/role/@name
                else
                    fn:error(xs:QName('connectors'), concat($connector/@xmi:idref, ' - connector target role name is empty'))"/>

        <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:variable name="propertyShapeURITarget"
            select="f:buildPropertyShapeURI($sourceClassName, $targetRole)"/>
        <xsl:variable name="propertyShapeURISource"
            select="f:buildPropertyShapeURI($targetClassName, $sourceRole)"/>
        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
            <rdf:Description rdf:about="{$sourceNodeShapeURI}">
                <sh:property rdf:resource="{$propertyShapeURITarget}"/>
            </rdf:Description>
            <sh:PropertyShape rdf:about="{$propertyShapeURITarget}">
                <sh:path rdf:resource="{$targetRoleURI}"/>
            </sh:PropertyShape>
            <xsl:call-template name="shapeLayerName">
                <xsl:with-param name="elementName" select="$targetRole"/>
                <xsl:with-param name="uri" select="$propertyShapeURITarget"/>
                <xsl:with-param name="isPropertyShape" select="fn:true()"/>
            </xsl:call-template>
            <xsl:if test="$targetDocumentation != ''">
                <xsl:call-template name="shapeLayerDescription">
                    <xsl:with-param name="definition" select="$targetDocumentation"/>
                    <xsl:with-param name="uri" select="$propertyShapeURITarget"/>
                    <xsl:with-param name="rdfsComment" select="fn:false()"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <rdf:Description rdf:about="{$sourceNodeShapeURI}">
                <sh:property rdf:resource="{$propertyShapeURITarget}"/>
            </rdf:Description>
            <sh:PropertyShape rdf:about="{$propertyShapeURITarget}">
                <sh:path rdf:resource="{$targetRoleURI}"/>
            </sh:PropertyShape>
            <xsl:call-template name="shapeLayerName">
                <xsl:with-param name="elementName" select="$targetRole"/>
                <xsl:with-param name="uri" select="$propertyShapeURITarget"/>
                <xsl:with-param name="isPropertyShape" select="fn:true()"/>
            </xsl:call-template>
            <xsl:if test="$targetDocumentation != ''">
                <xsl:call-template name="shapeLayerDescription">
                    <xsl:with-param name="definition" select="$targetDocumentation"/>
                    <xsl:with-param name="uri" select="$propertyShapeURITarget"/>
                    <xsl:with-param name="rdfsComment" select="fn:false()"/>
                </xsl:call-template>
            </xsl:if>
            <rdf:Description rdf:about="{$targetNodeShapeURI}">
                <sh:property rdf:resource="{$propertyShapeURISource}"/>
            </rdf:Description>
            <sh:PropertyShape rdf:about="{$propertyShapeURISource}">
                <sh:path rdf:resource="{$sourceRoleURI}"/>
            </sh:PropertyShape>
            <xsl:call-template name="shapeLayerName">
                <xsl:with-param name="elementName" select="$sourceRole"/>
                <xsl:with-param name="uri" select="$propertyShapeURISource"/>
                <xsl:with-param name="isPropertyShape" select="fn:true()"/>
            </xsl:call-template>
            <xsl:if test="$targetDocumentation != ''">
                <xsl:call-template name="shapeLayerDescription">
                    <xsl:with-param name="definition" select="$sourceDocumentation"/>
                    <xsl:with-param name="uri" select="$propertyShapeURISource"/>
                    <xsl:with-param name="rdfsComment" select="fn:false()"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.05. Association range shape — in data shape layer . Within the SHACL Node
            Shape corresponding to the source UML class, specify property constraints indicating the
            range class.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>


    <xsl:template name="connectorRange">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name)"/>
        <xsl:variable name="sourceClassName"
            select="$connector/source/model/@name"/>
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
        <xsl:variable name="targetClassName"
            select="$connector/target/model/@name"/>
        <xsl:variable name="targetRole"
            select="
                if (boolean($connector/target/role/@name)) then
                    $connector/target/role/@name
                else
                    fn:error(xs:QName('connectors'), concat($connector/@xmi:idref, ' - connector target role name is empty'))"/>
        <xsl:variable name="targetRoleURI" select="f:buildURIfromLexicalQName($targetRole)"/>
        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>

        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($sourceClassName,$targetRole)}">
                <sh:class rdf:resource="{$targetClassURI}"/>
            </rdf:Description>
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($sourceClassName,$targetRole)}">
                <sh:class rdf:resource="{$targetClassURI}"/>
            </rdf:Description>

            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($targetClassName,$sourceRole)}">
                <sh:class rdf:resource="{$sourceClassURI}"/>
            </rdf:Description>


        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>Rule R.08. Association multiplicity — in data shape layer. 
            Within the SHACL PropertyShape corresponding to an association/dependency relation 
            linked to a given source UML Class, specify property constraints indicating minimum 
            and maximum cardinality, according to cases provided by rule:attribute-ds-multiplicity. </xd:desc>
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
        <xsl:variable name="sourceClassName"
            select="$connector/source/model/@name"/>
        <xsl:variable name="targetClassName"
            select="$connector/target/model/@name"/>
        <!--  <xsl:value-of select="$connector/target/type/@multiplicity"/>-->
        <!--<xsl:value-of select="$targetMultiplicity"/>-->
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
                    fn:error(xs:QName('connectors'),concat($connector/@xmi:idref, ' - connector target role name is empty'))"/>
        <xsl:variable name="targetRoleURI"
            select="f:buildURIfromLexicalQName($targetRole)"/>

        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:variable name="datatypeURI"
            select="f:buildURIfromLexicalQName('xsd:integer')"/>
        <!--        this is first property shape content-->
        <xsl:variable name="sourceDestinationRestrictionContent" as="item()*">
            <xsl:if test="boolean($targetMultiplicityMax)">
                <sh:maxCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$targetMultiplicityMax"/>
                </sh:maxCount>
            </xsl:if>
            <xsl:if test="boolean($targetMultiplicityMin)">
                <sh:minCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$targetMultiplicityMin"/>
                </sh:minCount>
            </xsl:if>
        </xsl:variable>
        <xsl:if
            test="
                $connectorDirection = 'Source -&gt; Destination' and
                boolean($targetMultiplicity) and boolean($sourceDestinationRestrictionContent)">
            
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($sourceClassName,$targetRole)}">
                <xsl:copy-of select="$sourceDestinationRestrictionContent"/>
            </rdf:Description>

        </xsl:if>
        <!--        end of first property shape content-->

        <!--        this is second property shape content-->
        <xsl:variable name="sourceInBidirectionalRestrictionContent" as="item()*">
            <xsl:if test="boolean($targetMultiplicityMax)">
                <sh:maxCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$targetMultiplicityMax"/>
                </sh:maxCount>
            </xsl:if>
            <xsl:if test="boolean($targetMultiplicityMin)">
                <sh:minCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$targetMultiplicityMin"/>
                </sh:minCount>
            </xsl:if>
        </xsl:variable>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($targetMultiplicity) and boolean($sourceInBidirectionalRestrictionContent)">
            
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($sourceClassName,$targetRole)}">
                <xsl:copy-of select="$sourceInBidirectionalRestrictionContent"/>
            </rdf:Description>

            
        </xsl:if>
        <!--        end of second property shape content-->

        <!--        this is third property shape content-->
        <xsl:variable name="targetInBidirectionalRestrictionContent" as="item()*">
            <xsl:if test="boolean($sourceMultiplicityMax)">
                <sh:maxCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$sourceMultiplicityMax"/>
                </sh:maxCount>
            </xsl:if>
            <xsl:if test="boolean($sourceMultiplicityMin)">
                <sh:minCount rdf:datatype="{$datatypeURI}">
                    <xsl:value-of select="$sourceMultiplicityMin"/>
                </sh:minCount>
            </xsl:if>
        </xsl:variable>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($sourceMultiplicity) and boolean($targetInBidirectionalRestrictionContent)">
            
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($targetClassName,$sourceRole)}">
                <xsl:copy-of select="$targetInBidirectionalRestrictionContent"/>
            </rdf:Description>
        </xsl:if>
        <!--        end of third property shape content-->
    </xsl:template>

    <xd:doc>
        <xd:desc>Rule R.10. Association asymmetry — in data shape layer .Within the SHACL Node Shape 
            corresponding to the UML Class, specify SPARQL constraint selecting instances connected 
            by the object property in a reciprocal manner.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>


    <xsl:template name="connectorAsymmetry">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name)"/>
        <xsl:variable name="sourceClassName"
            select="$connector/source/model/@name"/>
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
        <xsl:variable name="targetClassName"
            select="$connector/target/model/@name"/>
        <xsl:variable name="targetRole"
            select="
                if (boolean($connector/target/role/@name)) then
                    $connector/target/role/@name
                else
                    fn:error(xs:QName('connectors'),concat($connector/@xmi:idref, ' - connector target role name is empty'))"/>
        <xsl:variable name="targetRoleURI"
            select="f:buildURIfromLexicalQName($targetRole)"/>

        <xsl:variable name="connectorDirection" select="$connector/properties/@direction"/>
        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($sourceClassName,$targetRole)}">
                <sh:sparql rdf:parseType="Resource">
                    <sh:select>SELECT ?this ?that WHERE { ?this &lt;<xsl:value-of
                        select="$targetRoleURI"/>&gt; ?that . ?that &lt;<xsl:value-of
                            select="$targetRoleURI"/>&gt; ?this .}</sh:select>
                </sh:sparql>
            </rdf:Description>

            
        
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($sourceClassName,$targetRole)}">
                <sh:sparql rdf:parseType="Resource">
                    <sh:select>SELECT ?this ?that WHERE { ?this &lt;<xsl:value-of
                        select="$targetRoleURI"/>&gt; ?that . ?that &lt;<xsl:value-of
                            select="$targetRoleURI"/>&gt; ?this .}</sh:select>
                </sh:sparql>
            </rdf:Description>

    
            <rdf:Description
                rdf:about="{f:buildPropertyShapeURI($targetClassName,$sourceRole)}">
                <sh:sparql rdf:parseType="Resource">
                    <sh:select>SELECT ?this ?that WHERE { ?this &lt;<xsl:value-of
                        select="$sourceRoleURI"/>&gt; ?that . ?that &lt;<xsl:value-of
                            select="$sourceRoleURI"/>&gt; ?this .}</sh:select>
                </sh:sparql>
            </rdf:Description>

        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>This will override the common selector when applying templates</xd:desc>
    </xd:doc>
    <xsl:template match="connector[./properties/@ea_type = 'Realisation']"/>


</xsl:stylesheet>
