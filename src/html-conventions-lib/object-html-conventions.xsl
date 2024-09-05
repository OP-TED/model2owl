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
    <!--
    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="utils-html-conventions.xsl"/>-->
    <xsl:import href="common-elements-html-conventions.xsl"/>
    
    <xd:doc>
        <xd:desc>Getting all objectes and show only the ones with unmet conventions
        </xd:desc>
    </xd:doc>
    
    
    
    <xsl:template match="element[@xmi:type = 'uml:Object']">
        <xsl:variable name="objectName">
            <xsl:call-template name="getObjectName">
                <xsl:with-param name="object" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="objectConventions" as="item()*">
            <!--    Start of common checkers rules     -->
            <xsl:call-template name="namingFormat">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingNamePrefix">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingLocalSegmentName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalidNamePrefix">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="undefinedPrefix">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalidNameLocalSegment">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalidFirstCharacterInLocalSegment">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="delimitersInTheLocalSegment">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingDescription">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="elementType" select="'object'"/>
            </xsl:call-template>
            <xsl:call-template name="stereotypeProvided">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="elementType" select="'object'"/>
            </xsl:call-template>
            <xsl:call-template name="unknownStereotypeProvided">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="elementType" select="'object'"/>
            </xsl:call-template>
            <xsl:call-template name="invalidTagName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingTagValue">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingTagName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingPrefixTagName">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="namePlural">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="nonPublicElement">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:call-template name="elementUniqueName">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="isAttribute" select="fn:false()"/>
            </xsl:call-template>

            <!--    End of common checkers rules     -->
            <!--    Start of specific checker rules-->
            <xsl:call-template name="objectItemsChecker">
                <xsl:with-param name="object" select="."/>
            </xsl:call-template>

            <xsl:call-template name="objectOutgoingConnectors">
                <xsl:with-param name="object" select="."/>
            </xsl:call-template>

            <xsl:call-template name="objectInstanceConnectors">
                <xsl:with-param name="object" select="."/>
            </xsl:call-template>
            <!--    End of specific checker rules-->
            
        </xsl:variable>

        <xsl:if test="boolean($objectConventions)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2>
                        <xsl:value-of select="$objectName"/>
                    </h2>
                    <section>
                        <xsl:if test="boolean($objectConventions)">
                            <dl>
                                <dt>Unmet object conventions</dt>
                                <xsl:copy-of select="$objectConventions"/>
                            </dl>
                        </xsl:if>

                    </section>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$objectConventions"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Getting the object name</xd:desc>
        <xd:param name="object"/>
    </xd:doc>
    <xsl:template name="getObjectName">
        <xsl:param name="object"/>
        <xsl:variable name="objectName" select="$object/@name"/>
        <xsl:choose>
            <xsl:when test="$object/not(@name) = fn:true() or $object/@name = ''">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$objectName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    
    <xd:doc>
        <xd:desc>[object-attribute-2] The object $value$ shall have no values/attributes defined. 
             </xd:desc>
        <xd:param name="object"/>
    </xd:doc>
    
    <xsl:template name="objectItemsChecker">
        <xsl:param name="object"/>
        <xsl:variable name="objectNumberOfAttributes"
            select="count($object/attributes/attribute)"/>
        
        <xsl:sequence
            select="
            if ($objectNumberOfAttributes > 0) then
            f:generateWarningMessage(fn:concat('The object ', $object/@name,
            ' shall have no values/attributes defined. '),
            path($object),
            'object-attribute-2',
            'CMC-R19',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r19&quot; target=&quot;_blank&quot;&gt;CMC-R19&lt;/a&gt;'
            )
            else
            ()
            "
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>[object-connector-3] The object $value should not connect to other elements. 
             </xd:desc>
        <xd:param name="object"/>
    </xd:doc>
    
    <xsl:template name="objectOutgoingConnectors">
        <xsl:param name="object"/>
        <xsl:variable name="outgoingConnectors"
            select="f:getOutgoingConnectors($object)"/>
        <xsl:variable name="noOfOutgoingConnectors" select="count($outgoingConnectors/properties[@ea_type != 'Realisation'])"/>        
        <xsl:sequence
            select="
            if ($noOfOutgoingConnectors > 0) then
            f:generateErrorMessage(fn:concat('The object ', $object/@name,
            ' should not connect to other elements.'),
            path($object),
            'object-connector-3',
            'CMC-R19',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r19&quot; target=&quot;_blank&quot;&gt;CMC-R19&lt;/a&gt;'
            )
            else
            ()
            "
        />
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[object-connector-4] The object $name should instanciate a Class or Enumeration. 
            There shall be at least one Realisation relationship between the Object and a Class or Enumeration. 
        </xd:desc>
        <xd:param name="object"/>
    </xd:doc>
    
    <xsl:template name="objectInstanceConnectors">
        <xsl:param name="object"/>
        <xsl:variable name="outgoingConnectors"
            select="f:getOutgoingConnectors($object)"/>
        <xsl:variable name="noOfRealisationOutgoingConnectors" select="count($outgoingConnectors/properties[@ea_type = 'Realisation'])"/>        
        <xsl:sequence
            select="
            if ($noOfRealisationOutgoingConnectors = 0) then
            f:generateWarningMessage(fn:concat('The object ', $object/@name,
            ' should instanciate a Class or Enumeration. There shall be at least one Realisation relationship between Object and a Class or Enumeration.'),
            path($object),
            'object-connector-4',
            'CMC-R19',
            '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r19&quot; target=&quot;_blank&quot;&gt;CMC-R19&lt;/a&gt;'
            )
            else
            ()
            "
        />
    </xsl:template>
    
    
    
</xsl:stylesheet>