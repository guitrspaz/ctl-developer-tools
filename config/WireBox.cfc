/**
* @name: config.WireBox
* @hint: Configure WireBox for Coldbox Application
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 08/20/2018 11:47:24 AM
* @modified: Monday, 08/20/2018 11:47:24 AM
*/

component extends="coldbox.system.ioc.config.Binder"{

	/**
	* Configure WireBox, that's it!
	*/
	function configure(){

		// The WireBox configuration structure DSL
		wireBox={
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			// By default it registeres itself on application scope
			'scopeRegistration':{
				'enabled':true,
				'scope':"application", // server, cluster, session, application
				'key':"wireBox"
			},

			// DSL Namespace registrations
			'customDSL':{
				// namespace:"mapping name"
			},

			// Custom Storage Scopes
			'customScopes':{
				// annotationName:"mapping name"
			},

			// Package scan locations
			'scanLocations':[],

			// Stop Recursions
			'stopRecursions':[],

			// Parent Injector to assign to the configured injector, this must be an object reference
			'parentInjector':"",

			// Register all event listeners here, they are created in the specified order
			'listeners':[
				// { class:"", name:"", properties:{} }
			]
		};
		// Map Bindings below
	}

}