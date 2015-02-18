'use strict'
chai = require('chai')
sinonChai = require('sinon-chai')
chai.use(sinonChai)
expect = chai.expect
sinon = require('sinon')
Init = require('../../lib/controllers/init')
init = new Init
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
path = require('path')
cwd = process.cwd()
del = require('del')
errors = require('errors')
_ = require('lodash')

templatePath = path.resolve(cwd, '_templates')


describe 'init', ->
  describe '#initializeFolders', ->
    describe 'with no argument', ->
      before ->
        sinon.spy console, 'log'
        init.initializeFolders()
      after ->
        console.log.restore()
        return
      it 'console.logs an noFolderSpecified error', ->
        expect(console.log).to.have.been.calledWith (new (errors.noFolderSpecified)).toString()
      return
    describe 'with folders = []', ->
      before ->
        sinon.spy console, 'log'
        init.initializeFolders []
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
        init.initializeFolders folders
      after ->
        console.log.restore()
        return
      it 'console.logs an invalidArgument error', ->
        expect(console.log).to.have.been.calledWith (new (errors.invalidArgument)).toString()
      return
    describe 'with valid folders', ->
      folders = [
        'rb'
        'cs'
        'js'
      ]
      before ->
        sinon.stub(init, 'createFolders').returns BBPromise.resolve({})
        return
      after ->
        init.createFolders.restore()
        return
      describe 'with no existing _templates folder', ->
        before ->
          sinon.spy fs, 'mkdirAsync'
          del [ '_templates/**' ], ->
            init.initializeFolders folders
          return
        after (done) ->
          fs.mkdirAsync.restore()
          del [ '_templates/**' ], done
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
      describe 'with existing _templates folder', ->
        describe 'with no existing templates.md file', ->
          before ->
            fs.mkdirAsync(templatePath).then ->
              sinon.spy fs, 'mkdirAsync'
              return
          after (done) ->
            fs.mkdirAsync.restore()
            del [ '_templates/**' ], done
            return
          it 'calls #createFolders with correct params', ->
            init.initializeFolders(folders).then ->
              expect(init.createFolders.calledWith(folders)).to.eql true
          it 'doesnt call fs.mkdirAsync', ->
            expect(fs.mkdirAsync.notCalled).to.eql true
          it 'creates templates.md file', ->
            expect(fs.existsSync(templatePath + '/template.md')).to.eql true
          return
        describe 'with existing templates.md file', ->
          before ->
            fs.mkdirAsync(templatePath).then ->
              sinon.spy fs, 'mkdirAsync'
              fs.openAsync templatePath + '/template.md', 'wx+'
          after (done) ->
            fs.mkdirAsync.restore()
            del [ '_templates/**' ], done
            return
          it 'calls #createFolders with correct params', ->
            init.initializeFolders(folders).then ->
              expect(init.createFolders.calledWith(folders)).to.eql true
          it 'doesnt call fs.mkdirAsync', ->
            expect(fs.mkdirAsync.notCalled).to.eql true
          return
        return
      return
    return
  describe '#createFiles', ->
    filenames = [
      'code.md'
      'links.md'
      'text.md'
    ]
    nestedFolderPath = path.resolve(templatePath, 'rb')
    filesPaths = undefined
    successFileStrings = undefined
    before ->
      filesPaths = _.map(filenames, (name) ->
        path.resolve nestedFolderPath, name
      )
      successFileStrings = _.map(filenames, (name) ->
        'SUCCESS: ' + name + ' added to ' + nestedFolderPath
      )
      return
    describe 'with no existing files', ->
      before ->
        sinon.spy console, 'log'
        sinon.spy path, 'resolve'
        sinon.spy fs, 'openAsync'
        fs.mkdirAsync(templatePath).then ->
          fs.mkdirAsync(nestedFolderPath).then ->
            init.createFiles nestedFolderPath
      after (done) ->
        console.log.restore()
        path.resolve.restore()
        fs.openAsync.restore()
        del [ '_templates/**' ], done
        return
      it 'calls fs#openAsync for each of the required files', ->
        expect(fs.openAsync.calledWith(filesPaths[0], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[1], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[2], 'wx+')).to.eql true
        return
      it 'console.logs success message for each file created', ->
        expect(console.log).to.have.been.calledWith successFileStrings[0]
        expect(console.log).to.have.been.calledWith successFileStrings[1]
        expect(console.log).to.have.been.calledWith successFileStrings[2]
        return
      it 'creates a file for links, text and code', ->
        expect(fs.existsSync(nestedFolderPath + '/code.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/links.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/text.md')).to.eql true
        return
      return
    describe 'with existing files', ->
      errorMessage = 'ERROR: ' + nestedFolderPath + '/' + filenames[0] + ' already exists!'
      before ->
        sinon.spy console, 'log'
        sinon.spy path, 'resolve'
        sinon.spy fs, 'openAsync'
        fs.mkdirAsync(templatePath).then ->
          fs.mkdirAsync(nestedFolderPath).then ->
            fs.openAsync(filesPaths[0], 'wx+').then ->
              init.createFiles nestedFolderPath
      after (done) ->
        console.log.restore()
        path.resolve.restore()
        fs.openAsync.restore()
        del [ '_templates/**' ], done
        return
      it 'calls fs#openAsync for each of the required files', ->
        expect(fs.openAsync.calledWith(filesPaths[0], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[1], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[2], 'wx+')).to.eql true
        return
      it 'console.logs error message for each file created', ->
        expect(console.log).to.have.been.calledWith errorMessage
        expect(console.log).to.have.been.calledWith successFileStrings[1]
        expect(console.log).to.have.been.calledWith successFileStrings[2]
        return
      it 'creates a file for links, text and code', ->
        expect(fs.existsSync(nestedFolderPath + '/code.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/links.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/text.md')).to.eql true
        return
      return
    return
  return
