@Menu = React.createClass
  getInitialState: ->
    target: '/'

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    PubSub.subscribe 'navigate', (msg, data) =>
      @setState data
    PubSub.subscribe 'autocomplete', (msg, data) =>
      @setState data

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'navigate'
    PubSub.unsubscribe 'autocomplete'


  search: (event) ->
    event.preventDefault()
    console.log(event)

  search_change: (event) ->
    @setState search:event.target.value
    if event.target.value is ''
      @setState autocomplete: null
    else
      autocomplete = _.filter(CHAMPIONS, (champion) ->
        champion['key'].toLowerCase().indexOf(event.target.value.toLowerCase()) >= 0
      )
      @setState autocomplete: autocomplete

  search_blur: (event) ->
    # Blur happens before click events get registered, need to slow it down for autocomplete
    setTimeout( =>
      @setState autocomplete: null
    , 100)

  render: ->
    if @state.autocomplete
      autocomplete = <Autocomplete list={@state.autocomplete} />
    else
      autocomplete = ''

    return (
      <div className="item">
        <form className="ui transparent icon input" onSubmit={@search}>
          <input type="text" value={@state.search} placeholder="Search champions..." onBlur={@search_blur} onChange={@search_change} />
          <i className="search icon"></i>
        </form>
        {autocomplete}
      </div>
    )


