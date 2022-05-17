<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 17, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dragos</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:template name="footer">
        <footer class="text-center">
            <br/><br/>
            <p> This document is generated automatically by the <a
                    href="https://github.com/costezki/model2owl" target="_blank">model2owl tool</a>
                developed in the context of <a
                    href="https://joinup.ec.europa.eu/solution/eprocurement-ontology">the
                    eProcurement Ontology initiative</a>.</p>
            <p>The template of this report is based on the <a
                    href="https://github.com/thomaspark/pubcss">PubCSS library</a>.</p>
            <p>&#169; Publications Office of the European Union, 2022</p>
        </footer>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
        
        <script src="static/js/jquery-3.4.1.min.js"></script>
        <script src="static/js/jquery-ui.min.js"></script>
        <script src="static/js/bootstrap.min.js"></script>
        <script src="static/js/jquery.tocify.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.6.4/js/dataTables.buttons.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.6.4/js/buttons.print.min.js"></script>
        
        <script>
            $(function () {
            //Calls the tocify method on your HTML div.
            $("#toc").tocify({
            selectors: "h2",
            theme: "bootstrap",
            hashGenerator: "pretty",
            ignoreSelector: ".skip-toc"
            });
            });
            
        </script>
        <script>
            $(document).ready(function () {
            
            $("table.display").DataTable({
            buttons: [],
            "lengthMenu": [[-1], [30, "All"]],
            responsive: {
            details: true
            }
            });
            
            });
        </script>
    </xsl:template>
    
</xsl:stylesheet>