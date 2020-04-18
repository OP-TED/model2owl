<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                xmlns:f="http://https://github.com/costezki/model2owl#"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:../../src/html-conventions-lib/class-attributes-html-conventions.xsl"/>
   <xsl:import href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/test-class-attributes-html-conventions.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/reporter/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="file:../../src/html-conventions-lib/class-attributes-html-conventions.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/home/dragos/src/model2owl/test/unitTests/test-class-attributes-html-conventions.xspec">
            <xsl:call-template name="x:d6e2"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d6e2">
      <xsl:message>Scenario for getting the class name</xsl:message>
      <x:scenario>
         <x:label>Scenario for getting the class name</x:label>
         <x:call>
            <xsl:attribute name="template">getClassName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">class</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[33]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="class-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="class-doc" as="document-node()" select="doc($class-doc-uri)"/>
            <xsl:variable name="class" as="item()*">
               <xsl:for-each select="$class-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[33]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="getClassName">
               <xsl:with-param name="class" select="$class"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e5">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e5">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>correct class name</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>epo:AccessTerms</xsl:text>
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
         <x:label>correct class name</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
