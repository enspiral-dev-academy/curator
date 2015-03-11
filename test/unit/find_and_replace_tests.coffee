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
_ = require('lodash')
path = require('path')

describe 'find and replace model', ->
	describe '#execute', ->
		options = {
			encoding: 'utf8'
			src: 'source/file/path'
			dest:'destination/file/path'
			find: config.get('curator.findPhrases')
			replace: config.get('curator.fileTypes')
		}
		before ->
			sinon.stub(findAndReplace, 'readFile').returns(BBPromise.resolve("fake template data"))
			sinon.stub(findAndReplace, 'setTemplateData').returns(BBPromise.resolve({}))
			sinon.stub(findAndReplace, 'getRegEx').returns(['fake', 'array'])
			sinon.spy(console, 'log')
			findAndReplace.execute(options)
		after ->
			findAndReplace.readFile.restore()
			findAndReplace.getRegEx.restore()
			findAndReplace.setTemplateData.restore()
			console.log.restore()
		it 'calls #readFile with the template file and encoding', ->
			expect(findAndReplace.readFile.args[0]).to.eql [options.src, options.encoding]
		it 'calls #getRegEx with the template file data', ->
			expect(findAndReplace.getRegEx.calledWith("fake template data")).to.eql true
		it 'calls #setTemplateData with correct args', ->
			expect(findAndReplace.setTemplateData.calledWith(['fake', 'array'], "fake template data", options.replace, options.dest, options.encoding)).to.eql true
		it 'logs a success message', ->
			expect(console.log.calledWith('SUCCESS: ' + options.dest + ' successfully built' )).to.eql true
	describe '#readFile', ->
		before ->
			sinon.stub(fs, 'readFileAsync')
			findAndReplace.readFile('template data', 'utf8')
		after ->
			fs.readFileAsync.restore()
		it 'calls readFileAsync with the template file and encoding', ->
			expect(fs.readFileAsync.args[0]).to.eql ['template data', 'utf8']
	describe '#getRegEx', ->
		string = "test file include:code: end of test file"
		result = null
		before ->
			result = findAndReplace.getRegEx(string)
		it 'calls readFileAsync with the template file and encoding', ->
			expect(result).to.eql ['code']
	describe '#setTemplateData', ->
		describe 'with no existing file', ->
			_options = {
				filesNames: ['code', 'links', 'text'],
				templateFileData: 'fake template data include:code: after include:text: after include:links:',
				replace: 'code/',
				destination: 'destination',
				encoding: 'utf8',
			}
			filePaths = _.map(_options.filesNames, (file) -> 
				path.resolve(_options.replace, file + '.md')
			)
			before ->
				existStub = sinon.stub(fs, 'existsSync')
				existStub.onCall(0).returns(false)
				existStub.returns(true)
				sinon.stub(findAndReplace, 'writeFile').returns(BBPromise.resolve({}))
				sinon.stub(findAndReplace, 'readFile').returns(BBPromise.resolve(''))
				findAndReplace.setTemplateData(_options.filesNames, _options.templateFileData, _options.replace, _options.destination, _options.encoding)
			after ->
				fs.existsSync.restore()
				findAndReplace.readFile.restore()
				findAndReplace.writeFile.restore()
			it 'calls fs.existsSync with the path for each file', ->
				expect(fs.existsSync.args[0]).to.eql [filePaths[0]]
				expect(fs.existsSync.args[1]).to.eql [filePaths[1]]
				expect(fs.existsSync.args[2]).to.eql [filePaths[2]]
			it 'calls #writeFile for each of the files and destination file', ->
				expect(findAndReplace.writeFile.calledWith(_options.destination, 'fake template data  after  after ')).to.eql true
		describe 'with existing file', ->
			_options = {
				filesNames: ['code', 'text', 'links'],
				templateFileData: 'fake template data include:code: after include:text: after include:links:',
				replace: 'code/',
				destination: 'destination',
				encoding: 'utf8',
			}
			filePaths = _.map(_options.filesNames, (file) -> 
				path.resolve(_options.replace, file + '.md')
			)
			before ->
				existStub = sinon.stub(fs, 'existsSync').returns(true)
				sinon.stub(findAndReplace, 'writeFile').returns(BBPromise.resolve({}))
				sinon.stub(findAndReplace, 'readFile').returns(BBPromise.resolve(""))
				findAndReplace.setTemplateData(_options.filesNames, _options.templateFileData, _options.replace, _options.destination, _options.encoding)
			after ->
				fs.existsSync.restore()
				findAndReplace.readFile.restore()
				findAndReplace.writeFile.restore()
			it 'calls fs.existsSync with the path for each file', ->
				expect(fs.existsSync.args[0]).to.eql [filePaths[0]]
				expect(fs.existsSync.args[1]).to.eql [filePaths[1]]
				expect(fs.existsSync.args[2]).to.eql [filePaths[2]]
			it 'calls #writeFile for each of the files and destination file', ->
				expect(findAndReplace.writeFile.calledWith(_options.destination, 'fake template data  after  after ')).to.eql true
	describe '#writeFile', ->
		describe 'with no existing destination', ->
			_options = {
				templateFileData: 'fake template data',
				destination: 'destination',
			}
			before ->
				sinon.stub(fs, 'existsSync').returns(false)
				sinon.stub(fs, 'openAsync').returns(BBPromise.resolve())
				sinon.stub(fs, 'writeFileAsync').returns(BBPromise.resolve({}))
				findAndReplace.writeFile(_options.destination, _options.templateFileData)
			after ->
				fs.existsSync.restore()
				fs.writeFileAsync.restore()
				fs.openAsync.restore()
			it 'calls fs.existsSync with the destination file', ->
				expect(fs.existsSync.args[0]).to.eql [_options.destination]
			it 'calls fs.openAsync with the destination file', ->
				expect(fs.openAsync.calledWith(_options.destination, 'wx+')).to.eql true
			it 'calls fs.writeFileAsync fwith the correct args', ->
				expect(fs.writeFileAsync.calledWith(_options.destination, _options.templateFileData, encoding: 'utf8')).to.eql true
		describe 'with existing destination', ->
			_options = {
				templateFileData: 'fake template data',
				destination: 'destination',
			}
			before ->
				sinon.stub(fs, 'existsSync').returns(true)
				sinon.stub(fs, 'openAsync').returns(BBPromise.resolve())
				sinon.stub(fs, 'writeFileAsync').returns(BBPromise.resolve({}))
				findAndReplace.writeFile(_options.destination, _options.templateFileData)
			after ->
				fs.existsSync.restore()
				fs.writeFileAsync.restore()
				fs.openAsync.restore()
			it 'calls fs.existsSync with the destination file', ->
				expect(fs.existsSync.args[0]).to.eql [_options.destination]
			it 'doesn\'t call fs.openAsync with the destination file', ->
				expect(fs.openAsync.called).to.eql false
			it 'calls fs.writeFileAsync fwith the correct args', ->
				expect(fs.writeFileAsync.calledWith(_options.destination, _options.templateFileData, encoding: 'utf8')).to.eql true