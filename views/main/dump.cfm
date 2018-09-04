<!--- put content here --->
<cfscript>
	//WriteOutput('<p>'&event.getCurrentRoutedNamespace()&'</p>');
	//WriteOutput('<p>'&event.getCurrentRoutedEvent()&'</p>');
	//WriteOutput('<p>'&event.getCurrentEvent()&'</p>');
	//WriteOutput('<p>'&event.getCurrentAction()&'</p>');
	WriteDump(var=prc,label="Event");
</cfscript>