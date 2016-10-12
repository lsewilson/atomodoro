Pompomodoro = require '../lib/pompomodoro'

describe "Pompomodoro", ->
  [workspaceElement, activationPromise, obscureElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('pompomodoro')
    jasmine.attachToDOM(workspaceElement)
    atom.commands.dispatch workspaceElement, 'pompomodoro:start'
    obscureElement = workspaceElement.querySelector('.obscure')

  describe "when the pompomodoro:break event is triggered", ->
    it "covers the view with a div", ->
      expect(obscureElement).not.toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()

  describe "when the pomodoro break is over", ->
    it "renders the div invisible", ->
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:work'
      expect(obscureElement).not.toBeVisible()

  describe "start", ->
    it "hides code after 5s", ->
      setTimeout ( =>
        expect(obscureElement).toBeVisible()
        ), 10000
