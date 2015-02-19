'use strict'
Errors = require('../errors/index')
models = require('../models/index')
config = require('config')
fileTypes = config.get('curator.fileTypes')
helpers = require('../helpers/index')
BBPromise = require('bluebird')

Build = ->

Build::bricklay = (folders)  ->
  if !folders or folders.length == 0
    return Errors.argument.noFolderSpecified()
  invalidLanguages = helpers.invalidLanguages(folders)
  if invalidLanguages.length > 0
    return Errors.argument.invalidArgument(invalidLanguages)
  @setOptions folders

Build::setOptions = (folders)     ->
  opts = encoding: 'utf8'
  # go through rb cs js and get correct path to each folder
  BBPromise.map  folders, ((folder) ->
    opts.find = []
    opts.replace = []
    fileStructure = models.fileStructure.getFolders(folder)
    opts.dest = fileStructure.newTemplate
    opts.src = fileStructure.template
    BBPromise.map(fileTypes, ((type) ->
      opts.replace.push fileStructure[type]
      find = 'include:' + type
      find = new RegExp(find)
      opts.find.push find
      return
    ), concurrency: 1).then ->
gi      models.findAndReplace.execute opts
  ), concurrency: 1

module.exports = Build
