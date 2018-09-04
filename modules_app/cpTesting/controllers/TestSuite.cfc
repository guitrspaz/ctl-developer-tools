/**
* @name: cpTesting.controllers.TestSuite
* @hint: Handler for the Testing Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.EventHandler"{

	// Default Action
	function index(event,rc,prc){
		//get module settings
		prc['settings']=controller.getConfigSettings().modules.cpTesting.settings;

		//copied from module settings
		prc['suites']=prc.settings.testSuites;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;

		//directories outside the test root will not be included in the breadcrumbs
		prc['exclusions']=[];
		prc.suites.each(function(suite){
			ArrayAppend(prc.exclusions,ListToArray(suite,'/'),true);
		});

		//this is the structure used by the view to render the testing browser
		prc['testData']={
			'root':( structKeyExists(rc,'path') && Len(Trim(rc.path)) )?ReplaceNoCase(ReplaceNoCase(rc.path,':','/','ALL'),ExpandPath('/'),'/'):prc.suites[1]
		};

		//use the testSuiteService to create the breadcrumbs
		prc.testData['breadcrumbs']=getInstance('testSuiteService').buildBreadCrumbs(event.buildLink('testing:TestSuite.index'),prc.testData.root,prc.suites,prc.exclusions);

		//this is the test root that gets used for linking in views
		prc.testData['encodedRoot']=ReplaceNoCase(prc.testData.root,'/',':','ALL');

		//these are the directories and files to include in testing
		prc.testData['directories']=directoryList(
			ExpandPath(prc.testData.root),
			false,
			'query'
		);

		//this is the test root in dot-notation
		prc.testData['package']=ArrayToList(ListToArray(prc.testData.root,'/'),'.');

		//view setter
		event.setView("main/index");
	}

	function runner(event,rc,prc){
		//get module settings
		prc['settings']=controller.getConfigSettings().modules.cpTesting.settings;

		//copied from module settings
		prc['suites']=prc.settings.testSuites;
		prc['reporter']=prc.settings.testReporter;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;

		try{
			//this is the structure used by the view to render the testing browser
			prc['testData']={
				'testBundles':( structKeyExists(rc,'testBundles') && Len(Trim(rc.testBundles)) )?ListToArray(ArrayToList(ListToArray(ReplaceNoCase(rc.testBundles,':','/','ALL'),'/'),'.'),','):[],
				'testSuites':( structKeyExists(rc,'testSuites') && Len(Trim(rc.testSuites)) )?ListToArray(ArrayToList(ListToArray(ReplaceNoCase(rc.testSuites,':','/','ALL'),'/'),'.'),','):[],
				'testSpecs':( structKeyExists(rc,'testSpecs') && Len(Trim(rc.testSpecs)) )?ListToArray(ArrayToList(ListToArray(ReplaceNoCase(rc.testSpecs,':','/','ALL'),'/'),'.'),','):[],
				'package':( structKeyExists(rc,'directory') && Len(Trim(rc.directory)) )?ArrayToList(ListToArray(ReplaceNoCase(rc.directory,':','/','ALL'),'/'),'.'):ArrayToList(ListToArray(ReplaceNoCase(prc.suites[1],':','/','ALL'),'/'),'.'),
				'baseURL':event.buildLink('testing:TestSuite.runner')
			};

			//testing root
			prc.testData['directory']={
				'mapping':prc.testData.package,
				'recurse':(ArrayLen(prc.testData.testBundles))?false:true
			};


			//this is the testing root that gets used for linking in views
			prc.testData['encodedRoot']=':'&ReplaceNoCase(prc.testData.package,'.',':','ALL');

			//the options get sent to the report runner as params
			prc.testData['options']=StructCopy(prc.testData);

			//new testbox instance
			prc['testBox']=new testbox.system.TestBox(reporter={
				type=prc.reporter,
				options=prc.testData
			});

			//test results for use in the view
			prc['results']=prc.testBox.run(argumentCollection=prc.testData);

			//if the results are struct, they get filtered here
			if( isValid('struct',prc.results) && StructKeyExists(prc.results,'bundleStats') && isValid('array',prc.results.bundleStats) && ArrayLen(prc.results.bundleStats) ){
				var bs=prc.results.bundleStats.filter(function(bundle){
					return (structKeyExists(bundle,'totalSuites') && Val(bundle.totalSuites) )?true:false;
				});
				prc.results.bundleStats=bs;
			}
		} catch( Any e ){
			//if there is an error, it is returned instead of the results
			prc['results']=e;
		}
		event.setView(view="main/runner",layout="Blank");
	}
}