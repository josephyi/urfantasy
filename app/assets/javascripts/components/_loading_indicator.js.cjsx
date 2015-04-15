@LoadingIndicator = React.createClass
  render: ->
    return (
      <div className="ui active dimmer">
        <div className="ui large text loader">Loading</div>
      </div>
    )