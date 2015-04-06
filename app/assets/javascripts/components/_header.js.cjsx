@Header = React.createClass

  render: ->
    return (
      <div>
        <div className="ui secondary pointing menu app-header">
          <div className="left menu">
            <h3>URFantasy Pickem</h3>
          </div>

          <div className="right menu">
            <LoginButton {...this.props} />
          </div>
        </div>
      </div>
    )