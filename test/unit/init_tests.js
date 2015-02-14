var chai = require('chai');
var sinonChai = require("sinon-chai");
chai.use(sinonChai);
var expect = chai.expect;
var sinon = require('sinon');
var Init = require('../../lib/controllers/init_prototype');
var init = new Init();
var BBPromise = require('bluebird');
var fs = BBPromise.promisifyAll(require('fs'));
var path = require('path');
var cwd = process.cwd();
var del = require('del');
var errors = require('errors');
var _ = require('lodash');
// var del = BBPromise.promisify(require('del'));

var templatePath = path.resolve(cwd, '_templates');


describe('init', function () {
	describe('#initializeFolders', function () {
		describe('with no argument', function () {
			before(function () {
				sinon.spy(console, 'log');
				return init.initializeFolders();
			});
			after(function () {
				console.log.restore();
			});
			it('console.logs an noFolderSpecified error', function () {
				return expect(console.log).to.have.been.calledWith(new errors.noFolderSpecified().toString());
			});
		});
		describe('with folders = []', function () {
			before(function () {
				sinon.spy(console, 'log');
				return init.initializeFolders([]);
			});
			after(function () {
				console.log.restore();
			});
			it('console.logs an noFolderSpecified error', function () {
				return expect(console.log).to.have.been.calledWith(new errors.noFolderSpecified().toString());
			});
		});
		describe('with invalid folders', function () {
			var folders = ['tr', 'fake'];
			before(function () {
				sinon.spy(console, 'log');
				return init.initializeFolders(folders);
			});
			after(function () {
				console.log.restore();
			});
			it('console.logs an invalidArgument error', function () {
				return expect(console.log).to.have.been.calledWith(new errors.invalidArgument().toString());
			});
		});
		describe('with valid folders', function () {
			var folders = ['rb', 'cs', 'js'];
			before(function () {
				sinon.stub(init, 'createFolders').returns(BBPromise.resolve({}));
			});
			after(function () {
				init.createFolders.restore();
			});
			describe('with no existing _templates folder', function () {
				before(function () {
					sinon.spy(fs, 'mkdirAsync');
					del([
						'_templates/**',
					], function () {
						return init.initializeFolders(folders);
					});
				});
				after(function (done) {
					fs.mkdirAsync.restore();

					del([
						'_templates/**',
					], done);
				});
				it('calls fs.mkdirAsync', function () {
					return expect(fs.mkdirAsync.calledWith(templatePath)).to.eql(true);
				});
				it('creates _templates folder', function () {
					return expect(fs.existsSync(templatePath)).to.eql(true);
				});
				it('creates templates.md file', function () {
					return expect(fs.existsSync(templatePath + '/template.md')).to.eql(true);
				});
				it('calls #createFolders with correct params', function () {
					return expect(init.createFolders.calledWith(folders)).to.eql(true);
				});
			});

			describe('with existing _templates folder', function () {
				describe('with no existing templates.md file', function () {
					before(function () {
						return fs.mkdirAsync(templatePath)
							.then(function () {
								sinon.spy(fs, 'mkdirAsync');
							});
					});
					after(function (done) {
						fs.mkdirAsync.restore();
						del([
							'_templates/**',
						], done);
					});
					it('calls #createFolders with correct params', function () {
						return init.initializeFolders(folders)
							.then(function () {
								return expect(init.createFolders.calledWith(folders)).to.eql(true);
							});
					});
					it('doesnt call fs.mkdirAsync', function () {
						return expect(fs.mkdirAsync.notCalled).to.eql(true);
					});
					it('creates templates.md file', function () {
						return expect(fs.existsSync(templatePath + '/template.md')).to.eql(true);
					});
				});
				describe('with existing templates.md file', function () {
					before(function () {
						return fs.mkdirAsync(templatePath)
							.then(function () {
								sinon.spy(fs, 'mkdirAsync');
								return fs.openAsync(templatePath + '/template.md', 'wx+');
							});
					});
					after(function (done) {
						fs.mkdirAsync.restore();
						del([
							'_templates/**',
						], done);
					});
					it('calls #createFolders with correct params', function () {
						return init.initializeFolders(folders)
							.then(function () {
								return expect(init.createFolders.calledWith(folders)).to.eql(true);
							});
					});
					it('doesnt call fs.mkdirAsync', function () {
						return expect(fs.mkdirAsync.notCalled).to.eql(true);
					});
				});
			});
		});
	});
	describe('#createFiles', function () {
		var filenames = ['code.md', 'links.md', 'text.md'];
		var nestedFolderPath = path.resolve(templatePath, 'rb');
		var filesPaths;
		var successFileStrings;
		before(function () {
			filesPaths = _.map(filenames, function (name) {
				return path.resolve(nestedFolderPath, name);
			});
			successFileStrings = _.map(filenames, function (name) {
				return 'SUCCESS: ' + name + ' added to ' + nestedFolderPath;
			});
		});
		describe('with no existing files', function () {
			before(function () {
				sinon.spy(console, 'log');
				sinon.spy(path, 'resolve');
				sinon.spy(fs, 'openAsync');
				return fs.mkdirAsync(templatePath)
					.then(function () {
						return fs.mkdirAsync(nestedFolderPath)
							.then(function () {
								return init.createFiles(nestedFolderPath);
							});
					});
			});
			after(function (done) {
				console.log.restore();
				path.resolve.restore();
				fs.openAsync.restore();
				del([
					'_templates/**',
				], done);
			});
			it('calls fs#openAsync for each of the required files', function () {
				expect(fs.openAsync.calledWith(filesPaths[0], 'wx+')).to.eql(true);
				expect(fs.openAsync.calledWith(filesPaths[1], 'wx+')).to.eql(true);
				expect(fs.openAsync.calledWith(filesPaths[2], 'wx+')).to.eql(true);
			});
			it('console.logs success message for each file created', function () {
				expect(console.log).to.have.been.calledWith(successFileStrings[0]);
				expect(console.log).to.have.been.calledWith(successFileStrings[1]);
				expect(console.log).to.have.been.calledWith(successFileStrings[2]);
			});
			it('creates a file for links, text and code', function () {
				expect(fs.existsSync(nestedFolderPath + '/code.md')).to.eql(true);
				expect(fs.existsSync(nestedFolderPath + '/links.md')).to.eql(true);
				expect(fs.existsSync(nestedFolderPath + '/text.md')).to.eql(true);
			});
		});

		describe('with existing files', function () {
			var errorMessage = 'ERROR: ' + nestedFolderPath + '/' + filenames[0] + " already exists!";
			before(function () {
				sinon.spy(console, 'log');
				sinon.spy(path, 'resolve');
				sinon.spy(fs, 'openAsync');

				return fs.mkdirAsync(templatePath)
					.then(function () {
						return fs.mkdirAsync(nestedFolderPath)
							.then(function () {
								return fs.openAsync(filesPaths[0], "wx+")
									.then(function () {
										return init.createFiles(nestedFolderPath);
									});
							});
					});
			});
			after(function (done) {
				console.log.restore();
				path.resolve.restore();
				fs.openAsync.restore();
				del([
					'_templates/**',
				], done);
			});
			it('calls fs#openAsync for each of the required files', function () {
				expect(fs.openAsync.calledWith(filesPaths[0], 'wx+')).to.eql(true);
				expect(fs.openAsync.calledWith(filesPaths[1], 'wx+')).to.eql(true);
				expect(fs.openAsync.calledWith(filesPaths[2], 'wx+')).to.eql(true);
			});
			it('console.logs error message for each file created', function () {
				expect(console.log).to.have.been.calledWith(errorMessage);
				expect(console.log).to.have.been.calledWith(successFileStrings[1]);
				expect(console.log).to.have.been.calledWith(successFileStrings[2]);
			});
			it('creates a file for links, text and code', function () {
				expect(fs.existsSync(nestedFolderPath + '/code.md')).to.eql(true);
				expect(fs.existsSync(nestedFolderPath + '/links.md')).to.eql(true);
				expect(fs.existsSync(nestedFolderPath + '/text.md')).to.eql(true);
			});
		});
	});
});