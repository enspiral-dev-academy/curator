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
cwd = process.cwd()

templatePath = path.resolve(cwd, '_templates')


describe 'init', ->
  describe '#initializeFolders', ->
    describe 'with no argument', ->
      before ->
        sinon.stub console, 'log'
        init.initializeFolders()
      after ->
        console.log.restore()
      it 'console.logs an noFolderSpecified error', ->
        expect(console.log).to.have.been.calledWith (new (errors.noFolderSpecified)).toString()
    describe 'with folders = []', ->
      before ->
        sinon.stub console, 'log'
        init.initializeFolders []
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
        init.initializeFolders folders
      after ->
        console.log.restore()
      it 'console.logs an invalidArgument error', ->
        expect(console.log).to.have.been.calledWith (new (errors.invalidArgument)).toString()
    describe 'with valid folders', ->
      folders = ['rb', 'cs']
      before ->
        sinon.stub console, 'log'
        sinon.stub(init, 'createFolders').returns BBPromise.resolve({})
      after ->
        console.log.restore()
        init.createFolders.restore()
      describe 'with argument \'-A\'', ->
        before ->
          sinon.spy fs, 'mkdirAsync'
          del [ '_templates/**' ], ->
          init.initializeFolders '-A'
        after (done) ->
          fs.mkdirAsync.restore()
          del [ '_templates/**' ], done
        it 'calls fs.mkdirAsync', ->
          expect(fs.mkdirAsync.calledWith(templatePath)).to.eql true
        it 'creates _templates folder', ->
          expect(fs.existsSync(templatePath)).to.eql true
        it 'creates templates.md file', ->
          expect(fs.existsSync(templatePath + '/template.md')).to.eql true
        it 'calls #createFolders with correct params', ->
          expect(init.createFolders.calledWith(folders)).to.eql true
      describe 'with no existing _templates folder', ->
        before ->
          sinon.spy fs, 'mkdirAsync'
          del [ '_templates/**' ], ->
          init.initializeFolders folders
        after (done) ->
          fs.mkdirAsync.restore()
          del [ '_templates/**' ], done
        it 'calls fs.mkdirAsync', ->
          expect(fs.mkdirAsync.calledWith(templatePath)).to.eql true
        it 'creates _templates folder', ->
          expect(fs.existsSync(templatePath)).to.eql true
        it 'creates templates.md file', ->
          expect(fs.existsSync(templatePath + '/template.md')).to.eql true
        it 'calls #createFolders with correct params', ->
          expect(init.createFolders.calledWith(folders)).to.eql true
      describe 'with existing _templates folder', ->
        describe 'with no existing templates.md file', ->
          before ->
            fs.mkdirAsync(templatePath).then ->
            sinon.spy fs, 'mkdirAsync'
          after (done) ->
            fs.mkdirAsync.restore()
            del [ '_templates/**' ], done
          it 'calls #createFolders with correct params', ->
            init.initializeFolders(folders).then ->
              expect(init.createFolders.calledWith(folders)).to.eql true
          it 'doesnt call fs.mkdirAsync', ->
            expect(fs.mkdirAsync.notCalled).to.eql true
          it 'creates templates.md file', ->
            expect(fs.existsSync(templatePath + '/template.md')).to.eql true
        describe 'with existing templates.md file', ->
          before ->
            fs.mkdirAsync(templatePath).then ->
            sinon.spy fs, 'mkdirAsync'
            fs.openAsync templatePath + '/template.md', 'wx+'
          after (done) ->
            fs.mkdirAsync.restore()
            del [ '_templates/**' ], done
          it 'calls #createFolders with correct params', ->
            init.initializeFolders(folders).then ->
              expect(init.createFolders.calledWith(folders)).to.eql true
          it 'doesnt call fs.mkdirAsync', ->
            expect(fs.mkdirAsync.notCalled).to.eql true
  describe '#createFolders', ->
    filenames = ['code.md','links.md','text.md']
    folders = ['rb', 'cs', 'js']
    templatePath = path.resolve(cwd, '_templates')
    nestedFolderPaths = null;
    before ->
      nestedFolderPaths = _.map(folders, (name) ->
        path.resolve templatePath, name
      )
      successFileStrings = _.map(filenames, (name) ->
        'SUCCESS: ' + name + ' added to ' + nestedFolderPaths
      )
    describe 'with existing files', ->
      before ->
        sinon.stub console, 'log'
        sinon.stub init, 'createFiles'
        existStub = sinon.stub(fs, 'existsSync')
        existStub.returns false
        sinon.stub(fs, 'mkdirAsync').returns(BBPromise.resolve({}))
        init.createFolders folders
      after (done) ->
        console.log.restore()
        init.createFiles.restore()
        fs.existsSync.restore()
        fs.mkdirAsync.restore()
        del [ '_templates/**' ], done
      it 'calls fs#existsSync for each of the folderPaths', ->
        expect(fs.existsSync.calledWith(nestedFolderPaths[0])).to.eql true
        expect(fs.existsSync.calledWith(nestedFolderPaths[1])).to.eql true
        expect(fs.existsSync.calledWith(nestedFolderPaths[2])).to.eql true
      it 'creates the directory for each language', ->
        expect(fs.mkdirAsync).to.have.been.calledWith nestedFolderPaths[0]
        expect(fs.mkdirAsync).to.have.been.calledWith nestedFolderPaths[1]
        expect(fs.mkdirAsync).to.have.been.calledWith nestedFolderPaths[2]
      it 'calls createFiles', ->
        expect(init.createFiles.calledThrice).to.eql true
    describe 'with no existing files', ->
     before ->
        sinon.stub console, 'log'
        sinon.stub init, 'createFiles'
        existStub = sinon.stub(fs, 'existsSync')
        existStub.returns true
        sinon.stub(fs, 'mkdirAsync').returns(BBPromise.resolve({}))
        init.createFolders folders
      after (done) ->
        console.log.restore()
        init.createFiles.restore()
        fs.existsSync.restore()
        fs.mkdirAsync.restore()
        del [ '_templates/**' ], done
      it 'calls createFiles', ->
        expect(init.createFiles.calledThrice).to.eql true
      it 'doesnt create the directory for each language', ->
        expect(fs.mkdirAsync.called).to.eql false
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
    describe 'with no existing files', ->
      before ->
        sinon.stub console, 'log'
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
      it 'calls fs#openAsync for each of the required files', ->
        expect(fs.openAsync.calledWith(filesPaths[0], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[1], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[2], 'wx+')).to.eql true
      it 'console.logs success message for each file created', ->
        expect(console.log).to.have.been.calledWith successFileStrings[0]
        expect(console.log).to.have.been.calledWith successFileStrings[1]
        expect(console.log).to.have.been.calledWith successFileStrings[2]
      it 'creates a file for links, text and code', ->
        expect(fs.existsSync(nestedFolderPath + '/code.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/links.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/text.md')).to.eql true
    describe 'with existing files', ->
      errorMessage = 'WARNING: ' + nestedFolderPath + '/' + filenames[0] + ' already exists!'
      before ->
        sinon.stub console, 'log'
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
      it 'calls fs#openAsync for each of the required files', ->
        expect(fs.openAsync.calledWith(filesPaths[0], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[1], 'wx+')).to.eql true
        expect(fs.openAsync.calledWith(filesPaths[2], 'wx+')).to.eql true
      it 'console.logs warning message for each file created', ->
        expect(console.log).to.have.been.calledWith errorMessage
        expect(console.log).to.have.been.calledWith successFileStrings[1]
        expect(console.log).to.have.been.calledWith successFileStrings[2]
      it 'creates a file for links, text and code', ->
        expect(fs.existsSync(nestedFolderPath + '/code.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/links.md')).to.eql true
        expect(fs.existsSync(nestedFolderPath + '/text.md')).to.eql true
