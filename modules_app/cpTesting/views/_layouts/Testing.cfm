<cfscript>
	/* module javascripts */
	prc['scripts']=[
		prc.moduleRoot&'/views/_includes/js/testbox.js'
	];

	/* module css */
	prc['css']=[
	];

	/* Render to default layout */
	WriteOutput(renderLayout(layout='Main'));
</cfscript>
