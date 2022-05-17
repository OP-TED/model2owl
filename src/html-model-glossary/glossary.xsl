<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">


    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/fetchers.xsl"/>


    <xsl:template name="glossary">
        <h1>Model glossary</h1>
        <h2>Class names and definitions</h2>
        <table class="display">
            <thead class="center aligned">
                <tr>
                    <th>Class name</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <xsl:call-template name="listOfClassNamesAndDescription"/>
            </tbody>
        </table>

        <h2>DataType properties and definitions</h2>
        <table class="display">
            <thead class="center aligned">
                <tr>
                    <th>Attribute name</th>
                    <th>Description</th>
                    <th>Domain class name</th>
                    <th>Range data type</th>
                </tr>
            </thead>
            <tbody>
                <xsl:call-template name="listOfClassAttributeNames"/>
            </tbody>
        </table>

        <h2>Object properties and definitions</h2>
        <table class="display">
            <thead class="center aligned">
                <tr>
                    <th>Connector name</th>
                    <th>Description</th>
                    <th>Domain and Range classes</th>
                </tr>
            </thead>
            <tbody>
                <xsl:call-template name="listOfConnectors"/>
            </tbody>
        </table>
    </xsl:template>


    <xsl:template name="listOfClassNamesAndDescription">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="classNames" select="f:getDistinctClassNames($root)"/>
        <xsl:for-each select="$classNames">
            <xsl:sort select="." lang="en"/>
            <tr>
                <td>
                    <xsl:value-of select="."/>
                </td>
                <td>
                    <xsl:variable name="classElement" select="f:getElementByName(., $root)"/>
                    <xsl:value-of select="$classElement/properties/@documentation"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>




    <xsl:template name="listOfClassAttributeNames">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="attributeNames" select="f:getDistinctClassAttributeNames($root)"/>
        <xsl:for-each select="$attributeNames">
            <xsl:sort select="." lang="en"/>
            <xsl:variable name="attributeName" select="."/>
            <tr>
                <td>

                    <xsl:value-of select="$attributeName"/>
                </td>

                <xsl:call-template name="classAttributeUsage">
                    <xsl:with-param name="attributeName" select="$attributeName"/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
            </tr>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="classAttributeUsage">
        <xsl:param name="attributeName"/>
        <xsl:param name="root"/>
        <xsl:variable name="attributesWithSameName"
            select="f:getClassAttributeByName($attributeName, $root)"/>
        <xsl:choose>
            <xsl:when test="fn:count($attributesWithSameName) > 1">
                <td>
                    <xsl:value-of select="$attributesWithSameName[0]/documentation/@value"/>
                </td>
                <td>
                    <xsl:for-each select="$attributesWithSameName">
                        <xsl:value-of select="./parent::attributes/parent::element/@name"/>
                        <br/>
                    </xsl:for-each>
                </td>
                <td>
                    <xsl:for-each select="$attributesWithSameName">
                        <xsl:variable name="attributeType" select="./properties/@type"/>
                        <xsl:variable name="attributeMultiplicityMin" select="./bounds/@lower"/>
                        <xsl:variable name="attributeMultiplicityMax" select="./bounds/@upper"/>
                        <xsl:value-of
                            select="fn:concat($attributeType, ' [', $attributeMultiplicityMin, '..', $attributeMultiplicityMax, ']')"/>
                        <br/>
                    </xsl:for-each>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="className"
                    select="$attributesWithSameName/parent::attributes/parent::element/@name"/>
                <td>
                    <xsl:value-of select="$attributesWithSameName/documentation/@value"/>
                </td>
                <td>
                    <xsl:value-of select="$className"/>
                </td>
                <xsl:variable name="attributeType" select="$attributesWithSameName/properties/@type"/>
                <xsl:variable name="attributeMultiplicityMin"
                    select="$attributesWithSameName/bounds/@lower"/>
                <xsl:variable name="attributeMultiplicityMax"
                    select="$attributesWithSameName/bounds/@upper"/>
                <td>
                    <xsl:value-of
                        select="fn:concat($attributeType, ' [', $attributeMultiplicityMin, '..', $attributeMultiplicityMax, ']')"
                    />
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="listOfConnectors">
        <xsl:variable name="root" select="root()"/>
        <xsl:variable name="connectorNames" select="f:getDistinctConnectorsNames($root)"/>
        <xsl:for-each select="$connectorNames">
            <xsl:sort select="." lang="en"/>
            <xsl:variable name="connectorName" select="."/>
            <tr>
                <td>
                    <xsl:value-of select="$connectorName"/>
                </td>

                <xsl:call-template name="connectorUsage">
                    <xsl:with-param name="connectorName" select="$connectorName"/>
                    <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
            </tr>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="connectorUsage">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorsWithSameName"
            select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:choose>
            <xsl:when test="fn:count($connectorsWithSameName) > 1">
                <td>
                    <xsl:value-of
                        select="fn:concat($connectorsWithSameName[0]/documentation/@value, $connectorsWithSameName[0]/source/documentation/@value, $connectorsWithSameName[0]/target/documentation/@value)"
                    />
                </td>
                <td>
                    <xsl:for-each select="$connectorsWithSameName">
                        <xsl:variable name="targetClass"
                            select="f:getElementByIdRef(./target/@xmi:idref, $root)/@name"/>
                        <xsl:variable name="sourceClass"
                            select="f:getElementByIdRef(./source/@xmi:idref, $root)/@name"/>
                        <xsl:variable name="targetMultiplicity" select="./target/type/@multiplicity"/>
                        <xsl:variable name="sourceMultiplicity" select="./source/type/@multiplicity"/>
                        <xsl:if test="./target/role/@name = $connectorName">

                            <xsl:value-of
                                select="fn:concat($sourceClass, ' -&gt; ', $targetClass, ' [', $targetMultiplicity, ']')"/>
                            <br/>
                        </xsl:if>
                        <xsl:if test="./source/role/@name = $connectorName">

                            <xsl:value-of
                                select="fn:concat($sourceClass, ' [,', $sourceMultiplicity, ']', ' &lt;- ', $targetClass)"/>
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <td>
                    <xsl:value-of
                        select="fn:concat($connectorsWithSameName/documentation/@value, $connectorsWithSameName/source/documentation/@value, $connectorsWithSameName/target/documentation/@value)"
                    />
                </td>

                <xsl:variable name="targetClass"
                    select="
                        if (f:getElementByIdRef($connectorsWithSameName/target/@xmi:idref, $root)/@name) then
                            f:getElementByIdRef($connectorsWithSameName/target/@xmi:idref, $root)/@name
                        else
                            $connectorsWithSameName/target/model/@name"/>
                <xsl:variable name="sourceClass"
                    select="
                        if (f:getElementByIdRef($connectorsWithSameName/source/@xmi:idref, $root)/@name) then
                            f:getElementByIdRef($connectorsWithSameName/source/@xmi:idref, $root)/@name
                        else
                            $connectorsWithSameName/source/model/@name"/>
                <xsl:variable name="targetMultiplicity"
                    select="$connectorsWithSameName/target/type/@multiplicity"/>
                <xsl:variable name="sourceMultiplicity"
                    select="$connectorsWithSameName/source/type/@multiplicity"/>
                <xsl:if test="$connectorsWithSameName/target/role/@name = $connectorName">
                    <td>
                        <xsl:value-of
                            select="fn:concat($sourceClass, ' -&gt; ', $targetClass, ' [', $targetMultiplicity, ']')"
                        />
                    </td>
                </xsl:if>
                <xsl:if test="$connectorsWithSameName/source/role/@name = $connectorName">
                    <td>
                        <xsl:value-of
                            select="fn:concat($sourceClass, ' [,', $sourceMultiplicity, ']', ' &lt;- ', $targetClass)"
                        />
                    </td>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>