/**
* @name: dao
* @package: models.base.
* @hint: dao object that other dao objects extend
* @author: Chris Schroeder (schroeder@jhu.edu)
* @created: Tuesday, 03/01/2016 08:24:54 AM
* @modified: Tuesday, 03/01/2016 08:24:54 AM
*/

component
	displayname="models.base.dao"
	extends="models.base.service"
	output="false"
	accessors="true"
{
	property type="String" name="dsn" getter="true" setter="true";
	property type="String" name="hardcodeDSN" getter="true" setter="false" hint="this dsn value only does reads and caches results";

	/**
	 * @name: configureDAO()
	 * @package: models.base.dao.
	 * @hint: I configure instances of this object
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @copyright: Johns Hopkins University
	 * @date: Saturday, 11/04/2017 10:43:47 AM
	 */
	private Void function configureDAO(
		String defaultLog,
		Boolean debugMode,
		String ctlemail,
		String supportEmail,
		Struct paramAliases,
		String cacheName,
		String cacheRegion,
		Array cacheScopes,
		String caller,
		Struct child
	){
		super.configure(argumentCollection=arguments);
		if( structKeyExists(arguments,'dsn') && Len(Trim(arguments.dsn)) ){
			this.setdsn(arguments.dsn);
		} else {
			throw(
				type="models.base.Missing.DataBaseName",
				message="The dsn argument was not valid.",
				detail="You did not provide a valid dsn, which is required for nearly all of this component's methods",
				extendedInfo=ReplaceNoCase(Trim(SerializeJSON(arguments)),'//','','ONE')
			);
		}
	}

	/**
	 * @name: init()
	 * @package: models.base.dao.
	 * @hint: I initialize a public instance of this object
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @copyright: Johns Hopkins University
	 * @date: Saturday, 11/04/2017 10:43:47 AM
	 */
	public models.base.dao function init(){
		configureDAO(argumentCollection=arguments);
		return this;
	}

	/**
	 * @name: gethardCodeDSN()
	 * @package: models.base.dao.
	 * @hint: I return the hardcoded DSN for this object
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @copyright: Johns Hopkins University
	 * @date: Saturday, 11/04/2017 10:43:47 AM
	 */
	private String function gethardCodeDSN(){
		return 'DE_MyCourses';
	}

	/**
	* @name:	getUser()
	* @package: models.base.dao.
	* @hint:	I read a user from userID and return it as a query. I cache my query for 1 day.
	* @returns:	Query
	* @date:	Wednesday, 05/17/2017 07:57:34 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Query function getUser( required Numeric userID ){
		var errorStruct = {
			'logType':'warning',
			'stackTrace':getStackTrace(),
			'sql':{
				'string':"",
				'prefix':{}
			},
			'start':Now(),
			'result':QueryNew('FirstName,LastName,email,stuID,userID','varchar,varchar,varchar,varchar,varchar')
		};
		try{
			transaction action="begin" isolation="read_uncommitted" {
				savecontent variable="errorStruct.sql.string"{
					WriteOutput('
						SELECT TOP 1 stuID AS userID,stuID,FirstName,LastName,MiddleInit,Address1,Address2,City,State,ZIP,Country,HomePhone,WorkPhone,email,ProgramType,YearStarted,lastEnrollment,defaultUserLevel,yearStartedDate,countryID,stateID,timeZone,lastModified,randomStringID
						FROM StuInfo
						WHERE isDeleted=0
						AND stuID=:userID
					');
				}
				var userQuery = new Query(
					name="qUser",
					datasource=gethardcodeDSN(),
					sql=errorStruct.sql.string,
					cachedwithin=CreateTimeSpan(0,0,0,10)
				);
				userQuery.addParam(name='userID',value=arguments.userID,cfsqltype="NUMERIC");
				var qExecute=userQuery.execute();
				errorStruct['result']=qExecute.getResult();
				errorStruct.sql['prefix'] = qExecute.getPrefix();
			}
			transaction action="commit";
			errorStruct['logType']="information";
		} catch( Any e ){
			transaction action="rollback";
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' ){
			createLog(
				logName=this.getDefaultLog(),
				functName=this.getcaller()&".getUser()",
				logType=errorStruct.logType,
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	getcourseIdFromCourseOfferingId()
	* @package: models.base.dao.
	* @hint:	Returns the courseID for the offering
	* @returns:	A numeric ID for a record
	* @date:	Thursday, 04/13/2017 08:52:43 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Numeric function getcourseIdFromCourseOfferingId(
		required Numeric courseOfferingID
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'sql':{
				'string':"",
				'prefix':{}
			},
			'result':0
		};
		try{
			transaction action="begin" isolation="read_uncommitted" {
				var queryService=new Query(
					name="qgetcourseIdFromCourseOfferingId",
					datasource=gethardcodeDSN()
				);
				savecontent variable="errorStruct.sql.string"{
					WriteOutput('
						SELECT courseID FROM courseOffering WHERE courseOfferingID=:courseOfferingID
					');
				}
				queryService.addParam(name='courseOfferingID',value=arguments.courseOfferingID,cfsqltype='cf_sql_numeric');
				var queryData=queryService.execute(sql=errorStruct.sql.string);
				errorStruct.sql['prefix']=queryData.getPrefix();
				var result=queryData.getResult();
			}
			transaction action="commit";
			if( result.recordCount ){
				errorStruct['result']=result['courseID'][1];
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			transaction action="rollback";
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".getcourseIdFromCourseOfferingId()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	getFormattedUser()
	* @package: models.base.dao.
	* @hint:	I read a user from userID and return it in a number of formats.
	* @returns:	Any
	* @date:	Wednesday, 05/17/2017 07:57:34 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Any function getFormattedUser(
		required Numeric userID,
		String format="query" hint="if this is query, it will return all properties as a query. if numeric, it will return the userID if the user is found. if string, it will return first and last names. if struct, it will return all properties as a structure. if array, it will return all properties as an array."
	){
		var errorStruct={
			'userID':arguments.userID,
			'format':arguments.format,
			'stackTrace':getStackTrace(),
			'logType':"warning",
			'user':{},
			'arrayUsers':[],
			'userKeys':[],
			'result':(
				arguments.format=='user' || FindNoCase('obj',arguments.format) || FindNoCase('component',arguments.format)
			)?CreateObject('component','com.distance.myCourses4.user.user').init(argumentCollection=arguments):(
				FindNoCase('struct',arguments.format)
			)?{}:(
				FindNoCase('arr',arguments.format)
			)?[]:(
				FindNoCase('num',arguments.format)
				|| FindNoCase('id',arguments.format)
				|| FindNoCase('exists',arguments.format)
				|| FindNoCase('boolean',arguments.format)
			)?0:(
				FindNoCase('name',arguments.format)
				|| FindNoCase('string',arguments.format)
			)?'':QueryNew('userID','varchar')
		};
		try{
			var qUser=getUser(arguments.userID);
			if( isValid('query',errorStruct.result) ){
				errorStruct['result']=qUser;
			} else {
					errorStruct['arrayUsers']=QueryToArray(qry=qUser);
					if( ArrayLen(errorStruct.arrayUsers) ){
						errorStruct['user']=errorStruct.arrayUsers[1];
						if( isValid('struct',errorStruct.user) ){
							if( isInstanceOf(errorStruct.result,'com.distance.myCourses4.user.user') ){
								errorStruct.result.init(argumentCollection=errorStruct.user);
							} else if( isValid('struct',errorStruct.result) ){
								errorStruct['result']=errorStruct.user;
							} else if( isValid('numeric',errorStruct.result)
								&& StructKeyExists(errorStruct.user,'userID')
								&& isValid('numeric',errorStruct.user['userID'])
							){
								errorStruct['result']=errorStruct.user['userID'];
							} else if( isValid('array',errorStruct.result) ){
								errorStruct['result']=StructToArray(errorStruct.user);
							} else if( isValid('string',errorStruct.result)
								&& structKeyExists(errorStruct.user,'firstName')
								&& Len(errorStruct.user.firstName)
								&& structKeyExists(errorStruct.user,'lastName')
								&& Len(errorStruct.user.lastName)
							){
								errorStruct['result']=errorStruct.user['lastName']&', '&errorStruct.user['firstName'];
							} else if( arguments.format=='boolean' || arguments.format=='exists' ){
								errorStruct['result']=(
									StructKeyExists(errorStruct.user,'userID')
									&& isValid('numeric',errorStruct.user['userID'])
									&& errorStruct.user['userID']
								)?true:false;
							}
						}
					}
				}
			errorStruct['logType']="information";
		} catch( any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".getFormattedUser()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}
}
