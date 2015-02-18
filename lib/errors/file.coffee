'use strict'
errors = require('errors')
exports.notFound = errors.create(
  name: 'RuntimeError'
  defaultMessage: 'A runtime error occurred during processing')
exports.lost = errors.create(
  name: 'RuntimeError'
  defaultMessage: 'sorry we lost your file!')
