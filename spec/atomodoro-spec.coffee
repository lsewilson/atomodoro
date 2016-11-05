Atomodoro = require '../lib/atomodoro'

describe "Atomodoro", ->
  [workspaceElement, activationPromise, obscureElement, messageElement, notificationSpy, timerCallback] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('atomodoro')
    jasmine.attachToDOM(workspaceElement)
    obscureElement = workspaceElement.querySelector('.obscure')
    messageElement = workspaceElement.querySelector('.break-message')

  describe "atomodoro:break", ->
    beforeEach ->
         atom.config.set('atomodoro.numberOfIntervals', 4)
         atom.config.set('atomodoro.breakLength', 1)
         atom.config.set('atomodoro.workIntervalLength', 2)
         Atomodoro.getSettings()

    describe "Current interval is < total number of intervals", ->
      it "shows a message", ->
        expect(messageElement).not.toBeVisible()
        Atomodoro.break(1)
        expect(messageElement).toBeVisible()
        expect(messageElement.innerHTML).toEqual("It's time to take a break!")

      it "covers the view with a div", ->
        expect(obscureElement).not.toBeVisible()
        Atomodoro.break(1)
        expect(obscureElement).toBeVisible()

      it "disables the keyboard", ->
        Atomodoro.break(1)
        expect(document.onkeypress()).toEqual(false)

    describe "Current interval equals total number of intervals", ->
      beforeEach ->
        atom.notifications.onDidAddNotification notificationSpy = jasmine.createSpy()

      it "shows a message", ->
        Atomodoro.break(4)
        expect(notificationSpy).toHaveBeenCalled()
        notification = notificationSpy.mostRecentCall.args[0]
        expect(notification.getType()).toBe 'success'
        expect(notification.getMessage()).toContain "Well done, you've finished your session!"

  describe "atomodoro:work", ->
    it "renders the div invisible", ->
      Atomodoro.break(1)
      Atomodoro.work()
      expect(obscureElement).not.toBeVisible()

    it "allows us to type during work periods", ->
      Atomodoro.break(1)
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

  describe "atomodoro:getSettings", ->

    beforeEach ->
      atom.config.set('atomodoro.numberOfSessions', 4)
      atom.config.set('atomodoro.breakLength', 5)
      atom.config.set('atomodoro.workIntervalLength', 25)
      Atomodoro.getSettings()

    it "has variable settings", ->
      expect(Atomodoro.noOfIntervals).toBe 4
      expect(Atomodoro.breakLength).toBe 300000
      expect(Atomodoro.workTime).toBe 1500000


  # describe "atomodoro:start", ->
  #   it "calls break when start is called", ->
  #     panel = atom.workspace.panelContainers.modal.panels[0]
  #     jasmine.Clock.useMock()
  #     spy = spyOn(panel, 'show')
  #     Atomodoro.start()
  #     console.log(Atomodoro.workTime)
  #     console.log(spy.callCount)
  #     jasmine.Clock.tick(Atomodoro.workTime + 1)
  #     expect(panel.show.callCount).toEqual(1)
  #
  #   it "creates two breaks", ->
  #     panel = atom.workspace.panelContainers.modal.panels[0]
  #     spy = spyOn(panel, 'show')
  #     waits(2000)
  #     runs ->
  #       expect(panel.show.callCount).toEqual(2)

  describe "atomodoro:skip", ->
    it "overrides break", ->
      Atomodoro.break()
      Atomodoro.skip()
      expect(obscureElement).not.toBeVisible()

    it 'allows you to type during the break time when you skip the break', ->
      Atomodoro.break()
      Atomodoro.skip()
      expect(document.onkeypress()).toEqual(true)

  describe "atomodoro:session", ->

    beforeEach ->
      jasmine.Clock.useMock()

    it "confirms the session starts", ->
      Atomodoro.session(1)
      jasmine.clock().tick(workTime + 100)
      expect(Atomodoro.break().calls.count()).toEqual(1);
