<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteOutput(prc);
	WriteOutput(prc.settings.testBox.runRemote(argumentCollection=prc.testData));
</cfscript>