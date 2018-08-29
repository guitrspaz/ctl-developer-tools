<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteDump(var=prc.testData);
	WriteDump(var=prc.settings.testBox);
	WriteOutput(prc.settings.testBox.runRemote(argumentCollection=prc.testData));
</cfscript>