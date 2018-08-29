<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteDump(var=prc.testData);
	WriteOutput(prc.settings.testBox.runRemote(argumentCollection=prc.testData));
</cfscript>