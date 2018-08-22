/**
* @name: jhed
* @package: com.base.distance.
* @hint: I create jhed tools that can be accessed remotely.
* @author: Chris Schroeder (schroeder@jhu.edu)
* @created: Tuesday, 03/01/2016 08:24:54 AM
* @modified: Tuesday, 03/01/2016 08:24:54 AM
*/
component singleton
	output="false"
	displayName="models.base.jhed"
	extends="models.base.dao"
	accessors="true"
	hint="I create jhed tools that can be accessed remotely."
{
	public models.base.jhed function init(
		required String dsn,
		required String defaultLog,
		Boolean debugMode=0,
		Boolean sharedCache=true
	){
		super.configureDAO(argumentCollection=arguments);
		return this;
	}

	/**
	* @name:			jhed.getJhedIDFromStuID(
	*					required Numeric stuID
	*				)
	* @hint:	confirms that the user has a jhedID in the account they logged into in the past
	* @date:			Thursday, 06/30/2016 03:04:24 PM
	*/
	public Boolean function confirmJhed(
		required Numeric stuID,
		required Boolean excludeCTL
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':0,
			'sql':{
				'string':'',
				'prefix':{}
			}
		};
		try{
			var queryService=new Query(
				name='qJhedLookup',
				datasource=this.getdsn()
			);
			savecontent variable="errorStruct.sql.string"{
				WriteOutput('SELECT (CASE
						WHEN LEN(sec.jhedID)>0 THEN 1
						ELSE 0
					END) AS hasJhed,
					sec.defaultUserLevel
					FROM security sec
					JOIN stuInfo s ON s.stuID=sec.stuID
					WHERE sec.stuID=:stuID
					AND s.isDeleted=0');
			}
			queryService.addParam(name='stuID',value=arguments.stuID,cfsqltype='cf_sql_numeric');
			var queryData = queryService.execute(sql=errorStruct.sql.string);
			var result = queryData.getResult();
			errorStruct.sql['prefix'] = queryData.getPrefix();
			if( result.recordCount
				&& (
					result['hasJhed'][1]==1
					|| ( result['defaultUserLevel'][1]<=100 && arguments.excludeCTL )
				)
			){
				errorStruct['result']=1;
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".confirmJhed()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	jhed.getJHEDLoginAttempt
	* @hint:	I return data stored in the db about a JHED login
	* @returns:	Query result
	* @date:	Tuesday, 12/06/2016 08:01:58 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Query function getJHEDLoginAttempt(
		required String tableName=''
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'sql':{
				'string':"",
				'prefix':{}
			}
		};
		var result=QueryNew( 'affiliations,cookies,cn,displayName,eppn,givenName,mail,sn,uid,kid,ts,ubiqtkn,go,eventName,moduleName,eventArgs,courseOfferingID,courseID,offering,hostName' );
		try{
			transaction action="begin" isolation="read_uncommitted" {
				var queryService=new Query(
					name="qgetJHEDLoginAttempt",
					datasource=this.getdsn()
				);
				savecontent variable="errorStruct.sql.string"{
					WriteOutput("
						SELECT affiliations,
							cookies,
							cn,
							displayName,
							eppn,
							givenName,
							mail,
							sn,
							uid,
							kid,
							ts,
							ubiqtkn,
							go,
							eventName,
							moduleName,
							eventArgs,
							courseOfferingID,
							courseID,
							offering,
							hostName
						FROM dbo.#arguments.tableName#
						WHERE ts BETWEEN DateAdd(ss,-5,getDate()) AND getDate()
						AND Len(givenName)>0
						AND Len(sn)>0
						AND Len(uid)>0
					");
				}
				var queryData=queryService.execute(sql=errorStruct.sql.string);
				errorStruct.sql['prefix']=queryData.getPrefix();
			}
			transaction action="commit";
			if( isValid('struct',errorStruct.sql.prefix)
				&& StructKeyExists(errorStruct.sql.prefix,'RECORDCOUNT')
				&& isValid('numeric',errorStruct.sql.prefix.RECORDCOUNT)
				&& errorStruct.sql.prefix.RECORDCOUNT
			){
				result=queryData.getResult();
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
				functName=this.getcaller()&".getJHEDLoginAttempt()",
				args=errorStruct
			);
		}
		return result;
	}


	/**
	* @name:			jhed.getJhedIDFromStuID(
	*						required Numeric stuID
	*					)
	* @hint:	returns jhedID that matches arguments.stuID or blank if none match
	* @date:			Thursday, 06/30/2016 10:02:49 AM
	*/
	public String function getJhedIDFromStuID(
		required Numeric stuID
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':'',
			'sql':{
				'string':'',
				'prefix':''
			}
		};
		try{
			var queryService=new Query(
				name='qJhedLookup',
				datasource=this.getdsn(),
				cachedwithin=CreateTimeSpan(0,0,5,0)
			);
			savecontent variable="errorStruct.sql.string"{
				WriteOutput('SELECT sec.jhedID
					FROM security sec
					JOIN stuInfo s ON s.stuID=sec.stuID
					WHERE sec.stuID=:stuID
					AND s.isDeleted=0');
			}
			queryService.addParam(name='stuID',value=arguments.stuID,cfsqltype='cf_sql_numeric');
			var queryData = queryService.execute(sql=errorStruct.sql.string);
			var result = queryData.getResult();
			errorStruct.sql['prefix'] = queryData.getPrefix();
			if( result.recordCount ){
				errorStruct['result']=result['jhedID'][1];
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".getJhedIDFromStuID()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:		jhed.getStuIDFromJhedID(
	*					required String jhedID,
	* 					Numeric excludeID=0
	*				)
	* @hint:	returns stuID that matches arguments.jhedID or 0 if none match
	* @date:			Thursday, 06/30/2016 10:02:49 AM
	*/
	public Numeric function getStuIDFromJhedID(
		required String jhedID,
		Numeric excludeID=0
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':0,
			'sql':{
				'string':'',
				'prefix':{}
			}
		};
		try{
			var queryService=new Query(
				name='qJhedLookup',
				datasource=this.getdsn()
			);
			savecontent variable="errorStruct.sql.string"{
				WriteOutput('SELECT sec.stuID
					FROM security sec
					JOIN stuInfo s ON s.stuID=sec.stuID
					WHERE sec.jhedID=:jhedID
					AND s.isDeleted=0
				');
				if( arguments.excludeID ){
					WriteOutput(' AND s.stuID<>:excludeID ');
				}
			}
			queryService.addParam(name='jhedID',value=arguments.jhedID,cfsqltype='cf_sql_varchar');
			queryService.addParam(name='excludeID',value=arguments.excludeID,cfsqltype='cf_sql_numeric');
			var queryData = queryService.execute(sql=errorStruct.sql.string);
			var result = queryData.getResult();
			errorStruct.sql['prefix'] = queryData.getPrefix();
			if( result.recordCount && isValid('numeric',result['stuID'][1]) ){
				errorStruct['result']=result['stuID'][1];
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".getStuIDFromJhedID()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}
}
