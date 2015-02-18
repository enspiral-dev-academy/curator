'use strict'
chai = require('chai')
sinonChai = require('sinon-chai')
chai.use sinonChai
expect = chai.expect
sinon = require('sinon')
initController = require('../../lib/controllers/init')
uncache = require('require-uncache')
path = require('path')
cwd = process.cwd()
helpers = require('../../lib/helpers/index')
errors = require('errors')
describe 'curator', ->
  describe 'init', ->
    describe 'with one cli argument', ->
      before ->
        args = [
          'node'
          'some file path'
          'init'
          'rb'
        ]
        sinon.stub initController.prototype, 'initializeFolders'
        process.argv = args
        require '../../curator'
        return
      after ->
        initController::initializeFolders.restore()
        return
      it 'sends the correct params to init #initializeFolders', ->
        expect(initController::initializeFolders.calledWith([ 'rb' ])).to.eql true
        return
      return
    describe 'with multiple cli argument', ->
      before ->
        process.argv = [
          'node'
          'second path to file'
          'init'
          'rb'
          'cs'
        ]
        sinon.stub(initController.prototype, 'initializeFolders').returns true
        # on first require of a file the argv is cached so need to uncache
        # on subsequent requires of the same file it may not even run it again
        # and so just use the cached info
        uncache path.resolve(cwd, 'curator')
        require '../../curator'
        return
      after ->
        initController::initializeFolders.restore()
        return
      it 'sends the correct params to init #initializeFolders', ->
        expect(initController::initializeFolders.calledWith([
          'rb'
          'cs'
        ])).to.eql true
        return
      return
    return
  describe 'languages', ->
    before ->
      uncache path.resolve(cwd, 'curator')
      args = [
        'node'
        'some file path'
        'languages'
      ]
      process.argv = args
      sinon.spy console, 'log'
      require '../../curator'
      return
    after ->
      uncache path.resolve(cwd, 'curator')
      console.log.restore()
      return
    it 'console.logs the available languages', ->
      string = 'Currently available languages:'
      expect(console.log).to.have.been.calledWith helpers.displayLanguages(string)
    return
  describe 'no argument', ->
    before ->
      uncache path.resolve(cwd, 'curator')
      args = [
        'node'
        'some file path'
      ]
      process.argv = args
      sinon.spy console, 'log'
      require '../../curator'
      return
    after ->
      uncache path.resolve(cwd, 'curator')
      console.log.restore()
      return
    it 'console.logs a usage error', ->
      expect(console.log).to.have.been.calledWith (new (errors.usage)).toString()
    return
  describe '--help', ->
    before ->
      uncache path.resolve(cwd, 'curator')
      args = [
        'node'
        'some file path'
        '--help'
      ]
      process.argv = args
      sinon.spy console, 'log'
      require '../../curator'
      return
    after ->
      uncache path.resolve(cwd, 'curator')
      console.log.restore()
      return
    it 'console.logs an usage error', ->
      expect(console.log).to.have.been.calledWith (new (errors.usage)).toString()
    return
  return
