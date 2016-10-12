PompomodoroView = require './pompomodoro-view'
{CompositeDisposable} = require 'atom'

module.exports = Pompomodoro =
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

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pompomodoroView.destroy()

  serialize: ->
    pompomodoroViewState: @pompomodoroView.serialize()

  break: ->
    @modalPanel.show()

  work: ->
    @modalPanel.hide()

  start: ->
    console.log "Pompomodoro has started!"
    @session(0)

  session: (i) ->
    console.log "Session #{i} started"
    setTimeout ( =>
      @break()
      setTimeout ( =>
        @work()
        if i < 4
          @session(i+1)
      ) , 2000
    ) , 2000
    return "Session #{i} was run"

  skip: ->
    @modalPanel.hide()
    console.log("skip worked")
