'use strict'
_ = require('lodash')
errors = require('errors')
config = require('config')
languages = config.get('curator.languages')
helpers = require('../helpers/index')
BBPromise = require('bluebird')

exports.noFolderSpecified = ->
  string = 'you must specify at least one folder name:'
  string = helpers.displayLanguages(string)
  errors.create
    name: 'noFolderSpecified'
    defaultMessage: string
  console.log (new (errors.noFolderSpecified)).toString()
  return

exports.invalidCommand = (arg) ->
  string = arg + ' is not a curator command. See \'curator --help\''
  errors.create
    name: 'invalidCommand'
    defaultMessage: string
  console.log (new (errors.invalidCommand)).toString()
  return

exports.invalidArgument = (arg) ->
  string = arg + ' is not a curator argument. See \'curator --help\''
  errors.create
    name: 'invalidArgument'
    defaultMessage: string
  console.log (new (errors.invalidArgument)).toString()
  return

exports.help = (arg) ->
  string = 'build, init'
  errors.create
    name: 'usage'
    defaultMessage: string
  console.log (new (errors.usage)).toString()
  return
