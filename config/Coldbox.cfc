/**
* @name: config.Coldbox
* @hint: Configure ColdBox Application
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component{

	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox={
			//Application Setup
			'appName':"Developer Tools",
			'eventName':"event",

			//Development Settings
			'reinitPassword':"",
			'handlersIndexAutoReload':true,

			//Implicit Events
			'defaultEvent':"jsonLogReader:LogReader.index",
			'requestStartHandler':"Main.onRequestStart",
			'requestEndHandler':"",
			'applicationStartHandler':"Main.onAppInit",
			'applicationEndHandler':"",
			'sessionStartHandler':"",
			'sessionEndHandler':"",
			'missingTemplateHandler':"",

			//Extension Points
			'applicationHelper':"views/_includes/helpers/ApplicationHelper.cfm",
			'viewsHelper':"views/_includes/helpers/ViewsHelper.cfm",
			'modulesExternalLocation':[],
			'viewsExternalLocation':"",
			'layoutsExternalLocation':"",
			'handlersExternalLocation':"",
			'requestContextDecorator':"",
			'controllerDecorator':"",

			//Error/Exception Handling
			'invalidHTTPMethodHandler':"",
			'exceptionHandler':"main.onException",
			'invalidEventHandler':"",
			'customErrorTemplate':"/coldbox/system/includes/BugReport.cfm",

			//Application Aspects
			'handlerCaching':false,
			'eventCaching':false,
			'viewCaching':false
		};

		/* custom settings */
		settings={
			'appVersion':'1.0.1',
			'appHash':application.getname(),
			'ctlEmail':'ctlhelp@jhu.edu',
			'defaultLog':application.getname()&'.AppLog',
			'debugMode':false,
			'testSetting':true,
		    'dsn':{
		        'name':"DE_MyCourses",
		        'type':'SQL'
		    },
		    'SSLRequired':true,
		    'SSLPattern':'.*',
		    'instanceHash':Hash(CreateUUID())
		};

		/**
		 * environment settings, create a detectEnvironment() method to detect it yourself.
		 * create a function with the name of the environment so it can be executed if that environment is detected
		 * the value of the environment is a list of regex patterns to match the cgi.http_host.
		 */
		environments={
			'development':"localhost,^127\.0\.0\.1"
		};

		/* Module Directives */
		modules={
			// reload and unload modules in every request
			'autoReload':false,
			// An array of modules names to load, empty means all of them
			'include':[],
			// An array of modules names to NOT load, empty means none
			'exclude':[]
		};

		/* LogBox DSL */
		logBox={
			// Define Appenders
			'appenders':{
				'coldboxTracer':{
					'class':"coldbox.system.logging.appenders.ConsoleAppender"
				}
			},
			// Root Logger
			'root':{
				'levelmax':"INFO",
				'appenders':"*"
			},
			// Implicit Level Categories
			'info':[ "coldbox.system" ]
		};

		/* Layout Settings */
		layoutSettings={
			'defaultLayout':"",
			'defaultView':""
		};

		/* Interceptor Settings */
		interceptorSettings={
			'customInterceptionPoints':""
		};

		/* Register interceptors as an array, we need order */
		interceptors=[
		];

		/* ORM Settings */
		orm={
			'injection':{
				'enabled':true,
				'include':'',
				'exclude':''
			}
		};

		/* module setting overrides
		moduleSettings={
			'moduleName':{
				'settingName':"overrideValue"
			}
		};
		*/

		/* flash scope configuration */
			flash={
				'scope':"session",//session,client,cluster,ColdboxCache,or full path
				'properties':{}, // constructor properties for the flash scope implementation
				'inflateToRC':true, // automatically inflate flash data into the RC scope
				'inflateToPRC':false, // automatically inflate flash data into the PRC scope
				'autoPurge':true, // automatically purge flash data for you
				'autoSave':true // automatically save flash scopes at end of a request and on relocations.
			};

		/* Register Layouts
			layouts=[
				{
					'name':"login",
			 		'file':"Layout.tester.cfm",
					'views':"vwLogin,test",
					'folders':"tags,pdf/single"
				}
			];
		*/

		/* Conventions */
			conventions={
				'handlersLocation':"controllers",
				'viewsLocation':"views",
				'layoutsLocation':"views/_layouts",
				'modelsLocation':"models",
				'eventAction':"index"
			};

	}

	/**
	* Development environment
	*/
	function development(){
		coldbox['customErrorTemplate']="/coldbox/system/includes/BugReport.cfm";
	}

}