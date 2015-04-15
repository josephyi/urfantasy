@Main = React.createClass

  getInitialState: ->
    animating: false

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    # When the reset button is clicked...
    PubSub.subscribe 'main', (msg, data)=>
      console.log(data)
      @setState data

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'main'

  render: ->
    content = if @state.content then @state.content else <LoadingIndicator />
    return (
      <div className="app-main">
        {content}
      </div>
    )