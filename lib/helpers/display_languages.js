'use strict';
var _ = require('lodash');
var config = require('config');
var languages = config.get("curator.languages");


var displayLanguages = function(string) {
	_.forEach(languages, function (word, acronym) {
		var str = "\n" + acronym + "   " + word;
		string += str;
	});
	return string;
};


module.exports = displayLanguages;