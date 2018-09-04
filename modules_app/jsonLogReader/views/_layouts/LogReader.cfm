<cfscript>
	/* module javascripts */
	prc['scripts']=[
		prc.moduleRoot&'/views/_includes/js/module-custom.js'
	];

	/* module css */
	prc['css']=[
		prc.moduleRoot&'/views/_includes/css/module-custom.css'
	];

	/* Render to default layout */
	WriteOutput(renderLayout(layout='Main'));
</cfscript>
