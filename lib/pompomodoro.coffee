PompomodoroView = require './pompomodoro-view'
{CompositeDisposable} = require 'atom'

module.exports = Pompomodoro =

  config:
    breakLength:
      type: 'integer'
      default: 5

    workIntervalLength:
      type: 'integer'
      default: 25

    numberOfSessions:
      type: 'integer'
      default: 4

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

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pompomodoroView.destroy()

  serialize: ->
    pompomodoroViewState: @pompomodoroView.serialize()

  break: ->
    @modalPanel.show()
    document.onkeypress = -> false

  work: ->
    @modalPanel.hide()
    document.onkeypress = null

  start: ->
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
      ) , 10000
    ) , 2000
    return "Session #{i} was run"

  skip: ->
    @modalPanel.hide()
    console.log("skip worked")
