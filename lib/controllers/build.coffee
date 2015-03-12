'use strict'
Errors = require('../errors/index')
models = require('../models/index')
config = require('config')
fileTypes = config.get('curator.fileTypes')
helpers = require('../helpers/index')
BBPromise = require('bluebird')
BaseController = require('./base_controller')
path = require('path')
fs = BBPromise.promisifyAll(require('fs'))
mainReadme = path.resolve(process.cwd(), 'README.md')

class Build extends BaseController
  # constructor: ->
  bricklay: (folders) ->
    if folders && folders[0] is '-' && folders[1] is 'A'
      folders = [folders[0] + folders[1]]
    return unless @checkFolders(folders)
    folders = if (folders[0] is '-A') then config.get('curator.allLanguages') else folders
    @setOptions folders
    .then () => 
      @buildMainReadme(folders)

  setOptions: (folders) ->
    BBPromise.map(folders, ((folder) ->
      opts = encoding: 'utf8'
      fileStructure = models.fileStructure.getFolders(folder)
      opts.dest = fileStructure.newTemplate
      opts.src = fileStructure.template
      opts.replace = fileStructure[folder]
      models.findAndReplace.execute opts
    ), concurrency: 1)
  buildMainReadme: (folders) ->
    readmeData = null
    BBPromise.map(folders,  ((folder) -> 
      data = "[click here for "+ folder + " README](./readme-" + folder + ".md)\n\n"
      if !fs.existsSync(mainReadme)
        return fs.openAsync(mainReadme, 'wx+')
        .then () ->
          readmeData = data
          return fs.writeFileAsync(mainReadme, data, encoding: 'utf8')
      return fs.readFileAsync(mainReadme, 'utf8')
      .then (fileData) ->
        readmeData = if readmeData then readmeData + data else data
        data = readmeData + data
        fs.writeFileAsync(mainReadme, readmeData, encoding: 'utf8')
      .catch (err) ->
        console.log err.stack
    ), concurrency: 1)

module.exports = Build
