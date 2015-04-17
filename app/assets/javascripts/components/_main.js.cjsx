@Main = React.createClass

  getInitialState: ->
    animating: false

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    PubSub.subscribe 'main', (msg, data)=>
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