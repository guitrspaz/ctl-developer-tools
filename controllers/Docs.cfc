/**
* @name: handlers.Docs
* @hint: Handler for the Main layout
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.EventHandler"{

	// Default Action
	function index(event,rc,prc){
		prc['sectionTitle']="DocBox";
		event.setView("docs/index");
	}

	// Reload Action
	function reload(event,rc,prc){
		prc['sectionTitle']="DocBox";
		var docbox=new docbox.DocBox(properties={
			'projectTitle':"CoursePlus",
			'outputDir':ExpandPath( '/docs' )
		});

		docbox.generate(
			source=[{
				'dir':ExpandPath('/core'),
				'mapping':'core'
			},{
				'dir':ExpandPath('/com'),
				'mapping':'com'
			}],
			mapping="docs"
		);

		setNextEvent(event='docs',persist='',ssl=true);
	}
}