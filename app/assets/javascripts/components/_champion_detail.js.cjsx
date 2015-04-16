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
        <div className="champion-header">
          <h1>{@state.name}</h1>
          <img className="champion-img" src={"http://ddragon.leagueoflegends.com/cdn/img/champion/splash/#{@state.key}_0.jpg"} />
        </div>
        <Statistic label="Average Score" value={@state.average_score} />
        <Statistic label="Average Kills" value={@state.average_kills} />
        <Statistic label="Average Deaths" value={@state.average_deaths} />
        <Statistic label="Average Assists" value={@state.average_assists} />
        <Statistic label="KDA" value={@state.kda} />
        <Statistic label="Wins" value={@state.wins} />
        <Statistic label="Losses" value={@state.losses} />
        <Statistic label="Pick Rate" value={@state.pick_rate + '%'} />
        <Statistic label="Ban Rate" value={@state.ban_rate + '%'} />
        <Statistic label="Win Rate" value={@state.win_rate + '%'} />
      </div>
    )
