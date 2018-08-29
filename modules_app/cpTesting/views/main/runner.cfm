<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteDump(var=prc.testData,label='data');
	WriteDump(var=prc.settings.testReporter,label='reporter');
	WriteDump(var=prc.testBox,label='testbox');
	WriteOutput(prc.testBox.runRaw(argumentCollection=prc.testData));
</cfscript>