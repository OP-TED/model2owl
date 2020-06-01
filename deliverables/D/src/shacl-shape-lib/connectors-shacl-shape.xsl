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
        <xd:desc>[Rule 14]-(Association range shape in data shape layer) . Within the SHACL Node
            Shape corresponding to the source UML class, specify property constraints indicating the
            range class.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>


    <xsl:template name="connectorRange">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name, fn:true())"/>
        <xsl:variable name="sourceRole"
            select="
                if (boolean($connector/source/role/@name)) then
                    f:lexicalQNameToWords($connector/source/role/@name)
                    else ()
                    "/>
        <xsl:variable name="sourceRoleURI"
            select="
                if (boolean($sourceRole)) then
                    f:buildURIfromLexicalQName($sourceRole, fn:false())
                else
                    ()"
        />
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

        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">

            <sh:NodeShape rdf:about="{$sourceClassURI}">
                <sh:property>
                    <sh:PropertyShape>
                        <sh:path rdf:resource="{$targetRoleURI}"/>
                        <sh:name>
                            <xsl:value-of select="$targetRole"/>
                        </sh:name>
                        <sh:class rdf:resource="{$targetClassURI}"/>
                    </sh:PropertyShape>
                </sh:property>
            </sh:NodeShape>
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <sh:NodeShape rdf:about="{$sourceClassURI}">
                <sh:property>
                    <sh:PropertyShape>
                        <sh:path rdf:resource="{$targetRoleURI}"/>
                        <sh:name>
                            <xsl:value-of select="$targetRole"/>
                        </sh:name>
                        <sh:class rdf:resource="{$targetClassURI}"/>
                    </sh:PropertyShape>
                </sh:property>
            </sh:NodeShape>
            <sh:NodeShape rdf:about="{$targetClassURI}">
                <sh:property>
                    <sh:PropertyShape>
                        <sh:path rdf:resource="{$sourceRoleURI}"/>
                        <sh:name>
                            <xsl:value-of select="$sourceRole"/>
                        </sh:name>
                        <sh:class rdf:resource="{$sourceClassURI}"/>
                    </sh:PropertyShape>
                </sh:property>
            </sh:NodeShape>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc> Rule 15 (Association multiplicity in data shape layer) . Within the SHACL Node
            Shape corresponding to the source UML class, specify property constraints indicating
            minimum and maximum cardinality according to cases provided by Rule 8 </xd:desc>
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
      <!--  <xsl:value-of select="$connector/target/type/@multiplicity"/>-->
        <!--<xsl:value-of select="$targetMultiplicity"/>-->
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
            <sh:NodeShape rdf:about="{$sourceClassURI}">
                <sh:property>
                    <sh:PropertyShape>
                        <sh:path rdf:resource="{$targetRoleURI}"/>
                        <sh:name>
                            <xsl:value-of select="$targetRole"/>
                        </sh:name>
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
                    </sh:PropertyShape>
                </sh:property>
            </sh:NodeShape>
        </xsl:if>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($targetMultiplicity)">
            <sh:NodeShape rdf:about="{$sourceClassURI}">
                <sh:property>
                    <sh:PropertyShape>
                        <sh:path rdf:resource="{$targetRoleURI}"/>
                        <sh:name>
                            <xsl:value-of select="$targetRole"/>
                        </sh:name>
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
                    </sh:PropertyShape>
                </sh:property>
            </sh:NodeShape>
        </xsl:if>
        <xsl:if
            test="
                $connectorDirection = 'Bi-Directional' and
                boolean($sourceMultiplicity)">
            <sh:NodeShape rdf:about="{$targetClassURI}">
                <sh:property>
                    <sh:PropertyShape>
                        <sh:path rdf:resource="{$sourceRoleURI}"/>
                        <sh:name>
                            <xsl:value-of select="$sourceRole"/>
                        </sh:name>
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
                    </sh:PropertyShape>
                </sh:property>
            </sh:NodeShape>
        </xsl:if>

    </xsl:template>

    <xd:doc>
        <xd:desc>Rule 18 (Association asymmetry in data shape layer) . Within the SHACL Node Shape
            corresponding to the UML class, specify SPARQL constraint selecting instances connected
            by the object property in a reciprocal manner.</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>


    <xsl:template name="connectorAsymmetry">
        <xsl:param name="connector"/>
        <xsl:variable name="sourceClassURI"
            select="f:buildURIfromLexicalQName($connector/source/model/@name, fn:true())"/>
        <xsl:variable name="sourceRole"
            select="
                if (boolean($connector/source/role/@name)) then
                    f:lexicalQNameToWords($connector/source/role/@name)
                else
                    ()
                "
        />
        <xsl:variable name="sourceRoleURI"
            select="
                if (boolean($sourceRole)) then
                    f:buildURIfromLexicalQName($sourceRole, fn:false())
                else
                    ()"
        />
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
        <xsl:if test="$connectorDirection = 'Source -&gt; Destination'">
            <sh:NodeShape rdf:about="{$sourceClassURI}">
                <sh:sparql rdf:parseType="Resource">
                    <sh:select> SELECT ?this ?that WHERE { ?this &lt;<xsl:value-of select="$targetRoleURI"
                    />&gt; ?that . ?that &lt;<xsl:value-of select="$targetRoleURI"/>&gt; ?this .} </sh:select>
                </sh:sparql>
            </sh:NodeShape>
        </xsl:if>
        <xsl:if test="$connectorDirection = 'Bi-Directional'">
            <sh:NodeShape rdf:about="{$sourceClassURI}">
                <sh:sparql rdf:parseType="Resource">
                    <sh:select> SELECT ?this ?that WHERE { ?this &lt;<xsl:value-of select="$targetRoleURI"
                    />&gt; ?that . ?that &lt;<xsl:value-of select="$targetRoleURI"/>&gt; ?this .} </sh:select>
                </sh:sparql>
            </sh:NodeShape>
            <sh:NodeShape rdf:about="{$targetClassURI}">
                <sh:sparql rdf:parseType="Resource">
                    <sh:select> SELECT ?this ?that WHERE { ?this &lt;<xsl:value-of select="$sourceRoleURI"
                    />&gt; ?that . ?that &lt;<xsl:value-of select="$sourceRoleURI"/>&gt; ?this .} </sh:select>
                </sh:sparql>
            </sh:NodeShape>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>
