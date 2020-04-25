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
    <xsl:import href="../html-conventions-lib/utils-html-conventions.xsl"/>
    
    <xd:doc>
        <xd:desc>Getting all classes and attributes and show only the ones with unmet conventions 
            [class->common-name-11]
            [class->common-description-12]
            [class->common-stereotype-13]
        </xd:desc>
    </xd:doc>
    
    
    
    <xsl:template match="element[@xmi:type = 'uml:Class']">
        <xsl:variable name = "class">
            <xsl:call-template name="getClassName">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="classConventions" as="item()*">
            <xsl:call-template name="missingName">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingNamePrefix">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missing name local name">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalid first character n the local segment">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalid name prefix">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="invalid name local segment">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="delimiters in the name local segment">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="names must be unique">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            
            <xsl:call-template name="stereotype provided">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classIsNotPascalNamed">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="underspecifiedClass">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            
            <xsl:call-template name="disconnectedClass">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>

            

            
            
<!--            <xsl:call-template name="classNameChecker">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="missingDescription">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classNameCaseChecker">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classNamePrefixChecker">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>
            <xsl:call-template name="classAttributesChecker">
                <xsl:with-param name="class" select="."/>
            </xsl:call-template>-->
        </xsl:variable>
        <xsl:variable name="classAttributeConventions" as="item()*">
            <xsl:apply-templates select="attributes/attribute"/>
        </xsl:variable>
        <xsl:if test="boolean($classConventions) or boolean($classAttributeConventions)">
            <h2>              
                <xsl:value-of select="$class"/>
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
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Getting the class name</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    <xsl:template name="getClassName">
        <xsl:param name="class"/>
        <xsl:value-of select="$class/@name"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[class-connectors-16] - The class $className$ is not connected to anything. A class
            should be connected to otehr elements.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    
    <xsl:template name="disconnectedClass">
        <xsl:param name="class"/>
        <xsl:sequence
            select="
                if (boolean(f:getOutgoingConnectors($class)) or boolean(f:getIncommingConnectors($class)))
                then
                    ()
                else
                    f:generateHtmlWarning(fn:concat('The class ', $class/@name, 
                                                  ' is not connected to anything. A class should be connected to other elements.'))"
        />
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Return warning when class name is not a valid Qname</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    
    <xsl:template name="classNameChecker">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:if test="f:isValidQname($className) = fn:false()">
            <xsl:sequence select="f:generateHtmlWarning('The name of this class is not a valid Qname. Please change')"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>[common-description-9] - $elementName$ is missing a description. All concepts should be defined or described.</xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    
    <xsl:template name="missingDescription">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:variable name="noClassDescription" select="$class/properties/not(@documentation)"/>
        <xsl:if test="$noClassDescription = fn:true()">
            <xsl:sequence
                select="f:generateHtmlWarning(fn:concat($className, ' is missing a description. All concepts should be defined or described.'))"
            />
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when class Qname is not with capitalized letter </xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    
    <xsl:template name="classNameCaseChecker">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:if test="not(f:isQNameUpperCasedCamelCase($className))">
            <xsl:sequence select="f:generateHtmlWarning('The first letter of the local segment from the Qname of the class is lower-cased.')"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when Qname prefix is not in the namespaces </xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    
    <xsl:template name="classNamePrefixChecker">
        <xsl:param name="class"/>
        <xsl:variable name="className" select="$class/@name"/>
        <xsl:if test="not(f:isValidNamespace($className))">
            <xsl:sequence select="f:generateHtmlWarning('The prefix of this class name is not in the agreed namespaces')"/>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return warning when a Class doesn't have attributes </xd:desc>
        <xd:param name="class"/>
    </xd:doc>
    
    <xsl:template name="classAttributesChecker">
        <xsl:param name="class"/>
        <xsl:variable name="classNumberOfAttributes" select="count($class/attributes/attribute)"/>
        <xsl:if test="$classNumberOfAttributes = 0">
            <xsl:sequence select="f:generateHtmlWarning('This class has no attributes')"/>
        </xsl:if>
    </xsl:template>
    
    
    
</xsl:stylesheet>