/**
* @name: JSONParsingService
* @package:
* @hint: I handle parsing json
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Tuesday, 08/21/2018 09:05:20 AM
* @modified: Tuesday, 08/21/2018 09:05:20 AM
*/

component
	displayname="JSONParsingService"
	output="false"
	accessors="true"
	extends=models.base.service
{

	/**
	 * @name:		JSONParsingService.init
	 * @hint:		I create an instance of JSONParsingService
	 * @returns:	models.JSONParser.JSONParsingService
	 * @date:		Tuesday, 08/21/2018 09:05:20 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public models.JSONParser.JSONParsingService function init(){
		super.configure(argumentCollection=arguments);
		return this;
	}
}