'use strict'
helpers = require('../helpers/index')
Errors = require('../errors/index')

class BaseController
	# constructor: ->

	checkFolders: (folders) ->
	  if !folders or folders.length == 0
	    Errors.argument.noFolderSpecified()
	    return false
	  invalidLanguages = helpers.invalidLanguages(folders)
	  if invalidLanguages.length > 0
	    Errors.argument.invalidArgument(invalidLanguages)
	    return false
	  return true

module.exports = BaseController
