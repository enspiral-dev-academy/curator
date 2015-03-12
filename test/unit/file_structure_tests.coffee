'use strict'
chai = require('chai')
sinonChai = require('sinon-chai')
chai.use sinonChai
expect = chai.expect
sinon = require('sinon')
fileStructure = require('../../lib/models/file_structure')

describe 'file structure model', ->
	describe 'getFolders', ->
		result = null
		expectedResult = { 
		  _templates: process.cwd() + '/_templates',
		  template: process.cwd() + '/_templates/template.md',
		  newTemplate: process.cwd() + '/readme-rb.md',
		  rb: process.cwd() + '/_templates/rb' }
		before ->
	  	result = fileStructure.getFolders('rb')
	  it 'returns the correct folder info', ->
	    expect(result).to.eql expectedResult

