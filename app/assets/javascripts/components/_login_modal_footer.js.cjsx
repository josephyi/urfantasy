@LoginModalFooter = React.createClass

  _signUp: (event) ->
    event.preventDefault()
    PubSub.publish 'modal', {isOpen: false}

  render: ->
    <div className="actions">
      <div className="ui buttons">
        <div className="ui positive button">
          Log In
        </div>
        <div className="or"></div>
        <div className="ui positive button" onClick={@_signUp}>
          Sign Up
        </div>
      </div>
    </div>
