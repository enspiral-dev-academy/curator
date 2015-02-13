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
		describe(' with valid folders', function () {
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
				it('calls #createFolders with correct params', function () {
					return expect(init.createFolders.calledWith(folders)).to.eql(true);
				});
			});
			describe('with existing _templates folder', function () {
				before(function () {
					return fs.mkdirAsync(path.resolve(cwd, '_templates'))
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
			});
		});
	});
	describe('#createFolders', function () {
		before(function () {});
		after(function () {});
		xit('returns true', function () {});
	});
});