var cwd = process.cwd();
var _ = require('lodash');
var path = require('path');

function FileStructure() {
	this.filenames = ['code.md', 'links.md', 'text.md'];

}
FileStructure.prototype = {
	getFolders: function (language) {
		var files = {
			_templates: path.resolve(cwd, '_templates')

		};
		files.template = path.resolve(files._templates, 'template.md');
		var languageReadme = 'readme-' + language + '.md';
		console.log(languageReadme)
		files.newTemplate = path.resolve(cwd, languageReadme);
		files[language] = path.resolve(files._templates, language);
		console.log(files[language])
		_.forEach(this.filenames, function (file) {
			fileName = file.match(/(\w+)\.md/)[1];
			files[fileName] = path.resolve(files[language], file);
		});
		return files;
	}
};

module.exports = new FileStructure();