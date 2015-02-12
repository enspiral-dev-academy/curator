var chai = require('chai');
var sinonChai = require("sinon-chai");
chai.use(sinonChai);
var expect = chai.expect;
var sinon = require('sinon');
var Init = require('../lib/controllers/init_prototype');
var init = new Init();
var BBPromise = require('bluebird');
var fs = BBPromise.promisifyAll(require('fs'));
var path = require('path');
var cwd = process.cwd();
var del = require('del');
var templatePath = path.resolve(cwd, '_templates');


// FUNKY EXPLAINING OF SINON AND PROTOTYPES:
describe('init', function () {
	describe('#initializeFolders', function () {
		describe('and with valid folders', function () {
			var folders = ['rb', 'cs', 'js'];
			describe('with no existing _templates folder', function () {
				before(function () {
					sinon.stub(init, 'createFolders').returns(BBPromise.resolve({}));
					del([
						'_templates/**',
					]);
				});
				after(function () {
					init.createFolders.restore();
				});
				it('calls #createFolders with correct params', function () {
					// console.log(init.createFolders.calledWith(folders))
					return init.initializeFolders(folders)
						.then(function () {
							return expect(init.createFolders.calledWith(folders)).to.eql(true);
						});
				});
				it('creates _templates folder', function () {
					return init.initializeFolders(folders)
						.then(function () {
							return expect(fs.existsSync(templatePath)).to.eql(true);
						});
				});
			});
			describe('with existing _templates folder', function () {
				before(function () {
					fs.mkdir(path.resolve(cwd, '_templates'),
						function () {
							sinon.stub(init, 'createFolders').returns(BBPromise.resolve({}));
						});
				});
				after(function () {
					init.createFolders.restore();
				});
				it('calls #createFolders with correct params', function () {
					return init.initializeFolders(folders)
						.then(function () {
							return expect(init.createFolders.calledWith(folders)).to.eql(true);
						});
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