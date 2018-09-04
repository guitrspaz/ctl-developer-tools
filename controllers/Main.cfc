/**
* @name: controllers.Main
* @hint: Handler for the Main layout
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.EventHandler"{

	// Default Action
	function index(event,rc,prc){
		prc['sectionTitle']="Application Properties";
		event.setView("main/index");
	}

	function dump(event,rc,prc){
		prc['sectionTitle']='Data Dump';
		prc['configuration']=controller.getConfigSettings();
		prc['serviceProps']={
			'dsn':prc.configuration.dsn.name,
			'debugMode':prc.configuration.debugMode,
			'defaultLog':prc.configuration.defaultLog,
			'moduleVersion':prc.configuration.appVersion
		};
		//prc['service']=getInstance(name='service',initArguments=prc.serviceProps);
		//prc['dao']=getInstance(name='dao',initArguments=prc.serviceProps);
		prc['event']=event.getCollection();
		event.setView("main/dump");
	}

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit(event,rc,prc){

	}

	function onRequestStart(event,rc,prc){

	}

	function onRequestEnd(event,rc,prc){

	}

	function onSessionStart(event,rc,prc){

	}

	function onSessionEnd(event,rc,prc){
		var sessionScope=event.getValue("sessionReference");
		var applicationScope=event.getValue("applicationReference");
	}

	function onException(event,rc,prc){
		event.setHTTPHeader( statusCode=500 );
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception=prc.exception;
		//Place exception handler below:
	}

	function onMissingTemplate(event,rc,prc){
		//Grab missingTemplate From request collection, placed by ColdBox
		var missingTemplate=event.getValue("missingTemplate");

	}

}