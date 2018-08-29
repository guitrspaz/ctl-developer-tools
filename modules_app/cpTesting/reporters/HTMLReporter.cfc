component
{
	property name='name' getter="true" setter="true" default="HTML";
	property name='directory' getter="true" setter="true" default="/";
	property name='testMethod' getter="true" setter="true" default="";
	property name='testSpecs' getter="true" setter="true" default="";
	property name='testSuites' getter="true" setter="true" default="";
	property name='testBundles' getter="true" setter="true" default="";

	function init(){
		arguments.each(function(key,value){
			if( !isNull(key) && !isNull(value) && structKeyExists(this,'set'&key) ){
				Evaluate('this.set'&key&'('&value&')');
			}
		});
		return this;
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
		variables.baseURL='/index.cfm/testing:TestSuite.runner/directory/'&ReplaceNoCase(Trim(this.getdirectory()),'/',':');

		// prepare the report
		savecontent variable="local.report"{
			include 'templates/html.cfm';
		}
		return local.report;
	}

}