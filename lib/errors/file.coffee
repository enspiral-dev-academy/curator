'use strict'
errors = require('errors')

exports.invalidRequest = ->
  string = 'no _templates folder found'
  errors.create
    name: 'invalidRequest'
    defaultMessage: string
  console.log (new (errors.invalidRequest)).toString()
  return
