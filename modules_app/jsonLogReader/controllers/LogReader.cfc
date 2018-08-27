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
		prc['settings']=controller.getConfigSettings().modules.jsonLogReader.settings;
		prc['sectionTitle']="Log Reader";
		prc['moduleBase']=prc.settings.moduleBase;
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
		event.setView("main/index");
	}
}