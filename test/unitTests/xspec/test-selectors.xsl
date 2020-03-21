<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:__x="http://www.w3.org/1999/XSL/TransformAliasAlias"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:uml="http://www.omg.org/spec/UML/20131001"
                xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                version="2"
                exclude-result-prefixes="pkg impl">
   <xsl:import href="file:/home/lps/work/workspace-charm/model2owl/test/src/common/selectors.xsl"/>
   <xsl:import href="file:/home/lps/work/software/OxygenXMLEditor21/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:import href="file:/home/lps/work/software/OxygenXMLEditor21/frameworks/xspec/src/schematron/sch-location-compare.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="__x" result-prefix="xsl"/>
   <xsl:variable name="x:stylesheet-uri"
                 as="xs:string"
                 select="'file:/home/lps/work/workspace-charm/model2owl/test/src/common/selectors.xsl'"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/lps/work/software/OxygenXMLEditor21/frameworks/xspec/src/compiler/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="{$x:stylesheet-uri}"
                   date="{current-dateTime()}"
                   xspec="file:/home/lps/work/workspace-charm/model2owl/test/unitTests/test-selectors.xspec">
            <xsl:call-template name="x:d5e2"/>
            <xsl:call-template name="x:d5e5"/>
            <xsl:call-template name="x:d5e8"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d5e2">
      <xsl:message>Scenario for testing template with match 'xmi:XMI</xsl:message>
      <x:scenario>
         <x:label>Scenario for testing template with match 'xmi:XMI</x:label>
         <x:context href="file:/home/lps/work/workspace-charm/model2owl/test/testData/ePO-CM_v2.0.1_test.eap.xmi"
                    select="/"/>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc"
                          as="document-node()"
                          select="doc('file:/home/lps/work/workspace-charm/model2owl/test/testData/ePO-CM_v2.0.1_test.eap.xmi')"/>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:apply-templates select="$impl:context"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e4">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e4">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Not yet implemented</xsl:message>
      <xsl:variable select="'Not yet implemented'" name="impl:expected"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Not yet implemented</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e5">
      <xsl:message>Scenario for testing template with match 'elements</xsl:message>
      <x:scenario>
         <x:label>Scenario for testing template with match 'elements</x:label>
         <x:context href="file:/home/lps/work/workspace-charm/model2owl/test/testData/ePO-CM_v2.0.1_test.eap.xmi"
                    select="/xmi:XMI/xmi:Extension/elements"/>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc"
                          as="document-node()"
                          select="doc('file:/home/lps/work/workspace-charm/model2owl/test/testData/ePO-CM_v2.0.1_test.eap.xmi')"/>
            <xsl:variable name="impl:context"
                          select="$impl:context-doc/(/xmi:XMI/xmi:Extension/elements)"/>
            <xsl:apply-templates select="$impl:context"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e7">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e7">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Not yet implemented</xsl:message>
      <xsl:variable select="'Not yet implemented'" name="impl:expected"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Not yet implemented</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e8">
      <xsl:message>Scenario for testing template with match 'connectors</xsl:message>
      <x:scenario>
         <x:label>Scenario for testing template with match 'connectors</x:label>
         <x:context/>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context" select="()"/>
            <xsl:apply-templates select="$impl:context"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e10">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e10">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Not yet implemented</xsl:message>
      <xsl:variable select="'Not yet implemented'" name="impl:expected"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Not yet implemented</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
