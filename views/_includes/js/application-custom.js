
if( jQuery!==null ){
	jQuery(document).ready(function(){
		// activate all drop downs
		jQuery('.dropdown-toggle').dropdown();
		// Tooltips
		jQuery("[rel=tooltip]").tooltip();
	});
}