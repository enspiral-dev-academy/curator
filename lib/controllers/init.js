var BBPromise = require('bluebird');
var fs = BBPromise.promisifyAll(require('fs'));
var path = require('path');
var _ = require('lodash');
var mainFolder = '_templates';
var cwd = process.cwd();

// var Errors = require('../errors/index');
// looks at argv, and sees if there's js, c#, rb, etc
// send argv to model that creates folders 
// 

var initializeFolders = function (folders) {
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
			})
			.catch(function (err) {
				// throw new Errors.file
				// throw new Error "file not found"
				var string = 'ERROR: ' + nestedFolderPath + ' already exists ';
				console.log(string);
			});
	}));

};
// check _templates dir exists

// no : 
// make _templates dir

//yes; 
// make folder based on input type (rb) if it doesnt exist
// make files for input type (rb) ex-code.rb if it doesnt exists



module.exports = initializeFolders;