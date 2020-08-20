/**
* @name: ModuleConfig
* @package: modules_app.api.
* @hint: I am the ModuleConfig for the API Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Thursday, 08/20/2020 10:32:11 AM
* @modified: Thursday, 08/20/2020 10:32:16 AM
*/

component{
	this['title']='API';
	this['author']="Chris Schroeder";
	this['webURL']="";
	this['description']="A module for handling API calls";
	this['version']="1.0.0";
	this['viewParentLookup']=true;// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this['layoutParentLookup']=true;// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this['inheritEntryPoint']=true;
	this['entryPoint']="/api";// The module entry point using SES
	this['autoMapModels']=false;
	this['modelNamespace']="api";
	this['cfmapping']="api";
	this['aliases']=[];
	this['parseParentSettings']=true;
	//this['dependencies']=[ "JavaLoader", "CFCouchbase" ];

	function configure(){

		/* parent settings */
		parentSettings={};

		/* module settings - stored in the main configuration settings struct as modules.{moduleName}.settings */
		settings={
			'display':"core",
			'moduleName':this.title,
			'moduleRoot':moduleMapping,
			'moduleVersion':this.version,
			'modulePrefix':this.modelNamespace,
			'debugMode':false,
			'defaultLog':controller.getSetting('appHash')&'.ModuleLog.'&this.modelNamespace,
			'pageTitle':this.title
		};

		/* layout settings */
		layoutSettings={
			'defaultLayout':'json.cfm'
		};

		// Module Conventions
		conventions={
			'handlersLocation':"controllers",
			'viewsLocation':"views",
			'layoutsLocation':"views/_layouts",
			'pluginsLocation':"plugins",
			'modelsLocation':"models"
		};

		/* SES Routes */
		routes=[
			// Module Entry Point
			{ 'pattern':"/", 'handler':"json", 'action':"index" },
			// Convention Route
			{ 'pattern':"/:handler/:action?" }
		];

		/* Map Services */
		binder.mapDirectory(Right(moduleMapping,Len(moduleMapping)-1)).initWith(argumentCollection=settings);
    }

	/************************************** IMPLICIT ACTIONS *********************************************/

    /* On module init */
    function onLoad(){
		//log.info( this.title&' > '&SerializeJSON(this) );
	}

	/* On module shutdown */
	function onUnLoad(){
		//log.info( 'Module '&this.title&' unloaded safely.' );
	}

	/* This is available here because this component is an interceptor */
	function preProcess(event, interceptData){
		//log.info('The event executed is '&arguments.event.getCurrentEvent());
	}
}