
component{
	// Application properties
	this['name']=hash( getCurrentTemplatePath() );
	this['sessionManagement']=true;
	this['sessionTimeout']=createTimeSpan(0,0,30,0);
	this['setClientCookies']=true;

	// Java Integration
	this['javaSettings']={
		'loadPaths':[ ".\lib" ],
		'loadColdFusionClassPath':true,
		'reloadOnChange':false
	};

	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH=getDirectoryFromPath( getCurrentTemplatePath() );
	// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING="";
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE="";
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY="";

	// application start
	public boolean function onApplicationStart(){
		application['cbBootstrap']=new coldbox.system.Bootstrap( COLDBOX_CONFIG_FILE, COLDBOX_APP_ROOT_PATH, COLDBOX_APP_KEY, COLDBOX_APP_MAPPING );
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// application end
	public void function onApplicationEnd( struct appScope ){
		arguments.appScope.cbBootstrap.onApplicationEnd( arguments.appScope );
	}

	// request start
	public boolean function onRequestStart( string targetPage ){
		// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );

		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
	}

	public boolean function onMissingTemplate( template ){
		return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
	}

	public Void function onError( required Any exception ){
		var errorStruct={
			'attrs':{
				'timeStamp':Now(),
				'exception':arguments.exception,
				'stackTrace':getStackTrace()
			},
			'caller':'application.onError() > '
		};
		WriteLog(errorStruct.caller & ' > ' & SerializeJSON(errorStruct.attrs),"error","yes",application.name&".ErrorLog");
		return application.cbBootstrap.onException( argumentCollection=arguments );
	}

	/**
	 * @name: application.getStackTrace
	 * @hint: I return the route data
	 * @returns: Struct
	 * @date: Friday, 06/23/2017 08:23:54 AM
	 * @author:	Chris Schroeder (schroeder@jhu.edu)
	 */
	private struct function getStackTrace(){
		var errorStruct={
			'stackTrace':{}
		};
		try{
			Throw("This is thrown to gain access to the strack trace.","StackTrace");
		} catch( Any e ){
			if( structKeyExists( e,'tagContext' ) ){
				errorStruct['tagContext']=e.TagContext;
			}
		}
		return errorStruct;
	}
}