Pompomodoro = require '../lib/pompomodoro'

describe "Pompomodoro", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('pompomodoro')

  describe "when the pompomodoro:break event is triggered", ->
    it "covers the view with a div", ->
      jasmine.attachToDOM(workspaceElement)
      atom.commands.dispatch workspaceElement, 'pompomodoro:start'
      obscureElement = workspaceElement.querySelector('.obscure')
      expect(obscureElement).not.toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()
