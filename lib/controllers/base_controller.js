'use strict';
var helpers = require('./index');
var Errors = require('../errors/index');

function BaseController() {}

BaseController.prototype = {
	checkFolders:function (folders) {
		if (!folders || folders.length === 0) {
			return Errors.argument.noFolderSpecified();
		}
		var invalidLanguages = helpers.invalidLanguages(folders);
		if (invalidLanguages.length > 0) {
			return Errors.argument.invalidArgument(invalidLanguages);
		}
	}
};