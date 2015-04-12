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

  search: (event) ->
    event.preventDefault()
    console.log(event)

  search_change: (event) ->
    autocomplete = _.filter(CHAMPIONS, (champion) ->
      champion['key'].toLowerCase().indexOf(event.target.value.toLowerCase()) >= 0
    )
    @setState autocomplete: autocomplete


  render: ->
    fantasyClass = React.addons.classSet
      'item': true
      'active': @state.target is '/fantasy-leaderboard'

    championClass = React.addons.classSet
      'item': true
      'active': @state.target is '/scoreboard'

    if @state.autocomplete
      autocomplete = <Autocomplete list={@state.autocomplete} />
    else
      autocomplete = ''

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
          <form className="ui transparent icon input" onSubmit={@search}>
            <input type="text" placeholder="Search champions..." onChange={@search_change} />
            <i className="search icon"></i>
          </form>
          {autocomplete}
        </div>
      </div>
    )


