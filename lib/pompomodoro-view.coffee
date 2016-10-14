module.exports =
class PompomodoroView
  constructor: (serializedState) ->
    # Create root element
    @breakView = document.createElement('div')
    @breakView.classList.add('obscure')

    # Create message element
    message = document.createElement('div')
    message.textContent = "It's time to take a break!"
    message.classList.add('break-message')
    @breakView.appendChild(message)
    @breakView.setAttribute('style', 'position: fixed')

  # Tear down any state and detach
  destroy: ->
    @breakView.remove()

  getElement: ->
    @breakView
