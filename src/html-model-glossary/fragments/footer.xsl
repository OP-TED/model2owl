<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    exclude-result-prefixes="xs math xd f"
    version="3.0">
    
    <xsl:import href="../../common/utils.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 17, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> Dragos</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:template name="footer">
        <footer class="text-center mt-5 py-4 border-top">
            <p class="mb-2"> This document is generated automatically by the <a
                    href="https://github.com/costezki/model2owl" target="_blank" class="text-decoration-none">model2owl tool</a>
                developed in the context of <a
                    href="https://joinup.ec.europa.eu/solution/eprocurement-ontology" class="text-decoration-none">the
                    eProcurement Ontology initiative</a>.</p>
            <p class="mb-2">The template of this report is based on the <a
                    href="https://github.com/thomaspark/pubcss" class="text-decoration-none">PubCSS library</a>.</p>
            <p class="mb-0 text-muted">&#169; <xsl:value-of select="f:getMetadataValue('conventionReportCopyrightText')"/></p>
        </footer>
        
        <!-- Go to top button -->
        <button id="goToTop" class="go-to-top" aria-label="Go to top" title="Go to top">
            <span>&#8593;</span>
        </button>
        
        <!-- jQuery 3.7.1 -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
        
        <!-- Bootstrap 5 JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
        
        <!-- Tocbot -->
        <script src="https://cdn.jsdelivr.net/npm/tocbot@4.12.3/dist/tocbot.min.js"></script>
        
        <!-- DataTables -->
        <script type="text/javascript" src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>
        
        <script>
            <![CDATA[
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize Tocbot
                if (document.querySelector('.toc')) {
                    // Ensure headings have IDs for proper scrolling
                    document.querySelectorAll('.content h1, .content h2').forEach(function(heading, index) {
                        if (!heading.id) {
                            var id = heading.textContent.toLowerCase()
                                .replace(/[^\w\s-]/g, '')
                                .replace(/\s+/g, '-')
                                .replace(/-+/g, '-')
                                .trim();
                            if (!id) {
                                id = 'heading-' + index;
                            }
                            heading.id = id;
                        }
                    });
                    
                    tocbot.init({
                        tocSelector: '.toc',
                        contentSelector: '.content',
                        headingSelector: 'h1, h2',
                        smoothScroll: true,
                        scrollSmooth: true,
                        scrollSmoothDuration: 420,
                        scrollSmoothOffset: 20,
                        headingsOffset: 20,
                        collapseDepth: 0,
                        orderedList: false
                    });
                }
                
                // Initialize DataTables
                if (typeof jQuery !== 'undefined' && jQuery.fn.DataTable) {
                    jQuery('table.display').each(function() {
                        var table = jQuery(this).DataTable({
                            lengthMenu: [[-1], ["All"]],
                            pageLength: -1,
                            responsive: true,
                            order: [],
                            language: {
                                search: "Search:",
                                lengthMenu: "Show _MENU_ entries",
                                info: "Showing _START_ to _END_ of _TOTAL_ entries",
                                infoEmpty: "No entries to show",
                                infoFiltered: "(filtered from _MAX_ total entries)"
                            },
                            dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>rt<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>'
                        });
                        
                        // Ensure search input is type="search" for native clear button
                        var searchInput = jQuery(this).closest('.dataTables_wrapper').find('.dataTables_filter input');
                        var searchLabel = jQuery(this).closest('.dataTables_wrapper').find('.dataTables_filter label');
                        
                        if (searchInput.length) {
                            // Force type="search" for all browsers
                            searchInput.attr('type', 'search');
                            // For Firefox, ensure the input has the search type attribute
                            if (searchInput[0]) {
                                searchInput[0].type = 'search';
                            }
                            
                            // Add custom clear button for Firefox (and as fallback for other browsers)
                            var clearButton = jQuery('<span class="custom-clear-button" style="display: none; cursor: pointer; margin-left: 4px; padding: 2px 6px; color: #666; font-size: 16px; line-height: 1; opacity: 0.6;">&times;</span>');
                            searchInput.after(clearButton);
                            
                            // Show/hide clear button based on input value
                            function toggleClearButton() {
                                if (searchInput.val() && searchInput.val().length > 0) {
                                    clearButton.show();
                                } else {
                                    clearButton.hide();
                                }
                            }
                            
                            // Initial state
                            toggleClearButton();
                            
                            // Update on input
                            searchInput.on('input keyup', function() {
                                toggleClearButton();
                            });
                            
                            // Clear button click handler
                            clearButton.on('click', function(e) {
                                e.preventDefault();
                                e.stopPropagation();
                                searchInput.val('');
                                table.search('').draw();
                                searchInput.focus();
                                clearButton.hide();
                            });
                            
                            // Make the entire label clickable to focus the input
                            searchLabel.on('click', function(e) {
                                // Only focus if clicking on the label, not the input itself
                                if (e.target === this || jQuery(e.target).is('label')) {
                                    searchInput.focus();
                                }
                            });
                            
                            // Handle clear button click for better browser compatibility
                            searchInput.on('search', function() {
                                if (this.value === '') {
                                    table.search('').draw();
                                    toggleClearButton();
                                }
                            });
                            
                            // Also handle input event for immediate clearing
                            searchInput.on('input', function() {
                                if (this.value === '') {
                                    table.search('').draw();
                                }
                            });
                        }
                    });
                }
                
                // Go to top button functionality
                var goToTopButton = document.getElementById('goToTop');
                if (goToTopButton) {
                    // Show/hide button based on scroll position
                    window.addEventListener('scroll', function() {
                        if (window.pageYOffset > 300) {
                            goToTopButton.style.display = 'flex';
                        } else {
                            goToTopButton.style.display = 'none';
                        }
                    });
                    
                    // Smooth scroll to top on click
                    goToTopButton.addEventListener('click', function() {
                        window.scrollTo({
                            top: 0,
                            behavior: 'smooth'
                        });
                    });
                }
            });
            ]]>
        </script>
    </xsl:template>
    
</xsl:stylesheet>