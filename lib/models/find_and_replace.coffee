'use strict'
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))

class FindAndReplace
  execute: (options, callback) ->
    # read template.md file
    fs.readFileAsync(options.src, options.encoding)
    .then (templateFileData) ->
      # read the ruby code to put into new readme
      _templateData = null
      BBPromise.map(options.replace, ((replace, index) ->
        fs.readFileAsync(replace, options.encoding)
        .then (dataToInsert) ->
          # insert ruby code into saved template.md string
          _templateData = if _templateData then _templateData else templateFileData
          _templateData = _templateData.replace(new RegExp(options.find[index]), dataToInsert)
          if !fs.existsSync(options.dest)
            return fs.openAsync(options.dest, 'wx+')
            .then(->
              fs.writeFileAsync(options.dest, _templateData, encoding: 'utf8').nodeify callback
            )
          fs.writeFileAsync options.dest, _templateData, encoding: 'utf8'
          .then ->
            console.log 'SUCCESS: ' + options.dest + ' successfully built'
      
      ), concurrency: 1).nodeify callback
    .catch ->
      console.log 'ERROR: Make sure to run curator init <language name> first. Run build from the root directory'

module.exports = new FindAndReplace