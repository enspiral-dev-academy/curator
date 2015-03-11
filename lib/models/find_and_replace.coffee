'use strict'
BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
path = require('path')

class FindAndReplace
  execute: (options) ->
    @readFile(options.src, options.encoding)
    .then (templateFileData) =>
      fileNames = @getRegEx(templateFileData)
      @setTemplateData(fileNames, templateFileData, options.replace, options.dest, options.encoding)
    .then ->
      console.log 'SUCCESS: ' + options.dest + ' successfully built' 
    .catch (err)->
      console.log err, err.stack,  'ERROR: Make sure to run curator init <language name> first. Run build from the root directory'
  readFile: (file, encoding) ->
    fs.readFileAsync(file, encoding)
  getRegEx: (templateFileData) ->
    myregex = /include:(\S+):/g;
    fileNames = [];
    while((result = myregex.exec(templateFileData)) != null) 
      match = result[1];
      fileNames.push(match);
    fileNames
  setTemplateData: (fileNames, templateFileData, replace, destination, encoding) ->
    _templateData = null
    BBPromise.map(fileNames, ((fileName, index) =>
      filePath = path.resolve(replace, fileName + '.md')
      _templateData = if _templateData then _templateData else templateFileData
      if !fs.existsSync(filePath)
        _templateData = _templateData.replace('include:'+ fileName + ':', '')
        @writeFile(destination, _templateData)
      else
        fs.readFileAsync(filePath, encoding)
        .then (dataToInsert) =>
          _templateData = _templateData.replace('include:'+ fileName + ':', dataToInsert)
          @writeFile(destination, _templateData)
        .catch (err) =>
          @writeFile
          console.log err, 'could not find file ' + filePath
    ), concurrency: 1)

  writeFile: (destination, _templateData) ->
    if !fs.existsSync(destination)
      return fs.openAsync(destination, 'wx+')
      .then ->
        return fs.writeFileAsync(destination, _templateData, encoding: 'utf8')
    fs.writeFileAsync(destination, _templateData, encoding: 'utf8')
    .catch (err) ->
      console.log err

module.exports = new FindAndReplace 

