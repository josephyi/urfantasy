@LoginButton = React.createClass
  openModal: (event) ->
    event.preventDefault()
    PubSub.publish 'open:modal'
    console.log('hi')
    React.render(
      <LoginModal />, document.getElementById('modal')
      )


  render: ->
    if @props.loggedIn
      <a className="ui teal button">
        Logout
      </a>
    else
      <a className="ui teal button" onClick={@openModal}>
        Login/Sign up
      </a>
