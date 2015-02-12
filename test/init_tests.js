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
		before(function () {
		});
		after(function () {});
		it('calls method directly', function () {
      sinon.stub(test, 'test');
			test.test('boo');
			expect(test.test.calledWith('boo')).to.eql(true);
		});
		it('calls prototype method', function () {
      sinon.stub(myfunction.prototype, 'test');
      myfunction.prototype.test('hello');
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
