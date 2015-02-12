'use strict';
var _ = require('lodash');
var errors = require('errors');
var config = require('config');
var languages = config.get("curator.languages");

exports.noFolderSpecified = function () {
	var string = "";
	string += "you must specify at least one folder name:";
	_.forEach(languages, function (word, acronym) {
		var str = "\n" + acronym + "   " + word;
		string += str;
	});
	errors.create({
		name: 'noFolderSpecified',
		defaultMessage: string
	});
	console.log(new errors.noFolderSpecified().toString());
};

exports.invalidArgument = function(arg) {
	var string = arg + ' is not a curator command. See \'curator --help\'';
	errors.create({
		name: 'invalidArgument',
		defaultMessage: string
	});
	console.log(new errors.invalidArgument().toString());
};

exports.help = function(arg) {
	var string = 'build, init';
	errors.create({
		name: 'usage: curator',
		defaultMessage: string
	});
	console.log(new errors.invalidArgument().toString());
};
