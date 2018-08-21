/**
* @name: bean
* @package: com.distance.base.
* @hint: basic bean object
* @author: Chris Schroeder (schroeder@jhu.edu)
* @created: Tuesday, 03/01/2016 08:24:54 AM
* @modified: Tuesday, 03/01/2016 08:24:54 AM
*/

component
	displayname="com.distance.base.bean"
	accessors="true"
	output="false"
	extends="com.distance.base.coursePlusObject"
{
	property name='createdOn' type='Date' getter='true' setter='true';
	property name='modifiedOn' type='Date' getter='true' setter='true';
	property name='prototype' type='Any' getter='true' setter='true';
	property name='paramAliases' type='Struct' getter='true' setter='true';

	this['createdOn']=CreateDateTime(1969,12,31,23,59,59);
	this['modifiedOn']=Now();

	/**
	 * @name: configure()
	 * @package: com.distance.base.bean.
	 * @hint: This function returns an instance of com.distance.base.bean with argument.prototype as the property 'prototype'.
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @copyright: Johns Hopkins University
	 * @date: Friday, 07/01/2016 12:35:20 PM
	 */
	private Void function configure(){
		super.configureCPObject(argumentCollection=arguments);
		if( structKeyExists(arguments,'createdOn') && isValid('Date',arguments.createdOn) ){
			this.setmodifiedOn(arguments.createdOn);
		}
		if( structKeyExists(arguments,'modifiedOn') && isValid('Date',arguments.modifiedOn) ){
			this.setmodifiedOn(arguments.modifiedOn);
		}
	}

	public com.distance.base.bean function init(
		Any prototype,
		String defaultLog,
		Boolean debugMode,
		String ctlemail='ctlhelp@jhu.edu',
		String supportEmail,
		Array cacheScopes=[],
		Struct cacheTypes={}
	){
		configure(argumentCollection=arguments);
		if( structKeyExists(arguments,'paramAliases') && isValid('struct',arguments.paramAliases) ){
			this.setparamAliases(arguments.paramAliases);
		}
		return this;
	}

	/**
	 * @name: makeFunctName()
	 * @package: com.distance.base.bean.
	 * @hint: I return a string in the format: component.functionName()
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @copyright: Johns Hopkins University
	 * @date: Friday, 07/01/2016 09:15:13 AM
	 */
	private String function makeFunctName( required String functName,required String objName ){
		return arguments.objName & '.' & arguments.functName & '()';
	}

	/**
	 * @name: dump()
	 * @package: com.distance.base.bean.
	 * @hint: I dump data
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @copyright: Johns Hopkins University
	 * @date: Friday, 07/01/2016 09:15:13 AM
	 */
	public Void function dump(){
		var errorStruct={
			'stackTrace':getStackTrace(),
			'start':Now(),
			'bean':{},
			'result':""
		};
		try{
			errorStruct['bean']=getObjectAsStructure();
			errorStruct['end']=Now();
			errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
			savecontent variable="errorStruct.result"{
				WriteOutput('<h1>Dump</h1>');
				WriteDump(var=errorStruct);
				abort;
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=cfcatch;
		}
		WriteOutput(errorStruct.result);
	}
}
