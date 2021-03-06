<cfset cDir = getDirectoryFromPath( getCurrentTemplatePath() )>
<cfoutput>

<!--- Filter --->
<div class="" style="float: right">
	<input type="text" name="bundleFilter" id="bundleFilter" placeholder="Filter Bundles..." size="35">
</div>

<!--- Header --->
<p>TestBox v#testbox.getVersion()#</p>
<!--- <cfdump var="#testbox#" /> --->
<!--- <cfdump var="#results#" /> --->

<!--- Global Stats --->
<div class="box" id="globalStats">

<div class="buttonBar">
	<a href="#variables.baseURL#" class="inc-tb-file-btn"><button title="Run all the tests">Run All</button></a>
	<button onclick="toggleDebug()" title="Toggle the test debug information">Debug</button>
</div>

<h2>Global Stats (#results.getTotalDuration()# ms)</h2>
[ Bundles/Suites/Specs: #results.getTotalBundles()#/#results.getTotalSuites()#/#results.getTotalSpecs()# ]
[ <span class="specStatus passed" data-status="passed">Pass: #results.getTotalPass()#</span> ]
[ <span class="specStatus failed" data-status="failed">Failures: #results.getTotalFail()#</span> ]
[ <span class="specStatus error" data-status="error">Errors: #results.getTotalError()#</span> ]
[ <span class="specStatus skipped" data-status="skipped">Skipped: #results.getTotalSkipped()#</span> ]
[ <span class="reset" title="Clear status filters">Reset</span> ]
<br>
<cfif arrayLen( results.getLabels() )>
[ Labels Applied: #arrayToList( results.getLabels() )# ]
</cfif>

</div>

<!--- Bundle Info --->
<cfloop array="#variables.bundleStats#" index="thisBundle">
	<!--- Skip if not in the includes list --->
	<cfif len( url.testBundles ) and !listFindNoCase( url.testBundles, thisBundle.path )>
		<cfcontinue>
	</cfif>
	<!--- Bundle div --->
	<div class="box bundle" id="bundleStats_#thisBundle.path#" data-bundle="#thisBundle.path#">

		<!--- bundle stats --->
		<cfset testBundles=ReplaceNoCase(thisBundle.path,'/',':','ALL') />
		<h2><a href="#variables.baseURL#/testBundles/#testBundles#" class="inc-tb-file-btn" title="Run only this bundle">#thisBundle.path#</a> (#thisBundle.totalDuration# ms)</h2>
		[ Suites/Specs: #thisBundle.totalSuites#/#thisBundle.totalSpecs# ]
		[ <span class="specStatus passed" data-status="passed" data-bundleid="#thisBundle.id#">Pass: #thisBundle.totalPass#</span> ]
		[ <span class="specStatus failed" data-status="failed" data-bundleid="#thisBundle.id#">Failures: #thisBundle.totalFail#</span> ]
		[ <span class="specStatus error" data-status="error" data-bundleid="#thisBundle.id#">Errors: #thisBundle.totalError#</span> ]
		[ <span class="specStatus skipped" data-status="skipped" data-bundleid="#thisBundle.id#">Skipped: #thisBundle.totalSkipped#</span> ]
		[ <span class="reset" title="Clear status filters">Reset</span> ]

		<!-- Globa Error --->
		<cfif !isSimpleValue( thisBundle.globalException )>
			<h2>Global Bundle Exception<h2>
			<cfdump var="#thisBundle.globalException#" />
		</cfif>

		<!-- Iterate over bundle suites -->
		<cfloop array="#thisBundle.suiteStats#" index="suiteStats">
			<div class="suite #lcase( suiteStats.status)#" data-bundleid="#thisBundle.id#">
			<ul>
				#genSuiteReport( suiteStats, thisBundle )#
			</ul>
			</div>
		</cfloop>

		<!--- Debug Panel --->
		<cfif arrayLen( thisBundle.debugBuffer )>
			<hr>
			<h2>Debug Stream <button onclick="toggleDebug( '#thisBundle.id#' )" title="Toggle the test debug stream">+</button></h2>
			<div class="debugdata" data-specid="#thisBundle.id#">
				<p>The following data was collected in order as your tests ran via the <em>debug()</em> method:</p>
				<cfloop array="#thisBundle.debugBuffer#" index="thisDebug">
					<h1>#thisDebug.label#</h1>
					<cfdump var="#thisDebug#" />
					<cfif structKeyExists(thisDebug,'data')>
						<cfdump var="#thisDebug.data#"
							label="#thisDebug.label# - #dateFormat( thisDebug.timestamp, "short" )# at #timeFormat( thisDebug.timestamp, "full")#"
							top="#thisDebug.top#"
						/>
					</cfif>
					<cfif structKeyExists(thisDebug,'thread')>
						<cfdump var="#thisDebug.thread#"
							label="Thread data"
						/>
					</cfif>
					<p>&nbsp;</p>
				</cfloop>
			</div>
		</cfif>

	</div>
</cfloop>

<!--- <cfdump var="#results#"> --->
<script>
	jQuery(document).on('click','.inc-tb-file-btn',function(event){
		event.preventDefault();
		runTests(jQuery(event.currentTarget).attr('href'));
		return false;
	});

	// spec toggler
	jQuery("span.specStatus").click( function(){
		toggleSpecs( jQuery( this ).attr( "data-status" ), jQuery( this ).attr( "data-bundleid" ) );
	});
	// spec toggler
	jQuery("span.reset").click( function(){
		resetSpecs();
	});
	// Filter Bundles
	jQuery( "##bundleFilter" ).keyup(function(){
		var targetText = jQuery( this ).val().toLowerCase();
		jQuery( ".bundle" ).each(function( index ){
			var bundle = jQuery( this ).data( "bundle" ).toLowerCase();
			if( bundle.search( targetText ) < 0 ){
				// hide it
				jQuery( this ).hide();
			} else {
				jQuery( this ).show();
			}
		});
	});
	jQuery( "##bundleFilter" ).focus();
	function resetSpecs(){
		jQuery("div.spec").each( function(){
			jQuery(this).show();
		});
		jQuery("div.suite").each( function(){
			jQuery(this).show();
		});
	}
	function toggleSpecs( type, bundleID ){
		jQuery("div.suite").each( function(){
			handleToggle( jQuery( this ), bundleID, type );
		} );
		jQuery("div.spec").each( function(){
			handleToggle( jQuery( this ), bundleID, type );
		} );
	}
	function handleToggle( target, bundleID, type ){
		var $this = target;
		// if bundleid passed and not the same bundle, skip
		if( bundleID != undefined && $this.attr( "data-bundleid" ) != bundleID ){
			return;
		}
		// toggle the opposite type
		if( !$this.hasClass( type ) ){
			$this.fadeOut();
		} else {
			// show the type you sent
			$this.parents().fadeIn();
			$this.fadeIn();
		}
	}
	function toggleDebug( specid ){
		jQuery("div.debugdata").each( function(){
			var $this = jQuery( this );

			// if bundleid passed and not the same bundle
			if( specid != undefined && $this.attr( "data-specid" ) != specid ){
				return;
			}
			// toggle.
			$this.fadeToggle();
		});
	}
</script>

<!--- Recursive Output --->
<cffunction name="genSuiteReport" output="false">
	<cfargument name="suiteStats">
	<cfargument name="bundleStats">

	<cfsavecontent variable="local.report">
		<cfoutput>
		<!--- Suite Results --->
		<li>
			<cfset testSuites=arguments.suiteStats.name />
			<cfset testBundles=ReplaceNoCase(arguments.bundleStats.path,'/',':','ALL') />
			<span title="Total: #arguments.suiteStats.totalSpecs# Passed:#arguments.suiteStats.totalPass# Failed:#arguments.suiteStats.totalFail# Errors:#arguments.suiteStats.totalError# Skipped:#arguments.suiteStats.totalSkipped#"
			   class="inc-tb-file-btn #lcase( arguments.suiteStats.status )#"><strong>+#arguments.suiteStats.name#</strong></span>
			(#arguments.suiteStats.totalDuration# ms)
		</li>
			<cfloop array="#arguments.suiteStats.specStats#" index="local.thisSpec">

				<!--- Spec Results --->
				<ul>
				<div class="spec #lcase( local.thisSpec.status )#" data-bundleid="#arguments.bundleStats.id#" data-specid="#local.thisSpec.id#">
					<li>
						<cfset testSpecs=URLEncodedFormat( local.thisSpec.name ) />
						<cfset testBundles=ReplaceNoCase(arguments.bundleStats.path,'/',':','ALL') />
						<span class="inc-tb-file-btn #lcase( local.thisSpec.status )#">#local.thisSpec.name# (#local.thisSpec.totalDuration# ms)</span>

						<cfif local.thisSpec.status eq "failed">
							- <strong>#htmlEditFormat( local.thisSpec.failMessage )#</strong>
							  <button onclick="toggleDebug( '#local.thisSpec.id#' )" title="Show more information">+</button><br>
							  <div class="">#local.thisSpec.failOrigin[ 1 ].raw_trace#</div>
							  <cfif structKeyExists( local.thisSpec.failOrigin[ 1 ], "codePrintHTML" )>
								<div class="">#local.thisSpec.failOrigin[ 1 ].codePrintHTML#</div>
							  </cfif>
							<div class="box debugdata" data-specid="#local.thisSpec.id#">
								<cfdump var="#local.thisSpec.failorigin#" label="Failure Origin">
							</div>
						</cfif>

						<cfif local.thisSpec.status eq "error">
							- <strong>#htmlEditFormat( local.thisSpec.error.message )#</strong>
							  <button onclick="toggleDebug( '#local.thisSpec.id#' )" title="Show more information">+</button><br>
							  <div class="">#local.thisSpec.failOrigin[ 1 ].raw_trace#</div>
							  <cfif structKeyExists( local.thisSpec.failOrigin[ 1 ], "codePrintHTML" )>
								<div class="">#local.thisSpec.failOrigin[ 1 ].codePrintHTML#</div>
							  </cfif>
							<div class="box debugdata" data-specid="#local.thisSpec.id#">
								<cfdump var="#local.thisSpec.error#" label="Exception Structure">
							</div>
						</cfif>
					</li>
				</div>
				</ul>
			</cfloop>

			<!--- Do we have nested suites --->
			<cfif arrayLen( arguments.suiteStats.suiteStats )>
				<cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite">
					<div class="suite #lcase( arguments.suiteStats.status )#" data-bundleid="#arguments.bundleStats.id#">
						<ul>
						#genSuiteReport( local.nestedSuite, arguments.bundleStats )#
					</ul>
					</div>
				</cfloop>
			</cfif>

		</cfoutput>
	</cfsavecontent>

	<cfreturn local.report>
</cffunction>
</cfoutput>