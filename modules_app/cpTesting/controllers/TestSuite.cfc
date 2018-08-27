/**
* @name: TestSuite
* @hint: Handler for the Testing Module
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.EventHandler"{

	// Default Action
	function index(event,rc,prc){
		prc['settings']=controller.getConfigSettings().modules.cpTesting.settings;
		prc['sectionTitle']="TestSuite Module";
		prc['moduleBase']=prc.settings.moduleBase;
		event.setView("main/index");
	}
}