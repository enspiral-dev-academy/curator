'use strict'
chai = require('chai')
sinonChai = require('sinon-chai')
chai.use sinonChai
expect = chai.expect
sinon = require('sinon')
findAndReplace = require('../../lib/models/find_and_replace')
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
config = require('config')

describe 'find and replace model', ->
	describe '#execute', ->
		options = {
			encoding: 'utf8'
			src: 'source/file/path'
			dest:'destination/file/path'
			find: config.get('curator.findPhrases')
			replace: config.get('curator.fileTypes')
		}
		called = false
		callback = () -> 
	  	called = true

		before ->
	  	readFileStub = sinon.stub(fs, 'readFileAsync')
	  	readFileStub.onCall(0).returns(BBPromise.resolve('<template file data here>'))
	  	readFileStub.onCall(1).returns(BBPromise.resolve('<first data to insert>'))
	  	readFileStub.onCall(2).returns(BBPromise.resolve('<second data to insert>'))
	  	readFileStub.onCall(3).returns(BBPromise.resolve('<third data to insert>'))
	  	existStub = sinon.stub(fs, 'existsSync')
	  	existStub.onCall(0).returns(false)
	  	existStub.returns(true)
	  	sinon.stub(fs, 'writeFileAsync').returns(BBPromise.resolve({}))
	  	sinon.stub(fs, 'openAsync').returns(BBPromise.resolve({}))
	  	findAndReplace.execute(options, callback)
  	after ->
    	fs.readFileAsync.restore()
    	fs.existsSync.restore()
    	fs.writeFileAsync.restore()
    	fs.openAsync.restore()
	  it 'calls readFileAsync with the template file and encoding', ->
	  	expect(fs.readFileAsync.args[0]).to.eql [options.src, options.encoding]
	  it 'calls readFileAsync a for each of the replace files and encoding', ->
	  	expect(fs.readFileAsync.calledWith(options.replace[0], options.encoding)).to.eql true
	  	expect(fs.readFileAsync.calledWith(options.replace[1], options.encoding)).to.eql true
  		expect(fs.readFileAsync.calledWith(options.replace[2], options.encoding)).to.eql true
	  it 'calls existsSync for each replace file', ->
	  	expect(fs.existsSync.calledThrice).to.eql true
	  it 'calls openAsync once ', ->
	  	expect(fs.openAsync.calledOnce).to.eql true
	  it 'calls writeFileAsync for each of the replace files', ->
	  	expect(fs.writeFileAsync.calledThrice).to.eql true

