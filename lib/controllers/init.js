'use strict';
// OLD NON PROTOTYPE


var BBPromise = require('bluebird');
var fs = BBPromise.promisifyAll(require('fs'));
var path = require('path');
var _ = require('lodash');
var mainFolder = '_templates';
var cwd = process.cwd();
var filenames = ['code.md', 'links.md', 'text.md'];
var Errors = require('../errors/index');

var initializeFolders = function (folders) {
	if (folders.length === 0) {
		return Errors.argument.noFolderSpecified();
	}
	var templatePath = path.resolve(cwd, mainFolder);
	return fs.mkdirAsync(templatePath)
		.then(function (result) {
			console.log(mainFolder + ' folder has been created inside ' + cwd);
			return createFolders(folders, templatePath);
		})
		.catch(function (err) {
			console.log('WARNING: ' + mainFolder + ' folder already exists inside ' + cwd + ' trying to create sub folders...');
			return createFolders(folders, templatePath);
		});
};

var createFolders = function (folders, templatePath) {
	return BBPromise.settle(_.forEach(folders, function (folder) {
		var nestedFolderPath = path.resolve(templatePath, folder);
		return fs.mkdirAsync(nestedFolderPath)
			.then(function (data) {
				console.log(folder + ' folder has been created inside the ' + mainFolder + 'folder');
				return createFiles(nestedFolderPath);
			})
			.catch(function (err) {
				console.log('WARNING: ' + nestedFolderPath + ' already exists');
				return createFiles(nestedFolderPath);
			});
	}));
};

var createFiles = function (nestedFolderPath) {
	return BBPromise.settle(_.forEach(filenames, function (filename) {
		var nestedFilePath = path.resolve(nestedFolderPath, filename);
		return fs.openAsync(nestedFilePath, "wx+")
			.then(function (data) {
				return console.log(filename + ' added to nestedFolderPath!');
			})
			.catch(function (err) {
				return console.log('ERROR: ' + filename + " already exists!");
			});
	}));
};

module.exports = initializeFolders;