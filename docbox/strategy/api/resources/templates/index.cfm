<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
	<link href='https://fonts.googleapis.com/css?family=Ubuntu:400,300,300italic,400italic,700,700italic|Ubuntu+Mono' rel='stylesheet' type='text/css' />
	<meta charset="utf-8">
	<title>Generated Documentation (#arguments.projecttitle#)</title>
	<meta name="description" content="CoursePlus Developer Tools">
    <meta name="author" content="CTL,DocBox">
	<!---Base URL --->
	<base href="../docs" />
	<!---css --->
	<link href="../node_modules/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<!---js --->
	<script type="text/javascript" src="../node_modules/requirejs/require.js"></script>
	<!--- <script type="text/javascript" src="node_modules/normalize/lib/normalize.js"></script> --->
	<script type="text/javascript" src="../node_modules/jquery/dist/jquery.min.js"></script>
	<script type="text/javascript" src="../node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	    targetPage = "" + window.location.search;
	    if (targetPage != "" && targetPage != "undefined")
	        targetPage = targetPage.substring(1);
	    if (targetPage.indexOf(":") != -1)
	        targetPage = "undefined";
	    function loadFrames() {
	        if (targetPage != "" && targetPage != "undefined")
	             top.classFrame.location = top.targetPage;
	    }
	</script>
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
						<li><a href="../index.cfm"><strong>Log Reader</strong></a></li>
						<li><a href="../docs"><strong>API Docs</strong></a></li>
						<li><a href="../index.cfm/testing"><strong>Test Browser</strong></a></li>
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
							<li><a href="../index.cfm/main">Application Properties</a></li>
							<li><a href="../index.cfm/main.dump">Event Dumper</a></li>
							<li class="divider"></li>
							<li><a href="http://coldbox.ortusbooks.com" target="_blank">Help Manual</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div> <!---end container --->
	</nav> <!---end navbar --->

	<!---Container And Views --->
	<div class="container-fluid">
		<frameset cols="20%,80%" title="" onLoad="top.loadFrames()">
			<frame src="overview-frame.html" name="packageListFrame" title="All Packages">
			<frame src="overview-summary.html" name="classFrame" title="Package, class and interface descriptions" scrolling="yes">
			<noframes>
				<H2>
				Frame Alert</H2>

				<P>
				This document is designed to be viewed using the frames feature. If you see this message, you are using a non-frame-capable web client.
				<BR>
				Link to<a href="overview-summary.html">Non-frame version.</a>
			</noframes>
		</frameset>
	</div>
</body>
</html>
</cfoutput>