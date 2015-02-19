'use strict'
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
path = require('path')
_ = require('lodash')
mainFolder = '_templates'
cwd = process.cwd()
filenames = [
  'code.md'
  'links.md'
  'text.md'
]
Errors = require('../errors/index')
helpers = require('../helpers/index')
Init = ->
  @templatePath = path.resolve(cwd, mainFolder)
  return
Init.prototype =
  initializeFolders: (folders) ->
    if !folders or folders.length == 0
      return Errors.argument.noFolderSpecified()
    # check to see if folders are each included in config.curator.languages
    invalidLanguages = helpers.invalidLanguages(folders)
    if invalidLanguages.length > 0
      return Errors.argument.invalidArgument(invalidLanguages)
    templateFile = path.resolve(@templatePath, 'template.md')
    if fs.existsSync(@templatePath)
      # folder already there
      console.log 'WARNING: ' + mainFolder + ' folder already exists inside ' + cwd + ' trying to create sub folders...'
      fs.openAsync(templateFile, 'wx+').bind(this).then(->
        console.log 'SUCCESS: template.md added to ' + @templatePath
        @createFolders folders
      ).catch((err) ->
        console.log 'ERROR: ' + templateFile + ' already exists, trying to create sub folders...'
        @createFolders folders
      ).then (data) ->
        console.log 'completed curator init'
    else
      # no folder
      fs.mkdirAsync(@templatePath).bind(this).then(->
        console.log 'SUCCESS: ' + mainFolder + ' folder has been created inside ' + cwd
        fs.openAsync(templateFile, 'wx+').bind(this).then ->
          console.log 'SUCCESS: template.md added to ' + @templatePath
          @createFolders folders
      ).then (data) ->
        console.log 'completed curator init'
  createFolders: (folders) ->
    # forEach returned the input value to the function called for each element in folders
    # _.forEach['rb, 'cs', 'js'] => returned _settledValues of 'rb', 'cs' and 'js'
    # _.map returns the result of calling the function :)
    BBPromise.settle _.map(folders, _.bind(((folder) ->
      nestedFolderPath = path.resolve(@templatePath, folder)
      if fs.existsSync(nestedFolderPath)
        # folder already there
        console.log 'WARNING: ' + nestedFolderPath + ' already exists, trying to create sub files...'
        @createFiles nestedFolderPath
      else
        # no folder
        fs.mkdirAsync(nestedFolderPath).bind(this).then ->
          console.log 'SUCCESS: ' + folder + ' folder has been created inside the ' + mainFolder + 'folder'
          @createFiles nestedFolderPath
    ), this))
  createFiles: (nestedFolderPath) ->
    BBPromise.settle _.map(filenames, (filename) ->
      nestedFilePath = path.resolve(nestedFolderPath, filename)
      fs.openAsync(nestedFilePath, 'wx+').then(->
        console.log 'SUCCESS: ' + filename + ' added to ' + nestedFolderPath
      ).catch (err) ->
        console.log 'ERROR: ' + nestedFolderPath + '/' + filename + ' already exists!'
    )
module.exports = Init
