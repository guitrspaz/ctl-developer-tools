<cfscript>
	//WriteDump(var=prc.testData,label='data');
	//WriteDump(var=prc.testBox,label='testbox');
	if( isSimpleValue(prc.results) ){
		WriteOutput(prc.results);
	} else {
		WriteDump(var=prc.results);
	}
</cfscript>
<script type="text/javascript">
	if( jQuery!==null ){
		jQuery(document).on('click','.tb-file-btn',function(event){
			event.preventDefault();
			runTests(jQuery(event.currentTarget).attr('href'));
			return false;
		});
	}
</script>