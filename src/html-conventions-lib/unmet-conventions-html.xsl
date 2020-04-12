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
   xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">
    <xsl:output method="html" indent="yes"/>
   
   
   
   <xsl:import href="html-selectors.xsl"/>
    <xsl:import href="class-html-conventions.xsl"/>
   <xsl:import href="class-attributes-html-conventions.xsl"/>
   
   
   
<xsl:template match="/">
    <html lang="en">
        <head>
           
           <link rel="stylesheet" href="css/jquery-ui.min.css"/>  
           <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"/>
           <link rel="stylesheet" href="../static/pubcss-acm-sig.css"/>
           <link rel="stylesheet" media="screen" href="css/screen.css"/>
           <link rel="stylesheet" media="print" href="css/print.css"/>
           <link rel="stylesheet" href="css/toc_adjustments.css"/>
        </head>
       
        <body>
           <xsl:apply-templates/>
<!--           <h1>fdwfwfw</h1>
           <xsl:apply-templates select="/xmi:XMI/xmi:Extension/elements/element[@xmi:type = 'uml:Class']"/>
           <h1>altceva</h1>
           <xsl:apply-templates select="/xmi:XMI/xmi:Extension/elements/element[@xmi:type = 'uml:Class']/attributes/attribute"/>
           <!-\-<xs:include schemaLocation="class-html-conventions.xsl"/>-\->-->
        
        </body>
        <footer>
            <p> something maybe here </p>
        </footer>
        <script src="js/jquery-3.4.1.min.js"></script>
        
    </html>
   
</xsl:template>


</xsl:stylesheet>


