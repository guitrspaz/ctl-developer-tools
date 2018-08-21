<!--- put content here --->
<cfscript>
	WriteDump(var=StructKeyArray(request));
	/* WriteDump(var=request); */
	WriteDump(var=event.getCollection(),label="Collection");
	/* WriteDump(var=event.getDefaults(),label="WireBox"); */
	/* WriteDump(var=event.getLogBoxConfig(),label="LogBox"); */
	/* WriteDump(var=event.getMappings(),label="Mappings"); */
	/* WriteDump(var=event.getColdbox(),label="ColdBox"); */
	WriteDump(var=event.getProperties(),label="Properties");
</cfscript>