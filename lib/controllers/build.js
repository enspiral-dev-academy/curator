var Errors = require('../errors/index');
var models = require('../models/index');
var config = require('config');
var fileTypes = config.get('curator.fileTypes');
var helpers = require('../helpers/index');
var BBPromise = require('bluebird');
var _ = BBPromise.promisifyAll(require('lodash'));


function Build() {}

Build.prototype = {
	bricklay: function (folders) {
		if (!folders || folders.length === 0) {
			return Errors.argument.noFolderSpecified();
		}
		var invalidLanguages = helpers.invalidLanguages(folders);
		if (invalidLanguages.length > 0) {
			return Errors.argument.invalidArgument(invalidLanguages);
		}
		// for each folder go to the template.md file
		// for each folder save its file structure using models/filestructure/getfolders

		// check for includes:code / includes:text / includes:link in template.md
		// when it gets to an include find the appropriate key in the file strcture
		// filestructure.code would give the path to the code.md file
		// read from the code.md file and write into the template.md file, replacing the include:code part
		return BBPromise.map(folders, function (folder) {
			var fileStructure = models.fileStructure.getFolders(folder);
			console.log('fileStructure', fileStructure)
			return BBPromise.map(fileTypes, function (type) {
				var find = 'include:' + type;
				find = new RegExp(find)
				console.log('find', find)
				var opts = {
					dest: fileStructure.newTemplate,
					src: fileStructure.template,
					find: find,
					replace: fileStructure[type],
					encoding: 'utf8'
				};
				return models.findAndReplace.execute(opts)
			}, {
				concurrency: 1
			});

		}, {
			concurrency: 1
		}).then(function () {
			console.log('after all the settle');
		});
	}
};

module.exports = Build;