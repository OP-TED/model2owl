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

    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="../common/fetchers.xsl"/>
    <xsl:import href="utils-html-conventions.xsl"/>
    <xsl:import href="../../config-proxy.xsl"/>



    <xd:doc>
        <xd:desc>Getting all generalisations and show only the ones that have unmet conventions </xd:desc>
    </xd:doc>

    <xsl:template match="connector[./properties/@ea_type = 'Generalization']">
        <xsl:variable name="generalizationChecks" as="item()*">
            <xsl:if test="f:checkIfConnectorTargetAndSourceElementsExists(.)">
                <xsl:call-template name="generalizationClassWithSingleChild">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="generalizationInverseInheritance">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="generalizationHasName">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="generalizationHasRoleName">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="generalizationHasMultiplicity">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="generalizationDirectionChecker">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="generalizationSourceTargetTypes">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="./source/model/@type = 'ProxyConnector' and ./target/model/@type = 'ProxyConnector'">
                <xsl:call-template name="generalizationUnidirectionalConnectorsDirection">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
                <xsl:call-template name="generalizationMissingOrInvalidClassGeneralization">
                    <xsl:with-param name="generalizationConnector" select="."/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="boolean($generalizationChecks)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2>
                        <xsl:value-of select="f:getConnectorName(.)"/>
                    </h2>
                    <dl>
                        <dt> Unmet generalisation conventions </dt>
                        <xsl:copy-of select="$generalizationChecks"/>
                    </dl>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$generalizationChecks"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>[generalisation-hierarchy-1] - The class $parent$ has only one sub-class $child$.
            Class inheritance should be built employing at least two subclasses for each class or
            not at all. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="generalizationClassWithSingleChild">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="idRefTarget" select="$generalizationConnector/target/@xmi:idref"/>
        <xsl:variable name="targetElement"
            select="f:getElementByIdRef($idRefTarget, root($generalizationConnector))"/>
        <xsl:sequence
            select="
                if (count(f:getIncommingConnectors($targetElement)[properties/@ea_type = 'Generalization']) > 2) then
                    ()
                else
                    f:generateInfoMessage(fn:concat('The class ', $generalizationConnector/target/model/@name, ' has only one sub-class ',
                    $generalizationConnector/source/model/@name, '. Class inheritance should be built employing at least two subclasses for each class or',
                    ' not at all.'),
                    path($generalizationConnector),
                    'generalisation-hierarchy-1',
                    'CMC-R8',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r8&quot; target=&quot;_blank&quot;&gt;CMC-R8&lt;/a&gt;'
                    )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-hierarchy-2] - The classes $class1$ and $class2$ inherit one
            another. Sub-class relation must be established in one direction only, forming a
            hierarchy. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>

    <xsl:template name="generalizationInverseInheritance">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="idRefTarget" select="$generalizationConnector/target/@xmi:idref"/>
        <xsl:variable name="targetElement"
            select="f:getElementByIdRef($idRefTarget, root($generalizationConnector))"/>
        <xsl:variable name="idRefSource" select="$generalizationConnector/source/@xmi:idref"/>
        <xsl:sequence
            select="
                if (boolean(f:getOutgoingConnectors($targetElement)[target/@xmi:idref = $idRefSource and properties/@ea_type = 'Generalization'])) then
                    f:generateErrorMessage(fn:concat('The classes ', $generalizationConnector/target/model/@name, ' and ', $generalizationConnector/source/model/@name, ' inherit one ',
                    'another. Sub-class relation must be established in one direction only, forming a hierarchy.'),
                    path($generalizationConnector),
                    'generalisation-hierarchy-2',
                    'SC-R5',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-semantic-conventions.html#sec:sc-r5&quot; target=&quot;_blank&quot;&gt;SC-R5&lt;/a&gt;'
                    )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-multiplicity-3] - The generalisation has multiplicity. No multiplicity can
            be provided to generalisations. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="generalizationHasMultiplicity">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="hasNoTargetMultiplicity"
            select="$generalizationConnector/target/type/not(@multiplicity)"/>
        <xsl:variable name="hasNoSourceMultiplicity"
            select="$generalizationConnector/source/type/not(@multiplicity)"/>
        <xsl:sequence
            select="
                if ($hasNoTargetMultiplicity and $hasNoSourceMultiplicity) then
                    ()
                else
                    f:generateErrorMessage('The generalisation has multiplicity. No multiplicity can be provided to generalisations.',
                    path($generalizationConnector),
                    'generalisation-multiplicity-3',
                    'CMC-R11',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r11&quot; target=&quot;_blank&quot;&gt;CMC-R11&lt;/a&gt;
                    &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[generalisation-name-4] - The connector $connectorName$ has a name. No name can be
            provided for generalisation relation. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="generalizationHasName">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="generalizationHasNoName" select="$generalizationConnector/not(@name)"/>
        <xsl:sequence
            select="
                if ($generalizationHasNoName = fn:false()) then
                    f:generateErrorMessage(fn:concat('The connector ', $generalizationConnector/@name, ' has a name. No name can be provided for generalisation relation.'),
                    path($generalizationConnector),
                    'generalisation-name-4',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-name-5] - The generalisation connector has a role name. No source
            or target roles can be provided to generalisations. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="generalizationHasRoleName">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="hasNoTargetRoleName"
            select="$generalizationConnector/target/role/not(@name)"/>
        <xsl:variable name="hasNoSourceRoleName"
            select="$generalizationConnector/source/role/not(@name)"/>
        <xsl:sequence
            select="
                if ($hasNoTargetRoleName and $hasNoSourceRoleName) then
                    ()
                else
                    f:generateErrorMessage('The generalisation connector has a role name. No source or target roles can be provided to generalisations.',
                    path($generalizationConnector),
                    'generalisation-name-5',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-direction-6] - The $direction$ direction is invalid.
            Generalisations must employ "Source->Destination" direction only. </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    <xsl:template name="generalizationDirectionChecker">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="generalizationDirection"
            select="$generalizationConnector/properties/@direction"/>
        <xsl:sequence
            select="
                if ($generalizationDirection != 'Source -&gt; Destination') then
                    f:generateErrorMessage(fn:concat('The ', $generalizationDirection, ' direction is invalid. ',
                    'Generalisations must employ Source -&gt; Destination direction only.'),
                    path($generalizationConnector),
                    'generalisation-direction-6',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )
                else
                    ()"
        />
    </xsl:template>

    <xd:doc>
        <xd:desc>[generalisation-source-target-types-7] - Generalisations can be provided only
            between classes or between connectors.</xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>

    <xsl:template name="generalizationSourceTargetTypes">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="sourceType" select="$generalizationConnector/source/model/@type"/>
        <xsl:variable name="targetType" select="$generalizationConnector/target/model/@type"/>
        <xsl:sequence
            select="
                if (($sourceType = 'Class' and $targetType = 'Class') or ($sourceType = 'ProxyConnector' and $targetType = 'ProxyConnector')) then
                    ()
                else
                f:generateErrorMessage('Generalisations can be provided only between classes or between connectors.',
                path($generalizationConnector),
                'generalisation-source-target-types-7',
                'CMC-R12',
                '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                )"
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[generalisation-connector-unidirectional-connector-direction-8] - direction of connectors associated with the generalisation connector
            doesn’t match</xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    
    <xsl:template name="generalizationUnidirectionalConnectorsDirection">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="targetConnector"
            select="f:getTargetConnectorFromGeneralisation($generalizationConnector)"/>
        <xsl:variable name="sourceConnector"
            select="f:getSourceConnectorFromGeneralisation($generalizationConnector)"/>
        <xsl:variable name="targetConnectorSource" select="$targetConnector/source/model/@name"/>
        <xsl:variable name="targetConnectorTarget" select="$targetConnector/target/model/@name"/>
        <xsl:variable name="sourceConnectorSource" select="$sourceConnector/source/model/@name"/>
        <xsl:variable name="sourceConnectorTarget" select="$sourceConnector/target/model/@name"/>
        
        <xsl:variable name="targetConnectorString" select="fn:concat($targetConnectorSource,' -&gt; ', $targetConnectorTarget)"/>
        <xsl:variable name="sourceConnectorString" select="fn:concat($sourceConnectorSource,' -&gt; ', $sourceConnectorTarget)"/>
        
        <xsl:variable name="associationsBoundsClassNames" as="xs:string*">
            <xsl:sequence select="(
                $targetConnectorSource,
                $targetConnectorTarget,
                $sourceConnectorSource,
                $sourceConnectorTarget
                )"/>
        </xsl:variable>
        
        <xsl:variable name="distinctClassNames" select="distinct-values($associationsBoundsClassNames)" as="xs:string*"/>
        
        <xsl:if test="not(count($associationsBoundsClassNames) = count($distinctClassNames))">
        
        
        <xsl:sequence
            select="
            if (not(f:generalisationConnectorsHasOppositeDirections($generalizationConnector))) then
            ()
            else
            f:generateErrorMessage(fn:concat('The unidirectional connectors ',$targetConnectorString, ' and ', $sourceConnectorString,' associated with the generalisation connector have opposite directions'),
            path($generalizationConnector),
            'generalisation-connector-unidirectional-connector-direction-8',
            '',
            ''
            )"
        />
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[generalisation-connector-and-missing-class-generalisation-9] [generalisation-connector-and-class-inheritance-direction-10] -
            Missing class generalisation for two distinct classes related to the connector generalisation or
            connector generalisation and class generalisation relationship direction mismatch
        </xd:desc>
        <xd:param name="generalizationConnector"/>
    </xd:doc>
    
    <xsl:template name="generalizationMissingOrInvalidClassGeneralization">
        <xsl:param name="generalizationConnector"/>
        <xsl:variable name="targetConnector"
            select="f:getTargetConnectorFromGeneralisation($generalizationConnector)"/>
        <xsl:variable name="sourceConnector"
            select="f:getSourceConnectorFromGeneralisation($generalizationConnector)"/>
        <xsl:variable name="targetConnectorString" select="fn:concat($targetConnector/source/model/@name,' -&gt; ', $targetConnector/target/model/@name)"/>
        <xsl:variable name="sourceConnectorString" select="fn:concat($sourceConnector/source/model/@name,' -&gt; ', $sourceConnector/target/model/@name)"/>
        <xsl:sequence
            select="
            if (not(f:generalisationMissingOrIncorrect($generalizationConnector))) then
            ()
            else
            f:generateErrorMessage(fn:concat('The generalisation between ',$targetConnectorString, ' and ', $sourceConnectorString,' is missing or has invalid direction'),
            path($generalizationConnector),
            'generalisation-connector-unidirectional-connector-direction-8',
            '',
            ''
            )"
        />
    </xsl:template>

</xsl:stylesheet>