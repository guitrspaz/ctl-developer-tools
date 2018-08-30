<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>CoursePlus Developer Tools</title>
	<meta name="description" content="CoursePlus Developer Tools">
    <meta name="author" content="CTL">
	<!---Base URL --->
	<base href="#event.getHTMLBaseURL()#" />
	<!---css --->
	<link href="node_modules/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="views/_includes/css/application-custom.css" rel="stylesheet" type="text/css" />
	<cfif structKeyExists(prc,'css') AND isValid('array',prc.css)>
		<cfloop from="1" to="#ArrayLen(prc.css)#" index="c">
			<link href="#prc.css[c]#" rel="stylesheet" type="text/css" />
		</cfloop>
	</cfif>
	<!---js --->
	<script type="text/javascript" src="node_modules/requirejs/require.js"></script>
	<!--- <script type="text/javascript" src="node_modules/normalize/lib/normalize.js"></script> --->
	<script type="text/javascript" src="node_modules/jquery/dist/jquery.min.js"></script>
	<script type="text/javascript" src="node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
	<script src="views/_includes/js/application-custom.js"></script>
	<cfif structKeyExists(prc,'scripts') AND isValid('array',prc.scripts)>
		<cfloop from="1" to="#ArrayLen(prc.scripts)#" index="s">
			<script src="#prc.scripts[s]#" type="text/javascript"></script>
		</cfloop>
	</cfif>
</head>
<body data-spy="scroll">
	<!---Top NavBar --->
	<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
		<div class="container-fluid">
			<div class="ctl-dt-btn-nav">
				<div class="pull-right ctl-dt-btn-brand"><a href="#event.buildLink('main')#">CTL Developer Tools Application</a></div>
				<div class="pull-left">
					<div class="btn-group">
						<a href="#event.buildLink('')#" class="btn btn-primary">Tools</a>
						<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<span class="caret"></span>
							<span class="sr-only">Toggle Dropdown</span>
						</button>
						<ul class="dropdown-menu">
							<li><a href="#event.buildLink('')#"><strong>Log Reader</strong></a></li>
							<li><a href="#event.buildLink('docs')#"><strong>CoursePlus API Docs</strong></a></li>
							<li><a href="#event.buildLink('testing:TestSuite.index')#"><strong>Test Browser</strong></a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#event.buildLink('main')#">Application Properties</a></li>
							<li><a href="#event.buildLink('main.dump')#">ColdBox Event Dump</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="http://coldbox.ortusbooks.com" target="_blank">ColdBox Manual</a></li>
							<li><a href="http://testbox.ortusbooks.com" target="_blank">TestBox Manual</a></li>
							<li><a href="http://wirebox.ortusbooks.com" target="_blank">WireBox Manual</a></li>
							<li><a href="http://logbox.ortusbooks.com" target="_blank">LogBox Manual</a></li>
							<li><a href="https://github.com/Ortus-Solutions/DocBox" target="_blank">DocBox Documentation</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#event.buildLink(event.getCurrentRoutedURL())#?fwreinit=1"><strong class="text-danger">Reload Application</strong></a></li>
							<li><a href="#event.buildLink('docs.reload')#"><strong class="text-danger">Recompile API Docs</strong></a></li>
						</ul>
					</div>
				</div>
			</div>
		</div> <!---end container --->
	</nav> <!---end navbar --->

	<!---Container And Views --->
	<div class="container-fluid">#renderView()#</div>
</body>
</html>
</cfoutput>
