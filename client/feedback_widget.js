Template.home.rendered = function() { 
	window.webengageWidgetInit = window.webengageWidgetInit || function(){
		webengage.init({
			licenseCode:"~2024bbc5"
		}).onReady(function(){
			webengage.render();
		});
	};

	(function(d){
		debugger;
		var _we = d.createElement('script');
		_we.type = 'text/javascript';
		_we.async = true;
		_we.src = (d.location.protocol == 'https:' ? "//ssl.widgets.webengage.com" : "//cdn.widgets.webengage.com") + "/js/widget/webengage-min-v-3.0.js";
		var _sNode = d.getElementById('_webengage_script_tag');
		_sNode.parentNode.insertBefore(_we, _sNode);
	})(document);
};
