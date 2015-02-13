'use strict';
var _ = require('lodash');
var errors = require('errors');
var config = require('config');
var languages = config.get("curator.languages");
var helpers = require('../helpers/index');
var BBPromise = require('bluebird');

exports.noFolderSpecified = function () {
	var string = "you must specify at least one folder name:";
	string = helpers.displayLanguages(string);
	errors.create({
		name: 'noFolderSpecified',
		defaultMessage: string
	});

	console.log(new errors.noFolderSpecified().toString());
};

exports.invalidCommand = function (arg) {
	var string = arg + ' is not a curator command. See \'curator --help\'';
	errors.create({
		name: 'invalidCommand',
		defaultMessage: string
	});
	console.log(new errors.invalidCommand().toString());
};

exports.invalidArgument = function (arg) {
	var string = arg + ' is not a curator argument. See \'curator --help\'';
	errors.create({
		name: 'invalidArgument',
		defaultMessage: string
	});
	console.log(new errors.invalidArgument().toString());
};

exports.help = function (arg) {
	var string = 'build, init';
	errors.create({
		name: 'usage',
		defaultMessage: string
	});
	console.log(new errors.usage().toString());
};