/**
* @name: config.Router
* @hint: Configure Application Routing
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component{
	function configure(){
		setFullRewrites( false );//true removes index.cfm from urls
		route( ":handler/:action?" ).end();
	}
}