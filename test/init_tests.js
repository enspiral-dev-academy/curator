var chai = require('chai');
var sinonChai = require("sinon-chai");
chai.use(sinonChai);

var expect = chai.expect;
var sinon = require('sinon');



// FUNKY EXPLAINING OF SINON AND PROTOTYPES:
describe('init', function () {

	describe('#initializeFolders', function () {
		function myfunction() {}
		myfunction.prototype.test = function (testArg) {
			this.testArg = testArg;
		};

		var test = new myfunction();
		test.test('boo');
		before(function () {
			// sinon.stub(myfunction.prototype, 'test');
			new myfunction().test('hello');
			sinon.stub(test, 'test');
			test.test('boo');
		});
		after(function () {});
		it('returns true', function () {
			expect(test.test.calledWith('boo')).to.eql(true);
		});
		it('returns true', function () {
			expect(myfunction.prototype.test.calledWith('hello')).to.eql(true);
		});
	});
	describe('#createFolders', function () {

		before(function () {

		});
		after(function () {});
		it('returns true', function () {
			expect(true).to.eql(true);
		});
	});
});
