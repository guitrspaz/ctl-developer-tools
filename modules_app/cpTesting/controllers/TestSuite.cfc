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
		prc['suites']=prc.settings.testSuites;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;
		prc['exclusions']=[];
		prc.suites.each(function(suite){
			ArrayAppend(prc.exclusions,ListToArray(suite,'/'),true);
		});
		prc['testData']={
			'root':( structKeyExists(rc,'path') && Len(Trim(rc.path)) )?ReplaceNoCase(ReplaceNoCase(rc.path,':','/','ALL'),ExpandPath('/'),'/'):prc.suites[1]
		};
		prc.testData['breadcrumbs']=getInstance('testSuiteService').buildBreadCrumbs(event.buildLink('testing:TestSuite.index'),prc.testData.root,prc.suites,prc.exclusions);
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
		prc['suites']=prc.settings.testSuites;
		prc['reporter']=prc.settings.testReporter;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;
		prc['testData']={
			'testBundles':( structKeyExists(rc,'testBundles') && Len(Trim(rc.testBundles)) )?ListToArray(ArrayToList(ListToArray(ReplaceNoCase(rc.testBundles,':','/','ALL'),'/'),'.'),','):[],
			'testSuites':( structKeyExists(rc,'testSuites') && Len(Trim(rc.testSuites)) )?ListToArray(ArrayToList(ListToArray(ReplaceNoCase(rc.testSuites,':','/','ALL'),'/'),'.'),','):[],
			'testSpecs':( structKeyExists(rc,'testSpecs') && Len(Trim(rc.testSpecs)) )?ListToArray(ArrayToList(ListToArray(ReplaceNoCase(rc.testSpecs,':','/','ALL'),'/'),'.'),','):[],
			'package':( structKeyExists(rc,'directory') && Len(Trim(rc.directory)) )?ArrayToList(ListToArray(ReplaceNoCase(rc.directory,':','/','ALL'),'/'),'.'):ArrayToList(ListToArray(ReplaceNoCase(prc.suites[1],':','/','ALL'),'/'),'.')
		};
		prc.testData['directory']={
			'mapping':prc.testData.package,
			'recurse':false
		};
		prc.testData['encodedRoot']=':'&ReplaceNoCase(prc.testData.package,'.',':','ALL');
		prc.testData['options']=StructCopy(prc.testData);
		prc.testBox=new testbox.system.TestBox(reporter={
			type=prc.reporter,
			options=prc.testData
		});
		prc.results=prc.testBox.run(argumentCollection=prc.testData);
		if( isValid('struct',prc.results) && StructKeyExists(prc.results,'bundleStats') && isValid('array',prc.results.bundleStats) && ArrayLen(prc.results.bundleStats) ){
			var bs=prc.results.bundleStats.filter(function(bundle){
				return (structKeyExists(bundle,'totalSuites') && Val(bundle.totalSuites) )?true:false;
			});
			prc.results.bundleStats=bs;
		}
		event.setView(view="main/runner",layout="Blank");
	}
}