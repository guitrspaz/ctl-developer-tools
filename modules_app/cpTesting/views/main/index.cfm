<cfoutput>
	<article id="articleTop" class="container-fluid">
		<div>
			<h2>#prc.sectionTitle#</h2>
		</div>
		<p>
			Below is a listing of the files and folders starting from your root <code>#prc.testData.root#</code>.  You can click on individual tests in order to execute them
			or click on the <strong>Run All</strong> button above and it will execute a directory runner from the visible folder.
		</p>
		<form name="runnerForm" id="runnerForm">
			<input type="hidden" name="opt_run" id="opt_run" value="true" />
			<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
				<div class="panel panel-primary">
					<div class="panel-heading clearfix">
						<cfscript>
							WriteOutput(prc.testData.breadcrumbs);
						</cfscript>
						<div class="btn-group pull-right">
							<a role="button" class="btn btn-default tb-toggle-btn" data-toggle="collapse" data-parent="##accordion" href="##contents" aria-expanded="true" aria-controls="contents"><span class="tb-accordion-btn-text">Collapse</span></a>
						</div>
					</div>
					<ul id="contents" class="collapse list-group in" role="tabpanel" aria-label="Contents: #prc.testData.root#">
						<cfloop query="prc.testData.directories">
							<cfif LCase(prc.testData.directories.type) EQ "dir"
								AND prc.testData.directories.name NEQ "reporters"
								AND Left(Trim(prc.testData.directories.name),1) NEQ '.'
							>
								<li class="list-group-item">
									<span class="btn-group">
										<a class="btn btn-success tb-dir-btn tb-file-btn"
											role="button"
											href="#event.buildLink('testing:TestSuite.runner',true,true,'','directory=#prc.testData.encodedRoot#:#prc.testData.directories.name#')#"
										><span class="glyphicon glyphicon-play-circle" aria-hidden="true"></span></a>
										<a class="btn btn-default tb-dir-btn"
											role="button"
											href="#event.buildLink('testing:TestSuite.index',true,true,'','path=#prc.testData.encodedRoot#:#prc.testData.directories.name#')#"
										><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span></a>
									</span>
									<a href="#event.buildLink('testing:TestSuite.index',true,true,'','path=#prc.testData.encodedRoot#:#prc.testData.directories.name#')#"><span style="text-transform:capitalize;">#prc.testData.directories.name#</span></a>
								</li>
							<cfelseif listLast( prc.testData.directories.name, ".") EQ "cfc" and prc.testData.directories.name NEQ "Application.cfc">
								<cfset newname=ReplaceNoCase(prc.testData.directories.name,'.cfc','','ONE') />
								<li class="list-group-item">
									<span class="btn-group">
										<a class="btn btn-success tb-dir-btn tb-file-btn"
											role="button"
											href="#event.buildLink('testing:TestSuite.runner',true,true,'','directory=#prc.testData.encodedRoot#&testBundles=#prc.testData.package#.#newname#')#"
										><span class="glyphicon glyphicon-play-circle" aria-hidden="true"></span></a>
									</span>
									<a class="tb-file-btn"
										href="#event.buildLink('testing:TestSuite.runner',true,true,'','directory=#prc.testData.encodedRoot#&testBundles=#prc.testData.package#.#newname#')#"
									><span style="text-transform:capitalize;">#prc.testData.directories.name#</span></a>
								</li>
							</cfif>
						</cfloop>
					</ul>
				</div>
			</div>
		</form>
		<!--- Results --->
		<div class="container" id="tb-results"></div>
	</article>
</cfoutput>