'use strict';
var chai = require('chai');
var sinonChai = require("sinon-chai");
chai.use(sinonChai);
var expect = chai.expect;
var sinon = require('sinon');
var initController = require('../../lib/controllers/init');
var uncache = require('require-uncache');
var path = require('path');
var cwd = process.cwd();
var helpers = require('../../lib/helpers/index');
var errors = require('errors');


describe('curator', function () {
	describe('init', function () {
		describe('with one cli argument', function () {
			before(function () {
				var args = ['node', 'some file path', 'init', 'rb'];
				sinon.stub(initController.prototype, 'initializeFolders');
				process.argv = args;
				require('../../curator');
			});
			after(function () {
				initController.prototype.initializeFolders.restore();
			});
			it('sends the correct params to init #initializeFolders', function () {
				expect(initController.prototype.initializeFolders.calledWith(['rb'])).to.eql(true);
			});
		});
		describe('with multiple cli argument', function () {
			before(function () {
				process.argv = ['node', 'second path to file', 'init', 'rb', 'cs'];
				sinon.stub(initController.prototype, 'initializeFolders').returns(true);
				// on first require of a file the argv is cached so need to uncache
				// on subsequent requires of the same file it may not even run it again
				// and so just use the cached info
				uncache(path.resolve(cwd, 'curator'));
				require('../../curator');
			});
			after(function () {
				initController.prototype.initializeFolders.restore();
			});
			it('sends the correct params to init #initializeFolders', function () {
				expect(initController.prototype.initializeFolders.calledWith(['rb', 'cs'])).to.eql(true);
			});
		});
	});
	describe('languages', function () {
		before(function () {
			uncache(path.resolve(cwd, 'curator'));
			var args = ['node', 'some file path', 'languages'];
			process.argv = args;
			sinon.spy(console, 'log');
			require('../../curator');
		});
		after(function () {
			uncache(path.resolve(cwd, 'curator'));
			console.log.restore();
		});
		it('console.logs the available languages', function () {
			var string = "Currently available languages:";
			return expect(console.log).to.have.been.calledWith(helpers.displayLanguages(string));
		});
	});
	describe('no argument', function () {
		before(function () {
			uncache(path.resolve(cwd, 'curator'));
		var args = ['node', 'some file path'];
			process.argv = args;
			sinon.spy(console, 'log');
			require('../../curator');
		});
		after(function () {
			uncache(path.resolve(cwd, 'curator'));
			console.log.restore();
		});
		it('console.logs a usage error', function () {
			return expect(console.log).to.have.been.calledWith(new errors.usage().toString());
		});
	});
	describe('--help', function () {
		before(function () {
			uncache(path.resolve(cwd, 'curator'));
			var args = ['node', 'some file path', '--help'];
			process.argv = args;
			sinon.spy(console, 'log');
			require('../../curator');
		});
		after(function () {
			uncache(path.resolve(cwd, 'curator'));
			console.log.restore();
		});
		it('console.logs an usage error', function () {
			return expect(console.log).to.have.been.calledWith(new errors.usage().toString());
		});
	});

});