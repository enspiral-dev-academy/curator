'use strict'
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
config = require('config')
path = require('path')
_ = require('lodash')
mainFolder = config.get('curator.mainFolder')
cwd = process.cwd()
filenames = ['code.md', 'links.md', 'text.md']
Errors = require('../errors/index')
helpers = require('../helpers/index')
BaseController = require('./base_controller')

class Init extends BaseController
  constructor: ->
    @templatePath = path.resolve(cwd, mainFolder)


  initializeFolders: (folders) ->
    return unless @checkFolders(folders)
    templateFile = path.resolve(@templatePath, 'template.md')
    if fs.existsSync(@templatePath)
      # folder already there
      console.log 'WARNING: ' + mainFolder + ' folder already exists inside ' + cwd + ' trying to create sub folders...'
      fs.openAsync(templateFile, 'wx+').bind(this)
      .then(->
        console.log 'SUCCESS: template.md added to ' + @templatePath
        fs.writeFileAsync(templateFile, config.get('curator.templateString'))
        .then ->
          @createFolders folders
      ).catch((err) ->
        console.log 'ERROR: ' + templateFile + ' already exists, trying to create sub folders...'
        @createFolders folders
      ).then (data) ->
        console.log 'completed curator init'
    else
      # no folder
      fs.mkdirAsync(@templatePath).bind(this)
      .then(->
        console.log 'SUCCESS: ' + mainFolder + ' folder has been created inside ' + cwd
        fs.openAsync(templateFile, 'wx+').bind(this)
        .then ->
          console.log 'SUCCESS: template.md added to ' + @templatePath
          fs.writeFileAsync(templateFile, config.get('curator.templateString'))
          .then =>
            @createFolders folders
      ).then (data) ->
        console.log 'completed curator init'
  createFolders: (folders) ->
    BBPromise.settle _.map(folders, (folder) =>
      nestedFolderPath = path.resolve(@templatePath, folder)
      if fs.existsSync(nestedFolderPath)
        # folder already there
        console.log 'WARNING: ' + nestedFolderPath + ' already exists, trying to create sub files...'
        @createFiles nestedFolderPath
      else
        # no folder
        fs.mkdirAsync(nestedFolderPath).bind(this)
        .then ->
          console.log 'SUCCESS: ' + folder + ' folder has been created inside the ' + mainFolder + 'folder'
          @createFiles nestedFolderPath
    )
  createFiles: (nestedFolderPath) ->
    BBPromise.settle _.map(filenames, (filename) ->
      nestedFilePath = path.resolve(nestedFolderPath, filename)
      fs.openAsync(nestedFilePath, 'wx+').then(->
        console.log 'SUCCESS: ' + filename + ' added to ' + nestedFolderPath
      ).catch (err) ->
        console.log 'ERROR: ' + nestedFolderPath + '/' + filename + ' already exists!'
    )
module.exports = Init
