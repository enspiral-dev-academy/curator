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
describe 'Build', ->
  describe '#bricklay', ->
    describe 'with no argument', ->
      before ->
        sinon.spy console, 'log'
        builder.bricklay()
      after ->
        console.log.restore()
        return
      it 'console.logs an noFolderSpecified error', ->
        expect(console.log).to.have.been.calledWith (new (errors.noFolderSpecified)).toString()
      return
    describe 'with folders = []', ->
      before ->
        sinon.spy console, 'log'
        builder.bricklay []
      after ->
        console.log.restore()
        return
      it 'console.logs an noFolderSpecified error', ->
        expect(console.log).to.have.been.calledWith (new (errors.noFolderSpecified)).toString()
      return
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
        return
      it 'console.logs an invalidArgument error', ->
        expect(console.log).to.have.been.calledWith (new (errors.invalidArgument)).toString()
      return
    describe.skip 'with valid folders', ->
      folders = [
        'rb'
        'cs'
        'js'
      ]
      before ->
        sinon.stub(builder, 'setOptions').returns BBPromise.resolve({})
        return
      after ->
        init.createFolders.restore()
        return
      it 'calls fs.mkdirAsync', ->
        expect(fs.mkdirAsync.calledWith(templatePath)).to.eql true
      it 'creates _templates folder', ->
        expect(fs.existsSync(templatePath)).to.eql true
      it 'creates templates.md file', ->
        expect(fs.existsSync(templatePath + '/template.md')).to.eql true
      it 'calls #createFolders with correct params', ->
        expect(init.createFolders.calledWith(folders)).to.eql true
      return
    return
  describe.skip '#setOptions', ->
    before ->
    after ->
    it 'console.logs an noFolderSpecified error', ->
    return
  return
