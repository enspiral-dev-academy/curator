'use strict';
var _ = require('lodash');
var config = require('config');
var languages = config.get("curator.languages");


var validLanguage = function (languages) {
	if (typeof languages === 'string') {
		languages = [languages];
	}
	if ( languages.constructor !== Array) {
		languages = languages;
	}

	var map = _.map(languages, function (language) {
		return _.has(config.get('curator.languages'), language);
	});
	// check to see if any of the languages provided were false
	if (_.includes(map, false) ) {
		return false;
	}
	return true
};


module.exports = validLanguage;