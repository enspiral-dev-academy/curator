'use strict'

cwd = process.cwd()
_ = require('lodash')
path = require('path')

class FileStructure
  constructor: ->
    @filenames = ['code.md','links.md','text.md']

  
  getFolders: (language) ->
    files = _templates: path.resolve(cwd, '_templates')
    files.template = path.resolve(files._templates, 'template.md')
    languageReadme = 'readme-' + language + '.md'
    files.newTemplate = path.resolve(cwd, languageReadme)
    files[language] = path.resolve(files._templates, language)
    _.forEach @filenames, (file) ->
      fileName = file.match(/(\w+)\.md/)[1]
      files[fileName] = path.resolve(files[language], file)
      return
    files

module.exports = new FileStructure