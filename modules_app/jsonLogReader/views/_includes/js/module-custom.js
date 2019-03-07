if( jQuery!==null ){
	function serializeObject(obj){
		var o={};
		var a=jQuery(obj).serializeArray();
		jQuery.each(a,function(k,v){
			if (o[v.name] !== undefined) {
				if (!o[v.name].push) {
					o[v.name]=[o[v.name]];
				}
				o[v.name].push(v.value || '');
			} else {
				o[v.name]=v.value || '';
			}
		});
		return o;
	}

	jQuery(document).ready(function(){
		if( jQuery('#jsonData').text().trim()=='' ){
			jQuery('#jsonData').focus();
		} else {
			console.log(jQuery('#jsonData').text());
		}
		jQuery(document).on('click','#reset',function(e){
			e.preventDefault();
			jQuery('#jsonData').text('');
			jQuery('#jsonData').val();
			jQuery('#dumpTable').html('');
			jQuery('#jsonData').focus();
			return false;
		});

		jQuery(document).on('click','.target-reset',function(e){
			e.preventDefault();
			jQuery('#reset').trigger('click');
			return false;
		});
		jQuery(document).on('click','#clear',function(e){
			e.preventDefault();
			jQuery('#jsonData').text('');
			jQuery('#jsonData').val();
			return false;
		});
		jQuery(document).on('paste','#jsonData',function(e){
			setTimeout(function(){
				jQuery(e.currentTarget).prop('readonly',true);
				jQuery('#pageForm').trigger('submit');
			},1000);
		});
		jQuery(document).on('click','.cst-controller',function(event){
			var href=jQuery(event.currentTarget).attr('href');
			jQuery('html,body').animate({
				scrollTop: jQuery(href).offset().top
			},1000);
			return false;
		});
	});
}