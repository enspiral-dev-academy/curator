'use strict'

cwd = process.cwd()
_ = require('lodash')
path = require('path')

FileStructure = ->
  @filenames = [
    'code.md'
    'links.md'
    'text.md'
  ]
  return

  
FileStructure.prototype = getFolders: (language) ->
  files = _templates: path.resolve(cwd, '_templates')
  files.template = path.resolve(files._templates, 'template.md')
  languageReadme = 'readme-' + language + '.md'
  console.log languageReadme
  files.newTemplate = path.resolve(cwd, languageReadme)
  files[language] = path.resolve(files._templates, language)
  console.log files[language]
  _.forEach @filenames, (file) ->
    fileName = file.match(/(\w+)\.md/)[1]
    files[fileName] = path.resolve(files[language], file)
    return
  files
module.exports = new FileStructure
