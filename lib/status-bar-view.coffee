module.exports =
class PomoBar
  constructor: (time, progress) ->
    # Create root element
    @sessionProgress = document.createElement('div')
    @sessionProgress.classList.add 'inline-block'
    @sessionProgress.textContent = progress[0] + "/" + progress[1]

    @timer = document.createElement('div')
    @timer.classList.add 'inline-block'
    @timer.textContent = "#{time[0]}:#{time[1]}"

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @timer.remove()
    @sessionProgress.remove()

  getElement: ->
    @sessionProgress

  getTimer: ->
    @timer
