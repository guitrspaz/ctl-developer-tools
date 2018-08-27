<cfscript>
	WriteDump(var=prc);abort;
	/* module javascripts */
	prc['scripts']=[
		prc.moduleBase&'/views/_includes/js/testbox.js'
	];

	/* module css */
	prc['css']=[
		prc.moduleBase&'/views/_includes/css/html.css',
		prc.moduleBase&'/views/_includes/css/testbox.css'
	];

	/* Render to default layout */
	WriteOutput(renderLayout(layout='Main'));
</cfscript>
