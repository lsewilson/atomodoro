PompomodoroView = require './pompomodoro-view'
{CompositeDisposable} = require 'atom'

module.exports = Pompomodoro =

  config:
    breakLength:
      type: 'integer'
      default: 5 # 5

    workIntervalLength:
      type: 'integer'
      default: 5 # 25

    numberOfSessions:
      type: 'integer'
      default: 4 # 4

  pompomodoroView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @pompomodoroView = new PompomodoroView(state.pompomodoroViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @pompomodoroView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:start': => @start()
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:break': => @break()
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:work': => @work()
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:skip': => @skip()
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:session': => @session()

    @noOfIntervals = atom.config.get('pompomodoro.numberOfSessions')
    @breakLength = atom.config.get('pompomodoro.breakLength') * 1000 #* 60
    @workTime = atom.config.get('pompomodoro.workIntervalLength')  * 1000 #* 60


  break: ->
    @modalPanel.show()
    document.onkeypress = -> false

  work: ->
    @modalPanel.hide()
    document.onkeypress = null
    setTimeout ( =>
      atom.notifications.addInfo("Warning: 1 minute until your break!")
    ) , @workTime - 1000 #* 60

  start: ->
    @work()
    console.log "Pompomodoro has started!"
    @session(1)

  session: (i) ->
    console.log "Session #{i} started"
    setTimeout ( =>
      @break()
      setTimeout ( =>
        @work()
        if i < @noOfIntervals
          @session(i+1)
      ) , @breakLength
    ) , @workTime
    return "Session #{i} was run"

  skip: ->
    @modalPanel.hide()
    console.log("skip worked")

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pompomodoroView.destroy()

  serialize: ->
    pompomodoroViewState: @pompomodoroView.serialize()
