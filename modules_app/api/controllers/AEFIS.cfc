/**
* @name: api.controllers.AEFIS
* @hint: Handler for API calls from AEFIS
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, Thursday, 08/20/2020 10:30:26 AM
* @modified: Thursday, 08/20/2020 10:30:33 AM
*/

component extends="coldbox.system.EventHandler"{

	// Default Action
	function index(event,rc,prc){
		prc['settings']=controller.getConfigSettings().modules.api.settings;
		prc['sectionTitle']=prc.settings.pageTitle;
		prc['moduleRoot']=prc.settings.moduleRoot;
		if(structKeyExists(rc,'jsonData')){
			try{
				prc['jsonData']=Duplicate(rc.jsonData);
				if( isJSON(ReplaceNoCase(Trim(prc.jsonData),'//','','ONE')) ){
					prc['parsedJSON']=DeserializeJSON(prc.jsonData);
				} else {
					throw(
						message="Form data was not valid JSON.",
						type="InvalidJSON",
						detail="Error 001"
					);
				}
			} catch( Any e ){
				prc['jsonData']=Replace(Trim(rc.jsonData),'""','"','ALL');
				if( Right(prc.jsonData, 1)=='"' ){
					prc['jsonData']=Left(prc.jsonData,Len(prc.jsonData)-1);
				}
				try{
					if( isJSON(ReplaceNoCase(Trim(prc.jsonData),'//','','ONE')) ){
						prc['parsedJSON']=DeserializeJSON(prc.jsonData);
					} else {
						throw(
							message="Form data was not valid JSON.",
							type="InvalidJSON",
							detail="Error 002"
						);
					}
				} catch( Any f ){
					prc['parsedJSON']=f;
				}
			}
		}
		event.setView("json/index");
	}
}