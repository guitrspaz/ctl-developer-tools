<cfscript>
	//WriteDump(var=prc.testData,label='data');
	//WriteDump(var=prc.testBox,label='testbox');
	try{
		if( isSimpleValue(prc.results) ){
			WriteOutput(prc.results);
		} else {
			WriteDump(var=prc.results);
		}
	} catch( Any e ){
		WriteDump(var=e);
	}
</cfscript>