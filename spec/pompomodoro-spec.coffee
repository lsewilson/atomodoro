Pompomodoro = require '../lib/pompomodoro'

describe "Pompomodoro", ->
  [workspaceElement, activationPromise, obscureElement, messageElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('pompomodoro')
    jasmine.attachToDOM(workspaceElement)
    atom.commands.dispatch workspaceElement, 'pompomodoro:start'
    obscureElement = workspaceElement.querySelector('.obscure')
    messageElement = workspaceElement.querySelector('.break-message')

  describe "pomodoro:break", ->
    it "shows a message", ->
      expect(messageElement).not.toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(messageElement).toBeVisible()
      expect(messageElement.innerHTML).toEqual("It's time to take a break!")

    it "covers the view with a div", ->
      expect(obscureElement).not.toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()


  describe "pomodoro:work", ->
    it "renders the div invisible", ->
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:work'
      expect(obscureElement).not.toBeVisible()

  describe "pomodoro:start", ->
    it "hides code after 5s", ->
      setTimeout ( =>
        expect(obscureElement).toBeVisible()
        ), 7000

    it "hides code after 5s", ->
      spy = spyOn(Pompomodoro, 'break')
      expect(spy).toHaveBeenCalled()
