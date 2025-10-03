function example_structure(exampleid){
	structure=`
	<div id="` + exampleid + `-tabs" exampleid="` + exampleid + `"  class="tabs tabsstyle">
		<ul>
			<li><a href="#` + exampleid + `-tabs-1">Turtle</a></li>
			<li><a href="#` + exampleid + `-tabs-2">JSON-LD</a></li>
		</ul>
		<div id="` + exampleid + `-tabs-1">
			<textarea class="validationquery" id="` + exampleid + `-tab1validationquery" name="query" cols="80" rows="16"></textarea>
			<button class="buttonsample copyturtletoclipboard" id="` + exampleid + `-tabs-1-button-1">Copy</button>
			<button class="buttonsample validateturtle" id="` + exampleid + `-tabs-1-button-2">Validate</button>
		</div>
		<div id="` + exampleid + `-tabs-2">
			<textarea class="validationquery" id="` + exampleid + `-tab2validationquery" name="query" cols="80" rows="16"></textarea>
			<button class="buttonsample copyjsonldtoclipboard" id="` + exampleid + `-tabs-2-button-1">Copy</button>
			<button class="buttonsample validatejsonld" id="` + exampleid + `-tabs-2-button-2">Validate</button>
			<button class="buttonsample openinplayground" id="` + exampleid + `-tabs-2-button-3">Open in Playground</button>
		</div>
	</div>`;
	return structure;
}


/**
 * auxiliary function to get around the issue that indexOf() is not working with jquery.
 */

function myIndexOf(list, val) {
	var myindex  = -1;
	var i = 0;

	var elem = list[0];
        
	while ( i < list.length ) {
		if ( elem == val ) return i;
		i = i+1;
		elem = list[i];

	}
	
	return -1;

}


/**
 * Fills in the direct input area with some samples
 * @param {string} file - file containing the sample
 */
 function loadFile(editorinstance, file) {
    var xmlhttp;
    if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
    } else {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState === 4 && xmlhttp.status !== 200) {
            alert('Error when opening the file: ' + file + ' - ' + xmlhttp.status + ' ' + xmlhttp.statusText);
        } else if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
            editorinstance.setValue(xmlhttp.responseText);
        }
    };
    xmlhttp.open("GET", file, true);
    xmlhttp.send();
    return xmlhttp.responseText;
}

function createTurtleEditorFrom(selector) {
  return CodeMirror.fromTextArea(selector, {
    mode: "turtle",
    lineNumbers: true
  });
}

function createJSONLDEditorFrom(selector) {
  return CodeMirror.fromTextArea(selector, {
    mode: "application/ld+json",
    lineNumbers: true
  });
}

/**
 * Validates RDF content using SHACL shapes and returns a detailed validation report
 * @param {string} content - The RDF content to validate
 * @param {string} contentType - The content type (turtle or jsonld)
 */
async function validateRDF(content, contentType) {
    // Show loading state
    const button = event.target;
    const originalText = button.textContent;
    button.textContent = 'Validating...';
    button.disabled = true;
    
    try {
        // Determine which SHACL shapes to use - ITB supports both Turtle and JSON-LD shapes
        const shaclShapesUrl = contentType === 'jsonld' 
            ? './assets/shacl/context_shapes.jsonld'
            : './assets/shacl/ontology_shapes.ttl';
        
        // Load SHACL shapes
        const shaclShapes = await loadFileContent(null, shaclShapesUrl);
        
        // Perform SHACL validation
        const validationReport = await performSHACLValidation(content, shaclShapes, contentType);
        
        // Reset button state
        button.textContent = originalText;
        button.disabled = false;
        
        // Display validation report
        displayValidationReport(validationReport, contentType);
        
    } catch (error) {
        // Reset button state
        button.textContent = originalText;
        button.disabled = false;
        
        console.error('Validation error:', error);
        
        // Show error in dialog format
        const errorReport = {
            valid: false,
            violations: [{
                severity: 'Error',
                message: error.message,
                focusNode: 'Validation Service'
            }],
            warnings: [],
            service: 'ITB',
            timestamp: new Date().toISOString(),
            summary: {
                totalViolations: 1,
                totalWarnings: 0
            },
            turtleReport: `# Validation Error\n Please check syntactical correctness of the passed data\n# ${error.message}\n\n`
        };
        
        displayValidationReport(errorReport, contentType);
    }
}

/**
 * Performs SHACL validation using ITB validation service
 * @param {string} dataContent - The RDF data to validate
 * @param {string} shaclShapes - The SHACL shapes content
 * @param {string} contentType - The content type (turtle or jsonld)
 */
async function performSHACLValidation(dataContent, shaclShapes, contentType) {
    if (contentType === 'jsonld') {
        return await validateJSONLDWithITB(dataContent, shaclShapes);
    } else {
        return await validateTurtleWithITB(dataContent, shaclShapes);
    }
}

/**
 * Validates Turtle content with Turtle SHACL shapes using ITB
 * @param {string} turtleData - The Turtle RDF data to validate
 * @param {string} turtleShapes - The Turtle SHACL shapes
 */
async function validateTurtleWithITB(turtleData, turtleShapes) {
    const itbEndpoint = 'https://www.itb.ec.europa.eu/shacl/any/api/validate';
    
    try {
        // Create base64 encoded content for ITB API
        const encodedData = btoa(unescape(encodeURIComponent(turtleData)));
        const encodedShapes = btoa(unescape(encodeURIComponent(turtleShapes)));
        
        // Prepare JSON payload for Turtle validation
        const payload = {
            contentToValidate: encodedData,
            contentSyntax: 'text/turtle',
            embeddingMethod: 'BASE64',
            reportSyntax: 'text/turtle',
            loadImports: false,
            addInputToReport: false,
            addRulesToReport: false,
            externalRules: [{
                ruleSet: encodedShapes,
                embeddingMethod: 'BASE64',
                ruleSyntax: 'text/turtle'
            }]
        };
        
        const response = await fetch(itbEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(payload)
        });
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`ITB validation service error: ${response.status} - ${errorText}`);
        }
        
        // Check content type to determine how to parse response
        const contentType = response.headers.get('content-type');
        let result, turtleReport = '', isValid = false;
        
        if (contentType && contentType.includes('application/json')) {
            // JSON response with Base64 encoded report
            result = await response.json();
            isValid = result.result === 'SUCCESS';
            
            if (result.report) {
                try {
                    turtleReport = atob(result.report);
                    console.log('Decoded Turtle report from JSON:', turtleReport);
                } catch (e) {
                    console.warn('Failed to decode Base64 report:', e);
                    turtleReport = result.report; // Fallback to raw report
                }
            }
        } else {
            // Direct Turtle response
            turtleReport = await response.text();
            console.log('Direct Turtle report:', turtleReport);
            
            // Check if validation passed by looking at sh:conforms
            const conformsMatch = turtleReport.match(/sh:conforms\s+(true|false)/);
            isValid = conformsMatch ? conformsMatch[1] === 'true' : true; // Default to true if no conforms found
        }
        
        // Parse basic validation info from Turtle report
        const violations = [];
        const warnings = [];
        
        // Look for violation results in the Turtle report
        const violationMatches = turtleReport.match(/sh:ValidationResult/g);
        const violationCount = violationMatches ? violationMatches.length : 0;
        
        if (!isValid && violationCount > 0) {
            // Extract basic violation info from Turtle (simplified parsing)
            for (let i = 0; i < violationCount; i++) {
                violations.push({
                    severity: 'Violation',
                    message: `SHACL constraint violation found in validation report`,
                    focusNode: 'See full report for details'
                });
            }
        }
        
        return {
            valid: isValid,
            violations: violations,
            warnings: warnings,
            service: 'ITB',
            timestamp: new Date().toISOString(),
            summary: {
                totalViolations: violations.length,
                totalWarnings: warnings.length
            },
            turtleReport: turtleReport, // Full Turtle report for dialog display
            rawReport: result || turtleReport // Keep original result for debugging
        };
        
    } catch (error) {
        // Enhanced error handling with specific ITB guidance
        if (error.message.includes('415')) {
            throw new Error('ITB service requires JSON payload with proper Content-Type header. Please check the request format.');
        } else if (error.message.includes('400')) {
            throw new Error('ITB service rejected the request. The SHACL shapes or RDF data may be invalid.');
        } else if (error.message.includes('500')) {
            throw new Error('Please check syntactical correctness of the passed data. ITB service is experiencing internal errors. Please try again later.');
        } else if (error.name === 'TypeError' && error.message.includes('fetch')) {
            throw new Error('Unable to connect to ITB validation service. Please check your internet connection.');
        } else {
            throw new Error(`ITB validation failed: ${error.message}`);
        }
    }
}

/**
 * Validates JSON-LD content with JSON-LD SHACL shapes using ITB
 * @param {string} jsonldData - The JSON-LD data to validate
 * @param {string} jsonldShapes - The JSON-LD SHACL shapes
 */
async function validateJSONLDWithITB(jsonldData, jsonldShapes) {
    const itbEndpoint = 'https://www.itb.ec.europa.eu/shacl/any/api/validate';
    
    try {
        // Create base64 encoded content for ITB API
        const encodedData = btoa(unescape(encodeURIComponent(jsonldData)));
        const encodedShapes = btoa(unescape(encodeURIComponent(jsonldShapes)));
        
        // Prepare JSON payload for JSON-LD validation
        const payload = {
            contentToValidate: encodedData,
            contentSyntax: 'application/ld+json',
            embeddingMethod: 'BASE64',
            reportSyntax: 'text/turtle', // Still request Turtle report for consistent display
            loadImports: false,
            addInputToReport: false,
            addRulesToReport: false,
            externalRules: [{
                ruleSet: encodedShapes,
                embeddingMethod: 'BASE64',
                ruleSyntax: 'application/ld+json'
            }]
        };
        
        const response = await fetch(itbEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(payload)
        });
        
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`ITB validation service error: ${response.status} - ${errorText}`);
        }
        
        // Check content type to determine how to parse response
        const contentType = response.headers.get('content-type');
        let result, turtleReport = '', isValid = false;
        
        if (contentType && contentType.includes('application/json')) {
            // JSON response with Base64 encoded report
            result = await response.json();
            isValid = result.result === 'SUCCESS';
            
            if (result.report) {
                try {
                    turtleReport = atob(result.report);
                    console.log('Decoded JSON-LD validation Turtle report from JSON:', turtleReport);
                } catch (e) {
                    console.warn('Failed to decode Base64 report:', e);
                    turtleReport = result.report; // Fallback to raw report
                }
            }
        } else {
            // Direct Turtle response
            turtleReport = await response.text();
            console.log('Direct JSON-LD validation Turtle report:', turtleReport);
            
            // Check if validation passed by looking at sh:conforms
            const conformsMatch = turtleReport.match(/sh:conforms\s+(true|false)/);
            isValid = conformsMatch ? conformsMatch[1] === 'true' : true; // Default to true if no conforms found
        }
        
        // Parse basic validation info from Turtle report
        const violations = [];
        const warnings = [];
        
        // Look for violation results in the Turtle report
        const violationMatches = turtleReport.match(/sh:ValidationResult/g);
        const violationCount = violationMatches ? violationMatches.length : 0;
        
        if (!isValid && violationCount > 0) {
            // Extract basic violation info from Turtle (simplified parsing)
            for (let i = 0; i < violationCount; i++) {
                violations.push({
                    severity: 'Violation',
                    message: `SHACL constraint violation found in JSON-LD validation report`,
                    focusNode: 'See full report for details'
                });
            }
        }
        
        return {
            valid: isValid,
            violations: violations,
            warnings: warnings,
            service: 'ITB',
            timestamp: new Date().toISOString(),
            summary: {
                totalViolations: violations.length,
                totalWarnings: warnings.length
            },
            turtleReport: turtleReport, // Full Turtle report for dialog display
            rawReport: result || turtleReport // Keep original result for debugging
        };
        
    } catch (error) {
        // Enhanced error handling with specific ITB guidance for JSON-LD
        if (error.message.includes('415')) {
            throw new Error('ITB service requires JSON payload with proper Content-Type header for JSON-LD validation.');
        } else if (error.message.includes('400')) {
            throw new Error('ITB service rejected the JSON-LD request. The SHACL shapes or JSON-LD data may be invalid.');
        } else if (error.message.includes('500')) {
            throw new Error('Please check syntactical correctness of the passed data. ITB service is experiencing internal errors. Please try again later.');
        } else if (error.name === 'TypeError' && error.message.includes('fetch')) {
            throw new Error('Unable to connect to ITB validation service. Please check your internet connection.');
        } else {
            throw new Error(`JSON-LD ITB validation failed: ${error.message}`);
        }
    }
}



$(document).ready(function () {

	
	
	var examples = [];
	var editors = [];

        var examples_id = ".examples";
	var examples_class = ".h3";
	var folder = "./assets/examples/";
	var $examples = $(examples_id);

//	$examples.children(examples_class).each(function(index){
	$examples.each(function(index){
		exampleid = this.id;
		examples.push(exampleid); 
		var text = example_structure(exampleid);
		$(this).after(text);

		var obj = {CM0: createTurtleEditorFrom(document.getElementById(exampleid + "-tab1validationquery")), CM1: createJSONLDEditorFrom(document.getElementById(exampleid + "-tab2validationquery"))};
		editors[index] = obj;
		//editors[index].push({CM: createTurtleEditorFrom(document.getElementById(exampleid + "-tab1validationquery")}, CM2: createJSONLDEditorFrom(document.getElementById(exampleid + "-tab2validationquery")});
		//editors[index].push({CM: createJSONLDEditorFrom(document.getElementById(exampleid + "-tab2validationquery")});
		//editors[index][0] = createTurtleEditorFrom(document.getElementById(exampleid + "-tab1validationquery"));
		//editors[index][1] = createJSONLDEditorFrom(document.getElementById(exampleid + "-tab2validationquery"));

		$("#" + exampleid + "-tabs").tabs();

		$("#" + exampleid + "-tabs a").on('click', function(e) {
			$('.CodeMirror').each(function(i, el){
				el.CodeMirror.refresh();
			});
		});

                path_to_file = folder + exampleid;
		loadFile(editors[index].CM0, path_to_file + ".ttl");
		loadFile(editors[index].CM1, path_to_file + ".jsonld");
		
	});

	$("button.copyturtletoclipboard").on({
		"click": function() {
			var exampleid = $(this).parent().parent().attr("exampleid");
			var indexValues = $examples.map(function() { return this.id; }) ;
			var index = myIndexOf(indexValues, exampleid);
			texttocopy = editors[index].CM0.getValue()
			navigator.clipboard.writeText(texttocopy);
			$(this).tooltip({ items: "#" + this.id, content: "Copied !"});
			$(this).tooltip("open");
		},
		"mouseout": function() {
			$(this).tooltip("disable");
		}
	});
	
	$("button.copyjsonldtoclipboard").on({
		"click": function() {
			var exampleid = $(this).parent().parent().attr("exampleid");
			var indexValues = $examples.map(function() { return this.id; }) ;
			var index = myIndexOf(indexValues, exampleid);
			texttocopy = editors[index].CM1.getValue();
			navigator.clipboard.writeText(texttocopy);
			$(this).tooltip({ items: "#" + this.id, content: "Copied !"});
			$(this).tooltip("open");
		},
		"mouseout": function() {
			$(this).tooltip("disable");
		}
	});
	
	// Validation button handlers
	$("button.validateturtle").on('click', function(e) {
		var exampleid = $(this).parent().parent().attr("exampleid");
		var indexValues = $examples.map(function() { return this.id; }) ;
		var index = myIndexOf(indexValues, exampleid);
		var content = editors[index].CM0.getValue();
		
		if (!content.trim()) {
			alert('No content to validate. Please ensure the Turtle content is loaded.');
			return;
		}
		
		validateRDF(content, 'turtle');
	});
	
	$("button.validatejsonld").on('click', function(e) {
		var exampleid = $(this).parent().parent().attr("exampleid");
		var indexValues = $examples.map(function() { return this.id; }) ;
		var index = myIndexOf(indexValues, exampleid);
		var content = editors[index].CM1.getValue();
		
		if (!content.trim()) {
			alert('No content to validate. Please ensure the JSON-LD content is loaded.');
			return;
		}
		
		validateRDF(content, 'jsonld');
	});
	
	$("button.openinplayground").on('click', function(e) {
		var exampleid = $(this).parent().parent().attr("exampleid");
		var indexValues = $examples.map(function() { return this.id; }) ;
		var index = myIndexOf(indexValues, exampleid);

		newUrl = "https://json-ld.org/playground/#startTab=tab-expand&json-ld=" + editors[index].CM1.getValue(); 
		window.open(encodeURI(newUrl), '_blank');
		return false;
	});
	
	$("div.CodeMirror pre").on('click', function(e) {
		var et = $(e.target);
		if(et.hasClass('cm-url'))  {
			newUrl = $(this).text();
			window.open(encodeURI(newUrl), '_blank');
			return false;
		}
	});
});

/**
 * Displays a detailed validation report in a jQuery UI dialog
 * @param {Object} report - The validation report object
 * @param {string} contentType - The content type that was validated
 */
function displayValidationReport(report, contentType) {
    const timestamp = new Date(report.timestamp).toLocaleString();
    
    // Create dialog content
    let dialogContent = '';
    
    if (report.turtleReport) {
        // Display the full Turtle SHACL validation report
        dialogContent = report.turtleReport;
    } else {
        // Fallback to text summary if no Turtle report
        if (report.valid) {
            dialogContent = `VALIDATION SUCCESSFUL\n\n`;
            dialogContent += `Service: ${report.service}\n`;
            dialogContent += `Content Type: ${contentType.toUpperCase()}\n`;
            dialogContent += `Timestamp: ${timestamp}\n\n`;
            
            if (report.warnings && report.warnings.length > 0) {
                dialogContent += `WARNINGS (${report.warnings.length}):\n`;
                report.warnings.forEach((warning, index) => {
                    dialogContent += `${index + 1}. ${warning.message}\n`;
                    if (warning.focusNode) dialogContent += `   Focus: ${warning.focusNode}\n`;
                });
                dialogContent += '\n';
            }
            
            dialogContent += `The RDF content is valid according to the SHACL shapes.\n`;
            dialogContent += `SHACL shapes used: ./assets/shacl/${contentType === 'jsonld' ? 'context_shapes.jsonld' : 'ontology_shapes.ttl'}`;
        } else {
            dialogContent = `VALIDATION FAILED\n\n`;
            dialogContent += `Service: ${report.service}\n`;
            dialogContent += `Content Type: ${contentType.toUpperCase()}\n`;
            dialogContent += `Timestamp: ${timestamp}\n\n`;
            
            if (report.summary) {
                dialogContent += `SUMMARY:\n`;
                dialogContent += `- Violations: ${report.summary.totalViolations}\n`;
                dialogContent += `- Warnings: ${report.summary.totalWarnings}\n\n`;
            }
            
            if (report.violations && report.violations.length > 0) {
                dialogContent += `VIOLATIONS:\n`;
                report.violations.forEach((violation, index) => {
                    dialogContent += `${index + 1}. ${violation.message}\n`;
                    if (violation.focusNode) dialogContent += `   Focus: ${violation.focusNode}\n`;
                    if (violation.resultPath) dialogContent += `   Path: ${violation.resultPath}\n`;
                });
                dialogContent += '\n';
            }
            
            dialogContent += `SHACL shapes used: ./assets/shacl/${contentType === 'jsonld' ? 'context_shapes.jsonld' : 'ontology_shapes.ttl'}\n\n`;
            dialogContent += `For external validation, use: https://www.itb.ec.europa.eu/shacl/any/upload`;
        }
    }
    
    // Create or update dialog
    let dialogId = 'validation-report-dialog';
    let $dialog = $('#' + dialogId);
    
    // Clean up any existing dialog
    if ($dialog.length > 0) {
        $dialog.dialog('destroy').remove();
    }
    
    // Create new dialog
    $dialog = $('<div id="' + dialogId + '"></div>');
    $('body').append($dialog);
    
    // Set dialog content
    $dialog.html(dialogContent);
    
    // Configure dialog
    const dialogTitle = report.valid ? 'Validation Result - SUCCESS' : 'Validation Result - FAILED';
    const titleBarColor = report.valid ? 
        'background: linear-gradient(rgb(106, 153, 106), rgb(0, 100, 0)) darkgreen; color: rgb(255, 255, 255);' :
        'background: linear-gradient(rgb(153, 106, 106), rgb(100, 0, 0)) darkred; color: rgb(255, 255, 255);';
    
    $dialog.dialog({
        title: dialogTitle,
        width: 700,
        height: 400,
        modal: true,
        resizable: true,
        draggable: true,
        close: function() {
            $(this).dialog('destroy');
            $(this).remove(); // Remove the dialog element from DOM
        },
        open: function() {
            // Style the title bar
            $(this).parent().find('.ui-dialog-titlebar').attr('style', titleBarColor);
            // Set white-space to pre-wrap for proper formatting
            $(this).css({
                'white-space': 'pre-wrap',
                'font-family': 'monospace',
                'font-size': '12px',
                'overflow': 'auto'
            });
        }
    });
}

/**
 * Enhanced loadFile function that can load SHACL shapes or return content as string
 * @param {Object} editor - CodeMirror editor (null if loading for validation)
 * @param {string} path - Path to the file
 * @returns {Promise<string>} - File content as string when editor is null
 */
async function loadFileContent(editor, path) {
    try {
        const response = await fetch(path);
        if (!response.ok) {
            throw new Error(`Failed to load file: ${response.status} ${response.statusText}`);
        }
        
        const content = await response.text();
        
        if (editor) {
            // Set content in editor (existing functionality)
            editor.setValue(content);
        } else {
            // Return content as string (for SHACL validation)
            return content;
        }
    } catch (error) {
        console.error('Error loading file:', error);
        if (editor) {
            editor.setValue(`# Error loading file: ${path}\n# ${error.message}`);
        } else {
            throw error;
        }
    }
}
