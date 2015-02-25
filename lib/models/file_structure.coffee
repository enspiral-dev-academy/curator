'use strict'

cwd = process.cwd()
_ = require('lodash')
path = require('path')
config = require('config')

class FileStructure
  getFolders: (language) ->
    files = _templates: path.resolve(cwd, '_templates')
    files.template = path.resolve(files._templates, 'template.md')
    languageReadme = 'readme-' + language + '.md'
    files.newTemplate = path.resolve(cwd, languageReadme)
    files[language] = path.resolve(files._templates, language)
    _.forEach config.get('curator.fileTypes'), (file) ->
      fileName = file + '.md'
      files[file] = path.resolve(files[language], fileName)
      return
    files

module.exports = new FileStructure