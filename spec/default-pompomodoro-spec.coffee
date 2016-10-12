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

  describe "when the pomodoro break is over", ->
    it "renders the div invisible", ->
      jasmine.attachToDOM(workspaceElement)
      atom.commands.dispatch workspaceElement, 'pompomodoro:start'
      obscureElement = workspaceElement.querySelector('.obscure')
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:work'
      expect(obscureElement).not.toBeVisible()

  describe "start", ->
    it "hides code after 5s", ->
      jasmine.attachToDOM(workspaceElement)
      atom.commands.dispatch workspaceElement, 'pompomodoro:start'
      obscureElement = workspaceElement.querySelector('.obscure')
      setTimeout(expect(obscureElement).toBeVisible(), 10000)
