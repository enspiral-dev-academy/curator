'use strict';
var _ = require('lodash');
var config = require('config');
var languages = config.get("curator.languages");


var invalidLanguages = function (languages) {
	if (typeof languages === 'string') {
		languages = [languages];
	}
	// if ( languages.constructor !== Array) {
	// 	// languages = languages;
	// }
	var map = _.map(languages, function (language) {
		if (!_.has(config.get('curator.languages'), language)) {
			return language;
		}
	});
	map = _.compact(map);
	return map;
};

module.exports = invalidLanguages;