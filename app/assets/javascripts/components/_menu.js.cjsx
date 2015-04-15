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
    if event.target.value is ''
      @setState autocomplete: null
    else
      autocomplete = _.filter(CHAMPIONS, (champion) ->
        champion['key'].toLowerCase().indexOf(event.target.value.toLowerCase()) >= 0
      )
      @setState autocomplete: autocomplete

  search_blur: (event) ->
    @setState autocomplete: null

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
      <div className="item">
        <form className="ui transparent icon input" onSubmit={@search}>
          <input type="text" placeholder="Search champions..." onBlur={@search_blur} onChange={@search_change} />
          <i className="search icon"></i>
        </form>
        {autocomplete}
      </div>
    )


