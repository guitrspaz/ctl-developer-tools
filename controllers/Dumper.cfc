/**
* @name: handlers.Dumper
* @hint: Handler for Dumping Stuff
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.EventHandler"{

	function index(event,rc,prc){
		prc['sectionTitle']='Data Dump';
		prc['configuration']=controller.getConfigSettings();
		prc['serviceProps']={
			'dsn':prc.configuration.dsn.name,
			'debugMode':prc.configuration.debugMode,
			'defaultLog':prc.configuration.defaultLog,
			'moduleVersion':prc.configuration.appVersion
		};
		prc['service']=getInstance(name='service',initArguments=prc.serviceProps);
		prc['dao']=getInstance(name='dao',initArguments=prc.serviceProps);
		prc['event']=event.getCollection();
		event.setView("dump/index");
	}

}