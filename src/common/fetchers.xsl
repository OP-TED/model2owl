<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"     
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" 
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:import href="../../config-proxy.xsl"/>
    
    <xd:doc>
        <xd:desc>fetch the xmi:element with a given name</xd:desc>
        <xd:param name="name"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getElementByName" as="node()*">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="$root//elements/element[@name=$name]"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>fetch the element attribute with a given name</xd:desc>
        <xd:param name="name"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getAttributeByName" as="node()*">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="$root//elements/element/attributes/attribute[@name=$name]"/>
    </xsl:function>
    

    
    <xd:doc>
        <xd:desc>fetch the xmi:element with a given idRef</xd:desc>
        <xd:param name="idRef"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getElementByIdRef" as="node()*">
        <xsl:param name="idRef" as="xs:string"/>
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="$root//elements/element[@xmi:idref=$idRef]"/>
    </xsl:function>
    
    
    
    <xd:doc>
        <xd:desc>Get the conenctors outgoing from the element</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:getOutgoingConnectors" as="node()*">
        <xsl:param name="element" as="node()"/>
        <xsl:sequence select="root($element)//connector[source/@xmi:idref = $element/@xmi:idref]"/>
    </xsl:function>
    

    <xd:doc>
        <xd:desc>Get the connectors incomming to the element</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:getIncommingConnectors" as="node()*">
        <xsl:param name="element" as="node()"/>
        <xsl:sequence select="root($element)//connector[target/@xmi:idref = $element/@xmi:idref]"/>        
    </xsl:function>
    
    <xd:doc>
        <xd:desc>fetch the xmi:conenctor with a given name</xd:desc>
        <xd:param name="name"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getConnectorByName" as="node()*">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="root" as="node()"/>
        <xsl:sequence
            select="$root//connectors/connector[@name | target/role/@name | source/role/@name = $name]"
        />
    </xsl:function>
    
    <xd:doc>
        <xd:desc>fetch the xmi:connector with a given idRef</xd:desc>
        <xd:param name="idRef"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getConnectorByIdRef" as="node()*">
        <xsl:param name="idRef" as="xs:string"/>
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="$root//connectors/connector[@xmi:idref=$idRef]"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>fetch all the elements contained in the $element</xd:desc>
        <xd:param name="element"/>

    </xd:doc>
    <xsl:function name="f:getPackageElements" as="node()*">
        <xsl:param name="element" as="node()"/>
        <xsl:variable name="root" select="root($element)"/>
        <xsl:variable name="childElementsIds"
            select="$root//packagedElement[@xmi:type = 'uml:Package' and @xmi:id = $element/@xmi:idref]/*/@xmi:id"/>
        <xsl:variable name="childElements"
            select="$root//elements/element[@xmi:idref = $childElementsIds]"/>
        <xsl:sequence select="$childElements"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Get the superClass from using a generalization</xd:desc>
        <xd:param name="generalization"/>
    </xd:doc>
    <xsl:function name="f:getSuperClassFromGeneralization" as="xs:string*">
        <xsl:param name="generalization" as="node()"/>
        <!--<xsl:variable name="root" select="root($element)"/>-->
<!--        <xsl:variable name="superClassQname" select="$generalization/target/@xmi:idref" as="xs:string"/>-->
        <xsl:value-of select="$generalization/target/model/@name"/>
<!--        /xmi:XMI/xmi:Extension/connectors/connector[./properties/@ea_type = 'Generalization'][target/@xmi:idref='EAID_E84B97D8_2656_498d_B584_D95C2DBBD7A1']/source/model/@name-->
        
    </xsl:function>
    <xd:doc>
        <xd:desc>Get the subClasses from superClass and a generalization</xd:desc>
        <xd:param name="generalization"/>
    </xd:doc>
    <xsl:function name="f:getSubClassesFromGeneralization">
        <xsl:param name="generalization" as="node()"/>
        <xsl:variable name="root" select="root($generalization)"/>
<!--        <xsl:variable name="superClassId" select="f:getSuperClassFromGeneralization($generalization)/@xmi:idref" as="xs:string"/>-->
        <xsl:variable name="subClassesId"
            select="
                $root//connectors/connector[./properties/@ea_type = 'Generalization' and target/model/@name = f:getSuperClassFromGeneralization($generalization)]/source/@xmi:idref
                "
        />
        <xsl:sequence
            select="
                for $id in $subClassesId
                return
                  f:getElementByIdRef($id, $root)"
        />
    </xsl:function>
    
    <xd:doc>
        <xd:desc>fetch the class attribute with a given name</xd:desc>
        <xd:param name="name"/>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getClassAttributeByName" as="node()*">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="$root//element[@xmi:type = 'uml:Class']/attributes/attribute[@name=$name]"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>fetch all distinct class attribute names</xd:desc>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getDistinctClassAttributeNames" as="xs:string*">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="fn:distinct-values($root//element[@xmi:type = 'uml:Class']/attributes/attribute/@name)"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>fetch all connector distinct names</xd:desc>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getDistinctConnectorsNames" as="xs:string*">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="fn:distinct-values($root//connectors/connector/(@name | target/role/@name | source/role/@name))"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>fetch all class distinct names</xd:desc>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getDistinctClassNames" as="xs:string*">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="fn:distinct-values($root//element[@xmi:type = 'uml:Class']/@name)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Build connector name</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:function name="f:getConnectorName">
        <xsl:param name="connector"/>
        <xsl:variable name="hasNoName" select="$connector/not(@name)"/>
        <xsl:choose>
            <xsl:when test="$hasNoName = fn:true()">
                <xsl:variable name="source" select="f:getConnectorSourceName($connector)"/>
                <xsl:variable name="target" select="f:getConnectorTargetName($connector)"/>
                <xsl:if test="f:getConnectorDirection($connector) = 'Source -&gt; Destination'">
                    <xsl:variable name="targetRole" select="$connector/target/role/@name"/>
                    <xsl:value-of select="fn:concat($source, ' -&gt; ', $target, ' ', '(+',$targetRole,')' )"/>
                </xsl:if>
                <xsl:if test="f:getConnectorDirection($connector) = 'Bi-Directional'">
                    <xsl:variable name="targetRole" select="$connector/target/role/@name"/>
                    <xsl:variable name="sourceRole" select="$connector/source/role/@name"/>
                    <xsl:value-of select="fn:concat($source, ' &lt;-&gt; ', $target,' ', '(+',$targetRole,' ','+',$sourceRole,')' )"/>
                </xsl:if>
                <xsl:if test="f:getConnectorDirection($connector) != 'Source -&gt; Destination' and 
                    f:getConnectorDirection($connector) != 'Bi-Directional'">
                    <xsl:variable name="targetRole" select="$connector/target/role/@name"/>
                    <xsl:variable name="sourceRole" select="$connector/source/role/@name"/>
                    <xsl:value-of select="fn:concat($source, ' X ', $target, ' ', '(+',$targetRole,' ','+',$sourceRole,')' )"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$connector/@name"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Get association direction</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:function name="f:getConnectorDirection">
        <xsl:param name="connector"/>
        <xsl:value-of select="$connector/properties/@direction"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Get the source name of a connector</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:function name="f:getConnectorSourceName" as="xs:string">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
            if ($connector/source/model/@name = 'ProxyConnector') then
            fn:concat('(', 
            f:getConnectorByIdRef(fn:string(f:getElementByIdRef(fn:string($connector/source/@xmi:idref), root($connector))/@classifier), root($connector))/source/model/@name,
            ' - ',
            f:getConnectorByIdRef(fn:string(f:getElementByIdRef(fn:string($connector/source/@xmi:idref), root($connector))/@classifier), root($connector))/target/model/@name,
            ')')
            else
            $connector/source/model/@name "
        />
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Get the target name of a connector</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    
    <xsl:function name="f:getConnectorTargetName" as="xs:string">
        <xsl:param name="connector"/>
        <xsl:sequence
            select="
            if ($connector/target/model/@name = 'ProxyConnector') then
            fn:concat('(', 
            f:getConnectorByIdRef(fn:string(f:getElementByIdRef(fn:string($connector/target/@xmi:idref), root($connector))/@classifier), root($connector))/source/model/@name,
            ' - ',
            f:getConnectorByIdRef(fn:string(f:getElementByIdRef(fn:string($connector/target/@xmi:idref), root($connector))/@classifier), root($connector))/target/model/@name,
            ')')
            else
            $connector/target/model/@name "
        />
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>Get all namespaces used in the XMI</xd:desc>
        <xd:param name="root"/>
    </xd:doc>
    <xsl:function name="f:getAllNamespacesUsed">
        <xsl:param name="root" as="node()"/>
        <xsl:variable name="distinctElementNames" select="fn:distinct-values($root//element/@name)"/>
        <xsl:variable name="distinctAttributeNames" select="fn:distinct-values($root//element/attributes/attribute/@name)"/>
        <xsl:variable name="distinctConnectorNames"
            select="fn:distinct-values($root//connectors/connector/(@name | */role/@name | */model/@name))"
        />
        <xsl:variable name="prefixesFromElements"
            select="fn:distinct-values(
            for $elementName in $distinctElementNames
                return
                    if (fn:contains($elementName, ':')) then
                        fn:substring-before($elementName, ':')
                    else
                        ())"
        />
        <xsl:variable name="prefixesFromAttributes" select="fn:distinct-values(
            for $attributeName in $distinctAttributeNames
            return
            if (fn:contains($attributeName, ':')) then
            fn:substring-before($attributeName, ':')
            else
            ())"/>
        <xsl:variable name="prefixesFromConnectors" select="fn:distinct-values(
            for $connectorName in $distinctConnectorNames
            return
            if (fn:contains($connectorName, ':')) then
            fn:substring-before($connectorName, ':')
            else
            ())"/>
        <xsl:sequence
            select="fn:distinct-values(fn:insert-before(fn:insert-before($prefixesFromAttributes, 1, $prefixesFromElements), 1, $prefixesFromConnectors))"
        />

    </xsl:function>
    
    <xd:doc>
        <xd:desc>fetch the all tags for a element</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:getElementTags">
        <xsl:param name="element"/>
        <xsl:sequence select="$element/tags/tag"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Fetch all tags for a connector, including source, target, and connector-level tags</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:function name="f:getConnectorTags">
        <xsl:param name="connector"/>
        <!-- Fetch all tags from source, target, and connector level -->
        <xsl:sequence select="$connector//tags/tag" />
    </xsl:function>
    
    <xd:doc>
        <xd:desc> Fetch role name value from a connector. It can be either in source or in target</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:function name="f:getRoleNameFromConnector" as="xs:string">
        <xsl:param name="connector"/>
        <xsl:sequence select="($connector/source/role/@name, $connector/target/role/@name)[1]"/>
    </xsl:function>
    
</xsl:stylesheet>