'use strict';
var Build = require('../../lib/controllers/build');
var builder = new Build();
var chai = require('chai');
var sinonChai = require("sinon-chai");
chai.use(sinonChai);
var sinon = require('sinon');
var expect = chai.expect;
var errors = require('errors');
var BBPromise = require('bluebird');

describe.only('Build', function () {
	describe('#bricklay', function () {
		describe('with no argument', function () {
			before(function () {
				sinon.spy(console, 'log');
				return builder.bricklay();
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
				return builder.bricklay([]);
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
				return builder.bricklay(folders);
			});
			after(function () {
				console.log.restore();
			});
			it('console.logs an invalidArgument error', function () {
				return expect(console.log).to.have.been.calledWith(new errors.invalidArgument().toString());
			});
		});
		describe.skip('with valid folders', function () {
			var folders = ['rb', 'cs', 'js'];
			before(function () {
				sinon.stub(builder, 'setOptions').returns(BBPromise.resolve({}));
			});
			after(function () {
				init.createFolders.restore();
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
	});
	describe.skip('#setOptions', function () {
		before(function () {});
		after(function () {});
		it('console.logs an noFolderSpecified error', function () {});
	});
});