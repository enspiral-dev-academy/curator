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

// var options = {
// 	encoding: 'utf8',
// 	find: [/include:code/, /include:links/, /include:text/],
// 	replace: ['/Users/amelia/Documents/eda/curator/_templates/cs/code.md',
// 		'/Users/amelia/Documents/eda/curator/_templates/cs/links.md',
// 		'/Users/amelia/Documents/eda/curator/_templates/cs/text.md'
// 	],
// 	dest: '/Users/amelia/Documents/eda/curator/readme-cs.md',
// 	src: '/Users/amelia/Documents/eda/curator/_templates/template.md'
// };
