FindAndReplace = ->

'use strict'
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
FindAndReplace::execute = (options, callback) ->
  # read template.md file
  fs.readFileAsync(options.src, options.encoding).then (templateFileData) ->
    # read the ruby code to put into new readme
    _templateData
    BBPromise.map(options.replace, ((replace, index) ->
      fs.readFileAsync(replace, options.encoding).then (dataToInsert) ->
        # insert ruby code into saved template.md string
        _templateData = if _templateData then _templateData else templateFileData
        editedDestFile = _templateData.replace(options.find[index], dataToInsert)
        _templateData = editedDestFile
        if !fs.existsSync(options.dest)
          return fs.openAsync(options.dest, 'wx+').then(->
            fs.writeFileAsync(options.dest, editedDestFile, encoding: 'utf8').nodeify callback
          )
        fs.writeFileAsync options.dest, editedDestFile, encoding: 'utf8'
    ), concurrency: 1).nodeify callback

module.exports = new FindAndReplace
