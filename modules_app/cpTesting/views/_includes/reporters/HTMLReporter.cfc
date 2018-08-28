component
{
	function init(){
		return this;
	}

	/**
	* Get the name of the reporter
	*/
	function getName(){
		return "HTML";
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
		variables['bundleStats'] = arguments.results.getBundleStats();

		// prepare base links
		variables['baseURL']=(StructKeyExists(arguments.options,'baseURL'))?Trim(arguments.options.baseURL):'/';
		if( structKeyExists( url, "method") ){ variables.baseURL&= "/method/#URLEncodedFormat( url.method )#"; }
		if( structKeyExists( url, "output") ){ variables.baseURL&= "/output/#URLEncodedFormat( url.output )#"; }

		// prepare incoming params
		if( !structKeyExists( url, "testMethod") ){ url.testMethod = ""; }
		if( !structKeyExists( url, "testSpecs") ){ url.testSpecs = ""; }
		if( !structKeyExists( url, "testSuites") ){ url.testSuites = ""; }
		if( !structKeyExists( url, "testBundles") ){ url.testBundles = ""; }

		// prepare the report
		try{
			savecontent variable="local.report"{
				include arguments.options.base&'views/_includes/cfm/templates/html.cfm';
			}
		} catch(Any e){
			local.report=e;
		}
		return local.report;
	}

}