<cfscript>
	variables.test=CreateObject('component','modules_app.cpTesting.models.testSuiteService').init();
	WriteDump(var=variables.test);
</cfscript>