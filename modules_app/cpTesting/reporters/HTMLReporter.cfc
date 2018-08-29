/**
* Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* A simple HTML reporter
*/
component{

	function init(){
		return this;
	}

	/**
	* Get the name of the reporter
	*/
	function getName(){
		return "Simple";
	}

	/**
	* Do the reporting thing here using the incoming test results
	* The report should return back in whatever format they desire and should set any
	* Specifc browser types if needed.
	* @results.hint The instance of the TestBox TestResult object to build a report on
	* @testbox.hint The TestBox core object
	* @options.hint A structure of options this reporter needs to build the report with
	*/
	any function runReport(
		required testbox.system.TestResult results,
		required testbox.system.TestBox testbox,
		struct options={}
	){
		// content type
		getPageContext().getResponse().setContentType( "text/html" );

		// bundle stats
		variables.bundleStats = arguments.results.getBundleStats();

		// prepare base links
		variables.baseURL = "/index.cfm/testing:TestSuite.runner/";
		if( structKeyExists( url, "method") ){ variables.baseURL&="/method/"&url.method; }
		if( structKeyExists( url, "output") ){ variables.baseURL&="/output/"&url.output; }

		// prepare incoming params
		if( !structKeyExists( url, "testMethod") ){ url.testMethod = ""; }
		if( !structKeyExists( url, "testSpecs") ){ url.testSpecs = ""; }
		if( !structKeyExists( url, "testSuites") ){ url.testSuites = ""; }
		if( !structKeyExists( url, "testBundles") ){ url.testBundles = ""; }

		// prepare the report
		savecontent variable="local.report"{
			include "assets/html.cfm";
		}

		return local.report;
	}

}