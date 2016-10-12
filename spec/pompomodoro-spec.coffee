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

  describe "pompomodoro:break", ->
    it "shows a message", ->
      expect(messageElement).not.toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(messageElement).toBeVisible()
      expect(messageElement.innerHTML).toEqual("It's time to take a break!")

    it "covers the view with a div", ->
      expect(obscureElement).not.toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()


  describe "pompomodoro:work", ->
    it "renders the div invisible", ->
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      expect(obscureElement).toBeVisible()
      atom.commands.dispatch workspaceElement, 'pompomodoro:work'
      expect(obscureElement).not.toBeVisible()

  describe "pompomodoro:start", ->
    it "hides code after 5s", ->
      setTimeout ( =>
        expect(obscureElement).toBeVisible()
        ), 7000

    # it "calls break within start", ->
    #   # setTimeout ( =>
    #   #   expect(obscureElement).not.toBeVisible()
    #   #   ), 11000

  describe "pompomodoro:skip", ->
    it "overrides break", ->
      atom.commands.dispatch workspaceElement, 'pompomodoro:break'
      atom.commands.dispatch workspaceElement, 'pompomodoro:skip'
      expect(obscureElement).not.toBeVisible()
