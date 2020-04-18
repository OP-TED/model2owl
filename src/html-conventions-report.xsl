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
    
    
    
    <xsl:import href="html-conventions-lib/html-selectors.xsl"/>
    <xsl:import href="html-conventions-lib/class-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/class-attributes-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/enumeration-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/enumeration-items-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/data-type-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/packages-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/association-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/generalization-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/dependency-html-conventions.xsl"/>
    
    
    
    
    <xsl:template match="/">
        <html lang="en">
            <head>
                
                <link rel="stylesheet" href="static/css/jquery-ui.min.css"/>  
                <link rel="stylesheet" href="static/css/bootstrap.min.css"/>
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css"/>
                <link rel="stylesheet" href="static/css/pubcss-acm-sig.css"/>
                <link rel="stylesheet" media="screen" href="static/css/screen.css"/>
                <link rel="stylesheet" media="print" href="static/css/print.css"/>
                <link rel="stylesheet" href="static/css/toc_adjustments.css"/>
            </head>
            
            <body>
                <header class="counter-skip">
                    <h1 class="skip-toc">Unmet conventions for eProcurement conceptual model </h1>
                </header>
                <main>
                    <div id="toc" class="tocify"></div>
                    <h1>Introduction</h1>
                    <p>Tristique magna sit amet purus gravida quis blandit turpis cursus. Ullamcorper velit sed ullamcorper 
                        morbi tincidunt ornare massa. Sit amet cursus sit amet dictum sit amet. Condimentum lacinia quis vel 
                        eros donec ac odio tempor. Eget felis eget nunc lobortis mattis aliquam faucibus purus in. 
                        Egestas sed sed risus pretium quam vulputate dignissim suspendisse. Viverra aliquet eget sit amet tellus
                        cras adipiscing. Nulla facilisi morbi tempus iaculis urna id volutpat lacus. Faucibus scelerisque eleifend
                        donec pretium vulputate sapien nec sagittis. Libero volutpat sed cras ornare arcu dui vivamus arcu. 
                        Ut consequat semper viverra nam libero justo laoreet sit amet. Consequat mauris nunc congue nisi vitae suscipit. 
                        Posuere urna nec tincidunt praesent semper feugiat nibh sed. Maecenas pharetra convallis posuere morbi leo urna 
                        molestie at elementum. Morbi quis commodo odio aenean sed.</p>
                    <xsl:apply-templates/>               
                </main>
                <footer>
                    <p> footer here </p>
                </footer>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
                
                <script src="static/js/jquery-3.4.1.min.js"></script>
                <script src="static/js/jquery-ui.min.js"></script>
                <script src="static/js/bootstrap.min.js"></script>
                <script src="static/js/jquery.tocify.min.js"></script>
                
                <script>
                    $(function () {
                    //Calls the tocify method on your HTML div.
                    $("#toc").tocify({
                    selectors: "h1",
                    theme: "bootstrap",
                    hashGenerator: "pretty",
                    ignoreSelector: ".skip-toc"
                    });
                    });
            
                     $('.selector-heading').each(function(){
                     let nextSiblingElementType = jQuery(this).next().prop('nodeName');
                     if(nextSiblingElementType == "H2" || nextSiblingElementType == "DL" ){
                        $(this).append(' <i class="fa fa-times-circle invalid"></i>');
                    }else{
                        $(this).append(' <i class="fa fa-check-circle valid"></i>');                        
                    }
                    });
                </script>
            </body>
        </html>
        
    </xsl:template>
    
    
</xsl:stylesheet>


