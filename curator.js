'use strict';
var _ = require('lodash');
var input = _.slice(process.argv, 2, process.argv.length);
var controllers = require('./lib/controllers/index');
var Errors = require('./lib/errors/index');
var helpers = require('./lib/helpers/index');

var argument = input.shift();

switch (argument) {
	case 'init':
		var init = new controllers.init();
		init.initializeFolders(input);
		break;
	case 'languages':
		var string = "Currently available languages:";
		console.log(helpers.displayLanguages(string));
		break;
	case undefined:
		Errors.argument.help();
		break;
	case "--help":
		Errors.argument.help();
		break;
	default:
		Errors.argument.invalidCommand(argument);
		break;
}
// pass the command line args
//  probably a router class of some kind
// each command has it's own controller - build, init
//  use models if we need reusable logic - e.g. abstract file structure from rest of code