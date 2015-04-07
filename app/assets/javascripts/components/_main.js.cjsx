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
      @setState _.extend(data, {animating: true})
      setTimeout(@animationEnded, 1000) # hack because we cant get animationend events

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'main'

  render: ->
    content = if @state.content then @state.content else <LoadingIndicator />
    return (
      <div className="main">
        {content}
      </div>
    )