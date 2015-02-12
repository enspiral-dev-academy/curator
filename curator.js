'use strict';
var _ = require('lodash');
var input = _.slice(process.argv, 2, process.argv.length);
var controllers = require('./lib/controllers/index.js');

switch (input.shift()) {
	case 'init':
		controllers.init(input);
		break;
	default:
		console.log('default');
		break;
}
// pass the command line args
//  probably a router class of some kind
// each command has it's own controller - build, init
//  use models if we need reusable logic - e.g. abstract file structure from rest of code