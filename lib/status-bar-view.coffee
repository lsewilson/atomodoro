module.exports =
class PomoBar
  constructor: (time, progress) ->
    # Create root element
    @sessionProgress = document.createElement('div')
    @sessionProgress.classList.add 'inline-block'
    @sessionProgress.textContent = "Session: #{progress[0]}/#{progress[1]}"

    @timer = document.createElement('div')
    @timer.classList.add 'inline-block'
    @timer.textContent = "Time left: #{time[0]}:#{time[1]}"

  # Tear down any state and detach
  destroy: ->
    @timer.remove()
    @sessionProgress.remove()

  getElement: ->
    @sessionProgress

  getTimer: ->
    @timer
