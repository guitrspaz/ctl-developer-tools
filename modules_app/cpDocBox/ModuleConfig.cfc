/**
* @name: ModuleConfig
* @package: modules_app.cpDocBox.
* @hint: I am the ModuleConfig for the DocBox module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Thursday, 08/23/2018 07:48:48 AM
* @modified: Thursday, 08/23/2018 07:48:48 AM
*/

component{
	this['title']='CoursePlus DocBox';
	this['author']="Chris Schroeder";
	this['webURL']="";
	this['description']="A module for displaying CoursePlus methods";
	this['version']="0.0.1";
	this['viewParentLookup']=true;// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this['layoutParentLookup']=true;// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this['inheritEntryPoint']=false;
	this['entryPoint']="/testing";// The module entry point using SES
	this['autoMapModels']=true;
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
			'moduleVersion':this.version,
			'debugMode':false,
			'defaultLog':'moduleLog.'&this.modelNamespace,
			'docbox':new DocBox( strategy="class.path", properties={} )
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

		settings.docbox.generate(
			source=[{
				'dir':ExpandPath('/core'),
				'mapping':'core'
			},{
				'dir':ExpandPath('/com'),
				'mapping':'com'
			}],
			mapping="docs"
		);

		/* SES Routes */
		routes=[
			// Module Entry Point
			{ 'pattern':"/", 'handler':"api", 'action':"index" },
			// Convention Route
			{ 'pattern':"/:handler/:action?" }
		];
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