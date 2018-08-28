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
			<!---Brand --->
			<div class="navbar-header">
				<!---Responsive Design --->
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##navbar-collapse">
					<span class="sr-only">Toggle navigation</span>
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
				</button>
				<div class="navbar-brand">
					<a href="##" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span>
					</a>
					<ul id="tools-submenu" class="dropdown-menu">
						<li><a href="#event.buildLink('')#"><strong>Log Reader</strong></a></li>
						<li><a href="#event.buildLink('main.docs')#"><strong>API Docs</strong></a></li>
						<li><a href="#event.buildLink('testing:TestSuite.index')#"><strong>Test Browser</strong></a></li>
					</ul>
				</div>
			</div>

			<div class="collapse navbar-collapse" id="navbar-collapse">
				<!---About --->
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="##" class="dropdown-toggle" data-toggle="dropdown">
							<span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> Framework <span class="caret"></span>
						</a>
						<ul id="actions-submenu" class="dropdown-menu">
							<li><a href="#event.buildLink('main')#">Application Properties</a></li>
							<li><a href="#event.buildLink('main.dump')#">Event Dumper</a></li>
							<li class="divider"></li>
							<li><a href="http://coldbox.ortusbooks.com" target="_blank">Help Manual</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div> <!---end container --->
	</nav> <!---end navbar --->

	<!---Container And Views --->
	<div class="container-fluid">#renderView()#</div>
</body>
</html>
</cfoutput>
