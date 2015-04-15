@ChampionDetail = React.createClass
  getInitialState: ->
    isOpen: false
    animating: false

  componentDidMount: ->
    @_subscribeToEvents()


  animationEnded: ->
    console.log('animation ended!')
    @setState animating: false

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    # When the reset button is clicked...
    PubSub.subscribe 'sidebar', (msg, data)=>
      @setState _.extend(data, {animating: true})
      setTimeout(@animationEnded, 1000) # hack because we cant get animationend events

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'sidebar'

  _closeSidebar: (event) =>
    event.preventDefault()
    PubSub.publish 'sidebar', {isOpen: false}


  render: ->
    sidebarClass  = "ui right sidebar menu vertical overlay inverted labeled icon "

    if @state.isOpen
      sidebarClass += "visible "
    else
      sidebarClass += " "
      unless @state.animating
        sidebarClass += " "
    if @state.animating
      sidebarClass += "animating "

    return (
      <div className={sidebarClass}>
        <i className="close icon" onClick={@_closeSidebar}></i>
        <h1>{@state.name}</h1>
        <img src={"http://ddragon.leagueoflegends.com/cdn/5.7.2/img/champion/#{@state.name}.png"} />
        <Statistic label="Average Score" value={@state.average_score} />
        <Statistic label="Average Kills" value={@state.average_kills} />
        <Statistic label="Average Deaths" value={@state.average_deaths} />
        <Statistic label="Wins" value={@state.wins} />
        <Statistic label="Losses" value={@state.losses} />
      </div>
    )
