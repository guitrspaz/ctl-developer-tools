<cfscript>
	//WriteDump(var=prc.testData,label='data');
	//WriteDump(var=prc.testBox,label='testbox');
	if( isSimpleObject(prc.results) ){
		WriteOutput(prc.results);
	} else {
		WriteDump(var=prc.results);
	}
</cfscript>