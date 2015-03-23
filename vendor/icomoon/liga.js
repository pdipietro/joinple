/* A polyfill for browsers that don't support ligatures. */
/* The script tag referring to this file must be placed before the ending body tag. */

/* To provide support for elements dynamically added, this script adds
   method 'icomoonLiga' to the window object. You can pass element references to this method.
*/
(function () {
	'use strict';
	function supportsProperty(p) {
		var prefixes = ['Webkit', 'Moz', 'O', 'ms'],
			i,
			div = document.createElement('div'),
			ret = p in div.style;
		if (!ret) {
			p = p.charAt(0).toUpperCase() + p.substr(1);
			for (i = 0; i < prefixes.length; i += 1) {
				ret = prefixes[i] + p in div.style;
				if (ret) {
					break;
				}
			}
		}
		return ret;
	}
	var icons;
	if (!supportsProperty('fontFeatureSettings')) {
		icons = {
			'home': '&#xe900;',
			'house': '&#xe900;',
			'newspaper': '&#xe904;',
			'news': '&#xe904;',
			'pencil': '&#xe905;',
			'write': '&#xe905;',
			'blog': '&#xe909;',
			'pen2': '&#xe909;',
			'image': '&#xe90d;',
			'picture': '&#xe90d;',
			'camera': '&#xe90f;',
			'photo': '&#xe90f;',
			'film': '&#xe913;',
			'video2': '&#xe913;',
			'video-camera': '&#xe914;',
			'video3': '&#xe914;',
			'mic': '&#xe91e;',
			'microphone': '&#xe91e;',
			'profile': '&#xe923;',
			'file2': '&#xe923;',
			'file-text2': '&#xe926;',
			'file4': '&#xe926;',
			'stack': '&#xe92e;',
			'layers': '&#xe92e;',
			'lifebuoy': '&#xe941;',
			'support': '&#xe941;',
			'envelop': '&#xe945;',
			'mail': '&#xe945;',
			'bell': '&#xe951;',
			'alarm2': '&#xe951;',
			'calendar': '&#xe953;',
			'date': '&#xe953;',
			'user-plus': '&#xe973;',
			'user2': '&#xe973;',
			'search': '&#xe986;',
			'magnifier': '&#xe986;',
			'key2': '&#xe98e;',
			'password2': '&#xe98e;',
			'lock': '&#xe98f;',
			'secure': '&#xe98f;',
			'cog': '&#xe994;',
			'gear': '&#xe994;',
			'bin': '&#xe9ac;',
			'trashcan': '&#xe9ac;',
			'download2': '&#xe9c5;',
			'save4': '&#xe9c5;',
			'attachment': '&#xe9cd;',
			'paperclip': '&#xe9cd;',
			'eye': '&#xe9ce;',
			'views': '&#xe9ce;',
			'bookmark': '&#xe9d2;',
			'ribbon': '&#xe9d2;',
			'happy': '&#xe9df;',
			'emoticon': '&#xe9df;',
			'plus': '&#xea0a;',
			'add': '&#xea0a;',
			'cancel-circle': '&#xea0d;',
			'close': '&#xea0d;',
			'enter': '&#xea13;',
			'signin': '&#xea13;',
			'shuffle': '&#xea30;',
			'random': '&#xea30;',
			'circle-up': '&#xea41;',
			'up3': '&#xea41;',
			'circle-down': '&#xea43;',
			'down3': '&#xea43;',
			'new-tab': '&#xea7e;',
			'out2': '&#xea7e;',
			'0': 0
		};
		delete icons['0'];
		window.icomoonLiga = function (els) {
			var classes,
				el,
				i,
				innerHTML,
				key;
			els = els || document.getElementsByTagName('*');
			if (!els.length) {
				els = [els];
			}
			for (i = 0; ; i += 1) {
				el = els[i];
				if (!el) {
					break;
				}
				classes = el.className;
				if (/icomoon-liga/.test(classes)) {
					innerHTML = el.innerHTML;
					if (innerHTML && innerHTML.length > 1) {
						for (key in icons) {
							if (icons.hasOwnProperty(key)) {
								innerHTML = innerHTML.replace(new RegExp(key, 'g'), icons[key]);
							}
						}
						el.innerHTML = innerHTML;
					}
				}
			}
		};
		window.icomoonLiga();
	}
}());