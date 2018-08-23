/**
* @name: LogReader
* @hint: Handler for the JSON Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.EventHandler"{

	// Default Action
	function index(event,rc,prc){
		prc['sectionTitle']="JSON Parser Module";
		event.setView("main/index");
	}
}