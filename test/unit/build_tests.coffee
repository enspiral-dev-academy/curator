'use strict'
Build = require('../../lib/controllers/build')
builder = new Build
chai = require('chai')
sinonChai = require('sinon-chai')
chai.use sinonChai
sinon = require('sinon')
expect = chai.expect
errors = require('errors')
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
models = require('../../lib/models/index')
config = require('config')
path = require('path')
cwd = path.resolve(process.cwd())
 
describe 'Build', ->
  describe '#bricklay', ->
    describe 'with no argument', ->
      before ->
        sinon.stub console, 'log'
        builder.bricklay()
      after ->
        console.log.restore()
      it 'console.logs an noFolderSpecified error', ->
        expect(console.log).to.have.been.calledWith (new (errors.noFolderSpecified)).toString()
    describe 'with folders = []', ->
      before ->
        sinon.stub console, 'log'
        builder.bricklay []
      after ->
        console.log.restore()
      it 'console.logs an noFolderSpecified error', ->
        expect(console.log).to.have.been.calledWith (new (errors.noFolderSpecified)).toString()
    describe 'with invalid folders', ->
      folders = [
        'tr'
        'fake'
      ]
      before ->
        sinon.stub console, 'log'
        builder.bricklay folders
      after ->
        console.log.restore()
      it 'console.logs an invalidArgument error', ->
        expect(console.log).to.have.been.calledWith (new (errors.invalidArgument)).toString()
    describe 'with ONE valid folder', ->
      folder = ['rb']
      before ->
        sinon.stub(builder, 'setOptions').returns BBPromise.resolve({})
        builder.bricklay folder
      after ->
        builder.setOptions.restore()
      it 'calls builder#setOptions', ->
        expect(builder.setOptions.calledWith(folder)).to.eql true
    describe 'with valid folders', ->
      folders = ['rb', 'cs', 'js']
      before ->
        sinon.stub(builder, 'setOptions').returns BBPromise.resolve({})
        builder.bricklay folders
      after ->
        builder.setOptions.restore()
      it 'calls builder#setOptions', ->
        expect(builder.setOptions.calledWith(folders)).to.eql true
      it 'calls builder#setOptions', ->
        expect(builder.setOptions.calledWith(folders)).to.eql true
  describe '#setOptions', ->
    folders = ['rb', 'cs', 'js']
    optionsRb = null
    optionsCs = null
    optionsJs = null
    before ->
      fileStructureRb = 
        _templates: cwd + '/_templates'
        template: cwd + '/_templates/template.md'
        newTemplate: cwd + '/readme-rb.md'
        rb: cwd + '/_templates/rb'
      fileStructureCs = 
        _templates: cwd + '/_templates'
        template: cwd + '/_templates/template.md'
        newTemplate: cwd + '/readme-cs.md'
        cs: cwd + '/_templates/cs'
      fileStructureJs = 
        _templates: cwd + '/_templates'
        template: cwd + '/_templates/template.md'
        newTemplate: cwd + '/readme-js.md'
        js: cwd + '/_templates/js'
      optionsRb = 
        encoding: 'utf8'
        replace: cwd + '/_templates/rb'
        dest: cwd + '/readme-rb.md'
        src: cwd + '/_templates/template.md'
      optionsCs = 
        encoding: 'utf8'
        replace: cwd + '/_templates/cs'
        dest: cwd + '/readme-cs.md'
        src: cwd + '/_templates/template.md'
      optionsJs = 
        encoding: 'utf8'
        replace: cwd + '/_templates/js'
        dest: cwd + '/readme-js.md'
        src: cwd + '/_templates/template.md'
      sinon.stub(models.findAndReplace, 'execute')
      fileStub = sinon.stub(models.fileStructure, 'getFolders')
      fileStub.onFirstCall().returns fileStructureRb
      fileStub.onSecondCall().returns fileStructureCs
      fileStub.onThirdCall().returns fileStructureJs
      builder.setOptions(folders)
    after ->
      models.findAndReplace.execute.restore()
      models.fileStructure.getFolders.restore()
    it 'calls models#fileStructure#getFolders with each of the files', ->
      expect(models.fileStructure.getFolders.calledWith(folders[0])).to.eql true
      expect(models.fileStructure.getFolders.calledWith(folders[1])).to.eql true
      expect(models.fileStructure.getFolders.calledWith(folders[2])).to.eql true
    it 'calls models#findAndReplace#execute with the correct options', ->
      expect(models.findAndReplace.execute.args[0][0]).to.eql optionsRb
      expect(models.findAndReplace.execute.args[1][0]).to.eql optionsCs
      expect(models.findAndReplace.execute.args[2][0]).to.eql optionsJs
