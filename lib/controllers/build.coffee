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
    @setOptions folders

  setOptions: (folders) ->
    opts = encoding: 'utf8'
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
        models.findAndReplace.execute opts
    ), concurrency: 1

module.exports = Build
