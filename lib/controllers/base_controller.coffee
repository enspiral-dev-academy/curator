BaseController = ->

'use strict'
helpers = require('./index')
Errors = require('../errors/index')
BaseController.prototype = checkFolders: (folders) ->
  if !folders or folders.length == 0
    return Errors.argument.noFolderSpecified()
  invalidLanguages = helpers.invalidLanguages(folders)
  if invalidLanguages.length > 0
    return Errors.argument.invalidArgument(invalidLanguages)
  return
