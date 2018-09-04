<cfoutput>
	<article id="articleTop" class="container-fluid">
		<form name="articleForm" id="pageForm" class="ml-form" action="#event.buildLink('')#" method="post">
			<div class="form-group">
				<textarea class="form-control" contenteditable="true" name="jsonData" id="jsonData" placeholder="Paste JSON data..." rows="12"><cfif StructKeyExists(prc,'jsonData')>#prc.jsonData#</cfif></textarea>
			</div>
			<div class="btn-group" role="group" aria-label="formButtons">
				<button type="submit" class="btn btn-default">Submit</button>
				<button id="clear" class="btn btn-default">Clear</button>
				<button id="reset" class="btn btn-primary">Reset</button>
			</div>
		</form>
		<cfif StructKeyExists(prc,'parsedJSON')
			AND isValid('struct',prc.parsedJSON)
			AND NOT StructIsEmpty(prc.parsedJSON)
		>
			<a name="dumpTableTop" id="dumpTableTop"></a>
			<div id="dumpTable" class="ml-cfdump-table">
				<cfdump var="#prc.parsedJSON#" />
			</div>
			<a name="dumpTableBottom" id="dumpTableBottom"></a>
		</cfif>
		<!---
		<div class="ml-cfdump-table">
			<cfdump var="#rc#" label="rc" />
			<cfdump var="#prc#" label="prc" />
		</div>
		--->
		<div id="articleBottom"></div>
	</article>
	<div id="pageFooter" class="container-fluid">
		<nav class="navbar navbar-default navbar-fixed-bottom">
			<div class="container-fluid">
				<ul class="nav navbar-nav pull-right nav-pills" aria-label="Page locations">
					<li role="presentation" class="active"><a href="##pageForm" class="cst-controller target-reset" role="button">Reset</a></li>
					<li role="separator" class="divider"></li>
					<li role="presentation"><a href="##articleTop" class="cst-controller" role="button">Top</a></li>
					<li role="presentation"><a href="##articleForm" class="cst-controller" role="button">Form</a></li>
					<li role="presentation"><a href="##dumpTableTop" class="cst-controller" role="button">Results</a></li>
					<li role="presentation"><a href="##dumpTableBottom" class="cst-controller" role="button">Results End</a></li>
					<li role="presentation"><a href="##articleBottom" class="cst-controller" role="button">Bottom</a></li>
				</ul>
			</div>
		</nav>
	</div>

</cfoutput>