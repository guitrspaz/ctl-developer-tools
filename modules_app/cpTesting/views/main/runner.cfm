<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteDump(var=prc.testData);
	WriteDump(var=prc.testBox);
	WriteOutput(prc.testBox.runRemote(argumentCollection=prc.testData));
</cfscript>