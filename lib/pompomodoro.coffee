PompomodoroView = require './pompomodoro-view'
{CompositeDisposable} = require 'atom'

module.exports = Pompomodoro =

  config:
    breakLength:
      description: 'Length of break in minutes'
      type: 'integer'
      default: 5

    workIntervalLength:
      description: 'Length of work intervals in minutes'
      type: 'integer'
      default: 25

    numberOfIntervals:
      description: 'Number of work intervals in a session'
      type: 'integer'
      default: 4

  pompomodoroView: null
  modalPanel: null
  subscriptions: null
  noOfIntervals: null
  breakLength: null
  workTime: null

  activate: (state) ->
    @pompomodoroView = new PompomodoroView(state.pompomodoroViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @pompomodoroView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:start': => @start()
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:skip': => @skip()

    @noOfIntervals = atom.config.get('pompomodoro.numberOfSessions')
    @breakLength = atom.config.get('pompomodoro.breakLength') * 1000 #* 60
    @workTime = atom.config.get('pompomodoro.workIntervalLength') * 1000 #* 60

  break: (i) ->
    if i < this.noOfIntervals
      @modalPanel.show()
      document.onkeypress = -> false
    else
      atom.notifications.addSuccess("Well done, you've finished your sprint!")

  work: ->
    this.hidePanel()
    setTimeout ( =>
      atom.notifications.addInfo("1 minute until your break!")
    ) , @workTime - 1000 #* 60

  start: ->
    console.log "Pompomodoro has started!"
    console.log(@workTime)

    this.session(1)

  session: (i) ->
    console.log "Session #{i} started"
    this.work()
    setTimeout ( =>
      this.break(i)
      setTimeout ( =>
        if i < @noOfIntervals
          this.session(i+1)
      ) , @breakLength
    ) , @workTime
    return "Session #{i} was run"

  hidePanel: ->
    @modalPanel.hide()
    document.onkeypress = -> true

  skip: ->
    @modalPanel.hide()
    document.onkeypress = -> true

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pompomodoroView.destroy()

  serialize: ->
    pompomodoroViewState: @pompomodoroView.serialize()
