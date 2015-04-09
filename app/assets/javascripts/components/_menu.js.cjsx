@Menu = React.createClass
  getInitialState: ->
    target: '/'

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    PubSub.subscribe 'navigate', (msg, data)=>
      @setState data

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'navigate'

  championLeaderboard: (event) ->
    event.preventDefault() if event
    App.router.navigate('/scoreboard/top/3', true)

  fantasyLeaderboard: (event) ->
    event.preventDefault() if event
    App.router.navigate('/fantasy-leaderboard', true)


  render: ->
    fantasyClass = React.addons.classSet
      'item': true
      'active': @state.target is '/fantasy-leaderboard'

    championClass = React.addons.classSet
      'item': true
      'active': @state.target is '/scoreboard'

    return (
      <div className="ui vertical menu">
        <a className={fantasyClass} onClick={@fantasyLeaderboard}>
          Fantasy Leaderboard
        </a>
        <a className={championClass} onClick={@championLeaderboard}>
          Champion Leaderboard
        </a>
        <a className="item">
          How to Play
        </a>
        <div className="item">
          <div className="ui transparent icon input">
            <input type="text" placeholder="Search champions..." />
            <i className="search icon"></i>
          </div>
        </div>
      </div>
    )


