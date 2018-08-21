<!--- put content here --->
<cfscript>
	WriteDump(var=StructKeyArray(request));
	/* WriteDump(var=request); */
	WriteDump(var=event.getCollection());
	WriteDump(var=event.getColdbox());
</cfscript>