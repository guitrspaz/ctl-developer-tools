<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Welcome to Coldbox!</title>
	<meta name="description" content="ColdBox Application Template">
    <meta name="author" content="Ortus Solutions, Corp">
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
						<li><a href="#event.buildLink('main')#"><strong>Home</strong></a></li>
						<li><a href="#event.buildLink('')#"><strong>Log Reader</strong></a></li>
						<li><a href="#event.getHTMLBaseURL()#docs/index.html"><strong>API Docs</strong></a></li>
						<li><a href="#event.buildLink('testing')#"><strong>Test Browser</strong></a></li>
						<li><a href="#event.buildLink('main.dump')#"><strong>Event Dumper</strong></a></li>
					</ul>
				</div>
			</div>

			<div class="collapse navbar-collapse" id="navbar-collapse">
				<!---About --->
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="##" class="dropdown-toggle" data-toggle="dropdown">
							<i class="glyphicon glyphicon-info-sign"></i> About <b class="caret"></b>
						</a>
						<ul id="actions-submenu" class="dropdown-menu">
							 <li><a href=""><strong>#getSetting("codename",1)# (#getsetting("suffix",1)#)</strong></a></li>
							 <li><a href="http://coldbox.ortusbooks.com"><i class="glyphicon glyphicon-book"></i> Help Manual</a></li>
							 <li><a href="mailto:bugs@coldbox.org?subject=DataBoss Bug Report"><i class="glyphicon glyphicon-fire"></i> Report a Bug</a></li>
							 <li><a href="mailto:info@coldbox.org?subject=DataBoss Feedback"><i class="glyphicon glyphicon-bullhorn"></i> Send Us Feedback</a></li>
							 <li><a href="http://www.ortussolutions.com/products/coldbox"><i class="glyphicon glyphicon-home"></i> Professional Support</a></li>
							 <li class="divider"></li>
							 <li class="centered">
							 	<img width="150" src="views/_includes/images/ColdBoxLogo2015_300.png" alt="logo"/>
							 </li>
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
