module.exports =
class PomoBar
  constructor: (time, progress) ->

    @sessionProgress = document.createElement('div')
    @sessionProgress.classList.add 'inline-block'

    @timer = document.createElement('div')
    @timer.classList.add 'inline-block'

  update: (time,progress)->
    @sessionProgress.textContent = "Session: #{progress[0]}/#{progress[1]}"
    @timer.textContent = "Time left: #{time[0]}:#{time[1]}"

  destroy: ->
    @timer.remove()
    @sessionProgress.remove()

  getElement: ->
    @sessionProgress

  getTimer: ->
    @timer
