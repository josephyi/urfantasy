@Header = React.createClass
  getInitialState: ->
    { modalIsOpen: false }

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    # When the reset button is clicked...
    PubSub.subscribe 'open:modal', ()=>
      console.log('yo')

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'open:modal'

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