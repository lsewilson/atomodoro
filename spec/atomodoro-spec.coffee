Atomodoro = require '../lib/atomodoro'

describe "Atomodoro", ->
  [workspaceElement, activationPromise, obscureElement, messageElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('atomodoro')
    jasmine.attachToDOM(workspaceElement)
    atom.commands.dispatch workspaceElement, 'atomodoro:start'
    obscureElement = workspaceElement.querySelector('.obscure')
    messageElement = workspaceElement.querySelector('.break-message')

  describe "atomodoro:break", ->
    it "shows a message", ->
      expect(messageElement).not.toBeVisible()
      Atomodoro.break()
      expect(messageElement).toBeVisible()
      expect(messageElement.innerHTML).toEqual("It's time to take a break!")

    it "covers the view with a div", ->
      expect(obscureElement).not.toBeVisible()
      Atomodoro.break()
      expect(obscureElement).toBeVisible()

  describe "atomodoro:work", ->
    it "renders the div invisible", ->
      Atomodoro.break()
      expect(obscureElement).toBeVisible()
      Atomodoro.work()
      expect(obscureElement).not.toBeVisible()

    it "Allows us to type during work periods", ->
      Atomodoro.break()
      expect(document.onkeypress()).toEqual(false)
      Atomodoro.work()
      expect(document.onkeypress()).toEqual(true)

    #
    # fit "overwrites setTimeout", ->
    #   @timerCallback = jasmine.createSpy('atom.notifications.addWarning("1 minute warning")')
    #   jasmine.Clock.useMock()
    #   Atomodoro.work()
    #   expect(@timerCallback).not.toHaveBeenCalled()
    #   jasmine.Clock.tick(1001)
    #   console.log(@timerCallback)
    #   expect(@timerCallback.wasCalled).toEqual(true)

  describe "Atomodoro:start", ->

    beforeEach ->
      atom.config.set('atomodoro.numberOfSessions', 4)
      atom.config.set('atomodoro.breakLength', 5)
      atom.config.set('atomodoro.workIntervalLength', 25)

    it "has variable settings", ->
      expect(Atomodoro.noOfIntervals).toBe 4
      expect(Atomodoro.breakLength).toBe 300000
      expect(Atomodoro.workTime).toBe 1500000


  # describe "Atomodoro:start", ->
    # it "calls break when start is called", ->
    #   panel = atom.workspace.panelContainers.modal.panels[0]
    #   jasmine.Clock.useMock()
    #   spy = spyOn(panel, 'show')
    #   Atomodoro.start()
    #   console.log(Atomodoro.workTime)
    #   console.log(spy.callCount)
    #   jasmine.Clock.tick(Atomodoro.workTime + 1)
    #   expect(panel.show.callCount).toEqual(1)

    # it "creates two breaks", ->
    #   panel = atom.workspace.panelContainers.modal.panels[0]
    #   spy = spyOn(panel, 'show')
    #   waits(2000)
    #   runs ->
    #     expect(panel.show.callCount).toEqual(2)

  describe "atomodoro:skip", ->
    it "overrides break", ->
      Atomodoro.break()
      Atomodoro.skip()
      expect(obscureElement).not.toBeVisible()

    it 'allows you to type during the break time when you skip the break', ->
      Atomodoro.break()
      Atomodoro.skip()
      expect(document.onkeypress()).toEqual(true)

  describe "atomodoro:start runs the first session", ->
    it "confirms the session starts", ->
      expect(Atomodoro.start()).toEqual("Session 1 was run")
