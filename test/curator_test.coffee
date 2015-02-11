require './libs'

describe 'curator', ->
  beforeEach ->
    sinon.spy(console, 'log')
  it 'prints to console', ->
    require '../curator'
    expect(console.log).to.have.been.calledWith "hello"
    

