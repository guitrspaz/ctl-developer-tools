<cfset prc.docHTMLPath=(FindNoCase('-web',CGI.HTTP_HOST))?'/docs':ExpandPath('/docs') />
<div class="embed-responsive embed-responsive-4by3">
	<iframe src="<cfoutput>#prc.docHTMLPath#</cfoutput>" class="embed-responsive-item"></iframe>
</div>