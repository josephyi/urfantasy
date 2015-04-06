@LoginModalContent = React.createClass

  render: ->
    <div className="content">
      <div className="ui fluid action input">
        <input type="text" placeholder="Username" />
      </div>
      <div className="ui fluid action input">
        <input type="password" placeholder="Password" />
      </div>
    </div>
