'use strict';
var BBPromise = require('bluebird');
var fs = BBPromise.promisifyAll(require('fs'));
var path = require('path');
var _ = require('lodash');
var mainFolder = '_templates';
var cwd = process.cwd();
var filenames = ['code.md', 'links.md', 'text.md'];
var Errors = require('../errors/index');
var helpers = require('../helpers/index');

function Init() {
	this.templatePath = path.resolve(cwd, mainFolder);
}

Init.prototype = {
	initializeFolders: function (folders) {
		if (!folders || folders.length === 0) {
			return Errors.argument.noFolderSpecified();
		}
		// check to see if folders are each included in config.curator.languages
		var invalidLanguages = helpers.invalidLanguages(folders);
		if (invalidLanguages.length > 0) {
			return BBPromise.reject(Errors.argument.invalidArgument(invalidLanguages));
		}
		if (fs.existsSync(this.templatePath)) {
			// folder already there
			console.log('WARNING: ' + mainFolder + ' folder already exists inside ' + cwd + ' trying to create sub folders...');
			return this.createFolders(folders)
				.then(function (data) {
					return BBPromise.resolve(console.log('completed curator init'));
				});
		} else {
			// no folder
			return fs.mkdirAsync(this.templatePath)
				.bind(this)
				.then(function () {
					console.log('SUCCESS: ' + mainFolder + ' folder has been created inside ' + cwd);
					return this.createFolders(folders);
				}).then(function (data) {
					return console.log('completed curator init');
				});
		}
	},

	createFolders: function (folders) {
		// forEach returned the input value to the function called for each element in folders
		// _.forEach['rb, 'cs', 'js'] => returned _settledValues of 'rb', 'cs' and 'js'
		// _.map returns the result of calling the function :)
		return BBPromise.settle(_.map(folders, _.bind(function (folder) {
			var nestedFolderPath = path.resolve(this.templatePath, folder);
			if (fs.existsSync(nestedFolderPath)) {
				// folder already there
				console.log('WARNING: ' + nestedFolderPath + ' already exists, trying to create sub files...');
				return this.createFiles(nestedFolderPath);
			} else {
				// no folder
				return fs.mkdirAsync(nestedFolderPath)
					.bind(this)
					.then(function () {
						console.log('SUCCESS: ' + folder + ' folder has been created inside the ' + mainFolder + 'folder');
						return this.createFiles(nestedFolderPath);
					});
			}
		}, this)));
	},

	createFiles: function (nestedFolderPath) {
		return BBPromise.settle(_.map(filenames, function (filename) {
			var nestedFilePath = path.resolve(nestedFolderPath, filename);
			return fs.openAsync(nestedFilePath, "wx+")
				.then(function () {
					return console.log('SUCCESS: ' + filename + ' added to ' + nestedFolderPath);
				})
				.catch(function (err) {
					return console.log('ERROR: ' + nestedFolderPath + '/' + filename + " already exists!");
				});
		}));
	}

};

module.exports = Init;