<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://purl.org/dc/elements/1.1/"    
    version="3.0">
   
    <xsl:output version="1.0" encoding="windows-1252" indent="yes" /> 
    
    <xsl:import href="../common/functx-1.0.1-doc.xsl"/>
    
    <!-- List of xmi/xml UML files to be merged into a single file -->
    <!--<xsl:import href="../../src/common/functx-1.0.1-doc.xsl"/>-->
    <xsl:variable name="inputFolder" select="functx:substring-before-last(base-uri(), '/')"/>    
    <xsl:variable name="FileList" select="collection(concat($inputFolder, '/', '?select=*.xmi'))  | collection(concat($inputFolder, '/', '?select=*.xml'))"/>
    <xsl:template match="/">
        
        <xmi:XMI xmlns:uml="http://www.omg.org/spec/UML/20131001" 
                xmlns:xmi="http://www.omg.org/spec/XMI/20131001" 
                xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI" 
                xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" 
                xmlns:thecustomprofile="http://www.sparxsystems.com/profiles/thecustomprofile/1.0">
            <xmi:Documentation exporter="Enterprise Architect" exporterVersion="6.5"/> 
            
            <!-- Merge elements under uml:Model -->
            <uml:Model xmi:type="uml:Model" name="EA_Model">  
            <xsl:for-each select="$FileList" >
                <xsl:variable name="doc" select="." />                              
                    <xsl:copy-of select="$doc//uml:Model/packagedElement"></xsl:copy-of>
                    <xsl:copy-of select="$doc//uml:Model/umldi:Diagram"></xsl:copy-of>
                    <xsl:copy-of select="$doc//uml:Model/profileApplication"></xsl:copy-of>                  
            </xsl:for-each>
            </uml:Model>
            <!-- Merge elements under xmi:Extension -->
            <xmi:Extension extender="Enterprise Architect" extenderID="6.5">
            <xsl:for-each select="$FileList" >
                <xsl:variable name="doc" select="." />                
                <xsl:copy-of select="$doc//xmi:XMI/xmi:Extension/elements"></xsl:copy-of>
                <xsl:copy-of select="$doc//xmi:XMI/xmi:Extension/connectors"></xsl:copy-of>
                <xsl:copy-of select="$doc//xmi:XMI/xmi:Extension/primitivetypes/profiles"></xsl:copy-of>
                <xsl:copy-of select="$doc//xmi:XMI/xmi:Extension/diagrams"></xsl:copy-of>                
            </xsl:for-each>
            </xmi:Extension>
            
            <!-- Merge other elements-->  
            <xsl:for-each select="$FileList" >
                <xsl:variable name="doc" select="." />               
                <xsl:copy-of select="$doc//thecustomprofile:subproperty"></xsl:copy-of>
                <xsl:copy-of select="$doc//thecustomprofile:disjoint"></xsl:copy-of>
                <xsl:copy-of select="$doc//thecustomprofile:extends"></xsl:copy-of>
                <xsl:copy-of select="$doc//thecustomprofile:isA"></xsl:copy-of>
            </xsl:for-each>
        </xmi:XMI>        
    </xsl:template>       
</xsl:stylesheet>
