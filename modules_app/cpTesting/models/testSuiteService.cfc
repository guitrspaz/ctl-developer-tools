/**
* @name: testSuiteService
* @package: modules_app.cpTesting.models.
* @hint: I am the service component for the Test Suite Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Thursday, 08/23/2018 07:48:48 AM
* @modified: Thursday, 08/23/2018 07:48:48 AM
*/

component
	displayname="testSuiteService"
	output="false"
	accessors="true"
	extends=models.base.service
{

	/**
	 * @name:		testSuiteService.init
	 * @hint:		I create an instance of this service
	 * @returns:	modules_app.cpTesting.models.testSuiteService
	 * @date:		Thursday, 08/23/2018 07:48:48 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public modules_app.cpTesting.models.testSuiteService function init(){
		super.configure(argumentCollection=arguments);
		return this;
	}

}