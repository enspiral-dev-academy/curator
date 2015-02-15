var BBPromise = require('bluebird');
var fs = BBPromise.promisifyAll(require('fs'));

function FindAndReplace() {}

// var options = {
// 	encoding: 'utf8',
// 	find: /include:code/,
// 	replace: '/Users/amelia/Documents/eda/curator/_templates/cs/code.md',
// 	dest: '/Users/amelia/Documents/eda/curator/readme-cs.md',
// 	src: '/Users/amelia/Documents/eda/curator/_templates/template.md'
// };


// this copy of find and replace doesnt do any iterating and assumes that had already been done,
// problem:
// it looks at options.src each time it is called, so first time finds the first include:text and 
// changes that to the correct text snippet and adds that to options.dest

// second time it finds include:code in the OPTIONS.SRC but as the options.src does not have the edited include:text
// it copies this unedited version into the options.dest and adds the correct code snipped 
// but in doing so 'undoes' the prevous interation call (that changed include:text to be a text snippet)
FindAndReplace.prototype = {
	execute: function (options, callback) {
		console.log('options', options)
			// read template.md file
		return fs.readFileAsync(options.src, options.encoding)
			.then(function (sourceFileData) {
				console.log('sourceFileData', sourceFileData)
				return fs.readFileAsync(options.replace, options.encoding)
					// read the ruby code to put into new readme
					.then(function (replaceFileData) {
						console.log('data to insert', replaceFileData)
						var editedSourceFileData = sourceFileData.replace(options.find, replaceFileData);
						console.log('editedSourceFileData', editedSourceFileData)
						if (!fs.existsSync(options.dest)) {
							console.log('doesnt exist!')
							return fs.openAsync(options.dest, 'wx+')
								.then(function () {
									return fs.writeFileAsync(options.dest, editedSourceFileData, {
											encoding: 'utf8'
										})
										.nodeify(callback);
								});
						}
						return fs.writeFileAsync(options.dest, editedSourceFileData, {
							encoding: 'utf8'
						}).then(function (data) {
							console.log('DATA', data)
						}).nodeify(callback);
					});
			});
	}
};

module.exports = new FindAndReplace();
