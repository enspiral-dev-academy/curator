BBPromise = require('bluebird')
fs = BBPromise.promisifyAll(require('fs'))
path = require('path')
_ = require('lodash')
mainFolder = '_templates'
cwd = process.cwd()
filenames = ["code.md", "links.md", "text.md"]

initializeFolders = (folders) ->
	templatePath = path.resolve cwd, mainFolder
	fs.mkdirAsync(templatePath)
		.then (result) ->
			console.log "#{mainFolder} folder has been created inside #{cwd}"
			createFolders folders, templatePath
		.catch (err) ->
			console.log "WARNING: #{mainFolder} folder already exists inside #{cwd} trying to create sub folders..."
			createFolders folders, templatePath

createFolders = (folders, templatePath) ->
	BBPromise.settle _.forEach folders, (folder) ->
		nestedFolderPath = path.resolve(templatePath, folder)
		fs.mkdirAsync(nestedFolderPath)
			.then (data) ->
				console.log "#{folder} folder has been created inside the #{mainFolder}folder"
				createFiles nestedFolderPath
			.catch (err) ->
				console.log "WARNING: #{nestedFolderPath} already exists"
				createFiles nestedFolderPath

createFiles = (nestedFolderPath) ->
	BBPromise.settle _.forEach filenames, (filename) ->
		nestedFilePath = path.resolve(nestedFolderPath, filename)
		fs.openAsync(nestedFilePath,"wx+")
			.then (data) ->
				console.log "#{filename} added to nestedFolderPath!"
			.catch (err) ->
				console.log "WARNING: #{filename} already exists!"

module.exports = initializeFolders
