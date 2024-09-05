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
        <xd:desc>Getting all classes and attributes and show only the ones with unmet conventions
        </xd:desc>
    </xd:doc>



    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:variable name="className">
            <xsl:call-template name="getClassName">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="classConventions" as="item()*">
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
                    <xsl:with-param name="elementType" select="'class'"/>
                </xsl:call-template>
                <xsl:call-template name="stereotypeProvided">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="elementType" select="'class'"/>
                </xsl:call-template>
                <xsl:call-template name="unknownStereotypeProvided">
                    <xsl:with-param name="element" select="."/>
                    <xsl:with-param name="elementType" select="'class'"/>
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
                <xsl:call-template name="classIsNotPascalNamed">
                    <xsl:with-param name="class" select="."/>
                </xsl:call-template>
                <xsl:call-template name="classUnderspecified">
                    <xsl:with-param name="class" select="."/>
                </xsl:call-template>
                <xsl:call-template name="classDisconnected">
                    <xsl:with-param name="class" select="."/>
                </xsl:call-template>
                <!--    End of specific checker rules-->
            
        </xsl:variable>
        <xsl:variable name="classAttributeConventions" as="item()*">
            <xsl:apply-templates select="attributes/attribute"/>
        </xsl:variable>
        <xsl:if test="boolean($classConventions) or boolean($classAttributeConventions)">
            <xsl:choose>
                <xsl:when test="$reportType = 'HTML'">
                    <h2 id="{$className}">
                        <xsl:value-of select="$className"/>
                    </h2>
                    <section>
                        <xsl:if test="boolean($classConventions)">
                            <dl>
                                <dt>Unmet class conventions</dt>
                                <xsl:copy-of select="$classConventions"/>
                            </dl>
                        </xsl:if>
                        <xsl:if test="boolean($classAttributeConventions)">
                            <xsl:copy-of select="$classAttributeConventions"/>
                        </xsl:if>
                    </section>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$classConventions"/>
                    <xsl:copy-of select="$classAttributeConventions"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Getting the class name</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="getClassName">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:choose>
            <xsl:when test="$class/not(@name) = fn:true() or $class/@name = ''">
                <xsl:value-of>No name</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$className"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>[class-connector-4] - The class $className$ is disconnected. A class should be 
            connected to other elements.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="classDisconnected">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (boolean(f:getOutgoingConnectors($class)) or boolean(f:getIncommingConnectors($class)))
                then
                    ()
                else
                    f:generateWarningMessage(fn:concat('The class ', $class/@name,
                    ' is is disconnected. A class should be connected to other elements.'),
                    path($class),
                    'class-connector-4',
                    'CMC-R12',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r12&quot; target=&quot;_blank&quot;&gt;CMC-R12&lt;/a&gt;'
                    )"
        />
    </xsl:template>

   
    <xd:doc>
        <xd:desc>[class-attributes-3] - The class $className$ nas no attributes provided. A class
            should define some attributes.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="classUnderspecified">
        <xsl:param name="class"/>
        <xsl:variable name="classNumberOfAttributes" select="count($class/attributes/attribute)"/>
        <xsl:sequence
            select="
                if ($classNumberOfAttributes = 0) then
                    f:generateWarningMessage(fn:concat('The class ', $class/@name, ' has no attributes provided. A class should define some attributes.'),
                    path($class),
                    'class-attributes-3',
                    'CMC-R10',
                    '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r10&quot; target=&quot;_blank&quot;&gt;CMC-R10&lt;/a&gt;'
                    )
                else
                    ()"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>[class-name-2] - The class name $value$ is invalid. The class name must start with
            a capital case. </xd:desc>
        <xd:param name="class"/>
    </xd:doc>

    <xsl:template name="classIsNotPascalNamed">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:sequence
            select="
                if (f:isValidQname($className))
                then
                    if (f:isQNameUpperCasedCamelCase($className) = fn:false())
                    then
                        f:generateErrorMessage(fn:concat('The class name ', $className, ' is invalid. The class name must start with a capital case.'),
                        path($class),
                        'class-name-2',
                        'CMC-R4',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r4&quot; target=&quot;_blank&quot;&gt;CMC-R4&lt;/a&gt;
                        &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-general-conventions.html#sec:gc-r4&quot; target=&quot;_blank&quot;&gt;GC-R4&lt;/a&gt;'
                        )
                    else
                        ()
                else
                    if (fn:contains($uppercaseLetters, fn:substring($className, 1, 1)))
                    then
                        ()
                    else
                        f:generateErrorMessage(fn:concat('The class name ', $className, ' is invalid. The class name must start with a capital case.'),
                        path($class),
                        'class-name-2',
                        'CMC-R4',
                        '&lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-conceptual-model-conventions.html#sec:cmc-r4&quot; target=&quot;_blank&quot;&gt;CMC-R4&lt;/a&gt;
                        &lt;a href=&quot;https://semiceu.github.io/style-guide/1.0.0/gc-general-conventions.html#sec:gc-r4&quot; target=&quot;_blank&quot;&gt;GC-R4&lt;/a&gt;'
                        )"
        />
    </xsl:template>    
    
</xsl:stylesheet>