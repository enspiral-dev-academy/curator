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
		var opts = {
			encoding: 'utf8'
		};
		// go through rb cs js and get correct path to each folder
		return BBPromise.map(folders, function (folder) {
			opts.find = [];
			opts.replace = [];
			var fileStructure = models.fileStructure.getFolders(folder);
			console.log('fileStructure', fileStructure)
			opts.dest = fileStructure.newTemplate;
			opts.src = fileStructure.template;

			// go through each file type - code links and text
			return BBPromise.map(fileTypes, function (type) {
				opts.replace.push(fileStructure[type]);
				var find = 'include:' + type;
				find = new RegExp(find);
				opts.find.push(find);
				console.log('find', find);

			}, {
				concurrency: 1
			}).then(function () {
				return models.findAndReplace.execute(opts)
					.then(function () {
						console.log('after all the settle');
					});
			});
		}, {
			concurrency: 1
		});
	}
};

module.exports = Build;