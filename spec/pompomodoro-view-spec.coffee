PompomodoroView = require '../lib/pompomodoro-view'

# describe "mocking and clocking", ->
#
#   beforeEach ->
#     @timerCallback = jasmine.createSpy('timerCallback')
#     jasmine.Clock.useMock()
#
#   it "overwrites setTimeout", ->
#     setTimeout ( =>
#       @timerCallback()
#       ) , 1000
#     expect(@timerCallback).not.toHaveBeenCalled()
#     jasmine.Clock.tick(2000)
#     console.log(@timerCallback())
#     console.log(@timerCallback.wasCalled)
#     expect(@timerCallback.wasCalled).toEqual(true)
