@Main = React.createClass

  getInitialState: ->
    content: @homepage()
    animating: false

  homepage: ->
    return <Scoreboard />

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    # When the reset button is clicked...
    PubSub.subscribe 'main', (msg, data)=>
      @setState _.assign(data, {animating: true})
      setTimeout(@animationEnded, 1000) # hack because we cant get animationend events

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'main'

  render: ->
    return (
      <div className="main">
        {this.state.content}
      </div>
    )