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
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:start': => @start()
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:break': => @break()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pompomodoroView.destroy()

  serialize: ->
    pompomodoroViewState: @pompomodoroView.serialize()

  break: ->
    @modalPanel.show()

  start: ->
    console.log "Pompomodoro has started!"

  toggle: ->
    console.log 'Pompomodoro was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
