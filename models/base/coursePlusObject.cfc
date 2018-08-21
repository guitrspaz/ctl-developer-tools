/**
* @name: coursePlusObject
* @hint: I am the base object for all beans using service-layer tools in the models.base package
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Wednesday, 05/17/2017 07:26:54 AM
* @modified: Wednesday, 05/17/2017 07:26:54 AM
*/

component
	displayname="coursePlusObject"
	accessors="true"
	output="false"
{
	property name='appCacheRegions' type='Struct' getter='true' setter='true';
	property name="baseClass" getter="true" setter="true" type="string" default="models.base.coursePlusObject";
	property name='blueprints' getter='true' setter='true' type='struct';
	property name='cacheName' type='String' getter='true' setter='true' default='serviceObject';
	property name='cacheRegion' type='String' getter='true' setter='true';
	property name='cacheScopes' type='Array' getter='true' setter='true';
	property name='cacheTypes' type='Struct' getter='true' setter='true';
	property name='caller' type='String' getter='true' setter='true' default='models.base.coursePlusObject';
	property name='child' type='Struct' getter='true' setter='true';
	property name='compareDate' type='Date' getter='true' setter='true';
	property name='configuredAt' type='Date' getter='true' setter='true';
	property name='ctlemail' type='String' getter='true' setter='true' default='ctlhelp@jhu.edu';
	property name='debugMode' type='Boolean' getter='true' setter='true' default=false;
	property name='defaultLog' type='String' getter='true' setter='true' default='serviceObjects';
	property name='defaultDate' type='Date' getter='true' setter='true';
	property name='developerEmail' type='String' getter='true' setter='true';
	property name='extendedInclusions' type='array' getter='true' setter='true';
	property name='filePath' type='string' getter='true' setter='true' default="/fileDepot";
	property name='hash' type='String' getter='true' setter='true';
	property name='knownLocalCacheRegions' type='Array' getter='true' setter='true';
	property name='knownSharedCacheRegions' type='Array' getter='true' setter='true';
	property name='loaded' type='Boolean' getter='true' setter='true' default='false';
	property name='moduleName' getter='true' setter='true' type='string' default='theMonolith';
	property name='moduleRoot' getter='true' setter='true' type='string' default='/core';
	property name='modulePrefix' getter='true' setter='true' type='string' default='';
	property name='moduleVersion' getter='true' setter='true' type='string' default='0.0.0';
	property name='paramAliases' type='Struct' getter='true' setter='true';
	property name='sharedCache' type='Boolean' getter='true' setter='true' default='false';
	property name='supportEmail' type='String' getter='true' setter='true' default='ctlhelp@jhu.edu';
	property name='systemUser' getter='true' setter='true' type='Numeric' default=51367;

	this['compareDate']=CreateDateTime(1970,1,1,0,0,0);
	this['defaultDate']=CreateDateTime(1969,12,31,23,59,59);
	this['configuredAt']=Now();

	/**
	 * @name: configureCPObject
	 * @package: models.base.coursePlusObject
	 * @hint: I configure the object properties
	 * @returns: Void
	 * @date: Sunday, 05/21/2017 09:18:23 AM
	 * @author:	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Void function configureCPObject(
		Boolean sharedCache
	){
		try{
			var defaultCacheTypes={};
			var defaultCacheScopes=[];
			var allowedSharedCacheRegions=['coursePlus'];
			var allowedLocalCacheRegions=['OBJECT','theMonolithOBJECT','myCourses4OBJECT','monolithSchedTasksOBJECT'];
			//cache regions
			this.setknownSharedCacheRegions(allowedSharedCacheRegions);
			this.setknownLocalCacheRegions(allowedLocalCacheRegions);
			var metaData=GetMetaData(this).filter(function(key,value){
				return isSimpleValue(value);
			});
			/**
			 *	Important: If the sharedCache argument is not provided,
			 *	we should default the argument to the default property
			 *	value to allow the rest of the process to continue as if
			 *	the argument exists.
			 *  -CS, Friday, 06/09/2017 07:57:37 AM
			 */
			if( ( !structKeyExists(arguments,'sharedCache') || isNull(arguments.sharedCache) )
				&& !isNull(this.getsharedCache())
			){
				arguments.sharedCache=( !isNull(this.getsharedCache()) )?this.getsharedCache():false;
			}

			if( this.getsharedCache()!=arguments.sharedCache || !(Len(Trim(this.getcacheRegion()))) ){
				var cacheCollection=(arguments.sharedCache)?allowedSharedCacheRegions:allowedLocalCacheRegions;
				var cacheRegionString=(
					structKeyExists(arguments,'cacheRegion')
					&& Len(Trim(arguments.cacheRegion))
					&& cacheRegionExists(arguments.cacheRegion)
					&& ArrayFindNoCase(cacheCollection,arguments.cacheRegion)
					&& arguments.sharedCache==this.getsharedCache()
				)?arguments.cacheRegion:returnCacheRegion(arguments.sharedCache);
				this.setcacheRegion(cacheRegionString);
			}

			//uneditable defaults
			this.setcaller(metaData['FULLNAME']);
			this.setchild(metaData);
			this.sethash(CreateUUID());
			this.setconfiguredAt(Now());
			this.setextendedInclusions(['compareDate','defaultDate']);
			var baseCompareDate=CreateDateTime(1970,1,1,0,0,0);
			var baseDefaultDate=CreateDateTime(1969,12,31,23,59,59);

			//init-variable properties

			/* default dates */
			if( structKeyExists(arguments,'compareDate')
				&& !isNull(arguments.compareDate)
				&& (isValid('date',arguments.compareDate) || isValid('time',arguments.compareDate))
			){
				baseCompareDate=arguments.compareDate;
			}
			if( structKeyExists(arguments,'defaultDate')
				&& !isNull(arguments.defaultDate)
				&& (isValid('date',arguments.defaultDate) || isValid('time',arguments.defaultDate))
			){
				baseDefaultDate=arguments.defaultDate;
			}
			this.setcompareDate(baseCompareDate);
			this.setdefaultDate(baseDefaultDate);

			/* object properties */
			if( structKeyExists(arguments,'blueprints')
				&& !isNull(arguments.blueprints)
				&& isValid('struct',arguments.blueprints)
			){
				this.setblueprints(arguments.blueprints);
			}
			if( structKeyExists(arguments,'defaultLog')
				&& !isNull(arguments.defaultLog)
				&& Len(Trim(arguments.defaultLog))
			){
				this.setdefaultLog(arguments.defaultLog);
			}
			if( StructKeyExists(arguments,'cacheScopes')
				&& !isNull(arguments.compareDate)
				&& isValid('array',arguments.cacheScopes)
			){
				defaultCacheScopes=arguments.cacheScopes;
			}
			this.setcacheScopes(defaultCacheScopes);
			if( StructKeyExists(arguments,'cacheTypes')
				&& !isNull(arguments.cacheTypes)
				&& isValid('struct',arguments.cacheTypes)
			){
				defaultCacheTypes=arguments.cacheTypes;
			}
			this.setcacheTypes(defaultCacheTypes);
			if( structKeyExists(arguments,'debugMode')
				&& !isNull(arguments.debugMode)
				&& isValid('boolean',arguments.debugMode)
			){
				this.setdebugMode(arguments.debugMode);
			}
			if( structKeyExists(arguments,'filePath')
				&& !isNull(arguments.filePath)
				&& Len(Trim(arguments.filePath))
			){
				this.setfilePath(arguments.filePath);
			}
			if( structKeyExists(arguments,'systemUser')
				&& !isNull(arguments.systemUser)
				&& isValid('numeric',arguments.systemUser)
			){
				this.setsystemUser(arguments.systemUser);
			}
			if( structKeyExists(arguments,'moduleRoot')
				&& !isNull(arguments.moduleRoot)
				&& Len(Trim(arguments.moduleRoot))
			){
				this.setmoduleRoot(arguments.moduleRoot);
			}
			if( structKeyExists(arguments,'moduleName')
				&& !isNull(arguments.moduleName)
				&& Len(Trim(arguments.moduleName))
			){
				this.setmoduleName(arguments.moduleName);
			}
			if( structKeyExists(arguments,'modulePrefix')
				&& !isNull(arguments.modulePrefix)
				&& Len(Trim(arguments.modulePrefix))
			){
				this.setmodulePrefix(arguments.modulePrefix);
			}
			if( structKeyExists(arguments,'moduleVersion')
				&& !isNull(arguments.moduleVersion)
				&& Len(Trim(arguments.moduleVersion))
			){
				this.setmoduleVersion(arguments.moduleVersion);
			}

			//try to find a valid support email address - use temporarily for developer email address too
			if( structKeyExists(arguments,'ctlEmail')
				&& !isNull(arguments.ctlEmail)
				&& Len(Trim(arguments.ctlEmail))
			){
				this.setctlEmail(arguments.ctlEmail);
				this.setsupportEmail(arguments.ctlEmail);
				this.setdeveloperEmail(arguments.ctlEmail);
			} else if( structKeyExists(arguments,'supportEmail')
				&& !isNull(arguments.supportEmail)
				&& Len(Trim(arguments.supportEmail))
			){
				this.setctlEmail(arguments.supportEmail);
				this.setsupportEmail(arguments.supportEmail);
				this.setdeveloperEmail(arguments.supportEmail);
			}

			//try to find a valid developer email address
			if( structKeyExists(arguments,'developerEmail')
				&& !isNull(arguments.developerEmail)
				&& Len(Trim(arguments.developerEmail))
			){
				this.setdeveloperEmail(ListFirst(arguments.developerEmail,','));
			} else if( structKeyExists(arguments,'adminEmail')
				&& !isNull(arguments.adminEmail)
				&& Len(Trim(arguments.adminEmail))
			){
				this.setdeveloperEmail(ListFirst(arguments.adminEmail,','));
			} else if( structKeyExists(arguments,'devEmail')
				&& !isNull(arguments.devEmail)
				&& Len(Trim(arguments.devEmail))
			){
				this.setdeveloperEmail(ListFirst(arguments.devEmail,','));
			}

			if( structKeyExists(arguments,'sharedCache')
				&& !isNull(arguments.sharedCache)
				&& isValid('boolean',arguments.sharedCache)
				&& arguments.sharedCache!=this.getsharedCache()
			){
				this.setsharedCache(arguments.sharedCache);
			}
			if( structKeyExists(arguments,'paramAliases')
				&& !isNull(arguments.paramAliases)
				&& isValid('struct',arguments.paramAliases)
			){
				this.setparamAliases(configureParamAliases(arguments.paramAliases));
			}
			this.setloaded(true);

			//logging management
			var altLogs={
				'models.base.bean':'',
				'models.base.moduleProperties':'modulePropertyInitLog'
			};
			var logInstance=doLogging(altLogs);
			if( logInstance['doLog']==true ){
				logInit(logInstance['logName'],false,{
					'initArguments':arguments.filter(function(key,value){
						return (!isNull(value));
					}).map(function(key,value){
						var meta=GetMetaData(value);
						if( isObject(meta) && !isValid('struct',meta) ){
							return {
								'key':key,
								'value':value,
								'type':meta.getName(),
								'simple':meta.getSimpleName()
							};
						} else {
							return {
								'key':key,
								'value':value,
								'type':meta['FULLNAME'],
								'simple':ListLast(meta['FULLNAME'],'.')
							};
						}
					})
				});
			}
		} catch(Any e){
			WriteLog(SerializeJSON({cfcatch:e}),'error','yes','serviceObjects');
		}
	}

	public Date function returnCompareDate(Date compareDate=CreateDateTime(1970,1,1,0,0,0)){
		return (
			isValid('date',this.getcompareDate())
		)?this.getcompareDate():(
			StructKeyExists(arguments,'compareDate')
			&& isValid('date',arguments.compareDate)
		)?arguments.compareDate:CreateDateTime(1970,1,1,0,0,0);
	}
	public Date function returnDefaultDate(Date defaultDate=CreateDateTime(1969,12,31,23,59,59)){
		return (
			isValid('date',this.getdefaultDate())
		)?this.getdefaultDate():(
			StructKeyExists(arguments,'defaultDate')
			&& isValid('date',arguments.defaultDate)
		)?arguments.defaultDate:CreateDateTime(1969,12,31,23,59,59);
	}

	private Struct function doLogging(Struct altLogs={}){
		var result={
			'doLog':true,
			'logName':'componentInitLog'
		};
		StructEach(arguments.altLogs,function(key,value){
			if( isInstanceOf(this,key) ){
				if( Len(Trim(value)) ){
					result['logName']=Trim(value);
				} else {
					result['doLog']=false;
				}
			}
		});
		return result;
	}

	public models.base.coursePlusObject function init(){
		configureCPObject(argumentCollection=arguments);
		return this;
	}

	/**
	 * @name: logInit()
	 * @package: models.base.coursePlusObject
	 * @hint: I log the object init configuration
	 * @returns: Void
	 * @date: Sunday, 05/21/2017 09:18:23 AM
	 * @author:	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Void function logInit(
		required String logName,
		Boolean trace=false,
		Struct extendedInfo={}
	){
		var logType='information';
		var props={
			'cache':{
				'region':this.getcacheRegion(),
				'scopes':this.getcacheScopes(),
				'types':this.getcacheTypes(),
				'distributed':this.getsharedCache()
			},
			'module':{
				'name':this.getmoduleName(),
				'root':this.getmoduleRoot(),
				'prefix':this.getmodulePrefix(),
				'version':this.getmoduleVersion(),
				'support':this.getsupportEmail()
			},
			'service':{
				'timestamp':DateTimeFormat(this.getconfiguredAt(),'short'),
				'id':this.gethash(),
				'name':this.getcaller(),
				'metaData':this.getchild(),
				'defaultLog':this.getdefaultLog(),
				'debugMode':this.getdebugMode()
			}
		};
		if( structCount(arguments['extendedInfo']) ){
			props['extendedInfo']=arguments['extendedInfo'];
		}

		if( arguments.trace || this.getdebugMode() ){
			props['trace']=getstackTrace();
			logType='warning';
		}

		createLog(
			functName=this.getcaller()&'.init()',
			logType=logType,
			logName=logName,
			args=props
		);
	}

	/**
	 * @name: makeBlueprint()
	 * @package: models.base.coursePlusObject
	 * @hint: I return the object as a structure
	 * @returns: Struct
	 * @date: Monday, 08/22/2016 08:23:54 AM
	 * @author:	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Struct function makeBlueprint(required String objectClass,includeParents=[]){
		var objStruct={};
		if( !ArrayLen(arguments.includeParents) ){
			arguments['includeParents']=[arguments.objectClass];
		}
		try{
			var obj=CreateObject('component',arguments.objectClass).init();
			objStruct=obj.getObjectAsStructure( includeParents=arguments.includeParents );
		} catch( Any e ){
			throw(
				type='InvalidObject',
				message='This blueprint could not be created.',
				detail='The object referenced (`'&arguments.objectClass&'`) for this blueprint is invalid.',
				extendedInfo=SerializeJSON({cfcatch:e})
			);
		}
		return objStruct;
	}

	/**
	 * @name: getStackTrace()
	 * @package: models.base.coursePlusObject
	 * @hint: I return the route data
	 * @returns: Struct
	 * @date: Monday, 08/22/2016 08:23:54 AM
	 * @author:	Chris Schroeder (schroeder@jhu.edu)
	 */
	public struct function getStackTrace(){
		var errorStruct={
			'stackTrace':{},
			'start':Now()
		};
		try{
			Throw("This is thrown to gain access to the strack trace.","StackTrace");
		} catch( Any e ){
			/*
			if( structKeyExists( e,'stackTrace' ) ){
				errorStruct.stackTrace=e.StackTrace;
			}
			*/
			if( structKeyExists( e,'tagContext' ) ){
				errorStruct['tagContext']=e.TagContext.filter(function(tagItem){
					return (
						isValid('struct',tagItem)
						&& StructKeyExists(tagItem,'TEMPLATE')
						&& (
							FindNoCase('/com',tagItem['TEMPLATE'])
							|| FindNoCase('/core',tagItem['TEMPLATE'])
							|| FindNoCase('/myCourses',tagItem['TEMPLATE'])
							|| FindNoCase('/help',tagItem['TEMPLATE'])
						)
					);
				});
			}
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		return errorStruct;
	}

	/**
	 * @name:	createLog()
	 * @package: models.base.coursePlusObject
	 * @hint:	I write to logs
	 * @returns:	Void
	 * @date:	Monday, 08/22/2016 08:23:54 AM
	 * @author:	Chris Schroeder (schroeder@jhu.edu)
	 */
	public void function createLog(
		String logName=this.getDefaultLog() hint="name of log to write to",
		required String functName hint="name of function writing to log",
		String moduleName hint="module name, which, if it exists, gets prepended to the text string",
		Struct args={},
		Struct jsonStruct={},
		String message hint="if it exists, message gets added to the log text just before the args",
		String logType="information" hint="this directly reflects the type attribute for cflog"
	){
		var props={};
		props['cacheRegion']=this.getcacheRegion();
		props['hash']=this.gethash();
		props['configuredAt']=this.getconfiguredAt();
		props['instanceOf']=this.getcaller();
		//create text message
		var logString='';
		if( structKeyExists(arguments,'moduleName') && Len(Trim(arguments.moduleName)) ){
			logString=ListAppend( logString,arguments.moduleName,' > ' );
		}
		if( Len(Trim(arguments.functName)) ){
			logString=ListAppend( logString,arguments.functName,' > ' );
		} else {
			logString=ListAppend( logString,'Anonymous()',' > ' );
		}
		if( structKeyExists(arguments,'message') && Len(Trim(arguments.message)) ){
			logString=ListAppend( logString,arguments.message,' > ' );
		}
		if( isValid('struct',arguments.jsonStruct) && !(StructIsEmpty(arguments.jsonStruct)) ){
			StructAppend(props,arguments.jsonStruct,true);
		}
		if( isValid('struct',arguments.args) && !(StructIsEmpty(arguments.args)) ){
			StructAppend(props,arguments.args,true);
		}
		//default log name
		if( !( Len( Trim(arguments.logName) ) ) ){
			arguments['logName']='createLogError';
		}

		//make sure there is a log type
		if( !( Len( Trim(arguments.logType) ) ) ){
			arguments['logType']="information";
		}
		//serialize error struct
		logString&=' > '&ReplaceNoCase(Trim(SerializeJSON(props)),'//','','ONE');
		//log data
		WriteLog(logString,arguments.logType,'yes',arguments.logName);
	}

	/* cache configuration methods */

	/**
	* @name:	loadCacheRegions()
	* @package: models.base.coursePlusObject
	* @hint:	I return the application cache regions as a structure
	* @returns:	Struct
	* @date:	Thursday, 03/16/2017 09:36:49 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	private Struct function loadCacheRegions(
		String sharedRegion=''
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{}
		};
		var emptyRegion={};
		emptyRegion['regionName']='';
		emptyRegion['isDefined']=0;
		emptyRegion['regionType']='unknown';

		//defaults
		errorStruct.result['defaultRegion']=StructCopy(emptyRegion);
		errorStruct.result['sharedRegion']=StructCopy(emptyRegion);
		errorStruct.result['alternateRegions']={};
		errorStruct.result['sharingEnabled']=0;
		errorStruct.result['definedRegions']=0;
		errorStruct.result['undefinedRegions']=0;
		try{
			errorStruct.result=readExistingCacheRegions();
			if( Len(Trim(arguments.sharedRegion))
				&& cacheRegionExists(Trim(arguments.sharedRegion))
			){
				errorStruct.result['sharedRegion']={};
				errorStruct.result.sharedRegion['regionName']=arguments.sharedRegion;
				errorStruct.result.sharedRegion['regionType']='shared';
				errorStruct.result.sharedRegion['isDefined']=1;
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".loadCacheRegions()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	readExistingCacheRegions()
	* @package: models.base.coursePlusObject
	* @hint:	I find all available cacheRegions
	* @returns:	Struct
	* @date:	Thursday, 03/16/2017 09:36:49 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	private Struct function readExistingCacheRegions(){
		cachePut('readExistingCacheRegions-init',Now(),CreateTimeSpan(0,0,0,10),CreateTimeSpan(0,0,0,10));
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{},
			'defaultRegions':this.getknownLocalCacheRegions(),
			'sharedRegions':this.getknownSharedCacheRegions(),
			'knownRegions':{},
			'hardcodeRegions':{},
			'liveRegions':{}
		};
		var emptyRegion={};
		emptyRegion['regionName']='';
		emptyRegion['isDefined']=0;
		emptyRegion['regionType']='unknown';

		errorStruct.hardcodeRegions['defaultRegion']=StructCopy(emptyRegion);
		errorStruct.hardcodeRegions['defaultRegion']['regionType']='default';
		errorStruct.hardcodeRegions['sharedRegion']=StructCopy(emptyRegion);
		errorStruct.hardcodeRegions['sharedRegion']['regionType']='shared';

		//defaults
		errorStruct.result['defaultRegion']=StructCopy(emptyRegion);
		errorStruct.result['sharedRegion']=StructCopy(emptyRegion);
		errorStruct.result['alternateRegions']={};
		errorStruct.result['sharingEnabled']=0;
		errorStruct.result['definedRegions']=0;
		errorStruct.result['undefinedRegions']=0;
		try{
			if( !(isNull(cacheGet('readExistingCacheRegions-init'))) ){
				var cacheManager=createObject('java','net.sf.ehcache.CacheManager').getInstance();
				errorStruct['knownRegions']=cacheManager.getCacheNames();
				ArrayEach(errorStruct.knownRegions,function(item){
					var itemData={};
					itemData['regionName']=item;
					itemData['isDefined']=0;
					itemData['regionType']='unknown';

					if(cacheRegionExists(item)){
						itemData['isDefined']=1;
					}

					if( ArrayFindNoCase(errorStruct.defaultRegions,Trim(item))
						&& !(Len(Trim(errorStruct.hardcodeRegions.defaultRegion.regionName)))
						&& itemData['isDefined']
					){
						itemData['regionType']='default';
						errorStruct.hardcodeRegions['defaultRegion']=itemData;
						errorStruct.hardcodeRegions['sharedRegion']=itemData;
						errorStruct.result['definedRegions']=errorStruct.result['definedRegions']+1;
					}

					if( ArrayFindNoCase(errorStruct.sharedRegions,Trim(item))
						&& itemData['isDefined']
					){
						itemData['regionType']='shared';
						errorStruct.result['sharingEnabled']=1;
						errorStruct.hardcodeRegions['sharedRegion']=itemData;
						errorStruct.result['definedRegions']=errorStruct.result['definedRegions']+1;
					}

					if( itemData.equals(errorStruct.hardcodeRegions['defaultRegion'])==false
						&& itemData.equals(errorStruct.hardcodeRegions['sharedRegion'])==false
						&& itemData['isDefined']==1
					){
						itemData['regionType']='applicationSpace';
						errorStruct.liveRegions[item]=itemData;
						errorStruct.result['definedRegions']=errorStruct.result['definedRegions']+1;
					}
				});
				errorStruct.result['undefinedRegions']=ArrayLen(errorStruct.knownRegions)-errorStruct.result['definedRegions'];
				errorStruct.result['defaultRegion']=errorStruct.hardcodeRegions.defaultRegion;
				errorStruct.result['sharedRegion']=errorStruct.hardcodeRegions.sharedRegion;
				errorStruct.result['alternateRegions']=errorStruct.liveRegions;
				errorStruct.result['knownRegions']=errorStruct.knownRegions;
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".readExistingCacheRegions()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name: returnCacheRegion()
	 * @package: models.base.coursePlusObject
	 * @hint: I return the cacheRegion name for this object
	 * @returns: String
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @date: Friday, 07/01/2016 09:16:05 AM
	 */
	public String function returnCacheRegion(Boolean sharedCache=false){
		configureCacheRegion(argumentCollection=arguments);
		return this.getcacheRegion();
	}


	/**
	 * @name: configureModuleCacheRegion()
	 * @package: models.base.coursePlusObject
	 * @hint: I set the cacheRegion name
	 * @returns: String
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @date: Friday, 07/01/2016 09:16:05 AM
	 */
	private Void function configureModuleCacheRegion( String cacheRegion='' ){
		if( isNull(this.getcacheRegion()) || Len(Trim(this.getcacheRegion()))==0 ){
			if( StructKeyExists(arguments,'cacheRegion')
				&& Len(Trim(arguments.cacheRegion))
				&& cacheRegionExists(Trim(arguments.cacheRegion))
			){
				this.setcacheRegion(Trim(arguments.cacheRegion));
			} else {
				this.setcacheRegion(returnCacheRegion(this.getsharedCache()));
			}
		}
	}

	/**
	 * @name: configureCacheRegion()
	 * @package: models.base.coursePlusObject
	 * @hint: I set the cacheRegion name for this object
	 * @returns: Void
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @date: Friday, 07/01/2016 09:16:05 AM
	 */
	private Void function configureCacheRegion(Boolean sharedCache=false){
		if( isNull(this.getcacheRegion()) || !(Len(Trim(this.getcacheRegion()))) ){
			errorStruct.cacheRegionSetup=initAppCacheRegions();
			//set this value even if distribution is not enabled
			if( arguments.sharedCache ){
				if( structKeyExists(errorStruct.cacheRegionSetup,'cacheRegions')
					&& isValid('struct',errorStruct.cacheRegionSetup.cacheRegions)
					&& structKeyExists(errorStruct.cacheRegionSetup.cacheRegions,'sharedRegion')
					&& isValid('struct',errorStruct.cacheRegionSetup.cacheRegions.sharedRegion)
					&& structKeyExists(errorStruct.cacheRegionSetup.cacheRegions.sharedRegion,'regionName')
				){
					this.setcacheRegion(errorStruct.cacheRegionSetup.cacheRegions.sharedRegion.regionName);
				}
			} else {
				if( structKeyExists(errorStruct.cacheRegionSetup,'cacheRegions')
					&& isValid('struct',errorStruct.cacheRegionSetup.cacheRegions)
					&& structKeyExists(errorStruct.cacheRegionSetup.cacheRegions,'defaultRegion')
					&& isValid('struct',errorStruct.cacheRegionSetup.cacheRegions.defaultRegion)
					&& structKeyExists(errorStruct.cacheRegionSetup.cacheRegions.defaultRegion,'regionName')
				){
					this.setcacheRegion(errorStruct.cacheRegionSetup.cacheRegions.defaultRegion.regionName);
				}
			}
		}
	}

	/**
	* @name:	initAppCacheRegions()
	* @package: models.base.coursePlusObject
	* @hint:	I check to see if there is a shared cache and if not, attempt to set it
	* @returns:	Struct
	* @date:	Tuesday, 03/21/2017 07:05:39 PM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function initAppCacheRegions(
		Struct child={},
		String caller='models.base.coursePlusObject',
		Struct props
	){
		var errorStruct={
			'result':( structKeyExists(arguments,'props')
				&& isValid('struct',arguments.props)
			)?arguments.props:{},
			'logType':"warning",
			'start':Now(),
			'child':( isValid('struct',arguments.child) && structCount(arguments.child) )?arguments.child:( isValid('struct',this.getchild()) )?this.getchild():(isInstanceOf(this,'WEB-INF.cftags.component'))?GetMetaData(this).filter(function(key,value){
				return isSimpleValue(value);
			}):{},
			'stackTrace':getStackTrace()
		};
		try{
			if( !( structKeyExists(errorStruct.result,'cacheDistributionSetAt') )
				|| errorStruct.result.cacheDistributionSetAt=='not set'
			){
				var cacheSetup=returnAppCacheRegions();
				if( isValid('struct',cacheSetup) ){
					StructEach(cacheSetup,function(key,value){
						errorStruct.result[key]=value;
					});
					if( structKeyExists(errorStruct.result,'cacheDistributionEnabled')
						&& isValid('boolean',errorStruct.result.cacheDistributionEnabled)
						&& errorStruct.result.cacheDistributionEnabled
					){
						errorStruct.result['cacheDistributionSetAt']=(
							Len(Trim(arguments.caller))
						)?Trim(arguments.caller):(
							Len(Trim(this.getcaller()))
						)?Trim(this.getcaller()):(
							structKeyExists(errorStruct.child,'FULLNAME') && Len(Trim(errorStruct.child['FULLNAME']))
						)?Trim(errorStruct.child['FULLNAME']):GetMetaData(this)['FULLNAME'];
					}
				}
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".initAppCacheRegions()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name: returnAppCacheRegions()
	 * @package: models.base.coursePlusObject
	 * @hint: I return all available cacheRegions for the parent application
	 * @returns: Void
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @date: Friday, 07/01/2016 09:16:05 AM
	 */
	private Struct function returnAppCacheRegions(){
		return ( configureAppCacheRegions() )?this.getappCacheRegions():{};
	}


	/**
	* @name: returnCacheName()
	* @package: models.base.coursePlusObject
	* @hint: I return a formatted name for a cache item
	* @date: Monday, 08/22/2016 08:23:54 AM
	* @author: Chris Schroeder (schroeder@jhu.edu)
	*/
	public String function returnCacheName(
		required String prefix,
		String type='bean',
		Struct params={}
	){
		var cacheName=arguments.prefix;
		if( Len(Trim(arguments.type) ) ){
			cacheName&='-'&arguments.type;
		} else {
			cacheName&='-unknown';
		}
		if( structCount(arguments.params) ){
			for( var ak in arguments.params ){
				cacheName&='-'&ak&'|'&arguments.params[ak];
			}
		}
		return cacheName;
	}

	/**
	* @name:	configureAppCacheRegions()
	* @package: models.base.coursePlusObject
	* @hint:	I set up all available cacheRegions for the parent application
	* @returns:	Boolean
	* @date:	Tuesday, 03/21/2017 07:43:13 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Boolean function configureAppCacheRegions(){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{},
			'knownRegions':{}
		};
		//default cache structure in case of failure
		var defaultRegion={};
		defaultRegion['regionName']='OBJECT';
		defaultRegion['regionType']='local';
		defaultRegion['isDefined']=0;

		//forces init of a default cacheStore
		cachePut('init',Now(),CreateTimeSpan(0,0,0,10),CreateTimeSpan(0,0,0,10));

		//default values in case of failure
		errorStruct.knownRegions['defaultRegion']=StructCopy(defaultRegion);
		errorStruct.knownRegions['sharedRegion']=StructCopy(defaultRegion);
		errorStruct.knownRegions['alternateRegions']={};
		errorStruct.knownRegions['sharingEnabled']=0;

		//default returnValues
		errorStruct.result['cacheRegions']=errorStruct.knownRegions;
		errorStruct.result['cacheDistributionEnabled']=false;
		errorStruct.result['configured']=false;
		try{
			//cache regions
			errorStruct.knownRegions=loadCacheRegions('coursePlus');
			if( isValid('struct',errorStruct.knownRegions) ){
				errorStruct.result['cacheRegions']=errorStruct.knownRegions;
				if( structKeyExists(errorStruct.result.cacheRegions,'sharingEnabled')
					&& isValid('boolean',errorStruct.result.cacheRegions['sharingEnabled'])
				){
					errorStruct.result['cacheDistributionEnabled']=errorStruct.result['cacheRegions']['sharingEnabled'];
				}
			}
			errorStruct.result['configured']=true;
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".configureAppCacheRegions()",
				args=errorStruct
			);
		}
		errorStruct.result['authRegion']=errorStruct.knownRegions['sharedRegion']['regionName'];
		this.setappCacheRegions(errorStruct.result);
		return errorStruct.result.configured;
	}

	/**
	* @name:	formatCacheKeyArrayData()
	* @package: models.base.coursePlusObject
	* @hint:	I search cache keys for defined strings
	* @date:	Monday, 08/22/2016 08:21:22 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function formatCacheKeyArrayData( required Struct cacheData ){
		var result={};
		StructEach(arguments.cacheData,function(key,value){
			if( isValid('array',value) && ArrayLen(value)>=2 ){
				result[key]=findArrayItemsInString(
					arr=value[1],
					st=value[2]
				);
			}
		});
		return result;
	}

	/**
	* @name:	clearCaches()
	* @package: models.base.coursePlusObject
	* @hint:	I load clear caches with dashed name convention ( scope-type[-identifierKey1|identifierValue1-identifierKey2|identifierValue2] )
	* @date:	Monday, 08/22/2016 08:21:22 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function clearCaches(
		Array cacheScopes=this.getcacheScopes(),
		Array types=mergeCacheTypes(),
		Struct params={},
		Boolean isGlobal=0,
		Boolean restrictedGlobal=0
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'cacheTypes':arguments.types,
			'cacheList':CacheGetAllIds(this.getcacheRegion()),
			'flushed':[],
			'params':[],
			'paramCount':0,
			'start':Now(),
			'cacheParams':[],
			'cacheData':{},
			'stackTrace':getstackTrace(),
			'restrictedGlobal':0,
			'isGlobal':0
		};
		if( StructCount(arguments.params) ){
			errorStruct['cacheParams']=StructKeyArray(arguments.params);
		}
		var scope='';
		var mkr=0;
		var ci=0;
		var it=0;
		var identifierFindCount=0;
		var identifier='';
		try{
			if( structKeyExists(arguments,'isGlobal')
				&& isValid('boolean',arguments.isGlobal)
			){
				errorStruct['isGlobal']=arguments.isGlobal;
			}
			if( structKeyExists(arguments,'restrictedGlobal')
				&& isValid('boolean',arguments.restrictedGlobal)
			){
				errorStruct['restrictedGlobal']=arguments.restrictedGlobal;
			}
			if( !structKeyExists(arguments,'types') || isNull(arguments.types) ){
				arguments['types']=[];
			}

			if( !structKeyExists(arguments,'params') || isNull(arguments.params) ){
				arguments['params']={};
			}

			//block deleting all cache scopes and keys if no scope is specified
			if( !structKeyExists(arguments,'cacheScopes') || isNull(arguments.cacheScopes) ){
				arguments['cacheScopes']=[CreateUUID()];
				arguments['isGlobal']=0;
				arguments['restrictedGlobal']=0;
			}

			errorStruct['cacheCount']=ArrayLen(errorStruct.cacheList);
			errorStruct['typeCount']=ArrayLen(arguments.types);
			errorStruct['scopeCount']=ArrayLen(arguments.cacheScopes);
			if( structCount(errorStruct.arguments.params) ){
				errorStruct['params']=formatParams(
					i=errorStruct.cacheParams,
					p=arguments.params
				);
				if( !(errorStruct.isGlobal) && !(errorStruct.restrictedGlobal) ){
					errorStruct['paramCount']=StructCount(arguments.params);
				} else if ( errorStruct.restrictedGlobal ){
					errorStruct['paramCount']=1;
				}
			}
			var cacheProperties=Duplicate(errorStruct.arguments);
			var cacheDataStruct={};
			var flushedItems=[];
			if( errorStruct.cacheCount ){
				var cacheNameList=Duplicate(errorStruct.cacheList);
				ArrayEach(cacheNameList,function(item){
					var cacheData=formatCacheKeyArrayData({
						scopes=[cacheProperties.cacheScopes,item],
						types=[cacheProperties.types,item],
						params=[errorStruct.cacheParams,item]
					});
					if( isValid('struct',cacheData)
						&& ( errorStruct.scopeCount==0 || (structKeyExists(cacheData,'scopes') && isValid('numeric',cacheData.scopes) && cacheData.scopes>0) )
						&& ( errorStruct.typeCount==0 || (structKeyExists(cacheData,'types') && isValid('numeric',cacheData.types) && cacheData.types>0) )
						&& ( errorStruct.paramCount==0 || (structKeyExists(cacheData,'params') && isValid('numeric',cacheData.params) && cacheData.params>=errorStruct.paramCount) )
					){
						cacheData['cacheName']=UCase(item);
						cacheRemove(UCase(item),false,returnCacheRegion(this.getsharedCache()));
						ArrayAppend(flushedItems,UCase(item));
					}
					cacheDataStruct[item]=cacheData;
				});
			}
			errorStruct['cacheData']=cacheDataStruct;
			errorStruct['flushed']=flushedItems;
			errorStruct['logType']="information";
		} catch( any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getDefaultLog(),
				functName=this.getcaller()&".clearCaches()",
				logType=errorStruct.logType,
				args=errorStruct
			);
		}
		return errorStruct.flushed;
	}

	/**
	* @name:	mergeCacheTypes()
	* @package: models.base.coursePlusObject
	* @hint:	I merge a structure of cacheTypes into an array
	* @date:	Monday, 08/22/2016 08:21:22 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function mergeCacheTypes( Struct g={} ){
		var types=[];
		var cts=[];
		if( structKeyExists(this,'getCacheTypes') && isValid('struct',this.getcacheTypes()) ){
			cts=this.getcacheTypes();
		}

		if( StructCount(arguments.g) ){
			cts=g;
		}
		cts.map(function(k,v){
			if( isValid('struct',v) ){
				v.map(function(sk,sv){
					ArrayAppend(types,sv,true);
				});
			} else if( isValid('array',v) ){
				ArrayAppend(types,v,true);
			} else {
				ArrayAppend(types,v);
			}
		});
		return types;
	}

	/**
	* @name:	formatParams()
	* @package: models.base.coursePlusObject
	* @hint:	I formate parameter aliases and add them to the array of strings to search for in a cache key
	* @date:	Monday, 08/22/2016 08:21:22 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function formatParams(
		required Array i,
		required Struct p
	){
		var args=arguments;
		var a=[];
		var aliasData={
			'coID':['courseOfferingID'],
			'courseOfferingID':['coID']
		};
		if( structKeyExists(this,'getparamAliases') && !(isNull(this.getparamAliases())) && isValid('struct',this.getparamAliases()) ){
			aliasData=this.getparamAliases();
		}
		var aliasKeys=[];
		if( !(isValid('struct',aliasData)) ){
			aliasKeys=StructKeyArray( aliasData );
		}
		ArrayEach(args.i,function(v,k){
			if( structKeyExists(args.p,v)
				&& Len(Trim(args.p[v]))
				&& args.p[v]!=0
				&& args.p[v]!=false
			){
				ArrayAppend(a,'-' & UCase(v) & '|' & UCase(args.p[v]));
			}
			if( isValid('struct',aliasData)
				&& isValid('array',aliasKeys)
				&& ArrayFindNoCase(aliasKeys,v)
				&& isValid('array',aliasData[v])
			){
				var aliasArray=aliasData[v];
				ArrayEach(aliasArray,function(aliasItem){
					if( !(ArrayFindNoCase(a,'-' & UCase(aliasItem) & '|' & UCase(args.p[v]))) ){
						ArrayAppend(a,'-' & UCase(aliasItem) & '|' & UCase(args.p[v]));
					}
				});
			}
		});
		return a;
	}

	/**
	 * @name:	configureParamAliases()
	 * @package: models.base.coursePlusObject
	 * @hint:	I return the cache param aliases for a module or component in a structure of arrays
	 * @returns:	Struct
	 * @date:	Monday, 05/22/2017 09:04:49 AM
	 * @author:	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Struct function configureParamAliases( Struct aliases={} ){
		var paramAliases={};
		paramAliases['courseOfferingID']=['coID','offeringID'];
		paramAliases['coID']=['courseOfferingID','offeringID'];
		paramAliases['courseID']=['cID'];
		paramAliases['cID']=['courseID'];
		if( structCount(arguments.aliases) ){
			StructEach(arguments.aliases,function(key,value){
				var aliasData=[];
				if( isValid('array',value) ){
					if( structKeyExists(paramAliases,key) ){
						ArrayAppend(aliasData,value,true);
					} else {
						aliasData=value;
					}
				}
				if( isValid('array',aliasData) ){
					paramAliases[key]=aliasData;
				}
			});
		}
		return paramAliases;
	}

	/* object manipulation methods */

	/**
	 * @name:		toNativeFormat()
	 * @package: models.base.coursePlusObject
	 * @hint:		I convert runtime custom objects to native formats (Array,Struct,String (JSON)) using JSON serialization
	 * @returns:	Any
	 * @date:		Wednesday, 08/30/2017 07:41:27 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Any function toNativeFormat(
		String format='struct',
		Struct model={},
		Any obj
	){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'params':arguments.filter(function(key,value){
				return (!isNull(value) && filterIsBasic(key,value));
			}),
			'raw':{},
			'serialized':Replace(Trim(SerializeJSON({})),'//','','ONE'),
			'deserialized':{},
			'nativeFormat':{},
			'result':(
				LCase(Trim(arguments.format))=='array'
			)?[]:(
				LCase(Trim(arguments.format))=='json' || LCase(Trim(arguments.format))=='string'
			)?Replace(Trim(SerializeJSON({})),'//','','ONE'):{}
		};
		try{
			errorStruct['raw']=(!structKeyExists(arguments,'obj'))?{}:(isSimpleValue(arguments.obj))?{'obj':arguments.obj}:arguments.obj;
			errorStruct['serialized']=Replace(Trim(SerializeJSON(arguments.obj)),'//','','ONE');
			if( isJSON(errorStruct.serialized) ){
				if( isSimpleValue(errorStruct.result) ){
					errorStruct.result=errorStruct.serialized;
				} else {
					errorStruct['deserialized']=DeserializeJSON(errorStruct.serialized);
					if( isValid('struct',errorStruct.deserialized) ){
						if( StructCount(arguments.model) ){
							var objKeys=StructKeyArray(errorStruct.deserialized);
							errorStruct['nativeFormat']=arguments.model.map(function(key,value){
								var keyPos=ArrayFindNoCase(objKeys,key);
								if( keyPos ){
									var keyRef=objKeys[keyPos];
									return errorStruct.deserialized[keyRef];
								} else {
									return value;
								}
							});
						} else {
							errorStruct['nativeFormat']=errorStruct['deserialized'];
						}
					}
					if( arguments.format=='array' ){
						errorStruct.result=StructToArray(s=errorStruct.nativeFormat);
					} else {
						errorStruct.result=errorStruct.nativeFormat;
					}
				}
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".toNativeFormat()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name:		getObjectAsStructure()
	 * @package: models.base.coursePlusObject
	 * @hint:		I return this object as a structure
	 * @returns:	Struct
	 * @date:		Thursday, 06/15/2017 12:47:29 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Struct function getObjectAsStructure(
		Array includeParents,
		Numeric currentLevel,
		Array extendedInclusions,
		Boolean throwOnError
	){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{},
			'persistArgs':{
				'includeParents':( StructKeyExists(arguments,'includeParents') )?arguments.includeParents:[],
				'currentLevel':( StructKeyExists(arguments,'currentLevel') && arguments.currentLevel>0 )?arguments.currentLevel:1,
				'extendedInclusions':this.getextendedInclusions(),
				'defineableProperties':{},
				'throwOnError':(structKeyExists(arguments,'throwOnError') && !this.getdebugMode())?arguments.throwOnError:(this.getdebugMode())?true:false
			},
			'metaData':GetMetaData(this),
			'allParents':( StructKeyExists(arguments,'includeParents') && ArrayLen(arguments.includeParents) )?false:true,
			'totalExtendedInclusions':( StructKeyExists(arguments,'extendedInclusions') )?ArrayLen(arguments.extendedInclusions):0,
			'currentLevel':( StructKeyExists(arguments,'currentLevel') && arguments.currentLevel>0 )?arguments.currentLevel:1
		};
		try{
			if( errorStruct.totalExtendedInclusions ){
				var existingInclusions=errorStruct.persistArgs.extendedInclusions;
				ArrayAppend(
					errorStruct.persistArgs.extendedInclusions,
					ArrayFilter(arguments.extendedInclusions,function(item){
						return ( ArrayFindNoCase(existingInclusions,item) )?false:true;
					}),
					true
				);
			}

			if( !errorStruct.allParents
				&& !ArrayFindNoCase(errorStruct.persistArgs['includeParents'],errorStruct.metaData['FULLNAME'])
			){
				ArrayAppend(errorStruct.persistArgs.includeParents,errorStruct.metaData.FULLNAME);
			}
			var metaAttrs=errorStruct.persistArgs;
			metaAttrs['metaData']=errorStruct.metaData;

			errorStruct.persistArgs['defineableProperties']=aggregateDefineableProperties(argumentCollection=metaAttrs);
			if( StructCount(errorStruct.persistArgs.defineableProperties) ){
				errorStruct.persistArgs.defineableProperties.each(function(key,value){
					var propAttrs=errorStruct.persistArgs;
					var structData={};
					propAttrs['key']=key;
					propAttrs['value']=value.DEFAULT;
					propAttrs['currentLevel']=propAttrs.currentLevel+1;
					structData.propVal=propertyCallback(argumentCollection=propAttrs);
					if( StructKeyExists(structData,'propVal') && !isNull(structData.propVal) ){
						errorStruct.result[key]=structData.propVal;
					}
				});
			}

			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".getObjectAsStructure()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name:		aggregateDefineableProperties()
	 * @package: models.base.coursePlusObject
	 * @hint:		I return a structure of all defineable properties for this object
	 * @returns:	Struct
	 * @date:		Thursday, 06/15/2017 01:00:14 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Struct function aggregateDefineableProperties(
		Struct metaData={},
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Struct defineableProperties={},
		Array definedKeys,
		Boolean throwOnError=true
	){
		var errorStruct={
			'result':{},
			'persistArgs':{
				'includeParents':arguments.includeParents,
				'currentLevel':arguments.currentLevel,
				'extendedInclusions':arguments.extendedInclusions,
				'definedKeys':StructKeyArray(arguments.defineableProperties),
				'throwOnError':(this.getdebugMode())?true:arguments.throwOnError
			},
			'defineableProperties':arguments.defineableProperties,
			'propStruct':{},
			'allParents':( ArrayLen(arguments.includeParents) )?false:true,
			'metaData':arguments.metaData.filter(function(key,value){
				var remove=['AUTHOR','CREATED','DISPLAYNAME','FUNCTIONS','HINT','MODIFIED','OUTPUT','PATH'];
				return (ArrayFindNoCase(remove,key) || ArrayFindNoCase(remove,key&':'))?false:true;
			})
		};

		//handle local properties
		if( StructKeyExists(errorStruct.metaData,'PROPERTIES')
			&& isValid('array',errorStruct.metaData['PROPERTIES'])
			&& StructKeyExists(errorStruct.metaData,'FULLNAME')
		){
			//arguments for properties array->struct conversion
			var toStructData=errorStruct.persistArgs;
			toStructData['metaProps']=errorStruct.metaData.PROPERTIES;
			toStructData['objectName']=errorStruct.metaData.FULLNAME;
			toStructData['accessors']=( StructKeyExists(errorStruct.metaData,'ACCESSORS') && isValid('boolean',errorStruct.metaData['ACCESSORS']) )?errorStruct.metaData.ACCESSORS:false;
			//toStructData['definedKeys']=StructKeyArray(errorStruct.defineableProperties);
			//reset properties value with structure instead of array before proceeding

			//arguments for filtered properties import
			var metaPersist=errorStruct.persistArgs;
			metaPersist['propertyData']=errorStruct.metaData;
			metaPersist['propertyData']['PROPERTIES']=propertyMetaDataToStruct(
				argumentCollection=toStructData//arguments for array->struct conversion
			);
			StructAppend( errorStruct.defineableProperties,filterProperties(
				argumentCollection=metaPersist//arguments for filtered properties import
			),true );
		}

		//aggregate extended properties
		if( StructKeyExists(errorStruct.metaData,'EXTENDS')
			&& isValid('struct',errorStruct.metaData.EXTENDS)
			&& structKeyExists(errorStruct.metaData.EXTENDS,'FULLNAME')
		){
			var extendPersist=errorStruct.persistArgs;
			extendPersist['metaData']=errorStruct.metaData.EXTENDS;
			extendPersist['currentLevel']=arguments.currentLevel-1;
			extendPersist['defineableProperties']=errorStruct.defineableProperties;
			StructAppend( errorStruct.defineableProperties,aggregateDefineableProperties( argumentCollection=extendPersist ),false );
		}
		errorStruct['result']=errorStruct['defineableProperties'];
		return errorStruct.result;
	}

	/**
	 * @name:		filterProperties()
	 * @package: models.base.coursePlusObject
	 * @hint:		I will filter out unwanted and undefineable properties
	 * @returns:	Struct
	 * @date:		Thursday, 06/15/2017 01:08:36 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Struct function filterProperties(
		required Struct propertyData,
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Array definedKeys=[],
		Boolean throwOnError=true
	){
		var errorStruct={
			'propertyData':arguments.propertyData,
			'persistArgs':{
				'includeParents':arguments.includeParents,
				'currentLevel':arguments.currentLevel,
				'extendedInclusions':arguments.extendedInclusions,
				'definedKeys':arguments.definedKeys,
				'throwOnError':(this.getdebugMode())?true:arguments.throwOnError
			},
			'validationData':{}
		};
		return arguments.propertyData['PROPERTIES'].filter(function(key,value){
			var hasGetter=false;
			var isValidProperty=false;
			var validateProps=errorStruct.persistArgs;

			//first, lets find out if we can get and set a value for this property
			if(isValid('struct',value) ){
				if( structKeyExists(value,'GETTER')
					&& isValid('boolean',value['GETTER'])
					&& value['GETTER']
				){
					hasGetter=true;
				} else if ( structKeyExists(errorStruct.propertyData,'ACCESSORS')
					&& isValid('boolean',errorStruct.propertyData['ACCESSORS'])
					&& errorStruct.propertyData['ACCESSORS']
				){
					hasGetter=true;
				} else if ( StructKeyExists(this,'get'&value['NAME']) ){
					hasGetter=true;
				}
			}

			//if we can, lets find out if we should include it in the result
			if( hasGetter ){
				validateProps['propertyName']=key;
				validateProps['objectName']=errorStruct.propertyData['FULLNAME'];
				isValidProperty=validateProperty(argumentCollection=validateProps);
			}

			//if it should be included, return true. otherwise, return false
			if( isValidProperty ){
				return true;
			} else {
				return false;
			}
		});
	}

	/**
	 * @name:		validateProperty()
	 * @package: models.base.coursePlusObject
	 * @hint:		I validate whether or not a property should be added to a requested object structure
	 * @returns:	Boolean
	 * @date:		Thursday, 06/15/2017 02:16:46 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Boolean function validateProperty(
		required String propertyName,
		required String objectName,
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Array definedKeys=[],
		Boolean throwOnError=true
	){
		var errorStruct={
			'result':false,
			'propertyName':arguments.propertyName,
			'objectName':arguments.objectName,
			'persistArgs':{
				'includeParents':arguments.includeParents,
				'currentLevel':arguments.currentLevel,
				'extendedInclusions':arguments.extendedInclusions,
				'definedKeys':arguments.definedKeys,
				'throwOnError':(this.getdebugMode())?true:arguments.throwOnError
			},
			'allParents':( ArrayLen(arguments.includeParents) )?false:true
		};
		if( !ArrayFindNoCase(errorStruct.persistArgs.definedKeys,errorStruct.propertyName) ){
			if( errorStruct.allParents ){
				errorStruct['result']=true;
			} else if( ArrayFindNoCase(errorStruct.persistArgs.includeParents,errorStruct.objectName) ){
				errorStruct['result']=true;
			} else if( ArrayFindNoCase(errorStruct.persistArgs.extendedInclusions,errorStruct.propertyName) ){
				errorStruct['result']=true;
			}
		}
		return errorStruct.result;
	}

	/**
	 * @name:		propertyCallback()
	 * @package: models.base.coursePlusObject
	 * @hint:		I handle setting a property
	 * @returns:	Any
	 * @date:		Thursday, 06/15/2017 02:01:23 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Any function propertyCallback(
		required String key,
		required Any value,
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Array definedKeys=[],
		Boolean throwOnError=true
	){
		var errorStruct={
			'persistArgs':{
				'includeParents':arguments.includeParents,
				'currentLevel':arguments.currentLevel,
				'extendedInclusions':arguments.extendedInclusions,
				'definedKeys':[],
				'throwOnError':(this.getdebugMode())?true:arguments.throwOnError
			},
			'allParents':( ArrayLen(arguments.includeParents) )?false:true
		};
		if( structKeyExists(this,'get'&arguments.key) ){
			try{
				errorStruct['processing']=Evaluate('this.get'&key&'()');
			} catch(any k){ }
		} else {
			errorStruct['processing']=arguments.value;
		}
		if( structKeyExists(errorStruct,'processing') ){
			if( isInstanceOf(errorStruct.processing,'models.base.coursePlusObject')
				|| isInstanceOf(errorStruct.processing,'WEB-INF.cftags.component')
			){
				var cpAttrs=errorStruct.persistArgs;
				cpAttrs['obj']=errorStruct.processing;
				cpAttrs['currentLevel']=cpAttrs.currentLevel+1;
				var processingMetaName=GetMetaData(errorStruct.processing).FULLNAME;
				if( !errorStruct.allParents && !ArrayFindNoCase(cpAttrs.includeParents,processingMetaName) ){
					ArrayAppend(cpAttrs.includeParents,processingMetaName);
				}
				errorStruct['result']=importObject(argumentCollection=cpAttrs);
			} else if( isValid('array',errorStruct.processing) || isValid('query',errorStruct.processing) || isValid('struct',errorStruct.processing) ){
				var cmplxAttrs=errorStruct.persistArgs;
				cmplxAttrs['currentLevel']=cmplxAttrs.currentLevel+1;
				cmplxAttrs['complexProperty']=errorStruct.processing;
				errorStruct['result']=importComplexProperty(argumentCollection=cmplxAttrs);
			} else if( isSimpleValue(errorStruct.processing) ){
				errorStruct['result']=errorStruct.processing;
			}
		}
		if( structKeyExists(errorStruct,'result') ){
			return errorStruct.result;
		} else {
			return;
		}
	}

	/**
	 * @name: importComplexProperty()
	 * @package: models.base.coursePlusObject
	 * @hint: Handles complex properties.
	 * @returns: Any
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @date: Wednesday, 07/06/2016 02:57:25 PM
	 */
	private Any function importComplexProperty(
		Any complexProperty,
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Array definedKeys=[],
		Boolean throwOnError=true
	){
	 	var errorStruct={
	 		'result':(
	 			isValid('array',arguments.complexProperty)
	 			|| isValid('query',arguments.complexProperty)
	 		)?[]:{},
			'persistArgs':{
				'includeParents':arguments.includeParents,
				'currentLevel':arguments.currentLevel,
				'extendedInclusions':arguments.extendedInclusions,
				'definedKeys':[],
				'throwOnError':(this.getdebugMode())?true:arguments.throwOnError
			}
	 	};
		if( isValid('struct',arguments.complexProperty) ){
			StructEach(arguments.complexProperty,function(key,value){
				var propAttrs=errorStruct.persistArgs;
				var structData={};
				propAttrs['key']=key;
				propAttrs['value']=value;
				propAttrs['currentLevel']=propAttrs.currentLevel+1;
				structData.propVal=propertyCallback(argumentCollection=propAttrs);
				if( StructKeyExists(structData,'propVal') && !isNull(structData.propVal) ){
					errorStruct.result[key]=structData.propVal;
				}
			});
		} else if( isValid('array',arguments.complexProperty)
			|| isValid('query',arguments.complexProperty)
		){
			//translate queries to arrays before handling
			if( isValid('query',arguments.complexProperty) ){
				var qryArray=QueryToArray(qry=arguments.complexProperty);
				arguments.complexProperty=qryArray;
			}
			ArrayEach(arguments.complexProperty,function(item,idx){
				var propAttrs=errorStruct.persistArgs;
				var arrayData={};
				propAttrs['key']=idx;
				propAttrs['value']=item;
				propAttrs['currentLevel']=propAttrs.currentLevel+1;
				arrayData.propVal=propertyCallback(argumentCollection=propAttrs);
				if( StructKeyExists(arrayData,'propVal') && !isNull(arrayData.propVal) ){
					ArrayAppend(errorStruct.result,arrayData.propVal);
				}
			});
		}
		return errorStruct.result;
	}

	/**
	 * @name:		xmlObjectToStruct()
	 * @package: models.base.coursePlusObject
	 * @hint:		I return an xmlObject as a structure
	 * @returns:	Struct
	 * @date:		Saturday, 07/15/2017 12:11:57 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Struct function xmlObjectToStruct(
		required xml xmlObject,
		Struct blueprints=this.getblueprints()
	){
		var xmlRoot=XmlParse(arguments.xmlObject).xmlRoot;
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'model':(
				StructKeyExists(arguments,'blueprints')
				&& StructCount(arguments.blueprints)
				&& structKeyExists(arguments.blueprints,xmlRoot.XmlName)
			)?arguments.blueprints[xmlRoot.XmlName]:xmlRoot.XmlAttributes,
			'result':{},
			'blueprints':( StructKeyExists(arguments,'blueprints') )?arguments.blueprints:{},
			'xmlNode':xmlRoot,
			'xmlAttributes':(isValid('struct',xmlRoot.XmlAttributes))?xmlRoot.XmlAttributes:{},//root attributes
			'xmlChildren':(isValid('array',xmlRoot.XmlChildren))?xmlRoot.XmlChildren:[],//root children,
			'children':[],
			'propKeys':[],
			'modelKeys':[]
		};
		errorStruct.totalChildren=ArrayLen(errorStruct.children);
		try{
			errorStruct['propKeys']=StructKeyArray(errorStruct.xmlAttributes);
			errorStruct['modelKeys']=StructKeyArray(errorStruct.blueprints);
			errorStruct.model.each(function(key,value){
				var foundPropKey=ArrayFindNoCase(errorStruct.propKeys,key);
				var foundModelKey=ArrayFindNoCase(errorStruct.modelKeys,key);

				if( foundPropKey ){
					//this injects the xml attribute value
					var propKeyRef=errorStruct.propKeys[foundPropKey];
					if( !isNull(errorStruct.xmlAttributes[propKeyRef]) ){
						errorStruct.result[key]=errorStruct.xmlAttributes[propKeyRef];
					}
				} else if( foundModelKey && !isValid('array',value) ){
					//this injects another struct if it exists in the blueprints
					var modelKeyRef=errorStruct.modelKeys[foundModelKey];
					if( !isNull(errorStruct.blueprints[modelKeyRef]) && isValid('struct',errorStruct.blueprints[modelKeyRef]) ){
						errorStruct.result[key]=errorStruct.blueprints[modelKeyRef];
					}
				} else {
					//default is to leave the object property default value
					errorStruct.result[key]=value;
				}
			});
			errorStruct.xmlChildren.each(function(childNode){
				//find the pluralName
				var pluralName=(
					ArrayFindNoCase(StructKeyArray(errorStruct.blueprints),childNode.XmlName)
					&& ArrayFindNoCase(StructKeyArray(errorStruct.blueprints[childNode.XmlName]),'plural')
				)?errorStruct.blueprints[childNode.XmlName].plural:childNode.XmlName;
				var foundModelKey=ArrayFindNoCase(errorStruct.modelKeys,childNode.XmlName);
				if( foundModelKey ){
					var modelKeyRef=errorStruct.modelKeys[foundModelKey];
					if( Len(Trim(pluralName)) && StructKeyExists(errorStruct.blueprints,modelKeyRef)){
						if(!structKeyExists(errorStruct.result,pluralName) || !isValid('array',errorStruct.result[pluralName]) ){
							errorStruct.result[pluralName]=[];
						}
						if( !isNull(errorStruct.blueprints[modelKeyRef])
							&& isValid('struct',errorStruct.blueprints[modelKeyRef])
						){
							ArrayAppend(
								errorStruct.result[pluralName],
								xmlObjectToStruct( xmlObject=childNode )
							);
						}
					}
				}
			});
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".xmlObjectToStruct()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	private String function findPluralName(
		required String name,
		Boolean hasPlural=false
	){
		var nodeName=Trim(arguments.name);
		var pluralNodeName=nodeName;
		if( !arguments.hasPlural && Len(nodeName) ){
			if( right(nodeName,1)=='y' ){
				pluralNodeName=Left(nodeName,Len(nodeName)-1)&'ies';
			} else if( right(nodeName,1)=='s' ){
				pluralNodeName=( right(nodeName,2)=='es' )?nodeName:nodeName&'es';
			} else {
				pluralNodeName=nodeName&'s';
			}
		}
		return pluralNodeName;
	}

	/**
	 * @name:		importObject()
	 * @package: models.base.coursePlusObject
	 * @hint:		I handle importing an object as a structure into another object
	 * @returns:	Struct
	 * @date:		Thursday, 06/15/2017 05:54:40 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Struct function importObject(
		required Any obj,
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Array definedKeys=[],
		Boolean throwOnError=true
	){
		var errorStruct={
			'result':{},
			'persistArgs':{
				'includeParents':arguments.includeParents,
				'currentLevel':arguments.currentLevel,
				'extendedInclusions':arguments.extendedInclusions,
				'definedKeys':[],
				'throwOnError':(this.getdebugMode())?true:arguments.throwOnError
			}
		};
		if( isInstanceOf(arguments.obj,'models.base.coursePlusObject') ){
			errorStruct['result']=arguments.obj.getObjectAsStructure(argumentCollection=errorStruct.persistArgs);
		} else if( isInstanceOf(arguments.obj,'WEB-INF.cftags.component') ){
			try{
				errorStruct['result']=arguments.obj.getSnapshot(argumentCollection=errorStruct.persistArgs);
			} catch( Any sn ){
				try{
					errorStruct['result']=arguments.obj.toStruct(argumentCollection=errorStruct.persistArgs);
				} catch( Any ts ){ }
			}
		}
		return errorStruct.result;
	}

	/**
	 * @name:		getSnapShot()
	 * @package: models.base.coursePlusObject
	 * @hint:		Alias for getObjectAsStructure
	 * @returns:	Struct
	 * @date:		Sunday, 06/18/2017 06:53:44 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Struct function getSnapShot(
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Boolean throwOnError=true
	){
		return getObjectAsStructure(argumentCollection=arguments);
	}

	/**
	 * @name:		toStruct()
	 * @package: models.base.coursePlusObject
	 * @hint:		Alias for getObjectAsStructure
	 * @returns:	Struct
	 * @date:		Sunday, 06/18/2017 06:53:48 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Struct function toStruct(
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Boolean throwOnError=true
	){
		return getObjectAsStructure(argumentCollection=arguments);
	}

	/**
	 * @name:		propertyMetaDataToStruct()
	 * @package: models.base.coursePlusObject
	 * @hint:		I convert an array of property meta data into a structure and add a default value if it is not defined
	 * @returns:	Struct
	 * @date:		Thursday, 06/15/2017 05:54:40 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Struct function propertyMetaDataToStruct(
		required Array metaProps,
		required String objectName,
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=[],
		Array definedKeys=[],
		Boolean accessors=false,
		Boolean throwOnError=true
	){
		var errorStruct={
			'result':{},
			'metaProps':arguments.metaProps,
			'accessors':arguments.accessors,
			'persistArgs':{
				'includeParents':arguments.includeParents,
				'currentLevel':arguments.currentLevel-1,
				'extendedInclusions':arguments.extendedInclusions,
				'definedKeys':arguments.definedKeys,
				'throwOnError':(this.getdebugMode())?true:arguments.throwOnError
			},
			'foundInParents':(ArrayLen(arguments.includeParents) && ArrayFindNoCase(arguments.includeParents,arguments.objectName))?true:false,
			'allParents':(ArrayLen(arguments.includeParents))?false:true,
			'totalKeys':ArrayLen(arguments.definedKeys)
		};
		/*
		createLog(
			logName=this.getdefaultLog(),
			logType='warning',
			functName=this.getcaller()&".propertyMetaDataToStruct()",
			args=errorStruct
		);
		*/
		var existingKeys=errorStruct.persistArgs.definedKeys;
		var exceptionKeys=errorStruct.persistArgs.extendedInclusions;
		ArrayEach(errorStruct.metaProps,function(prop){
			if( isValid('struct',prop) && structKeyExists(prop,'NAME') ){
				var isFound=true;
				var propertyName=prop['NAME'];
				if( errorStruct.allParents
					|| errorStruct.foundInParents
					|| ArrayFindNoCase(exceptionKeys,propertyName)
				){
					if( !errorStruct.totalKeys ){
						isFound=false;
					} else if( errorStruct.totalKeys && ArrayFindNoCase( existingKeys,propertyName )==0 ){
						isFound=false;
					}
					if( isFound==false ){
						var structProperty={
							'getter':( structKeyExists(prop,'GETTER') && isValid('boolean',prop['GETTER']) )?prop['GETTER']:errorStruct.accessors,
							'setter':( structKeyExists(prop,'SETTER') && isValid('boolean',prop['SETTER']) )?prop['SETTER']:errorStruct.accessors,
							'type':( structKeyExists(prop,'TYPE') )?LCase(prop['TYPE']):false,
							'default':(
								structKeyExists(prop,'DEFAULT')
							)?prop['DEFAULT']:(
								structKeyExists(prop,'TYPE')
							)?returnTypeDefault(prop['TYPE']):returnNull()
						};
						if( structKeyExists(structProperty,'default') && !isNull(structProperty['default']) ){
							errorStruct.result[propertyName]=structProperty;
						}
					}
				}
			}
		});
		return errorStruct.result;
	}

	/* other object manipulation tools */

	/**
	 * @name:		returnNull()
	 * @package: models.base.coursePlusObject
	 * @hint:		I return a null value
	 * @returns:	Null
	 * @date:		Thursday, 06/15/2017 01:55:22 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	 private Any function returnNull(){
	 	return;
	 }

	/**
	 * @name:		returnTypeDefault()
	 * @package: models.base.coursePlusObject
	 * @hint:		I return the default value an object type
	 * @returns:	Any
	 * @date:		Thursday, 06/15/2017 01:55:22 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Any function returnTypeDefault(
		required String type
	){
		var response={};

		if( existsInPackages(objectClass=arguments['type']) ){
			response['result']=Evaluate('CreateObject("component","'&Trim(arguments['type'])&'").init()');
		} else {
			switch( LCase(Trim(arguments['type'])) ){
				case 'struct':
				case 'structure':
				case 'coldfusion.runtime.Struct':
					response['result']={};
				break;
				case 'array':
				case 'query':
				case 'coldfusion.runtime.Array':
					response['result']=[];
				break;
				case 'numeric':
				case 'int':
				case 'integer':
				case 'java.lang.Double':
					response['result']=0;
				break;
				case 'boolean':
				case 'java.lang.Boolean':
					response['result']=false;
				break;
				case 'date':
				case 'time':
				case 'coldfusion.runtime.OleDateTime':
					response['result']=this.getdefaultDate();
				break;
				case 'any':
				case 'string':
				case 'java.lang.String':
					response['result']='';
				break;
			}
		}
		if( structKeyExists(response,'result') && !isNull(response['result']) ){
			return response['result'];
		} else {
			return;
		}
	}

	/**
	 * @name:		existsInPackages()
	 * @package: models.base.coursePlusObject
	 * @hint:		I confirm whether an object belongs to an array of libraries
	 * @returns:	Struct
	 * @date:		Thursday, 06/15/2017 05:54:40 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Boolean function existsInPackages(
		required String objectClass,
		Array packages=['core','com','myCourses','help']
	){
		var objectName=arguments.objectClass;
		var result=arguments.packages.filter(function(package){
			return (FindNoCase(package,objectName)==1);
		});
		return ( ArrayLen(result) )?true:false;
	}

	/**
	* @name:	queryFromArrayOfComplexObjects()
	* @package: models.base.coursePlusObject
	* @hint:	I create a query from an array of structs or objects
	* @returns:	Query
	* @date:	Sunday, 11/27/2016 09:37:36 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Query function queryFromArrayOfComplexObjects(
		required Array objects
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':QueryNew(''),
			'keys':[],
			'processed':[]
		};
		try{
			if( ArrayLen(arguments.objects) ){
				errorStruct['processed']=arguments.objects.map(function(item){
					if( isValid('struct',item) ){
						return item;
					} else {
						return importObject(item);
					}
				});
				if( ArrayLen(errorStruct.processed) ){
					if( isValid('struct',errorStruct.processed[1]) ){
						errorStruct['keys']=StructKeyArray(errorStruct.processed[1]);
						errorStruct['result']=QueryNew(ArrayToList(errorStruct.keys));
						ArrayEach(errorStruct.processed,function(item){
							var row=QueryAddRow(errorStruct.result);
							ArrayEach(errorStruct.keys,function(key){
								if( structKeyExists(item,key) ){
									if( IsSimpleValue( item[key] ) ){
										var col=QuerySetCell(errorStruct.result,key,item[key]);
									}
								}
							});
						});
					}
				}
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".queryFromArrayOfComplexObjects()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	QueryToArray()
	* @package: models.base.coursePlusObject
	* @hint:	I convert queries to arrays of structures
	* @returns: Array
	* @date:	Monday, 08/22/2016 08:23:54 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	* @args:	qry=new Query(), rowRange=[min,max]
	*/
	public Array function QueryToArray(
		required Query qry,
		Array rowRange
	){
		var errorStruct={
			'result':[],
			'processing':[],
			'stackTrace':getstackTrace(),
			'start':Now(),
			'logType':'warning',
			'totalItems':0,
			'startOn':( StructKeyExists(arguments,'rowRange')
				&& ArrayLen(arguments.rowRange)
				&& isValid('numeric',arguments.rowRange[1])
			)?arguments.rowRange[1]:1,
			'endOn':( StructKeyExists(arguments,'rowRange')
				&& ArrayLen(arguments.rowRange)>1
				&& isValid('numeric',arguments.rowRange[2])
				&& arguments.rowRange[2]>=arguments.rowRange[1]
			)?arguments.rowRange[2]:0
		};
		var rowData={};
		try{
			var cols=arguments.qry.getMetaData().getColumnLabels();
			//row loop
			for( var row in arguments.qry ){
				rowData={};
				//col loop
				for( var col in cols ){
					rowData[col]=row[col];
				}
				ArrayAppend(errorStruct.processing,rowData);
			}

			//count array - can not assume a recordCount is defined (they're not in QoQ's, for example)
			errorStruct['totalItems']=ArrayLen(errorStruct.processing);

			//if there are no items, return the default empty array and skip the rest
			if( errorStruct.totalItems ){
				//if no endOn was defined, use the array length
				if( errorStruct.endOn==0 ){
					errorStruct['endOn']=errorStruct.totalItems;
				}
				if( errorStruct.endOn-errorStruct.startOn==errorStruct.totalItems || !errorStruct.totalItems ){
					//time-saver: filter for the range if startOn is not 0 OR endOn is not the array length
					errorStruct['result']=errorStruct.processing;
				} else {
					//otherwise, filter the
					errorStruct['result']=ArrayFilter(errorStruct.processing,function(item,idx){
						return ( idx<=errorStruct.endOn && idx>=errorStruct.startOn );
					});
				}
			}
			errorStruct['logType']='information';
		} catch (Any e){
			errorStruct['logType']='error';
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				args=errorStruct,
				functName=this.getcaller()&'.QueryToArray()'
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	reverseStruct()
	* @package: models.base.coursePlusObject
	* @hint:	I reverse a struct so that its values become its keys and its keys become its values. It will omit complex values.
	* @returns:	Struct
	* @date:	Sunday, 05/21/2017 10:38:44 PM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function reverseStruct( required Struct structObj ){
		var result={};
		arguments.structObj.each(function(key,value){
			if( isSimpleValue(value) && !(structKeyExists(result,value)) ){
				result[value]=key;
			}
		});
		return result;
	}

	/**
	* @name:	findArrayItemsInString()
	* @package: models.base.coursePlusObject
	* @hint:	I find array items (string values only) in a string
	* @date:	Monday, 08/22/2016 08:23:54 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Numeric function findArrayItemsInString(required Array arr,required String st){
		var targetString=arguments.st;
		var result=0;
		var filteredItems=ArrayFilter(arguments.arr,function(aItem){
			return ( isSimpleValue(aItem) && FindNoCase(aItem,targetString) );
		});
		if( isValid('array',filteredItems) ){
			result=ArrayLen(filteredItems);
		}
		return result;
	}

	/**
	* @name:	structToArray()
	* @package: models.base.coursePlusObject
	* @hint:	I convert a structure to an array
	* @returns: Array
	* @date:	Wednesday, 05/17/2017 07:37:37 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function structToArray( required Struct s ){
		var a=[];
		s.each(function(key,value){
			if( !isNull(value) ){
				ArrayAppend(a,value);
			}
		});
		return a;
	}

	public any function stringToAscii( String str='' ) {
		var errorStruct={
			'string':arguments.str,
			'cleanedString':Duplicate(arguments.str),
			'logType':"warning"
		};
		try{
			errorStruct['cleanedString']=ReReplaceNoCase(Duplicate(errorStruct.string),'[^\x20-\x7E]','','ALL');
			errorStruct['logType']="information";
		} catch ( any e ) {
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		if( errorStruct.logType!='information' ){
			createLog(
				logName=this.getDefaultLog(),
				functName=this.getcaller()&".stringToAscii()",
				logType=errorStruct.logType,
				args=errorStruct
			);
		}
		return errorStruct.cleanedString;
	};
	/**
	* @name:	structToArray()
	* @package: models.base.coursePlusObject
	* @hint:	I convert an array to a structure
	* @returns: Struct
	* @date:	Wednesday, 05/17/2017 07:37:37 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function arrayToStruct( required Array a ){
		var s={};
		a.each(function(item,idx){
			s[idx]=item;
		});
		return s;
	}
}
