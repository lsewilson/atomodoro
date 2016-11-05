module.exports =
class AtomodoroView
  constructor: (serializedState) ->
    @breakView = document.createElement('div')
    @breakView.classList.add('obscure')

    message = document.createElement('div')
    message.textContent = "It's time to take a break!"
    message.classList.add('break-message')
    @breakView.appendChild(message)
    @breakView.setAttribute('style', 'position: fixed')

  destroy: ->
    @breakView.remove()

  getElement: ->
    @breakView
