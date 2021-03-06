/**
* Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* The TestBox main base runner which has all the common methods needed for runner implementations.
*/
component{

	/************************************** UTILITY METHODS *********************************************/

	/**
	* Checks if the incoming labels are good for running
	* @incomingLabels.hint The incoming labels to test against this runner's labels.
	* @testResults.hint The testing results object
	*/
	boolean function canRunLabel(
		required array incomingLabels,
		required testResults
	){

		var labels = arguments.testResults.getLabels();
        var excludes = arguments.testResults.getExcludes();

        // do we have labels applied?
        var canRun = true;
		if( arrayLen( labels ) ){
            canRun = false;
			for( var thisLabel in labels ){
				// verify that a label exists, if it does, break, it matches the criteria, if no matches, then skip it.
				if( arrayFindNoCase( incomingLabels, thisLabel ) ){
					// match, so we can run it.
                    canRun = true;
				}
			}
        }

        if ( ! arrayIsEmpty( excludes ) ) {
            for ( var thisExclude in excludes ) {
                if ( arrayFindNoCase( incomingLabels, thisExclude ) ) {
                    canRun = false;
                }
            }
        }

        return canRun;
	}

	/**
	* Checks if we can run the spec due to using testSpec arguments or incoming URL filters.
	* @name.hint The spec name
	* @testResults.hint The testing results object
	*/
	boolean function canRunSpec(
		required name,
		required testResults
	){

		var testSpecs = arguments.testResults.getTestSpecs();

		// verify we have some?
		if( arrayLen( testSpecs ) ){
			return ( arrayFindNoCase( testSpecs, arguments.name ) ? true : false );
		}

		// we can run it.
		return true;
	}

	/**
	* Checks if we can run the suite due to using testSuite arguments or incoming URL filters.
	* @suite.hint The suite definition
	* @testResults.hint The testing results object
	*/
	boolean function canRunSuite(
		required suite,
		required testResults
	){

		var testSuites = arguments.testResults.getTestSuites();

		// verify we have some?
		if( arrayLen( testSuites ) ){
			var results = ( arrayFindNoCase( testSuites, arguments.suite.name ) ? true : false );

			// Verify nested if no match, maybe it is an embedded suite that is trying to execute.
			if( results == false && arrayLen( arguments.suite.suites ) ){
				for( var thisSuite in arguments.suite.suites ){
					// go down the rabitt hole
					if( canRunSuite( thisSuite, arguments.testResults ) ){
						return true;
					}
				}
				return false;
			}

			// Verify hierarchy slug
			if( results == false && len( arguments.suite.slug ) ){
				var slugArray = listToArray( arguments.suite.slug, "/" );
				for( var thisSlug in slugArray ){
					if( arrayFindNoCase( testSuites, thisSlug ) ){
						return true;
					}
				}
				return false;
			}

			return results;
		}

		// we can run it.
		return true;
	}

	/**
	* Checks if we can run the test bundle due to using testBundles arguments or incoming URL filters.
	* @suite.hint The suite definition
	* @testResults.hint The testing results object
	*/
	boolean function canRunBundle(
		required bundlePath,
        required testResults,
        required targetMD
	){
		var testBundles = arguments.testResults.getTestBundles();

		// verify we have some?
		if( arrayLen( testBundles ) ){
			return ( arrayFindNoCase( testBundles, arguments.bundlePath ) ? true : false );
		}

		// we can run it.
		return true;
	}

	/**
	* Validate the incoming method name is a valid TestBox test method name
	* @methodName.hint The method name to validate
	* @target.hint The target object
	*/
	boolean function isValidTestMethod( required methodName, required target ) {
		// True if annotation "test" exists
		if( structKeyExists( getMetadata( arguments.target[ arguments.methodName ] ), "test" ) ){
			return true;
		}
		// All xUnit test methods must start or end with the term, "test".
		return( !! reFindNoCase( "(^test|test$)", methodName ) );
	}

	/**
	* Get metadata from a method
	* @target.hint The target method
	* @name.hint The annotation to look for
	* @defaultValue.hint The default value to return if not found
	*/
	function getMethodAnnotation( required target, required name, defaultValue="" ){
		var md = getMetadata( arguments.target );

		if( structKeyExists( md, arguments.name ) ){
			return ( len( md[ arguments.name ] ) ? md[ arguments.name ] : true );
		}
		else{
			return arguments.defaultValue;
		}
	}

}
