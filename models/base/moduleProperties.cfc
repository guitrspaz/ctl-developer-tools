/**
* @name: moduleProperties
* @package: com.distance.base.
* @hint: I am a base module property
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Wednesday, 03/15/2017 08:29:29 AM
* @modified: Wednesday, 03/15/2017 08:29:29 AM
*/

component
	displayname="moduleProperties"
	output="false"
	accessors="true"
	extends="com.distance.base.coursePlusObject"
{
	property name='applicationRoot' type='string' default="/core" getter='true' setter='true';
	property name='adminEmail' type='string' default="ctlhelp@jhu.edu" getter='true' setter='true';
	property name='blueprints' getter='true' setter='true' type='struct';
	property name='catalogDSN' getter='true' setter='true' type='string';
	property name='defaultEvent' getter='true' setter='true' type='string' default='home';
	property name='devEmail' getter='true' setter='true' type='string' default='ctlhelp@jhu.edu';
	property name='devID' getter='true' setter='true' type='numeric' default=3562;
	property name='filePath' getter='true' setter='true' type='string' default='/fileDepot';
	property name='hasOwnProperties' getter='true' setter='true' type='boolean' default=true;
	property name='paramAliases' getter='true' setter='true' type='struct';
	property name='propertyScopes' getter='true' setter='true' type='array';
	property name='tempFileDir' getter='true' setter='true' type='string' default='/fileDepot/tmp';

	private Void function configure(
		String adminEmail,
		Array blueprints=[],
		Array cacheScopes=[],
		Struct cacheTypes={},
		String cacheRegion='',
		String catalogDSN='',
		Date compareDate=CreateDateTime(1970,1,1,0,0,0),
		Boolean debugMode=0,
		String defaultEvent,
		String defaultLog='com.distance.base',
		Date defaultDate=CreateDateTime(1969,12,31,23,59,59),
		String devEmail,
		Numeric devID,
		String filePath='/fileDepot',
		Boolean hasOwnProperties,
		String moduleName,
		String moduleRoot,
		String modulePrefix,
		String moduleVersion,
		Struct paramAliases={},
		Boolean sharedCache=false,
		String supportEmail='ctlhelp@jhu.edu',
		String tempFileDir='/fileDepot/tmp',
		Array propertyScopes=[]
	){
		super.configureCPObject(argumentCollection=arguments);
		//this should not be this way, but most modules have an applicationRoot set to their root
		if( structKeyExists(arguments,'moduleRoot') && Len(Trim(arguments.moduleRoot)) ){
			this.setapplicationRoot(arguments.moduleRoot);
		}
		if( structKeyExists(arguments,'adminEmail') && Len(Trim(arguments.adminEmail)) ){
			this.setadminEmail(arguments.adminEmail);
		} else {
			this.setadminEmail(this.getdeveloperEmail());
		}
		this.setblueprints( returnBuiltBlueprints(arguments.blueprints) );
		this.setcatalogDSN(arguments.catalogDSN);
		if( structKeyExists(arguments,'defaultEvent') ){
			this.setdefaultEvent(arguments.defaultEvent);
		}
		if( structKeyExists(arguments,'devEmail') && Len(Trim(arguments.devEmail)) ){
			this.setdevEmail(arguments.devEmail);
		} else {
			this.setdevEmail(this.getdeveloperEmail());
		}
		if( structKeyExists(arguments,'devID') && isValid('numeric',arguments.devID) ){
			this.setdevID(arguments.devID);
		}
		this.setfilePath(arguments.filePath);
		if( structKeyExists(arguments,'hasOwnProperties') && isValid('boolean',arguments.hasOwnProperties) ){
			this.sethasOwnProperties(arguments.hasOwnProperties);
		}
		this.settempFileDir(arguments.tempFileDir);
		this.setpropertyScopes(arguments.propertyScopes);
	}

	public com.distance.base.moduleProperties function init(){
		configure( argumentCollection=arguments );
		return this;
	}

	public Struct function returnProperties(){
		return this.getObjectAsStructure();
	}

	private Struct function returnBuiltBlueprints(required Array blueprints){
		var result={};
		var includes=arguments.blueprints;
		arguments.blueprints.each(function(blueprint){
			var bpName=ListLast(blueprint,'.');
			if(Len(Trim(ReplaceNoCase(bpName,'.','','ALL')))){
				result[Trim(ReplaceNoCase(bpName,'.','','ALL'))]=makeBlueprint(blueprint,includes);
			}
		});
		return result;
	}
}
