<cfoutput>
	<cfdump var="#prc#" />
<!---
	<article id="articleTop" class="container-fluid">
		<div class="site-content-contain">
			<div id="content" class="site-content">
				<div id="primary" class="content-area">
					<h1>#prc.sectionTitle#</h1>
					<p>
						Below is a listing of the files and folders starting from your root <code>#variables.attrs.testRoot#</code>.  You can click on individual tests in order to execute them
						or click on the <strong>Run All</strong> button above and it will execute a directory runner from the visible folder.
					</p>
					<form name="runnerForm" id="runnerForm">
						<input type="hidden" name="opt_run" id="opt_run" value="true" />
						<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
							<div class="panel panel-primary">
								<div class="panel-heading clearfix">
									<cfscript>
										WriteOutput(variables.attrs.breadcrumbNav);
									</cfscript>
									<div class="btn-group pull-right">
										<a role="button" class="btn btn-default tb-toggle-btn" data-toggle="collapse" data-parent="##accordion" href="##contents" aria-expanded="true" aria-controls="contents"><span class="tb-accordion-btn-text">Collapse</span></a>
									</div>
								</div>
								<ul id="contents" class="collapse list-group in" role="tabpanel" aria-label="Contents: #variables.attrs.testRoot#">
									<cfloop query="variables.attrs.directoryContents">
										<cfif LCase(variables.attrs.directoryContents.type) EQ "dir" AND variables.attrs.directoryContents.name NEQ "reporters">
											<li class="list-group-item">
												<span class="btn-group">
													<a class="btn btn-success tb-dir-btn tb-file-btn"
														role="button"
														href="#application.testboxRoot#assets/cfm/runner.cfm?directory=#variables.attrs.directoryRunnerPath#"
													><span class="glyphicon glyphicon-play-circle" aria-hidden="true"></span></a>
													<a class="btn btn-default tb-dir-btn"
														role="button"
														href="#application.testboxRoot#index.cfm?path=#URLEncodedFormat(variables.attrs.linkPath)#"
													><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span></a>
												</span>
												<a href="#application.base#index.cfm?path=#URLEncodedFormat(variables.attrs.linkPath)#"><span style="text-transform:capitalize;">#variables.attrs.niceName#</span></a>
											</li>
										<cfelseif listLast( variables.attrs.directoryContents.name, ".") EQ "cfm" and variables.attrs.directoryContents.name NEQ "Application.cfm">
											<li class="list-group-item">
												<span class="btn-group">
													<a class="btn btn-success tb-dir-btn tb-file-btn"
														role="button"
														href="#application.testboxRoot#assets/cfm/tests/#variables.attrs.directoryContents.name#"
														<cfif !variables.attrs.cpu>target="_blank"</cfif>
													><span class="glyphicon glyphicon-play-circle" aria-hidden="true"></span></a>
												</span>
												<a class="tb-file-btn"
													href="#application.testboxRoot#assets/cfm/tests/#variables.attrs.directoryContents.name#"
													<cfif !variables.attrs.cpu>target="_blank"</cfif>
												><span style="text-transform:capitalize;">#variables.attrs.niceName#</span></a>
											</li>
										<cfelseif listLast( variables.attrs.directoryContents.name, ".") EQ "cfc" and variables.attrs.directoryContents.name NEQ "Application.cfc">
											<li class="list-group-item">
												<span class="btn-group">
													<a class="btn btn-success tb-dir-btn tb-file-btn"
														role="button"
														href="#application.testboxRoot#assets/cfm/runner.cfm?directory=#variables.attrs.directoryRunnerPath#&method=runRemote&testBundles=#URLEncodedFormat(variables.attrs.testBundles)#"
														<cfif !variables.attrs.cpu>target="_blank"</cfif>
													><span class="glyphicon glyphicon-play-circle" aria-hidden="true"></span></a>
												</span>
												<a class="tb-file-btn"
													href="#application.testboxRoot#assets/cfm/runner.cfm?directory=#variables.attrs.directoryRunnerPath#&method=runRemote&testBundles=#URLEncodedFormat(variables.attrs.testBundles)#"
													<cfif !variables.attrs.cpu>target="_blank"</cfif>
												><span style="text-transform:capitalize;">#variables.attrs.niceName#</span></a>
											</li>
										</cfif>
									</cfloop>
								</ul>
							</div>
						</div>
					</form>
					<!--- Results --->
					<div class="container" id="tb-results"></div>
				</div>
			</div>
		</div>
	</article>
--->
</cfoutput>