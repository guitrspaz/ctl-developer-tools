<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteDump(var=prc.testData);
	WriteDump(var=prc.settings.testBox);
	prc.settings.testBox.addDirectory(prc.testData.directory,true);
	WriteOutput(prc.settings.testBox.runRemote(argumentCollection=prc.testData));
</cfscript>