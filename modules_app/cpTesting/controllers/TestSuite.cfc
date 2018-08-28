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
			'root':( structKeyExists(rc,'path') && Len(Trim(rc.path)) )?ReplaceNoCase(ReplaceNoCase(rc.path,':','/','ALL'),ExpandPath('/'),'/'):'/com'
		};
		prc.testData['breadcrumbs']=getInstance('testSuiteService').buildBreadCrumbs(event.buildLink('testing:TestSuite.index'),prc.testData.root);
		prc.testData['encodedRoot']=ReplaceNoCase(prc.testData.root,'/',':','ALL');
		prc.testData['directories']=directoryList(
			ExpandPath(prc.testData.root),
			false,
			'query'
		);
		prc.testData['package']=ArrayToList(ListToArray(prc.testData.root,'/'),'.');
		event.setView("main/index");
	}

	function runner(event,rc,prc){
		prc['settings']=controller.getConfigSettings().modules.cpTesting.settings;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;
		prc['testData']={
			'bundles':( structKeyExists(rc,'testBundles') && Len(Trim(rc.testBundles)) )?ArrayToList(ListToArray(ReplaceNoCase(rc.testBundles,':','/','ALL'),'/'),'.'):'',
			'directory':( structKeyExists(rc,'directory') && Len(Trim(rc.directory)) )?ReplaceNoCase(ReplaceNoCase(rc.directory,':','/','ALL'),ExpandPath('/'),'/'):'/com'
		};
		prc.testData['package']=ArrayToList(ListToArray(prc.testData.directory,'/'),'.');
		prc.testData['encodedRoot']=ReplaceNoCase(prc.testData.directory,'/',':');
		event.setView("main/runner");
	}
}