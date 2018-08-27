/**
* @name: JSONParserService
* @package: modules_app.jsonLogReader.models.
* @hint: I am the service component for the JSON Parser Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Thursday, 08/23/2018 07:48:48 AM
* @modified: Thursday, 08/23/2018 07:48:48 AM
*/

component
	displayname="JSONParserService"
	output="false"
	accessors="true"
	extends=models.base.service
{

	/**
	 * @name:		JSONParserService.init
	 * @hint:		I create an instance of this service
	 * @returns:	modules_app.jsonLogReader.models.JSONParserService
	 * @date:		Thursday, 08/23/2018 07:48:48 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public modules_app.jsonLogReader.models.JSONParserService function init(){
		super.configure(argumentCollection=arguments);
		return this;
	}

	/**
	* @name:	JSONParserService.handleLogRow
	* @hint:	I intake a log row and return a struct of error data
	* @returns:	Struct
	* @date:	Wednesday, 10/05/2016 08:10:51 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function handleLogRow(
		String logRow=''
	){
		var errorStruct={
			arguments=arguments,
			logType="warning",
			start=Now(),
			stackTrace=getStackTrace(),
			result={},
			attrs={}
		};
		try{
			errorStruct.attrs=RERowToStruct(arguments.logRow);
			if( isValid('struct',errorStruct.attrs) && structKeyExists(errorStruct.attrs,'message') ){
				errorStruct.result=readJSON(errorStruct.attrs);
			}
			errorStruct.logType="information";
		} catch( Any e ){
			errorStruct.logType="error";
			errorStruct.cfcatch=e;
		}
		errorStruct.end=Now();
		errorStruct.diff=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".handleLogRow()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	JSONParserService.RERowToStruct
	* @hint:	I convert a log row to an array and return the json text
	* @returns:	Array of log elements
	* @date:	Wednesday, 10/05/2016 07:54:16 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function RERowToStruct(
		String logRow=''
	){
		var errorStruct={
			logType="warning",
			patternMatch=',(?=(?:[^"]*"[^"]*")*[^"]*$)',
			start=Now(),
			cols=['type','thread','date','time','application','message'],
			stackTrace=getStackTrace(),
			result={},
			items=[]
		};
		var pkey='unknown';
		try{
			errorStruct.items=REMatch(errorStruct.patternMatch,Trim(arguments.logRow));
			if( ArrayLen(errorStruct.items) ){
				for( var i=1;i<=ArrayLen(errorStruct.items);i++ ){
					pkey=i;
					if( i<=ArrayLen(errorStruct.cols) ){
						pkey=errorStruct.cols[i];
					}
					errorStruct.result[pkey]=errorStruct.items[i];
				}
			}
			errorStruct.logType="information";
		} catch( Any e ){
			errorStruct.logType="error";
			errorStruct.cfcatch=e;
		}
		errorStruct.end=Now();
		errorStruct.diff=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'test' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".RERowToStruct()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	JSONParserService.readJSON
	* @hint:	I read the json found in a log row
	* @returns:	Struct
	* @date:	Wednesday, 10/05/2016 07:58:28 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function readJSON(
		Struct logRow={}
	){
		var errorStruct={
			attrs=StructCount(arguments.logRow),
			logType="warning",
			start=Now(),
			items={},
			stackTrace=getStackTrace(),
			result={}
		};
		errorStruct.items['type']='Warning';
		errorStruct.items['thread']='none';
		errorStruct.items['date']=DateFormat(Now(),'MM/DD/YYYY');
		errorStruct.items['time']=TimeFormat(Now(),'HH:mm:ss');
		errorStruct.items['application']='LogReader';
		errorStruct.items['message']='';
		try{
			for( var idx in arguments.logRow ){
				errorStruct.items[ idx ]=arguments.logRow[ idx ];
			}
			if( structKeyExists(errorStruct.items,'message') ){
				errorStruct.jsonString=ListLast(errorStruct.items.message,'//');
				if( isJSON(Trim(errorStruct.jsonString)) ){
					errorStruct.result=DeserializeJSON(errorStruct.jsonString);
				}
			}
			//remove message content after creating a struct
			if( structKeyExists(errorStruct.items,'message')
				&& Len(Trim(errorStruct.items.message))
				&& StructCount(errorStruct.result)
			){
				StructDelete(errorStruct.items,'message');
			}
			//append log data to result
			errorStruct.result['logData']=errorStruct.items;

			errorStruct.logType="information";
		} catch( Any e ){
			errorStruct.logType="error";
			errorStruct.cfcatch=e;
		}
		errorStruct.end=Now();
		errorStruct.diff=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".readJSON()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}
}
