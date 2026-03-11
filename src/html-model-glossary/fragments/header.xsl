<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 17, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dragos</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="head">
        <head>            
            <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
            <meta charset="utf-8"/>
            <meta name="description" content="Model glossary"/>
            <meta name="author" content="Publications Office of the European Union"/>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            
            <!-- Google Fonts - Roboto -->
            <link rel="preconnect" href="https://fonts.googleapis.com"/>
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
            <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
            
            <!-- Bootstrap 5 CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous"/>
            
            <!-- PubCSS -->
            <link rel="stylesheet" href="static/css/pubcss-acm-sig.css"/>
            
            <!-- Tocbot CSS -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tocbot@4.12.3/dist/tocbot.css"/>
            
            <!-- DataTables CSS -->
            <link href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
            
            <!-- Custom styles -->
            <link rel="stylesheet" href="static/css/toc_adjustments.css"/>
            <link rel="stylesheet" href="static/css/glossary.css"/>
            
            <link rel="shortcut icon" href=""/>
            <title>Model glossary</title>
        </head>
    </xsl:template>
    
</xsl:stylesheet>