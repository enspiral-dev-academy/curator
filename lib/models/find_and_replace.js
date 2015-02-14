var BBPromise = require('bluebird');
var fs = BBPromise.promisifyAll(require('fs'));

function FindAndReplace() {

}

FindAndReplace.prototype = {
	execute: function (options, callback) {
		console.log('options', options)
			// read template.md file
		return fs.readFileAsync(options.src, options.encoding)
			.then(function (templateFileData) {
				console.log('templateFileData', templateFileData)
					// read the ruby code to put into new readme
					var _templateData;
				return BBPromise.map(options.replace, function (replace, index) {
					console.log('OPTIONS.REPLACE', replace)
					return fs.readFileAsync(replace, options.encoding)
						.then(function (dataToInsert) {
							console.log('data to insert', dataToInsert)
								// insert ruby code into saved template.md string
								_templateData = _templateData ? _templateData : templateFileData
							var editedDestFile = _templateData.replace(options.find[index], dataToInsert);
							_templateData = editedDestFile;
							// editedDestFile = templateFileData.replace(options.find, dataToInsert);
							console.log('editedDestFile', editedDestFile)
							console.log('destination', options.dest)
							if (!fs.existsSync(options.dest)) {
								console.log('doesnt exist!')
								return fs.openAsync(options.dest, 'wx+')
									.then(function () {
										return fs.writeFileAsync(options.dest, editedDestFile, {
												encoding: 'utf8'
											})
											.nodeify(callback);
									});
							}
							return fs.writeFileAsync(options.dest, editedDestFile, {
								encoding: 'utf8'
							});

						});
				}, {
					concurrency: 1
				}).nodeify(callback);


			});
	}
};

module.exports = new FindAndReplace();
// var fnr = new FindAndReplace();
// var cwd = process.cwd();
// var path = require('path');
// var source = path.resolve(cwd, 'test.js');
// var destination = path.resolve(cwd, 'dest.js');
// console.log(destination);
// var opts = {
// 	dest: destination,
// 	find: /a{4}/,
// 	replace: source,
// 	encoding: 'utf8'
// };

// // var opts = {
// 			src:'path to template.md file'
// // 	dest: 'path to readme-ruby.md,
// // 	find: '/include:code/',
// // 	replace: 'some ruby code from ',
// // 	encoding: 'utf8'
// // };
// fnr.execute(opts, function () {
// 	console.log('done!');
// });