<cfoutput>
<div class="jumbotron">
	<div class="row">
		<div class="col-md-5">
			<img src="views/_includes/images/ColdBoxLogo2015_300.png" class="pull-left margin10" alt="logo"/>
		</div>

		<div class="col-md-7">
			<h1>#prc.welcomeMessage#</h1>
			<p>You are now running <strong>#getSetting("codename",1)# #getSetting("version",1)# (#getsetting("suffix",1)#)</strong>. Welcome to the next generation of ColdFusion (CFML) applications.  You can now start building your application with ease, we already did the hard work for you.</p>
			<p>
				<a class="btn btn-primary" href="http://coldbox.ortusbooks.com" target="_blank" title="Read our ColdBox Manual" rel="tooltip">
					<strong>Read ColdBox Manual</strong>
				</a>
			</p>
		</div>
	</div>
</div>

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