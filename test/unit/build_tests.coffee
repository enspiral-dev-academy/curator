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

describe 'Build', ->
  describe '#bricklay', ->
    describe 'with no argument', ->
      before ->
        sinon.spy console, 'log'
        builder.bricklay()
      after ->
        console.log.restore()
      it 'console.logs an noFolderSpecified error', ->
        expect(console.log).to.have.been.calledWith (new (errors.noFolderSpecified)).toString()
    describe 'with folders = []', ->
      before ->
        sinon.spy console, 'log'
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
        sinon.spy console, 'log'
        builder.bricklay folders
      after ->
        console.log.restore()
      it 'console.logs an invalidArgument error', ->
        expect(console.log).to.have.been.calledWith (new (errors.invalidArgument)).toString()
    describe 'with valid folders', ->
      folders = ['rb', 'cs', 'js']
      before ->
        sinon.stub(builder, 'setOptions').returns BBPromise.resolve({})
        builder.bricklay folders
      after ->
        builder.setOptions.restore()
      it 'calls builder#setOptions', ->
        expect(builder.setOptions.calledWith(folders)).to.eql true
  describe '#setOptions', ->
    folders = ['rb', 'cs', 'js']
    options = 
      encoding: 'utf8'
      find: [/include:code/, /include:links/, /include:text/ ]
      replace: [
        '/Users/amelia/Documents/eda/curator/_templates/rb/code.md'
        '/Users/amelia/Documents/eda/curator/_templates/rb/links.md'
        '/Users/amelia/Documents/eda/curator/_templates/rb/text.md']
      dest: '/Users/amelia/Documents/eda/curator/readme-rb.md'
      src: '/Users/amelia/Documents/eda/curator/_templates/template.md'
    before ->
      fileStructure = 
        _templates: '/Users/amelia/Documents/eda/curator/_templates'
        template: '/Users/amelia/Documents/eda/curator/_templates/template.md'
        newTemplate: '/Users/amelia/Documents/eda/curator/readme-rb.md'
        rb: '/Users/amelia/Documents/eda/curator/_templates/rb'
        code: '/Users/amelia/Documents/eda/curator/_templates/rb/code.md'
        links: '/Users/amelia/Documents/eda/curator/_templates/rb/links.md'
        text: '/Users/amelia/Documents/eda/curator/_templates/rb/text.md' 
      console.log('fileStructure!', fileStructure)
      sinon.stub(models.findAndReplace, 'execute')
      sinon.stub( models.fileStructure, 'getFolders').returns fileStructure
      builder.setOptions(folders)
    after ->
      models.findAndReplace.execute.restore()
      models.fileStructure.getFolders.restore()
    it 'calls models#fileStructure#getFolders with each of the files', ->
      expect(models.fileStructure.getFolders.calledWith(folders[0])).to.eql true
      expect(models.fileStructure.getFolders.calledWith(folders[1])).to.eql true
      expect(models.fileStructure.getFolders.calledWith(folders[2])).to.eql true
    it 'calls models#findAndReplace#execute with the correct options', ->
      expect(models.findAndReplace.execute.calledWith(options)).to.eql true
