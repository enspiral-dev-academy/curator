'use strict'
_ = require('lodash')
config = require('config')
languages = config.get('curator.languages')

displayLanguages = (string) ->
  _.forEach languages, (word, acronym) ->
    str = '\n' + acronym + '   ' + word
    string += str
    return
  string

module.exports = displayLanguages
