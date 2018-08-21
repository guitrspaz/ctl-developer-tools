<cfoutput>
	<!--- stuff goes here --->

	<div class="row">
		<div class="col-md-9">
			<section id="eventHandlers">
				<div class="page-header">
					<h2>Registered Event Handlers</h2>
				</div>
				<p>You can click on the following event handlers to execute their default action <span class="label label-danger">index()</span></p>
				<ul class="list-group">
					<cfloop list="#getSetting("RegisteredHandlers")#" index="handler">
						<li class="list-group-item"><a href="#event.buildLink( handler )#">#handler#</a></li>
					</cfloop>
				</ul>
			</section>
		</div>
	</div>
</cfoutput>