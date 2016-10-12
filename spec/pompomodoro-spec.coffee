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
      Pompomodoro.break()
      expect(messageElement).toBeVisible()
      expect(messageElement.innerHTML).toEqual("It's time to take a break!")

    it "covers the view with a div", ->
      expect(obscureElement).not.toBeVisible()
      Pompomodoro.break()
      expect(obscureElement).toBeVisible()


  describe "pompomodoro:work", ->
    it "renders the div invisible", ->
      Pompomodoro.break()
      expect(obscureElement).toBeVisible()
      Pompomodoro.work()
      expect(obscureElement).not.toBeVisible()

  # describe "pompomodoro:start", ->
  #   it "calls break when start is called", ->
#     panel = atom.workspace.panelContainers.modal.panels[0]
#     spy = spyOn(panel, 'show')
  #     waits(2000)
  #     runs ->
  #       expect(panel.show.callCount).toEqual(1)
  #
  #   it "creates two breaks", ->
  #     panel = atom.workspace.panelContainers.modal.panels[0]
  #     spy = spyOn(panel, 'show')
  #     waits(2000)
  #     runs ->
  #       expect(panel.show.callCount).toEqual(2)

  describe "pompomodoro:skip", ->
    it "overrides break", ->
      Pompomodoro.break()
      Pompomodoro.skip()
      expect(obscureElement).not.toBeVisible()

  describe "start runs the first session", ->
    it "confirms the session starts", ->
      expect(Pompomodoro.start()).toEqual("Session 0 was run")
