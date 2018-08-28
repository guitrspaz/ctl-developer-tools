/**
* @name: TestSuite
* @hint: Handler for the Testing Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.EventHandler"{

	// Default Action
	function index(event,rc,prc){
		prc['settings']=controller.getConfigSettings().modules.cpTesting.settings;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;
		prc['testData']={
			'root':( structKeyExists(rc,'path') && Len(Trim(rc.path)) )?URLDecode(rc.path):'/'
		};
		prc['testSuiteService']=getInstance('testSuiteService');
		event.setView("main/index");
	}

	function runner(event,rc,prc){
		prc['settings']=controller.getConfigSettings().modules.cpTesting.settings;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;
		prc['testData']={
			'bundles':( structKeyExists(rc,'testBundles') && Len(Trim(rc.testBundles)) )?URLDecode(rc.testBundles):'',
			'directory':( structKeyExists(rc,'directory') && Len(Trim(rc.directory)) )?URLDecode(rc.directory):'/'
		};
		event.setView("main/runner");
	}
}