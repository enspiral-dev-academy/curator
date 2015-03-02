'use strict'
_ = require('lodash')
config = require('config')

invalidLanguages = (languages) ->
  map = _.map(languages, (language) ->
    if !_.has(config.get('curator.languages'), language)
      return language
    return
  )
  map = _.compact(map)
  map

module.exports = invalidLanguages
