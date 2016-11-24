<!DOCTYPE html>
<html lang="en" >

<head>

	
	<script>
window.ts_endpoint_url = "https:\/\/slack.com\/beacon\/timing";

(function(e) {
	var n=Date.now?Date.now():+new Date,r=e.performance||{},t=[],a={},i=function(e,n){for(var r=0,a=t.length,i=[];a>r;r++)t[r][e]==n&&i.push(t[r]);return i},o=function(e,n){for(var r,a=t.length;a--;)r=t[a],r.entryType!=e||void 0!==n&&r.name!=n||t.splice(a,1)};r.now||(r.now=r.webkitNow||r.mozNow||r.msNow||function(){return(Date.now?Date.now():+new Date)-n}),r.mark||(r.mark=r.webkitMark||function(e){var n={name:e,entryType:"mark",startTime:r.now(),duration:0};t.push(n),a[e]=n}),r.measure||(r.measure=r.webkitMeasure||function(e,n,r){n=a[n].startTime,r=a[r].startTime,t.push({name:e,entryType:"measure",startTime:n,duration:r-n})}),r.getEntriesByType||(r.getEntriesByType=r.webkitGetEntriesByType||function(e){return i("entryType",e)}),r.getEntriesByName||(r.getEntriesByName=r.webkitGetEntriesByName||function(e){return i("name",e)}),r.clearMarks||(r.clearMarks=r.webkitClearMarks||function(e){o("mark",e)}),r.clearMeasures||(r.clearMeasures=r.webkitClearMeasures||function(e){o("measure",e)}),e.performance=r,"function"==typeof define&&(define.amd||define.ajs)&&define("performance",[],function(){return r}) // eslint-disable-line
})(window);

</script>
<script>;(function() {

'use strict';


window.TSMark = function(mark_label) {
	if (!window.performance || !window.performance.mark) return;
	performance.mark(mark_label);
};
window.TSMark('start_load');


window.TSMeasureAndBeacon = function(measure_label, start_mark_label) {
	if (start_mark_label === 'start_nav' && window.performance && window.performance.timing) {
		window.TSBeacon(measure_label, (new Date()).getTime() - performance.timing.navigationStart);
		return;
	}
	if (!window.performance || !window.performance.mark || !window.performance.measure) return;
	performance.mark(start_mark_label + '_end');
	try {
		performance.measure(measure_label, start_mark_label, start_mark_label + '_end');
		window.TSBeacon(measure_label, performance.getEntriesByName(measure_label)[0].duration);
	} catch(e) { return; }
};


window.TSBeacon = function(label, value) {
	var endpoint_url = window.ts_endpoint_url || 'https://slack.com/beacon/timing';
	(new Image()).src = endpoint_url + '?data=' + encodeURIComponent(label + ':' + value);
};

})();
</script>
 

<script>
window.TSMark('step_load');
</script>	<noscript><meta http-equiv="refresh" content="0; URL=/files/aristeujnr/F3585HWFJ/atualizador43to44.sh?nojsmode=1" /></noscript>
<script>(function() {
        'use strict';

	var start_time = Date.now();
	var logs = [];
	var connecting = true;
	var ever_connected = false;
	var log_namespace;

	var logWorker = function(ob) {
		var log_str = ob.secs+' start_label:'+ob.start_label+' measure_label:'+ob.measure_label+' description:'+ob.description;

		if (TS.metrics.getLatestMark(ob.start_label)) {
			TS.metrics.measure(ob.measure_label, ob.start_label);
			TS.log(88, log_str);

			if (ob.do_reset) {
				window.TSMark(ob.start_label);
			}
		} else {
			TS.maybeWarn(88, 'not timing: '+log_str);
		}
	}

	var log = function(k, description) {
		var secs = (Date.now()-start_time)/1000;

		logs.push({
			k: k,
			d: description,
			t: secs,
			c: !!connecting
		})

		if (!window.boot_data) return;
		if (!window.TS) return;
		if (!TS.metrics) return;
		if (!connecting) return;

		
		log_namespace = log_namespace || (function() {
			if (boot_data.app == 'client') return 'client';
			if (boot_data.app == 'space') return 'post';
			if (boot_data.app == 'api') return 'apisite';
			if (boot_data.app == 'mobile') return 'mobileweb';
			if (boot_data.app == 'web' || boot_data.app == 'oauth') return 'web';
			return 'unknown';
		})();

		var modifier = (TS.boot_data.feature_no_rollups) ? '_no_rollups' : '';

		logWorker({
			k: k,
			secs: secs,
			description: description,
			start_label: ever_connected ? 'start_reconnect' : 'start_load',
			measure_label: 'v2_'+log_namespace+modifier+(ever_connected ? '_reconnect__' : '_load__')+k,
			do_reset: false,
		});
	}

	var setConnecting = function(val) {
		val = !!val;
		if (val == connecting) return;

		if (val) {
			log('start');
			if (ever_connected) {
				
				window.TSMark('start_reconnect');
				window.TSMark('step_reconnect');
				window.TSMark('step_load');
			}

			connecting = val;
			log('start');
		} else {
			log('over');
			ever_connected = true;
			connecting = val;
		}
	}

	window.TSConnLogger = {
		log: log,
		logs: logs,
		start_time: start_time,
		setConnecting: setConnecting
	}
})();</script>

<script type="text/javascript">
if(self!==top)window.document.write("\u003Cstyle>body * {display:none !important;}\u003C\/style>\u003Ca href=\"#\" onclick="+
"\"top.location.href=window.location.href\" style=\"display:block !important;padding:10px\">Go to Slack.com\u003C\/a>");

(function() {
	var timer;
	if (self !== top) {
		timer = window.setInterval(function() {
			if (window.$) {
				try {
					$('#page').remove();
					$('#client-ui').remove();
					window.TS = null;
					window.clearInterval(timer);
				} catch(e) {}
			}
		}, 200);
	}
}());

</script>

<script>(function() {
        'use strict';

        window.callSlackAPIUnauthed = function(method, args, callback) {
                var timestamp = Date.now() / 1000;  
                var version = (window.TS && TS.boot_data) ? TS.boot_data.version_uid.substring(0, 8) : 'noversion';
                var url = '/api/' + method + '?_x_id=' + version + '-' + timestamp;
                var req = new XMLHttpRequest();

                req.onreadystatechange = function() {
                        if (req.readyState == 4) {
                                req.onreadystatechange = null;
                                var obj;

                                if (req.status == 200 || req.status == 429) {
                                        try {
                                                obj = JSON.parse(req.responseText);
                                        } catch (err) {
                                                console.warn('unable to do anything with api rsp');
                                        }
                                }

                                obj = obj || {
                                        ok: false
                                }

                                callback(obj.ok, obj, args);
                        }
                }

                var async = true;
                req.open('POST', url, async);

                var form_data = new FormData();
                var has_data = false;
                Object.keys(args).map(function(k) {
                        if (k[0] === '_') return;
                        form_data.append(k, args[k]);
                        has_data = true;
                });

                if (has_data) {
                        req.send(form_data);
                } else {
                        req.send();
                }
        }
})();</script>

						
	
		<script>
			if (window.location.host == 'slack.com' && window.location.search.indexOf('story') < 0) {
				document.cookie = '__cvo_skip_doc=' + escape(document.URL) + '|' + escape(document.referrer) + ';path=/';
			}
		</script>
	

		<script type="text/javascript">
		
		try {
			if(window.location.hash && !window.location.hash.match(/^(#?[a-zA-Z0-9_]*)$/)) {
				window.location.hash = '';
			}
		} catch(e) {}
		
	</script>

	<script type="text/javascript">
				(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		ga('create', "UA-106458-17", 'slack.com');

		
			window.optimizely = [];
		
		
		ga('send', 'pageview');
	
		(function(e,c,b,f,d,g,a){e.SlackBeaconObject=d;
		e[d]=e[d]||function(){(e[d].q=e[d].q||[]).push([1*new Date(),arguments])};
		e[d].l=1*new Date();g=c.createElement(b);a=c.getElementsByTagName(b)[0];
		g.async=1;g.src=f;a.parentNode.insertBefore(g,a)
		})(window,document,"script","https://a.slack-edge.com/4e6c/js/libs/slack_beacon.js","sb");
		sb('set', 'token', '3307f436963e02d4f9eb85ce5159744c');

					sb('set', 'user_id', "U28PVNJLE");
							sb('set', 'user_' + "batch", "?");
							sb('set', 'user_' + "created", "2016-09-06");
						sb('set', 'name_tag', "teleduc-nied" + '/' + "elvisr");
				sb('track', 'pageview');

		function track(a){ga('send','event','web',a);sb('track',a);}

	</script>



<script type='text/javascript'>
	
	/* safety stub */
	window.mixpanel = {
		track: function() {},
		track_links: function() {},
		track_forms: function() {}
	};

	function mixpanel_track(){}
	function mixpanel_track_forms(){}
	function mixpanel_track_links(){}
	
</script>
	
	<meta name="referrer" content="no-referrer">
		<meta name="superfish" content="nofish">

	<script type="text/javascript">



var TS_last_log_date = null;
var TSMakeLogDate = function() {
	var date = new Date();

	var y = date.getFullYear();
	var mo = date.getMonth()+1;
	var d = date.getDate();

	var time = {
	  h: date.getHours(),
	  mi: date.getMinutes(),
	  s: date.getSeconds(),
	  ms: date.getMilliseconds()
	};

	Object.keys(time).map(function(moment, index) {
		if (moment == 'ms') {
			if (time[moment] < 10) {
				time[moment] = time[moment]+'00';
			} else if (time[moment] < 100) {
				time[moment] = time[moment]+'0';
			}
		} else if (time[moment] < 10) {
			time[moment] = '0' + time[moment];
		}
	});

	var str = y + '/' + mo + '/' + d + ' ' + time.h + ':' + time.mi + ':' + time.s + '.' + time.ms;
	if (TS_last_log_date) {
		var diff = date-TS_last_log_date;
		//str+= ' ('+diff+'ms)';
	}
	TS_last_log_date = date;
	return str+' ';
}

var parseDeepLinkRequest = function(code) {
	var m = code.match(/"id":"([CDG][A-Z0-9]{8})"/);
	var id = m ? m[1] : null;

	m = code.match(/"team":"(T[A-Z0-9]{8})"/);
	var team = m ? m[1] : null;

	m = code.match(/"message":"([0-9]+\.[0-9]+)"/);
	var message = m ? m[1] : null;

	return { id: id, team: team, message: message };
}

if ('rendererEvalAsync' in window) {
	var origRendererEvalAsync = window.rendererEvalAsync;
	window.rendererEvalAsync = function(blob) {
		try {
			var data = JSON.parse(decodeURIComponent(atob(blob)));
			if (data.code.match(/handleDeepLink/)) {
				var request = parseDeepLinkRequest(data.code);
				if (!request.id || !request.team || !request.message) return;

				request.cmd = 'channel';
				TSSSB.handleDeepLinkWithArgs(JSON.stringify(request));
				return;
			} else {
				origRendererEvalAsync(blob);
			}
		} catch (e) {
		}
	}
}
</script>



<script type="text/javascript">

	var TSSSB = {
		call: function() {
			return false;
		}
	};

</script>
<script>TSSSB.env = (function() {
	'use strict';

	var v = {
		win_ssb_version: null,
		win_ssb_version_minor: null,
		mac_ssb_version: null,
		mac_ssb_version_minor: null,
		mac_ssb_build: null,
		lin_ssb_version: null,
		lin_ssb_version_minor: null,
		desktop_app_version: null
	};

	var is_win = (navigator.appVersion.indexOf("Windows") !== -1);
	var is_lin = (navigator.appVersion.indexOf("Linux") !== -1);
	var is_mac = !!(navigator.userAgent.match(/(OS X)/g));

	if (navigator.userAgent.match(/(Slack_SSB)/g) || navigator.userAgent.match(/(Slack_WINSSB)/g)) {
		
		var parts = navigator.userAgent.split('/');
		var version_str = parts[parts.length-1];
		var version_float = parseFloat(version_str);
		var version_parts = version_str.split('.');
		var version_minor = (version_parts.length == 3) ? parseInt(version_parts[2]) : 0;

		if (navigator.userAgent.match(/(AtomShell)/g)) {
			
			if (is_lin) {
				v.lin_ssb_version = version_float;
				v.lin_ssb_version_minor = version_minor;
			} else if (is_win) {
				v.win_ssb_version = version_float;
				v.win_ssb_version_minor = version_minor;
			} else if (is_mac) {
				v.mac_ssb_version = version_float;
				v.mac_ssb_version_minor = version_minor;
			}

			if (version_parts.length >= 3) {
				v.desktop_app_version = {
					major: parseInt(version_parts[0]),
					minor: parseInt(version_parts[1]),
					patch: parseInt(version_parts[2])
				}
			}
		} else {
			
			v.mac_ssb_version = version_float;
			v.mac_ssb_version_minor = version_minor;

			
			
			var app_ver = window.macgap && macgap.app && macgap.app.buildVersion && macgap.app.buildVersion();
			var matches = String(app_ver).match(/(?:\()(.*)(?:\))/);
			v.mac_ssb_build = (matches && matches.length == 2) ? parseInt(matches[1] || 0) : 0;
		}
	}

	return v;
})();
</script>


	<script type="text/javascript">
		
		var was_TS = window.TS;
		delete window.TS;
		TSSSB.call('didFinishLoading');
		if (was_TS) window.TS = was_TS;
	</script>
	    <title>atualizador43to44.sh | TelEduc - NIED Slack</title>
    <meta name="author" content="Slack">

	
		
	
	
					
	
				
	
	
	
	
			<!-- output_css "core" -->
    <link href="https://a.slack-edge.com/7d03/style/rollup-plastic.css" rel="stylesheet" type="text/css" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)">

		<!-- output_css "before_file_pages" -->
    <link href="https://a.slack-edge.com/74a30/style/libs/codemirror.css" rel="stylesheet" type="text/css" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)">
    <link href="https://a.slack-edge.com/7b37b/style/codemirror_overrides.css" rel="stylesheet" type="text/css" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)">

	<!-- output_css "file_pages" -->
    <link href="https://a.slack-edge.com/12787/style/rollup-file_pages.css" rel="stylesheet" type="text/css" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)">

	<!-- output_css "regular" -->
    <link href="https://a.slack-edge.com/53d7/style/print.css" rel="stylesheet" type="text/css" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)">
    <link href="https://a.slack-edge.com/1d9c/style/libs/lato-1-compressed.css" rel="stylesheet" type="text/css" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)">

	

	
	
		<meta name="robots" content="noindex, nofollow" />
	

	
<link id="favicon" rel="shortcut icon" href="https://a.slack-edge.com/66f9/img/icons/favicon-32.png" sizes="16x16 32x32 48x48" type="image/png" />

<link rel="icon" href="https://a.slack-edge.com/0180/img/icons/app-256.png" sizes="256x256" type="image/png" />

<link rel="apple-touch-icon-precomposed" sizes="152x152" href="https://a.slack-edge.com/66f9/img/icons/ios-152.png" />
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="https://a.slack-edge.com/66f9/img/icons/ios-144.png" />
<link rel="apple-touch-icon-precomposed" sizes="120x120" href="https://a.slack-edge.com/66f9/img/icons/ios-120.png" />
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="https://a.slack-edge.com/66f9/img/icons/ios-114.png" />
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="https://a.slack-edge.com/0180/img/icons/ios-72.png" />
<link rel="apple-touch-icon-precomposed" href="https://a.slack-edge.com/66f9/img/icons/ios-57.png" />

<meta name="msapplication-TileColor" content="#FFFFFF" />
<meta name="msapplication-TileImage" content="https://a.slack-edge.com/66f9/img/icons/app-144.png" />
	
	<!--[if lt IE 9]>
	<script src="https://a.slack-edge.com/ef0d/js/libs/html5shiv.js"></script>
	<![endif]-->

</head>

<body class="			">

		  			<script>
		
			var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
			if (w > 1440) document.querySelector('body').classList.add('widescreen');
		
		</script>
	
  	
	

			

<nav id="site_nav" class="no_transition">

	<div id="site_nav_contents">

		<div id="user_menu">
			<div id="user_menu_contents">
				<div id="user_menu_avatar">
										<span class="member_image thumb_48" style="background-image: url('https://secure.gravatar.com/avatar/f7db7f3d81a4977190817a4d9d8084f6.jpg?s=192&d=https%3A%2F%2Fa.slack-edge.com%2F7fa9%2Fimg%2Favatars%2Fava_0002-192.png')" data-thumb-size="48" data-member-id="U28PVNJLE"></span>
					<span class="member_image thumb_36" style="background-image: url('https://secure.gravatar.com/avatar/f7db7f3d81a4977190817a4d9d8084f6.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2F66f9%2Fimg%2Favatars%2Fava_0002-72.png')" data-thumb-size="36" data-member-id="U28PVNJLE"></span>
				</div>
				<h3>Signed in as</h3>
				<span id="user_menu_name">elvisr</span>
			</div>
		</div>

		<div class="nav_contents">

			<ul class="primary_nav">
				<li><a href="/messages" data-qa="app"><i class="ts_icon ts_icon_angle_arrow_up_left"></i>Back to Slack</a></li>
				<li><a href="/home" data-qa="home"><i class="ts_icon ts_icon_home"></i>Home</a></li>
				<li><a href="/account" data-qa="account_profile"><i class="ts_icon ts_icon_user"></i>Account &amp; Profile</a></li>
				<li><a href="/apps/manage" data-qa="configure_apps" target="_blank"><i class="ts_icon ts_icon_plug"></i>Configure Apps</a></li>
				<li><a href="/archives"data-qa="archives"><i class="ts_icon ts_icon_archive" ></i>Message Archives</a></li>
				<li><a href="/files" data-qa="files"><i class="ts_icon ts_icon_all_files clear_blue"></i>Files</a></li>
				<li><a href="/team" data-qa="team_directory"><i class="ts_icon ts_icon_team_directory"></i>Directory</a></li>
									<li><a href="/stats" data-qa="statistics"><i class="ts_icon ts_icon_dashboard"></i>Statistics</a></li>
													<li><a href="/customize" data-qa="customize"><i class="ts_icon ts_icon_magic"></i>Customize</a></li>
													<li><a href="/account/team" data-qa="team_settings"><i class="ts_icon ts_icon_cog_o"></i>Team Settings</a></li>
							</ul>

			
		</div>

		<div id="footer">

			<ul id="footer_nav">
				<li><a href="/is" data-qa="tour">Tour</a></li>
				<li><a href="/downloads" data-qa="download_apps">Download Apps</a></li>
				<li><a href="/brand-guidelines" data-qa="brand_guidelines">Brand Guidelines</a></li>
				<li><a href="/help" data-qa="help">Help</a></li>
				<li><a href="https://api.slack.com" target="_blank" data-qa="api">API<i class="ts_icon ts_icon_external_link small_left_margin ts_icon_inherit"></i></a></li>
								<li><a href="/pricing" data-qa="pricing">Pricing</a></li>
				<li><a href="/help/requests/new" data-qa="contact">Contact</a></li>
				<li><a href="/terms-of-service" data-qa="policies">Policies</a></li>
				<li><a href="http://slackhq.com/" target="_blank" data-qa="our_blog">Our Blog</a></li>
				<li><a href="https://slack.com/signout/11041494833?crumb=s-1480005499-d2bf81dd2b-%E2%98%83" data-qa="sign_out">Sign Out<i class="ts_icon ts_icon_sign_out small_left_margin ts_icon_inherit"></i></a></li>
			</ul>

			<p id="footer_signature">Made with <i class="ts_icon ts_icon_heart"></i> by Slack</p>

		</div>

	</div>
</nav>	
			
<header>
			<a id="menu_toggle" class="no_transition" data-qa="menu_toggle_hamburger">
			<span class="menu_icon"></span>
			<span class="menu_label">Menu</span>
			<span class="vert_divider"></span>
		</a>
		<h1 id="header_team_name" class="inline_block no_transition" data-qa="header_team_name">
			<a href="/home">
				<i class="ts_icon ts_icon_home" /></i>
				TelEduc - NIED
			</a>
		</h1>
		<div class="header_nav">
			<div class="header_btns float_right">
				<a id="team_switcher" data-qa="team_switcher">
					<i class="ts_icon ts_icon_th_large ts_icon_inherit"></i>
					<span class="block label">Teams</span>
				</a>
				<a href="/help" id="help_link" data-qa="help_link">
					<i class="ts_icon ts_icon_life_ring ts_icon_inherit"></i>
					<span class="block label">Help</span>
				</a>
									<a href="/messages" data-qa="launch">
						<img src="https://a.slack-edge.com/66f9/img/icons/ios-64.png" srcset="https://a.slack-edge.com/66f9/img/icons/ios-32.png 1x, https://a.slack-edge.com/66f9/img/icons/ios-64.png 2x" />
						<span class="block label">Launch</span>
					</a>
							</div>
				                    <ul id="header_team_nav" data-qa="team_switcher_menu">
	                        	                            <li class="active">
	                            	<a href="https://teleduc-nied.slack.com/home" target="https://teleduc-nied.slack.com/">
	                            			                            			<i class="ts_icon small ts_icon_check_circle_o active_icon s"></i>
	                            			                            				                            		<i class="team_icon small" style="background-image: url('https://s3-us-west-2.amazonaws.com/slack-files2/avatars/2015-11-19/14943134544_01ce52d13fa08743c8dc_88.jpg');"></i>
		                            		                            		<span class="switcher_label team_name">TelEduc - NIED</span>
	                            	</a>
	                            </li>
	                        	                        <li id="add_team_option"><a href="https://slack.com/signin" target="_blank"><i class="ts_icon ts_icon_plus team_icon small"></i> <span class="switcher_label">Sign in to another team...</span></a></li>
	                    </ul>
	                		</div>
	
	
</header>	
	<div id="page" >

		<div id="page_contents" data-qa="page_contents" class="">

<p class="print_only">
	<strong>Created by aristeujnr on November 22, 2016 at 11:41 AM</strong><br />
	<span class="subtle_silver break_word">https://teleduc-nied.slack.com/files/aristeujnr/F3585HWFJ/atualizador43to44.sh</span>
</p>

<div class="file_header_container no_print"></div>

<div class="alert_container">
		<div class="file_public_link_shared alert" style="display: none;">
		
	<i class="ts_icon ts_icon_link"></i> Public Link: <a class="file_public_link" href="https://slack-files.com/T0B17EJQH-F3585HWFJ-bfb6e6aba6" target="new">https://slack-files.com/T0B17EJQH-F3585HWFJ-bfb6e6aba6</a>
</div></div>

<div id="file_page" class="card top_padding">

	<p class="small subtle_silver no_print meta">
		11KB Shell snippet created on <span class="date">November 22nd 2016</span>.
		This file is private.		<span class="file_share_list"></span>
	</p>

	<a id="file_action_cog" class="action_cog action_cog_snippet float_right no_print">
		<span>Actions </span><i class="ts_icon ts_icon_cog"></i>
	</a>
	<a id="snippet_expand_toggle" class="float_right no_print">
		<i class="ts_icon ts_icon_expand "></i>
		<i class="ts_icon ts_icon_compress hidden"></i>
	</a>

	<div class="large_bottom_margin clearfix">
		<pre id="file_contents">#!/bin/bash
# Exibe linhas em toda a largura do terminal.
echo_c()
{
  w=$(stty size | cut -d&quot; &quot; -f2)       # width of the terminal
  l=${#1}                              # length of the string
  printf &quot;%&quot;$((l+(w-l)/2))&quot;s\n&quot; &quot;$1&quot;   # print string padded to proper width (%Ws)
}

# Exibe o header do instalador.
show_title()
{
	clear
	title=&quot;ATUALIZADOR - TELEDUC 4.3.2 PARA 4.4&quot;
	printf &#039;%*s\n&#039; &quot;${COLUMNS:-$(tput cols)}&quot; &#039;&#039; | tr &#039; &#039; -
	echo_c &quot;$title&quot;
	printf &#039;%*s\n&#039; &quot;${COLUMNS:-$(tput cols)}&quot; &#039;&#039; | tr &#039; &#039; -
}

test_internet_connection()
{
	wget -q --tries=10 --timeout=20 --spider http://teleduc.org.br
	if [[ $? -eq 0 ]]; then
	        echo &quot;Conexao com o servidor efetuada com sucesso.&quot;
	else
	        echo &quot;
Nao foi possivel se conectar ao servidor do TelEduc.
Este script exige acesso a internet. Por favor verifique sua conexao.
&quot;
	        exit
	fi
}

# Verifica que o script esta sendo executado a partir da raiz do teleduc.
# Busca o arquivo teleduc.inc para isso.
test_script_location()
{
	if [ ! -e ./cursos/aplic/bibliotecas/teleduc.inc ]; then
		show_title
		echo &quot;Este script nao esta na pasta raiz do teleduc.
	Por favor copie este script na pasta raiz do teleduc e execute-o a partir de la.&quot;
		echo &quot;&quot;
		exit
	fi
}

test_script_permissions()
{
	if [[ $UID != 0 ]]; then
		show_title
		echo &quot;Esse script nao foi executado com privilegios de administrador.&quot;
		echo &quot;Por favor execute este script com o seguinte comando:&quot;
	    echo &quot;
sudo bash $0 $*
	    &quot;
	    exit
	fi
}

test_internet_connection
test_script_location
test_script_permissions


MYSQL=/usr/bin/mysql

# Utiliza os dados de teleduc.inc para obter acesso ao banco de dados.
BD=$(grep &quot;&#039;dbnamebase&#039;&quot; ./cursos/aplic/bibliotecas/teleduc.inc | sed &quot;s|\$_SESSION\[&#039;dbnamebase&#039;\]=&#039;||&quot; | sed &quot;s/&#039;;//&quot;)
MYSQL_USER=$(grep &quot;&#039;dbuser&#039;&quot; ./cursos/aplic/bibliotecas/teleduc.inc | sed &quot;s|\$_SESSION\[&#039;dbuser&#039;\]=&#039;||&quot; | sed &quot;s/&#039;;//&quot;)
MYSQL_PASSWORD=$(grep &quot;&#039;dbpassword&#039;&quot; ./cursos/aplic/bibliotecas/teleduc.inc | sed &quot;s|\$_SESSION\[&#039;dbpassword&#039;\]=&#039;||&quot; | sed &quot;s/&#039;;//&quot;)

atual=$(pwd)

# Caminho completo da pasta onde estao os arquivos anexos.
archives=$($MYSQL -u $MYSQL_USER -p$MYSQL_PASSWORD -e &quot;use $BD; select diretorio from Diretorio where item=&#039;Arquivos&#039;;&quot; | grep &quot;/&quot;)

# Caminho da pasta onde estao os arquivos anexos, relativo a raiz do teleduc. 
relative_archives=$($MYSQL -u $MYSQL_USER -p$MYSQL_PASSWORD -e &quot;use $BD; select diretorio from Diretorio where item=&#039;Arquivos&#039;;&quot; | grep &quot;/&quot; | sed &quot;s|$atual||&quot; | sed &quot;s|/||&quot;)

# Este laco testa se a pasta de arquivos anexos esta dentro da raiz do teleduc.
# Inside recebe 1 se a pasta de arquivos eh subpasta da raiz.
inside=&quot;0&quot;
cd &quot;$archives&quot;
while [ &quot;$archives&quot; != &quot;/&quot; ]; do
	if [ &quot;$archives&quot; == &quot;$atual&quot; ]; then
		inside=&quot;1&quot;
		break
	fi
	cd ./..
	archives=$(pwd)
done
cd &quot;$atual&quot;



# Tenta obter document_root do apache a partir de possiveis arquivos de configuracao.
if [ -a /etc/apache2/sites-enabled/000-default.conf ]; then

	buscaDocumentRoot=$(grep &quot;/var/www/html&quot; /etc/apache2/sites-enabled/000-default.conf)
	if [ &quot;$buscaDocumentRoot&quot; != &quot;&quot; ]; then
		document_root=&quot;/var/www/html&quot;
	else
		document_root=&quot;/var/www&quot;
	fi

elif [ -a /etc/httpd/conf/httpd.conf ]; then

	buscaDocumentRoot=$(grep &quot;/var/www/html&quot; /etc/httpd/conf/httpd.conf)
	if [ &quot;$buscaDocumentRoot&quot; != &quot;&quot; ]; then
		document_root=&quot;/var/www/html&quot;
	else
		document_root=&quot;/var/www&quot;
	fi

elif [ -a /etc/apache2/sites-enabled/000-default ]; then

	buscaDocumentRoot=$(grep &quot;/var/www/html&quot; /etc/apache2/sites-enabled/000-default)
	if [ &quot;$buscaDocumentRoot&quot; != &quot;&quot; ]; then
		document_root=&quot;/var/www/html&quot;
	else
		document_root=&quot;/var/www&quot;
	fi

else
	document_root=&quot;/var/www/html&quot;
fi

#document_root=$(grep &#039;DocumentRoot&#039; /etc/apache2/sites-enabled/000-default.conf | sed &#039;s/DocumentRoot//&#039; | sed &#039;s/\t//&#039; | sed &#039;s/ //&#039;)
#if [ -z $document_root ]; then
#	$document_root=&quot;/var/www/html&quot;
#fi
#http://www.commandlinefu.com/commands/view/9020/how-to-get-the-apache-document-root
#http://stackoverflow.com/questions/19752834/where-do-i-find-documentroot-on-ubuntu-after-installing-php-mysql-and-apache2


ANSWER=&quot;5&quot;
while [  &quot;$ANSWER&quot; != &quot;1&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;2&quot; ]; do
	show_title
	echo &quot;Por favor escolha uma opcao.
	1 - Instalar telduc em /usr/share (RECOMENDADO).

	2 - Manter o teleduc instalado na pasta atual. (NAO recomendado).&quot;

	read ANSWER
	
	if [ &quot;$ANSWER&quot; == &quot;2&quot; ]; then
		#Inicializa resposta do usuario.
		ANSWER=&quot;5&quot;
		while [  &quot;$ANSWER&quot; != &quot;1&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;sim&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;2&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;nao&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;n&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;s&quot; ]; do
			show_title

			echo &quot;Para que a atualizacao forneca importantes melhorias de seguranca, RECOMENDAMOS FORTEMENTE que o teleduc seja instalado em /usr/share.
Voce deseja realizar a atualizacao sem instalar o teleduc em /usr/share?
1 - sim
2 - nao&quot;
			#Recebe resposta do usuario.
			read ANSWER
			#Torna a resposta composta apenas por letras minusculas.
			#ANSWER=${USER_ENTRY,,}
		done
		
		#Se o user deseja instalar de forma insegura.
		if [ &quot;$ANSWER&quot; == &quot;1&quot; ] || [ &quot;$ANSWER&quot; == &quot;sim&quot; ] || [ &quot;$ANSWER&quot; == &quot;s&quot; ]; then
			ANSWER=&quot;5&quot;
			#Confirma o desejo do usuario de instalar de forma insegura.
			while [  &quot;$ANSWER&quot; != &quot;1&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;sim&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;2&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;nao&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;n&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;s&quot; ]; do
				show_title
				echo &quot;Voce TEM CERTEZA que deseja abrir mao das importantes melhorias de seguranca da nova versao? Faca-o por sua conta e risco.
1 - sim
2 - nao&quot;
				read ANSWER
				#ANSWER=${USER_ENTRY,,}
			done
			if [ &quot;$ANSWER&quot; == &quot;1&quot; ] || [ &quot;$ANSWER&quot; == &quot;sim&quot; ] || [ &quot;$ANSWER&quot; == &quot;s&quot; ]; then
				#Executa script de copia de arquivos atualizados.
				sudo bash unsafe_install.sh
				exit
			fi		
		fi
		ANSWER=&quot;5&quot;	

	fi
	
done


	
# ANSWER=&quot;5&quot;
# while [  &quot;$ANSWER&quot; != &quot;1&quot; ] &amp;&amp; [ &quot;$ANSWER&quot; != &quot;2&quot; ]; do	
	
# 	show_title
	
# 	echo &quot;Por favor escolha a pasta do TelEduc no servidor.
# 	1 - Manter pasta atual  -  (RECOMENDADO. A url nao sera modificada)

# 	2 - $document_root  -  (A url pode acabar sendo modificada)&quot;

# 	read ANSWER
# done

# Nome da pasta raiz do teleduc.
THIS_FOLDER=${PWD##*/}

# Se o usuario escolheu por manter o teleduc na pasta atual, entao o link para
# webdriver sera o endereco atual.
# if [ &quot;$ANSWER&quot; == &quot;1&quot; ]; then
	LINK_ADR=$(pwd)
	OPTION=&quot;1&quot;
# fi

# Se o usuario escolheu utilizar a pasta padrao do apache para a raiz do teleduc,
# entao o link para webdriver deve estar em document_root/nome-da-raiz-do-teleduc.
# if [ &quot;$ANSWER&quot; == &quot;2&quot; ]; then
LINK_ADR=&quot;$document_root/$THIS_FOLDER&quot;
OPTION=&quot;2&quot;
# fi

# Pasta raiz antiga.
OLD_INSTALL_DIR=$(pwd)
# Pasta raiz nova: em usr/share/teleduc/webdriver.
NEW_INSTALL_DIR=/usr/share/teleduc/webdriver

cd ./cursos/diretorio

# Pasta atual.
DIR=$(pwd)

show_title
echo &quot;Criando restaurador de links da pasta diretorio...&quot;

# Fornece todos os links, e seus destinos, criando o comando de recriacao de cada link.
for dir in $DIR/* ; do
	if [ -d $dir ] &amp;&amp; [ ! -L $dir ]; then
		echo &quot;cp -R $dir /usr/share/teleduc/webdriver/cursos/diretorio&quot;
	fi    
    if [ -L &quot;$dir&quot; ]; then
	# Obtem local para o onde o link vai apontar.
	destiny=$(readlink &quot;$dir&quot;)
        printf &quot;%s %s &quot; &quot;ln -s&quot; &quot;$destiny&quot;
	# O sed e executado apenas no endereco do link, pois o local apontado nao mudara.
	printf &quot;%s\n&quot; $dir | sed &#039;s|&#039;$OLD_INSTALL_DIR&#039;|&#039;$NEW_INSTALL_DIR&#039;|&#039;
    fi
done &gt; ./../../recria_links.sh

cd ./../../..

# renomeia pasta atual para permitir criacao do link.
mv $THIS_FOLDER $THIS_FOLDER&#039;old&#039; # falta tratar erro que surge se ja existe pasta com esse nome.
cd $THIS_FOLDER&#039;old&#039;

echo &quot;Instalando o teleduc atraves do pacote do sistema...&quot;

###### Simula uma instalacao via DEB ou RPM.
simula_pacote()
{
	sudo cp -R ./teleduc /usr/share
	sudo chmod -v 711 /var/www
	sudo chmod -v 755 /usr/share/teleduc
	sudo chmod -v 775 /usr/share/teleduc/config
	sudo chown -v www-data:www-data /usr/share/teleduc/config/teleduc.inc
	sudo chmod -v 700 /usr/share/teleduc/config/teleduc.inc
	sudo chown -v www-data /usr/share/teleduc
	sudo chown -v www-data /usr/share/teleduc/webdriver/cursos/aplic/bibliotecas
	sudo chown -v www-data /usr/share/teleduc/webdriver/cursos/diretorio
	sudo chown -Rv www-data /usr/share/teleduc/webdriver/instalacao
	sudo chown -Rv www-data /usr/share/teleduc/config
	sudo ln -s /usr/share/teleduc/webdriver /var/www/html/teleduc
}
######

so=$(lsb_release -si | tr [A-Z] [a-z])

if [ &quot;$so&quot; == &quot;ubuntu&quot; ] || [ &quot;$so&quot; == &quot;debian&quot; ]; then
	# Importa chave do deb do teleduc.
	wget -O - http://143.106.157.5/repos/apt/Ubuntu/equipe.teleduc@gmail.com.gpg.key | sudo apt-key add -
	# Adiciona URL do repositorio do teleduc ao arquivo de configuracao do apt.
	echo &quot;deb http://143.106.157.5/repos/apt/Ubuntu/ trusty main&quot; &gt;&gt; /etc/apt/sources.list
	sudo apt-get update
	# Instala o teleduc.
	sudo apt-get install teleduc
elif [ &quot;$so&quot; == &quot;fedora&quot; || &quot;$so&quot; == &quot;centos&quot; ]; then
	# Baixa repositorio.
	wget http://www.teleduc.org.br/repo/rpm/noarch/teleduc-repo-1.0-0.noarch.rpm
	# Instala o repositorio.
	sudo yum localinstall teleduc-repo-1.0-0.noarch.rpm
	# Instala o teleduc.
	sudo yum install teleduc
	# Apaga arquivo baixado.
	rm teleduc-repo-1.0-0.noarch.rpm
else
	# Executa simulacao de instalacao via pacote DEB ou RPM sem exibir nada no terminal.
	simula_pacote &gt; scriptname &gt;/dev/null
fi

echo &quot;Restaurando dados da instalacao antiga...&quot;

if [ -L /var/www/html/teleduc ]; then
	rm /var/www/html/teleduc	
fi

if [ ! -L $LINK_ADR ]; then
	sudo ln -s /usr/share/teleduc/webdriver $LINK_ADR
	#mv /var/www/html/teleduc $LINK_ADR	
fi

# Remove teleduc.inc vazio instalado pelo pacote.
rm /usr/share/teleduc/config/teleduc.inc

# Restaura teleduc.inc da versao antiga
cp ./cursos/aplic/bibliotecas/teleduc.inc /usr/share/teleduc/config/

# Redefine permissoes do arquivo teleduc.inc
chown www-data:www-data /usr/share/teleduc/config/teleduc.inc
chmod 700 /usr/share/teleduc/config/teleduc.inc

# Apaga pasta instalacao
rm -R /usr/share/teleduc/webdriver/instalacao

echo &quot;Atualizando informacoes do banco de dados...&quot;

# Caso a raiz do teleduc nao tenha mudado de lugar.
if [ &quot;$OPTION&quot; == &quot;1&quot; ]; then
	databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e &quot;USE $BD; update Config set valor=&#039;4.4&#039; where item=&#039;versao&#039;;&quot;`	
fi
# Caso a raiz do teleduc tenha mudado de lugar, sera preciso atualizar o novo lugar no BD.
if [ &quot;$OPTION&quot; == &quot;2&quot; ]; then
	databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e &quot;USE $BD; update Diretorio set diretorio=&#039;/$THIS_FOLDER&#039; where item=&#039;raiz_www&#039;; update Config set valor=&#039;4.4&#039; where item=&#039;versao&#039;;&quot;`	
fi


echo &quot;Restaurando links da pasta diretorio...&quot;

# Se a pasta de arquivos esta dentro da raiz do teleduc, entao eh preciso muda-la de lugar e armazenar a nova pasta no BD.
if [ &quot;$inside&quot; == &quot;1&quot; ]; then

	cp -R $relative_archives /usr/share/teleduc/config
	atual=$(pwd)

	cd $relative_archives

	THIS_FOLDER=${PWD##*/}

	cd ./..

	cp -R $THIS_FOLDER ./arquivos

	mv arquivos /usr/share/teleduc/config	

	cd $atual

	sed -i &quot;s|$OLD_INSTALL_DIR/$relative_archives|/usr/share/teleduc/config/arquivos|g&quot; recria_links.sh
	
	databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e &quot;USE $BD; update Diretorio set diretorio=&#039;/usr/share/teleduc/config/arquivos&#039; where item=&#039;Arquivos&#039;;&quot;`
fi

c=$OLD_INSTALL_DIR&#039;old&#039;
sed -i &quot;s|$OLD_INSTALL_DIR|$c|g&quot; recria_links.sh

# Restaura links da pasta diretorio na raiz da nova versao do teleduc:
bash recria_links.sh

echo &quot;Atualizacao concluida!&quot;

</pre>

		<p class="file_page_meta no_print" style="line-height: 1.5rem;">
			<label class="checkbox normal mini float_right no_top_padding no_min_width">
				<input type="checkbox" id="file_preview_wrap_cb"> wrap long lines
			</label>
		</p>

	</div>

	<div id="comments_holder" class="clearfix clear_both">
	<div class="col span_1_of_6"></div>
	<div class="col span_4_of_6 no_right_padding">
		<div id="file_page_comments">
					</div>	
		<form action="https://teleduc-nied.slack.com/files/aristeujnr/F3585HWFJ/atualizador43to44.sh"
		id="file_comment_form"
					class="comment_form clearfix"
				method="post">
			<a href="/team/elvisr" class="member_preview_link" data-member-id="U28PVNJLE" >
			<span class="member_image thumb_36" style="background-image: url('https://secure.gravatar.com/avatar/f7db7f3d81a4977190817a4d9d8084f6.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2F66f9%2Fimg%2Favatars%2Fava_0002-72.png')" data-thumb-size="36" data-member-id="U28PVNJLE"></span>
		</a>
		<input type="hidden" name="addcomment" value="1" />
	<input type="hidden" name="crumb" value="s-1480005499-65fdc86686-☃" />

	<textarea id="file_comment" data-el-id-to-keep-in-view="file_comment_submit_btn" class="small comment_input small_bottom_margin autogrow-short" name="comment" wrap="virtual" ></textarea>
	<span class="input_note float_left indifferent_grey file_comment_tip">shift+enter to add a new line</span>	<button id="file_comment_submit_btn" type="submit" class="btn float_right  ladda-button" data-style="expand-right"><span class="ladda-label">Add Comment</span></button>
</form>

<form
		id="file_edit_comment_form"
					class="edit_comment_form clearfix hidden"
				method="post">
		<textarea id="file_edit_comment" class="small comment_input small_bottom_margin" name="comment" wrap="virtual"></textarea><br>
	<input type="submit" class="save btn float_right " value="Save" />
	<button class="cancel btn btn_outline float_right small_right_margin ">Cancel</button>
</form>	
	</div>
	<div class="col span_1_of_6"></div>
</div>
</div>




		
	</div>
	<div id="overlay"></div>
</div>







<script type="text/javascript">

	function vvv(v) {

		var vvv_warning = 'You cannot use vvv on dynamic values. Please make sure you only pass in static file paths.';
		if (TS && TS.warn) {
			TS.warn(vvv_warning);
		} else {
			console.warn(vvv_warning);
		}

		return v;
	}

	var cdn_url = "https:\/\/slack.global.ssl.fastly.net";
	var inc_js_setup_data = {
		emoji_sheets: {
			apple: 'https://a.slack-edge.com/f360/img/emoji_2016_06_08/sheet_apple_64_indexed_256colors.png',
			google: 'https://a.slack-edge.com/f360/img/emoji_2016_06_08/sheet_google_64_indexed_128colors.png',
			twitter: 'https://a.slack-edge.com/f360/img/emoji_2016_06_08/sheet_twitter_64_indexed_128colors.png',
			emojione: 'https://a.slack-edge.com/f360/img/emoji_2016_06_08/sheet_emojione_64_indexed_128colors.png',
		},
	};
</script>
			<script type="text/javascript">
<!--
	// common boot_data
	var boot_data = {
		start_ms: Date.now(),
		app: 'web',
		user_id: 'U28PVNJLE',
		no_login: false,
		version_ts: '1479959392',
		version_uid: '3ed12b0006429b2ae9ef5505c6b900427dea4d93',
		cache_version: "v13-tiger",
		cache_ts_version: "v1-cat",
		redir_domain: 'slack-redir.net',
		signin_url: 'https://slack.com/signin',
		abs_root_url: 'https://slack.com/',
		api_url: '/api/',
		team_url: 'https://teleduc-nied.slack.com/',
		image_proxy_url: 'https://slack-imgs.com/',
		beacon_timing_url: "https:\/\/slack.com\/beacon\/timing",
		beacon_error_url: "https:\/\/slack.com\/beacon\/error",
		clog_url: "clog\/track\/",
		api_token: 'xoxs-11041494833-76811766694-108924759653-1026ad3ea4',
		ls_disabled: false,

		notification_sounds: [{"value":"b2.mp3","label":"Ding","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/b2.mp3"},{"value":"animal_stick.mp3","label":"Boing","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/animal_stick.mp3"},{"value":"been_tree.mp3","label":"Drop","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/been_tree.mp3"},{"value":"complete_quest_requirement.mp3","label":"Ta-da","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/complete_quest_requirement.mp3"},{"value":"confirm_delivery.mp3","label":"Plink","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/confirm_delivery.mp3"},{"value":"flitterbug.mp3","label":"Wow","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/flitterbug.mp3"},{"value":"here_you_go_lighter.mp3","label":"Here you go","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/here_you_go_lighter.mp3"},{"value":"hi_flowers_hit.mp3","label":"Hi","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/hi_flowers_hit.mp3"},{"value":"item_pickup.mp3","label":"Yoink","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/item_pickup.mp3"},{"value":"knock_brush.mp3","label":"Knock Brush","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/knock_brush.mp3"},{"value":"save_and_checkout.mp3","label":"Woah!","url":"https:\/\/slack.global.ssl.fastly.net\/dfc0\/sounds\/push\/save_and_checkout.mp3"},{"value":"none","label":"None"}],
		alert_sounds: [{"value":"frog.mp3","label":"Frog","url":"https:\/\/slack.global.ssl.fastly.net\/a34a\/sounds\/frog.mp3"}],
		call_sounds: [{"value":"call\/alert_v2.mp3","label":"Alert","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/alert_v2.mp3"},{"value":"call\/incoming_ring_v2.mp3","label":"Incoming ring","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/incoming_ring_v2.mp3"},{"value":"call\/outgoing_ring_v2.mp3","label":"Outgoing ring","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/outgoing_ring_v2.mp3"},{"value":"call\/pop_v2.mp3","label":"Incoming reaction","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/pop_v2.mp3"},{"value":"call\/they_left_call_v2.mp3","label":"They left call","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/they_left_call_v2.mp3"},{"value":"call\/you_left_call_v2.mp3","label":"You left call","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/you_left_call_v2.mp3"},{"value":"call\/they_joined_call_v2.mp3","label":"They joined call","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/they_joined_call_v2.mp3"},{"value":"call\/you_joined_call_v2.mp3","label":"You joined call","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/you_joined_call_v2.mp3"},{"value":"call\/confirmation_v2.mp3","label":"Confirmation","url":"https:\/\/slack.global.ssl.fastly.net\/08f7\/sounds\/call\/confirmation_v2.mp3"}],
		call_sounds_version: "v2",
		max_team_handy_rxns: 5,
		max_channel_handy_rxns: 5,
		max_poll_handy_rxns: 7,
		max_handy_rxns_title_chars: 30,
				
		feature_tinyspeck: false,
		feature_i18n: false,
		feature_create_team_google_auth: false,
		feature_api_extended_2fa_backup: false,
		feature_flannel_fe: false,
		feature_ms_eventlog_changes: false,
		feature_do_not_clear_three_day_old_local_storage: false,
		feature_frecency_normalization: true,
		feature_emoji_usage_stats: false,
		feature_batch_file_deleted_event: false,
		feature_viewmodel_proto: false,
		feature_sales_tax: true,
		feature_message_replies: false,
		feature_message_replies_rewrite_864: false,
		feature_message_replies_off: false,
		feature_message_replies_threads_view: false,
		feature_no_rollups: false,
		feature_web_lean: false,
		feature_web_lean_all_users: false,
		feature_reminders_v3: true,
		feature_server_side_emoji_counts: true,
		feature_a11y_keyboard_shortcuts: false,
		feature_email_ingestion: false,
		feature_msg_consistency: false,
		feature_sli_channel_priority: false,
		feature_sli_similar_channels: true,
		feature_sli_clog_selections: true,
		feature_thanks: false,
		feature_attachments_inline: false,
		feature_fix_files: true,
		feature_canonical_avatars_web_client: true,
		feature_files_list: true,
		feature_channel_eventlog_client: true,
		feature_macssb1_banner: true,
		feature_macssb2_banner: true,
		feature_macelectron1_banner: true,
		feature_macelectron2_banner: true,
		feature_latest_event_ts: true,
		feature_elide_closed_dms: true,
		feature_no_redirects_in_ssb: true,
		feature_referer_policy: true,
		feature_more_field_in_message_attachments: false,
		feature_calls: true,
		feature_calls_no_rtm_start: true,
		feature_integrations_message_preview: true,
		feature_paging_api: false,
		feature_enterprise_api: true,
		feature_enterprise_create: true,
		feature_enterprise_api_auth: true,
		feature_enterprise_profile: true,
		feature_enterprise_search: true,
		feature_enterprise_locked_settings: false,
		feature_frecency_migration: false,
		feature_enterprise_frecency: false,
		feature_enterprise_team_overview_page: false,
		feature_enterprise_conditional_team_removal: true,
		feature_enterprise_search_ui: false,
		feature_enterprise_mandatory_2fa: true,
		feature_basic_analytics: false,
		feature_enterprise_user_account_settings: true,
		feature_enterprise_security_auth_refactor: false,
		feature_enterprise_context_menu: false,
		feature_enterprise_profile_menu_deactivate_2fa: false,
		feature_private_channels: true,
		feature_mpim_restrictions: false,
		feature_subteams_hard_delete: false,
		feature_no_unread_counts: true,
		feature_js_raf_queue: false,
		feature_shared_channels: false,
		feature_external_shared_channels_ui: false,
		feature_you_autocomplete_me: false,
		feature_allow_shared_general: false,
		feature_shared_channels_settings: true,
		feature_fast_files_flexpane: true,
		feature_no_has_files: true,
		feature_custom_saml_signin_button_label: true,
		feature_file_reactions_activity: true,
		feature_admin_approved_apps: true,
		feature_winssb_beta_channel: false,
		feature_inline_media_playback: true,
		feature_branch_io_deeplink: true,
		feature_policy_effective_date: true,
		feature_clog_whats_new: true,
		feature_presence_sub: false,
		feature_live_support_free_plan: false,
		feature_dm_yahself: true,
		feature_slackbot_goes_to_college: false,
		feature_newxp_enqueue_message: true,
		feature_shared_invites: true,
		feature_lato_2_ssb: true,
		feature_refactor_buildmsghtml: false,
		feature_omit_localstorage_users_bots: false,
		feature_disable_ls_compression: false,
		feature_force_ls_compression: false,
		feature_sign_in_with_slack: true,
		feature_sign_in_with_slack_ui_elements: true,
		feature_prevent_msg_rebuild: true,
		feature_app_review_scope_error: true,
		feature_zendesk_app_submission_improvement: false,
		feature_react_emoji_picker: false,
		feature_better_msg_copying: false,
		feature_name_tagging_client: false,
		feature_name_tagging_client_extras: false,
		feature_name_tagging_client_search: false,
		feature_new_msg_input: false,
		feature_browse_date: true,
		feature_use_imgproxy_resizing: false,
		feature_always_active_bots: false,
		feature_single_team_apps: false,
		feature_multiple_app_ownership: true,
		feature_update_message_file: true,
		feature_custom_clogs: true,
		feature_calls_linux: true,
		feature_a11y_pref_text_size: false,
		feature_a11y_pref_no_animation: true,
		feature_share_mention_comment_cleanup: false,
		feature_unread_view: true,
		feature_tw: false,
		feature_tw_ls_disabled: false,
		feature_external_files: false,
		feature_min_web: false,
		feature_electron_memory_logging: false,
		feature_no_tokenless_ms_connections: false,
		feature_devrel_try_it_now: false,
		feature_wait_for_all_mentions_in_client: false,
		feature_prev_next_button: false,
		feature_free_inactive_domains: true,
		feature_platform_calls: true,
		feature_a11y_tab: false,
		feature_admin_billing_refactor: true,
		feature_pdf_viewer: true,
		feature_wrapped_mention_parsing: false,
		feature_measure_css_usage: false,
		feature_take_profile_photo: false,
		feature_ajax_billing_history: false,
		feature_update_coachmarks_cta: true,
		feature_multnomah: false,
		feature_texty: false,
		feature_sales_tax_address: true,
		feature_toggle_id_translation: false,
		feature_can_edit_app: true,
		feature_gdrive_1_dot_5: true,
		feature_mention_non_members: false,
		feature_hide_email_pref: true,
		feature_ent_pricing_lp: true,
		feature_file_id_from_url_update: false,
		feature_pin_update: true,
		feature_tos_oct2016: true,
		feature_flexbox_client: false,
		feature_emoji_menu_tuning: false,
		feature_discoverable_teams: false,
		feature_discoverable_teams_client: false,
		feature_reveal_channel_renames: false,
		feature_claim_email_domain: false,
		feature_app_info_youtube_url: false,
		feature_api_metadata_token_allow: false,
		feature_app_cards_and_profs_frontend: false,
		feature_user_removed_from_team: true,
		feature_user_added_to_team: true,
		feature_a11y_ui_zoom: false,
		feature_message_menus: false,
		feature_contact_us_form: true,
		feature_app_cards_and_profs_set_card_color: false,
		feature_sli_recaps: false,
		feature_cdn_load_tracking: true,
		feature_searchable_member_list: false,
		feature_team_to_org_directory: true,
		feature_user_custom_status: false,

	client_logs: {"0":{"numbers":[0],"whitelisted":false},"@scott":{"numbers":[2,4,37,58,67,389,390,481,488,529,667,773,888,999],"owner":"@scott"},"@eric":{"numbers":[2,23,47,48,65,66,72,73,82,91,93,96,222,365,438,528,552,777,794],"owner":"@eric"},"2":{"owner":"@scott \/ @eric","numbers":[2],"whitelisted":false},"4":{"owner":"@scott","numbers":[4],"whitelisted":false},"5":{"channels":"#dhtml","numbers":[5],"whitelisted":false},"23":{"owner":"@eric","numbers":[23],"whitelisted":false},"sounds":{"owner":"@scott","name":"sounds","numbers":[37]},"37":{"owner":"@scott","name":"sounds","numbers":[37],"whitelisted":true},"47":{"owner":"@eric","numbers":[47],"whitelisted":false},"48":{"owner":"@eric","numbers":[48],"whitelisted":false},"58":{"owner":"@scott","numbers":[58],"whitelisted":false},"65":{"owner":"@eric","numbers":[65],"whitelisted":false},"66":{"owner":"@eric","numbers":[66],"whitelisted":false},"67":{"owner":"@scott","numbers":[67],"whitelisted":false},"72":{"owner":"@eric","numbers":[72],"whitelisted":false},"73":{"owner":"@eric","numbers":[73],"whitelisted":false},"82":{"owner":"@eric","numbers":[82],"whitelisted":false},"@shinypb":{"owner":"@shinypb","numbers":[88,1000,1989,1996]},"88":{"owner":"@shinypb","numbers":[88],"whitelisted":false},"91":{"owner":"@eric","numbers":[91],"whitelisted":false},"93":{"owner":"@eric","numbers":[93],"whitelisted":false},"96":{"owner":"@eric","numbers":[96],"whitelisted":false},"@steveb":{"owner":"@steveb","numbers":[99]},"99":{"owner":"@steveb","numbers":[99],"whitelisted":false},"222":{"owner":"@eric","numbers":[222],"whitelisted":false},"365":{"owner":"@eric","numbers":[365],"whitelisted":false},"389":{"owner":"@scott","numbers":[389],"whitelisted":false},"390":{"owner":"@scott","numbers":[390],"whitelisted":false},"438":{"owner":"@eric","numbers":[438],"whitelisted":false},"@rowan":{"numbers":[444,666],"owner":"@rowan"},"444":{"owner":"@rowan","numbers":[444],"whitelisted":false},"481":{"owner":"@scott","numbers":[481],"whitelisted":false},"488":{"owner":"@scott","numbers":[488],"whitelisted":false},"528":{"owner":"@eric","numbers":[528],"whitelisted":false},"529":{"owner":"@scott","numbers":[529],"whitelisted":false},"552":{"owner":"@eric","numbers":[552],"whitelisted":false},"dashboard":{"owner":"@ac \/ @bruce \/ @kylestetz \/ @nic \/ @rowan","channels":"#devel-enterprise-fe, #feat-enterprise-dash","name":"dashboard","numbers":[666]},"@ac":{"channels":"#devel-enterprise-fe, #feat-enterprise-dash","name":"dashboard","numbers":[666],"owner":"@ac"},"@bruce":{"channels":"#devel-enterprise-fe, #feat-enterprise-dash","name":"dashboard","numbers":[666],"owner":"@bruce"},"@kylestetz":{"channels":"#devel-enterprise-fe, #feat-enterprise-dash","name":"dashboard","numbers":[666],"owner":"@kylestetz"},"@nic":{"channels":"#devel-enterprise-fe, #feat-enterprise-dash","name":"dashboard","numbers":[666],"owner":"@nic"},"666":{"owner":"@ac \/ @bruce \/ @kylestetz \/ @nic \/ @rowan","channels":"#devel-enterprise-fe, #feat-enterprise-dash","name":"dashboard","numbers":[666],"whitelisted":false},"667":{"owner":"@scott","numbers":[667],"whitelisted":false},"773":{"owner":"@scott","numbers":[773],"whitelisted":false},"777":{"owner":"@eric","numbers":[777],"whitelisted":false},"794":{"owner":"@eric","numbers":[794],"whitelisted":false},"888":{"owner":"@scott","numbers":[888],"whitelisted":false},"999":{"owner":"@scott","numbers":[999],"whitelisted":false},"1000":{"owner":"@shinypb","numbers":[1000],"whitelisted":false},"minweb":{"owner":"@johnnyrodgers","features":["feature_min_web"],"channels":"#feat-minweb","name":"minweb","numbers":[1983]},"@johnnyrodgers":{"owner":"@johnnyrodgers","features":["feature_min_web"],"channels":"#feat-minweb","name":"minweb","numbers":[1983]},"1983":{"owner":"@johnnyrodgers","features":["feature_min_web"],"channels":"#feat-minweb","name":"minweb","numbers":[1983],"whitelisted":false},"flannel":{"owner":"@shinypb","features":["feature_flannel_fe"],"channels":"#devel-flannel","name":"flannel","numbers":[1989]},"1989":{"owner":"@shinypb","features":["feature_flannel_fe"],"channels":"#devel-flannel","name":"flannel","numbers":[1989],"whitelisted":true},"ms":{"owner":"@shinypb","name":"ms","numbers":[1996]},"1996":{"owner":"@shinypb","name":"ms","numbers":[1996],"whitelisted":true},"@patrick":{"owner":"@patrick","channels":"#dhtml","numbers":[2001,2002,2003,2004]},"2001":{"owner":"@patrick","channels":"#dhtml","numbers":[2001],"whitelisted":false},"dnd":{"owner":"@patrick","channels":"dhtml","name":"dnd","numbers":[2002]},"2002":{"owner":"@patrick","channels":"dhtml","name":"dnd","numbers":[2002],"whitelisted":true},"2003":{"owner":"@patrick","channels":"dhtml","numbers":[2003],"whitelisted":false},"2004":{"owner":"@patrick","channels":"#feature_message_replies, #feat-threads","numbers":[2004],"whitelisted":false},"mc_sibs":{"name":"mc_sibs","numbers":[9999]},"9999":{"name":"mc_sibs","numbers":[9999],"whitelisted":false},"@fearon":{"owner":"@fearon","numbers":[98765]},"98765":{"owner":"@fearon","numbers":[98765],"whitelisted":false}},


		img: {
			app_icon: 'https://a.slack-edge.com/272a/img/slack_growl_icon.png'
		},
		page_needs_custom_emoji: false,
		page_needs_team_profile_fields: false,
		page_needs_enterprise: false,
		slackbot_help_enabled: true
	};

	
	
	
	
	// client boot data
	
	
	
//-->
</script>	
	
				<!-- output_js "core" -->
<script type="text/javascript" src="https://a.slack-edge.com/cca09/js/rollup-core_required_libs.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>
<script type="text/javascript" src="https://a.slack-edge.com/f4d95/js/rollup-core_required_ts.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>
<script type="text/javascript" src="https://a.slack-edge.com/32b0/js/TS.web.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>

		<!-- output_js "core_web" -->
<script type="text/javascript" src="https://a.slack-edge.com/9982f/js/rollup-core_web.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>

		<!-- output_js "secondary" -->
<script type="text/javascript" src="https://a.slack-edge.com/f7865/js/rollup-secondary_a_required.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>
<script type="text/javascript" src="https://a.slack-edge.com/b52340/js/rollup-secondary_b_required.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>

					
	<!-- output_js "regular" -->
<script type="text/javascript" src="https://a.slack-edge.com/d381/js/TS.web.comments.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>
<script type="text/javascript" src="https://a.slack-edge.com/27bc/js/TS.web.file.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>
<script type="text/javascript" src="https://a.slack-edge.com/cb0fd/js/libs/codemirror.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>
<script type="text/javascript" src="https://a.slack-edge.com/8df80/js/codemirror_load.js" crossorigin="anonymous" onload="window._cdn && _cdn.ok(this, arguments)" onerror="window._cdn && _cdn.failed(this, arguments)"></script>

		<script type="text/javascript">
	<!--
		boot_data.page_needs_custom_emoji = true;

		boot_data.file = {"id":"F3585HWFJ","created":1479843702,"timestamp":1479843702,"name":"atualizador43to44.sh","title":"atualizador43to44.sh","mimetype":"text\/plain","filetype":"shell","pretty_type":"Shell","user":"U0J6DUBB5","editable":true,"size":11427,"mode":"snippet","is_external":false,"external_type":"","is_public":false,"public_url_shared":false,"display_as_bot":false,"username":"","url_private":"https:\/\/files.slack.com\/files-pri\/T0B17EJQH-F3585HWFJ\/atualizador43to44.sh","url_private_download":"https:\/\/files.slack.com\/files-pri\/T0B17EJQH-F3585HWFJ\/download\/atualizador43to44.sh","permalink":"https:\/\/teleduc-nied.slack.com\/files\/aristeujnr\/F3585HWFJ\/atualizador43to44.sh","permalink_public":"https:\/\/slack-files.com\/T0B17EJQH-F3585HWFJ-bfb6e6aba6","edit_link":"https:\/\/teleduc-nied.slack.com\/files\/aristeujnr\/F3585HWFJ\/atualizador43to44.sh\/edit","preview":"#!\/bin\/bash\n# Exibe linhas em toda a largura do terminal.\necho_c()\n{\n  w=$(stty size | cut -d\" \" -f2)       # width of the terminal","preview_highlight":"\u003Cdiv class=\"CodeMirror cm-s-default CodeMirrorServer\" oncopy=\"if(event.clipboardData){event.clipboardData.setData('text\/plain',window.getSelection().toString().replace(\/\\u200b\/g,''));event.preventDefault();event.stopPropagation();}\"\u003E\n\u003Cdiv class=\"CodeMirror-code\"\u003E\n\u003Cdiv\u003E\u003Cpre\u003E\u003Cspan class=\"cm-meta\"\u003E#!\/bin\/bash\u003C\/span\u003E\u003C\/pre\u003E\u003C\/div\u003E\n\u003Cdiv\u003E\u003Cpre\u003E\u003Cspan class=\"cm-comment\"\u003E# Exibe linhas em toda a largura do terminal.\u003C\/span\u003E\u003C\/pre\u003E\u003C\/div\u003E\n\u003Cdiv\u003E\u003Cpre\u003Eecho_c()\u003C\/pre\u003E\u003C\/div\u003E\n\u003Cdiv\u003E\u003Cpre\u003E{\u003C\/pre\u003E\u003C\/div\u003E\n\u003Cdiv\u003E\u003Cpre\u003E  \u003Cspan class=\"cm-def\"\u003Ew\u003C\/span\u003E\u003Cspan class=\"cm-operator\"\u003E=\u003C\/span\u003E\u003Cspan class=\"cm-quote\"\u003E$(stty size | cut -d&quot; &quot; -f2)\u003C\/span\u003E       \u003Cspan class=\"cm-comment\"\u003E# width of the terminal\u003C\/span\u003E\u003C\/pre\u003E\u003C\/div\u003E\n\u003C\/div\u003E\n\u003C\/div\u003E\n","lines":364,"lines_more":359,"preview_is_truncated":true,"channels":[],"groups":[],"ims":["D28Q2M19B"],"comments_count":0};
		boot_data.file.comments = [];

		

		var g_editor;

		$(function(){

			var wrap_long_lines = !!TS.model.code_wrap_long_lines;

			g_editor = CodeMirror(function(elt){
				var content = document.getElementById("file_contents");
				content.parentNode.replaceChild(elt, content);
			}, {
				value: $('#file_contents').text(),
				lineNumbers: true,
				matchBrackets: true,
				indentUnit: 4,
				indentWithTabs: true,
				enterMode: "keep",
				tabMode: "shift",
				viewportMargin: 10,
				readOnly: true,
				lineWrapping: wrap_long_lines
			});

			// past a certain point, CodeMirror rendering may simply stop working.
			// start having CodeMirror use its Long List View-style scolling at >= max_lines.
			var max_lines = 8192;

			var snippet_lines;

			// determine # of lines, limit height accordingly
			if (g_editor.doc && g_editor.doc.lineCount) {
				snippet_lines = parseInt(g_editor.doc.lineCount());
				var new_height;
				if (snippet_lines) {
					// we want the CodeMirror container to collapse around short snippets.
					// however, we want to let it auto-expand only up to a limit, at which point
					// we specify a fixed height so CM can display huge snippets without dying.
					// this is because CodeMirror works nicely with no height set, but doesn't
					// scale (big file performance issue), and doesn't work with min/max-height -
					// so at some point, we have to set an absolute height to kick it into its
					// smart / partial "Long List View"-style rendering mode.
					if (snippet_lines < max_lines) {
						new_height = 'auto';
					} else {
						new_height = (max_lines * 0.875) + 'rem'; // line-to-rem ratio
					}
					var line_count = Math.min(snippet_lines, max_lines);
					TS.info('Applying height of ' + new_height + ' to container for this snippet of ' + snippet_lines + (snippet_lines === 1 ? ' line' : ' lines'));
					$('#page .CodeMirror').height(new_height);
				}
			}

			$('#file_preview_wrap_cb').bind('change', function(e) {
				TS.model.code_wrap_long_lines = $(this).prop('checked');
				g_editor.setOption('lineWrapping', TS.model.code_wrap_long_lines);
			})

			$('#file_preview_wrap_cb').prop('checked', wrap_long_lines);

			CodeMirror.switchSlackMode(g_editor, "shell");
		});

		
		$('#file_comment').css('overflow', 'hidden').autogrow();
	//-->
	</script>


		<script type="text/javascript">
				TS.clog.setTeam('T0B17EJQH');
						TS.clog.setUser('U28PVNJLE');
			</script>

			<script type="text/javascript">TS.boot(boot_data);</script>
	
<style>.color_9f69e7:not(.nuc) {color:#9F69E7;}.color_4bbe2e:not(.nuc) {color:#4BBE2E;}.color_e7392d:not(.nuc) {color:#E7392D;}.color_3c989f:not(.nuc) {color:#3C989F;}.color_674b1b:not(.nuc) {color:#674B1B;}.color_e96699:not(.nuc) {color:#E96699;}.color_e0a729:not(.nuc) {color:#E0A729;}.color_684b6c:not(.nuc) {color:#684B6C;}.color_5b89d5:not(.nuc) {color:#5B89D5;}.color_2b6836:not(.nuc) {color:#2B6836;}.color_99a949:not(.nuc) {color:#99A949;}.color_df3dc0:not(.nuc) {color:#DF3DC0;}.color_4cc091:not(.nuc) {color:#4CC091;}.color_9b3b45:not(.nuc) {color:#9B3B45;}.color_d58247:not(.nuc) {color:#D58247;}.color_bb86b7:not(.nuc) {color:#BB86B7;}.color_5a4592:not(.nuc) {color:#5A4592;}.color_db3150:not(.nuc) {color:#DB3150;}.color_235e5b:not(.nuc) {color:#235E5B;}.color_9e3997:not(.nuc) {color:#9E3997;}.color_53b759:not(.nuc) {color:#53B759;}.color_c386df:not(.nuc) {color:#C386DF;}.color_385a86:not(.nuc) {color:#385A86;}.color_a63024:not(.nuc) {color:#A63024;}.color_5870dd:not(.nuc) {color:#5870DD;}.color_ea2977:not(.nuc) {color:#EA2977;}.color_50a0cf:not(.nuc) {color:#50A0CF;}.color_d55aef:not(.nuc) {color:#D55AEF;}.color_d1707d:not(.nuc) {color:#D1707D;}.color_43761b:not(.nuc) {color:#43761B;}.color_e06b56:not(.nuc) {color:#E06B56;}.color_8f4a2b:not(.nuc) {color:#8F4A2B;}.color_902d59:not(.nuc) {color:#902D59;}.color_de5f24:not(.nuc) {color:#DE5F24;}.color_a2a5dc:not(.nuc) {color:#A2A5DC;}.color_827327:not(.nuc) {color:#827327;}.color_3c8c69:not(.nuc) {color:#3C8C69;}.color_8d4b84:not(.nuc) {color:#8D4B84;}.color_84b22f:not(.nuc) {color:#84B22F;}.color_4ec0d6:not(.nuc) {color:#4EC0D6;}.color_e23f99:not(.nuc) {color:#E23F99;}.color_e475df:not(.nuc) {color:#E475DF;}.color_619a4f:not(.nuc) {color:#619A4F;}.color_a72f79:not(.nuc) {color:#A72F79;}.color_7d414c:not(.nuc) {color:#7D414C;}.color_aba727:not(.nuc) {color:#ABA727;}.color_965d1b:not(.nuc) {color:#965D1B;}.color_4d5e26:not(.nuc) {color:#4D5E26;}.color_dd8527:not(.nuc) {color:#DD8527;}.color_bd9336:not(.nuc) {color:#BD9336;}.color_e85d72:not(.nuc) {color:#E85D72;}.color_dc7dbb:not(.nuc) {color:#DC7DBB;}.color_bc3663:not(.nuc) {color:#BC3663;}.color_9d8eee:not(.nuc) {color:#9D8EEE;}.color_8469bc:not(.nuc) {color:#8469BC;}.color_73769d:not(.nuc) {color:#73769D;}.color_b14cbc:not(.nuc) {color:#B14CBC;}</style>

<!-- slack-www-hhvm216 / 2016-11-24 08:38:19 / v3ed12b0006429b2ae9ef5505c6b900427dea4d93 / B:H -->

</body>
</html>