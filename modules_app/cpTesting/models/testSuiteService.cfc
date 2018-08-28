/**
* @name: testSuiteService
* @package: modules_app.cpTesting.models.
* @hint: I am the service component for the Test Suite Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Thursday, 08/23/2018 07:48:48 AM
* @modified: Thursday, 08/23/2018 07:48:48 AM
*/

component
	displayname="testSuiteService"
	output="false"
	accessors="true"
	extends=models.base.service
{

	/**
	 * @name:		testSuiteService.init
	 * @hint:		I create an instance of this service
	 * @returns:	modules_app.cpTesting.models.testSuiteService
	 * @date:		Thursday, 08/23/2018 07:48:48 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public modules_app.cpTesting.models.testSuiteService function init(){
		super.configure(argumentCollection=arguments);
		return this;
	}

	public String function buildBreadCrumbs( required String link,required String path,Array suites=[] ){
		var errorStruct={
			'start':Now(),
			'logType':'warning',
			'result':'',
			'stackTrace':getStackTrace(),
			'sections':ListToArray(arguments.path,'/'),
			'link':'/'
		};
		try{
			if( ArrayLen(arguments.suites) ){
				errorStruct.result&='<ol class="breadcrumb pull-left">';
				for(var p=1;p<ArrayLen(arguments.suites);p++ ){
					errorStruct.result&='<li><a href="'&arguments.link&'/path/'&ReplaceNoCase(ReplaceNoCase(arguments.suites[p],'/',':','ALL'),'::',':','ALL')&'">'&Trim(arguments.suites[p])&'</a></li>';
				}
				errorStruct.result&='</ol>';
			}
			errorStruct.result&='<ol class="breadcrumb pull-left">';
			for( var a=1;a<=ArrayLen(errorStruct.sections);a++ ){
				if( Len(Trim(errorStruct.sections[a])) ){
					errorStruct.link&='/'&Trim(errorStruct.sections[a]);
					errorStruct.result&='<li><a href="'&arguments.link&'/path/'&ReplaceNoCase(ReplaceNoCase(errorStruct.link,'/',':','ALL'),'::',':','ALL')&'">'&Trim(errorStruct.sections[a])&'</a></li>';
				}
			}
			errorStruct.result&='</ol>';
			errorStruct['logType']='information';
		} catch(Any e){
			errorStruct['cfcatch']=e;
			errorStruct['logType']='error';
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".buildBreadCrumbs()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}
}