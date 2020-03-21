<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:model2owl/test/unitTests/"/>
   <xsl:import href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/test_checkers.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/reporter/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="file:model2owl/test/unitTests/"
                   date="{current-dateTime()}"
                   xspec="file:/home/dragos/src/model2owl/test/unitTests/test_checkers.xspec">
            <xsl:call-template name="x:d6e2"/>
            <xsl:call-template name="x:d6e8"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d6e2">
      <xsl:message>Check valid normalized string</xsl:message>
      <x:scenario>
         <x:label>Check valid normalized string</x:label>
         <x:call>
            <xsl:attribute name="template">isValidNormalizedString</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>normalized:String</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>normalized:String</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="isValidNormalizedString">
               <xsl:with-param name="input" select="$input"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e6">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e6">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>true</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" as="item()*">
         <xsl:for-each select="$impl:expected-doc">
            <xsl:sequence select="node()"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-true</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e8">
      <xsl:message>Check invalid normalized string</xsl:message>
      <x:scenario>
         <x:label>Check invalid normalized string</x:label>
         <x:call>
            <xsl:attribute name="template">isValidNormalizedString</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>Normalized Str!ng</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>Normalized Str!ng</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="isValidNormalizedString">
               <xsl:with-param name="input" select="$input"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e12">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e12">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-false</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>false</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" as="item()*">
         <xsl:for-each select="$impl:expected-doc">
            <xsl:sequence select="node()"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-false</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
