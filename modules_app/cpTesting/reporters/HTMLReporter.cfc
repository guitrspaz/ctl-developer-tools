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
		variables.bundleStats=arguments.results.getBundleStats();

		// prepare base links
		variables.baseURL="/index.cfm/testing:TestSuite/runner";
		if( structKeyExists( arguments.options,'encodedRoot') ){ variables.baseURL&='/directory/'&ReplaceNoCase(arguments.options.encodedRoot,'/',':','ALL'); }
		if( structKeyExists( arguments.options,'method') ){ variables.baseURL&="/method/"&arguments.options.method; }
		if( structKeyExists( arguments.options,'output') ){ variables.baseURL&="/output/"&arguments.options.output; }

		// prepare incoming params
		if( !structKeyExists( url,"testMethod") ){ url.testMethod=""; }
		if( !structKeyExists( url,"testSpecs") ){ url.testSpecs=""; }
		if( !structKeyExists( url,"testSuites") ){ url.testSuites=""; }
		if( !structKeyExists( url,"testBundles") ){ url.testBundles=""; }

		if( structKeyExists( arguments.options,'testMethod') ){
			if( isValid('array',arguments.options.testMethod) ){
				url.testMethod=ArrayToList(arguments.options.testMethod,',');
			} else if( isValid('string',arguments.testMethod) ){
				url.testMethod=URLDecode(arguments.options.testMethod);
			}
		}
		if( structKeyExists( arguments.options,'testSpecs') ){
			if( isValid('array',arguments.options.testSpecs) ){
				url.testSpecs=ArrayToList(arguments.options.testSpecs,',');
			} else if( isValid('string',arguments.testSpecs) ){
				url.testSpecs=URLDecode(arguments.options.testSpecs);
			}
		}
		if( structKeyExists( arguments.options,'testSuites') ){
			if( isValid('array',arguments.options.testSuites) ){
				url.testSuites=ArrayToList(arguments.options.testSuites,',');
			} else if( isValid('string',arguments.testSuites) ){
				url.testSuites=URLDecode(arguments.options.testSuites);
			}
		}
		if( structKeyExists( arguments.options,'testBundles') ){
			if( isValid('array',arguments.options.testBundles) ){
				url.testBundles=ArrayToList(arguments.options.testBundles,',');
			} else if( isValid('string',arguments.testBundles) ){
				url.testBundles=URLDecode(arguments.options.testBundles);
			}
		}

		// prepare the report
		savecontent variable="local.report"{
			include "templates/html.cfm";
		}

		return local.report;
	}

}