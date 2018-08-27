<cfscript>
	/* module javascripts */
	prc['scripts']=[
		prc.moduleBase&'/views/_includes/js/module-custom.js'
	];

	/* module css */
	prc['css']=[
		prc.moduleBase&'/views/_includes/css/module-custom.css'
	];

	/* Render to default layout */
	WriteOutput(renderLayout(layout='Main'));
</cfscript>
