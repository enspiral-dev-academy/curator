'use strict'
_ = require('lodash')
input = _.slice(process.argv, 2, process.argv.length)
controllers = require('./lib/controllers/index')
Errors = require('./lib/errors/index')
helpers = require('./lib/helpers/index')

start = ->
  argument = input.shift()
  switch argument
    when 'init'
      init = new (controllers.init)
      init.initializeFolders input
    when 'build'
      builder = new (controllers.build)
      builder.bricklay input
    when 'languages'
      string = 'Currently available languages:'
      console.log helpers.displayLanguages(string)
    when '--help'
      Errors.argument.help()
    else
      Errors.argument.help()
      break
  return

module.exports = start()