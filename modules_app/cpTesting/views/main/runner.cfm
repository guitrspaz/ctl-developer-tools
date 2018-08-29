<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteOutput(ReplaceNoCase(prc.settings.testBox.runRemote(argumentCollection=prc.testData),'//','','ONE'));
</cfscript>