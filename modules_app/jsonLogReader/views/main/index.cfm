<cfoutput>
	<article id="sitecontent" class="container-fluid">
		<div class="row">
			<form name="pageForm" id="pageForm" class="ml-form" action="#event.buildLink('json')#" method="post">
				<div class="form-group">
					<label for="jsonData">Paste Log Data</label>
					<textarea class="form-control" contenteditable="true" name="jsonData" id="jsonData" rows="12"><cfif StructKeyExists(prc,'jsonData')>#prc.jsonData#</cfif></textarea>
				</div>
				<div class="btn-group" role="group" aria-label="formButtons">
					<button type="submit" class="btn btn-default">Submit</button>
					<button id="clear" class="btn btn-default">Clear</button>
					<button id="reset" class="btn btn-primary">Reset</button>
				</div>
			</form>
		</div>
		<cfif StructKeyExists(prc,'parsedJSON')
			AND isValid('struct',prc.parsedJSON)
			AND NOT StructIsEmpty(prc.parsedJSON)
		>
			<div class="row">
				<a name="dumpTableTop" id="dumpTableTop"></a>
				<div id="dumpTable" class="ml-cfdump-table">
					<cfdump var="#prc.parsedJSON#" />
				</div>
				<a name="dumpTableBottom" id="dumpTableBottom"></a>
			</div>
		</cfif>
		<!---
		<div class="ml-cfdump-table">
			<cfdump var="#rc#" label="rc" />
			<cfdump var="#prc#" label="prc" />
		</div>
		--->
	</article>
	<div id="pageBottom"></div>
	<div id="pageFooter" class="container-fluid">
		<nav class="navbar navbar-default navbar-fixed-bottom">
			<div class="container-fluid">
				<ul class="nav navbar-nav pull-right nav-pills" aria-label="Page locations">
					<li role="presentation" class="active"><a href="##pageForm" class="cst-controller target-reset" role="button">Reset</a></li>
					<li role="separator" class="divider"></li>
					<li role="presentation"><a href="##sitecontent" class="cst-controller" role="button">Top</a></li>
					<li role="presentation"><a href="##pageForm" class="cst-controller" role="button">Form</a></li>
					<li role="presentation"><a href="##dumpTableTop" class="cst-controller" role="button">Results</a></li>
					<li role="presentation"><a href="##dumpTableBottom" class="cst-controller" role="button">Results End</a></li>
					<li role="presentation"><a href="##pageBottom" class="cst-controller" role="button">Bottom</a></li>
				</ul>
			</div>
		</nav>
	</div>

</cfoutput>