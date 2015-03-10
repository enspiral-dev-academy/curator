'use strict'
Errors = require('../errors/index')
models = require('../models/index')
config = require('config')
fileTypes = config.get('curator.fileTypes')
helpers = require('../helpers/index')
BBPromise = require('bluebird')
BaseController = require('./base_controller')

class Build extends BaseController
  # constructor: ->
  bricklay: (folders) ->
    return unless @checkFolders(folders)
    folders = if (folders[0] is '.') then config.get('curator.allLanguages') else folders
    @setOptions folders

  setOptions: (folders) ->
    opts = encoding: 'utf8'
    BBPromise.map  folders, ((folder) ->
      fileStructure = models.fileStructure.getFolders(folder)
      opts.dest = fileStructure.newTemplate
      opts.src = fileStructure.template
      opts.replace = fileStructure[folder]
      models.findAndReplace.execute opts
    ), concurrency: 1

module.exports = Build
