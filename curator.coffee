_ = require 'lodash'
input = _.slice process.argv, 2, process.argv.length
controllers = require './lib/controllers/index'

switch input.shift()
  when 'init' then controllers.init input
  else console.log 'default'
