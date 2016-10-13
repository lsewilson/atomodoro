PompomodoroView = require './pompomodoro-view'
{CompositeDisposable} = require 'atom'

module.exports = Pompomodoro =

  config:
    breakLength:
      type: 'integer'
      default: 1 # 5

    workIntervalLength:
      type: 'integer'
      default: 1 # 25

    numberOfSessions:
      type: 'integer'
      default: 2 # 4

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
    @subscriptions.add atom.commands.add 'atom-workspace', 'pompomodoro:skip': => @skip()

    @noOfIntervals = atom.config.get('pompomodoro.numberOfSessions')
    @breakLength = atom.config.get('pompomodoro.breakLength') * 1000 * 10 #* 60
    @workTime = atom.config.get('pompomodoro.workIntervalLength') * 1000 * 10 #* 60

  break: ->
    @modalPanel.show()
    document.onkeypress = -> false

  work: ->
    this.hidePanel()
    setTimeout ( =>
      atom.notifications.addInfo("1 minute until your break!")
    ) , @workTime - 1000 #* 60

  start: ->
    console.log "Pompomodoro has started!"
    this.session(1)

  session: (i) ->
    console.log "Session #{i} started"
    this.work()
    setTimeout ( =>
      this.break()
      setTimeout ( =>
        if i < @noOfIntervals
          this.session(i+1)
        else
          atom.notifications.addSuccess("Well done, you've finished your sprint!")
          this.hidePanel()
      ) , @breakLength
    ) , @workTime
    return "Session #{i} was run"

  hidePanel: ->
    @modalPanel.hide()
    document.onkeypress = -> true


  #
  # start: ->
  #   @work()
  #   console.log "Pompomodoro has started!"
  #   @session(1)
  #
  # session: (i) ->
  #   console.log "Session #{i} started"
  #   setTimeout ( =>
  #     @break()
  #     setTimeout ( =>
  #       @work()
  #       if i < @noOfIntervals
  #         @session(i+1)
  #       else
  #         atom.notifications.addSuccess("Well done, you've finished your sprint!")
  #     ) , @breakLength
  #   ) , @workTime
  #   return "Session #{i} was run"

  skip: ->
    @modalPanel.hide()
    document.onkeypress = -> true

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pompomodoroView.destroy()

  serialize: ->
    pompomodoroViewState: @pompomodoroView.serialize()
