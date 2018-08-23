/**
* @name: ModuleConfig
* @package: modules_app.jsonLogReader.
* @hint: I am the ModuleConfig for the JSON Parser Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Thursday, 08/23/2018 07:48:48 AM
* @modified: Thursday, 08/23/2018 07:48:48 AM
*/

component{
	this['title']='JSON Log Reader';
	this['author']="Chris Schroeder";
	this['webURL']="https://chriss-imac.sph.ad.jhsph.edu";
	this['description']="A module for parsing JSON data";
	this['version']="0.0.1";
	this['viewParentLookup']=true;// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this['layoutParentLookup']=true;// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this['inheritEntryPoint']=false;
	this['entryPoint']="/json";// The module entry point using SES
	this['autoMapModels']=true;
	this['modelNamespace']="json";
	this['cfmapping']="json";
	this['aliases']=[];
	this['parseParentSettings']=true;
	//this['dependencies']=[ "JavaLoader", "CFCouchbase" ];

	function configure(){

		/* parent settings */
		parentSettings={};

		/* module settings - stored in the main configuration settings struct as modules.{moduleName}.settings */
		settings={
			'display':"core",
			'moduleVersion':this.version,
			'debugMode':false,
			'defaultLog':'moduleLog.'&this.modelNamespace
		};

		/* layout settings */
		layoutSettings={
			'defaultLayout':""
		};

		// Module Conventions
		conventions={
			'handlersLocation':"controllers",
			'viewsLocation':"views",
			'layoutsLocation':"views/_layouts",
			'pluginsLocation':"plugins",
			'modelsLocation':"models"
		};

		/* datasources
			datasources={
				'dsn'={
					'name'="dbname",
					'dbType'="SQL",
					'username'="root",
					'password'="root"
				}
			};
		*/

		/* SES Routes */
		routes=[
			// Module Entry Point
			{ 'pattern':"/", 'handler':"LogReader", 'action':"index" },
			// Convention Route
			{ 'pattern':"/:handler/:action?" }
		];

		/* Interceptor Config
			interceptorSettings={
				customInterceptionPoints="onModuleError"
			};
		*/

		/* Interceptors
			interceptors=[{
				'name':"modulesecurity",
				'class':moduleMapping&'.interceptors.security',
				'properties':{
					'URLMatch':'/api-docs',
					'loginURL':'/api-docs/login'
				}
			}];
		*/
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