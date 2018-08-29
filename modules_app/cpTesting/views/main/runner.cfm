<cfscript>
	//for tests
	variables.testBundles=prc.testData.testBundles;
	variables.directory=prc.testData.directory;
	WriteDump(var=prc.testData,label='data');
	//WriteDump(var=prc.testBox,label='testbox');
	WriteOutput(prc.testBox.run(argumentCollection=prc.testData));
</cfscript>