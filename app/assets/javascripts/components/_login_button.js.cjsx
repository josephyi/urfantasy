@LoginButton = React.createClass
  openModal: (event) ->
    event.preventDefault()
    PubSub.publish 'modal', @modalArgs()

  modalArgs: ->
    isOpen: true
    title: 'Login/Sign up'
    content: @modalContent()
    footer: @modalFooter()

  modalContent: ->
    return <LoginModalContent />

  modalFooter: ->
    return <LoginModalFooter />

  render: ->
    if @props.loggedIn
      <a className="ui teal button">
        Logout
      </a>
    else
      <a className="ui teal button" onClick={@openModal}>
        Login/Sign up
      </a>
