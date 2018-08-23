/**
* @name: JSONParserService
* @package: modules_app.jsonLogReader.models.
* @hint: I am the service component for the JSON Parser Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Thursday, 08/23/2018 07:48:48 AM
* @modified: Thursday, 08/23/2018 07:48:48 AM
*/

component
	displayname="JSONParserService"
	output="false"
	accessors="true"
	extends=models.base.service
{

	/**
	 * @name:		JSONParserService.init
	 * @hint:		I create an instance of this service
	 * @returns:	modules_app.jsonLogReader.models.JSONParserService
	 * @date:		Thursday, 08/23/2018 07:48:48 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public modules_app.jsonLogReader.models.JSONParserService function init(){
		super.configure(argumentCollection=arguments);
		return this;
	}

}