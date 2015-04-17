@ChampionPage = React.createClass
  DEFAULT: {}
  URL: '/stat/champion/'

  getInitialState: ->
    return _.extend @DEFAULT, @props

  componentDidMount: ->
    @get_data() unless @state.data


  _get_rankings: ->
    for champ, i in OVERALL_STATS.assists_leaderboard
      i++
      if champ.id.toString() is @props.champion_id
        @props.assists_rank = i
        break
    for champ, i in OVERALL_STATS.kills_leaderboard
      i++
      if champ.id.toString() is @props.champion_id
        @props.kills_rank = i
        break
    for champ, i in OVERALL_STATS.kills_leaderboard
      i++
      if champ.id.toString() is @props.champion_id
        @props.deaths_rank = i
        break
    for champ, i in OVERALL_STATS.wins_leaderboard
      i++
      if champ.id.toString() is @props.champion_id
        @props.wins_rank = i
        break
    for champ, i in OVERALL_STATS.fantasy_leaderboard
      i++
      if champ.id.toString() is @props.champion_id
        @props.fantasy_rank = i
        break

  componentWillUnmount: ->

  get_data: ->
    url = @URL + @state.champion_id

    d3.json(url, (error,response) =>
      @_get_rankings()
      @setState response
    )

  scroll: (event) ->
    event.preventDefault()
    $('.app-main').animate({
      scrollTop: $('.champion-section-title').first().offset().top - 50
    }, 1000)

  render: ->
    return (<LoadingIndicator />) unless @state.avg_kill_stats?

    color = d3.scale.linear()
      .range(["#7A1810","#D9C007","#0F7015"])
      .domain([123,66,1])

    kill_stats = _.map(@state.avg_kill_stats, (stat) ->
      return {title: stat.region, value: stat.avg_kills} )
    death_stats = _.map(@state.avg_death_stats, (stat) ->
      return {title: stat.region, value: stat.avg_deaths} )
    assist_stats = _.map(@state.avg_assists_stats, (stat) ->
      return {title: stat.region, value: stat.avg_assists} )
    pick_rates = _.map(@state.pick_rates, (stat) ->
      return {title: stat.region, value: stat.pick_rate} )
    ban_rates = _.map(@state.ban_rates, (stat) ->
      return {title: stat.region, value: stat.ban_rate} )
    win_rates = _.map(@state.win_rates, (stat) ->
      return {title: stat.region, value: stat.win_rate} )
    pick_ban_ratio = _.map(@state.pick_ban_ratio, (stat) ->
      return {title: stat.region, value: stat.pick_ban_ratio} )


    return (
      <div className="champion-page">
        <div className="champion-header">
          <div className="champion-title">
            <span className="champion-name">{@state.name}</span>
          </div>
          <img className="champion-img" src={"http://ddragon.leagueoflegends.com/cdn/img/champion/splash/#{@state.key}_0.jpg"} />
          <div className="champion-badges">
            <Badge value={@props.fantasy_rank} title="Fantasy Score" color={color(@props.fantasy_rank)} />
            <Badge value={@props.kills_rank} title="Kills" color={color(@props.kills_rank)} />
            <Badge value={@props.deaths_rank} title="Deaths" color={color(@props.deaths_rank)} />
            <Badge value={@props.assists_rank} title="Assists" color={color(@props.assists_rank)} />
            <Badge value={@props.wins_rank} title="Wins" color={color(@props.wins_rank)} />
          </div>
          <i className="icon angle down" onClick={@scroll}></i>
        </div>
        <h2 className="champion-section-title">Game Stats</h2>
        <div className="bar-graphs">
          <Graph value={@state.popularity} title="Popularity" max=60 min=1 percent=true values={pick_ban_ratio} />
          <Graph value={@state.pick_rate} title="Pick Rate" max=30 min=1 percent=true values={pick_rates} />
          <Graph value={@state.ban_rate} title="Ban Rate" max=30 min=1 percent=true values={ban_rates} reverse=true />
          <Graph value={@state.win_rate} title="Win Rate" max=60 min=40 percent=true values={win_rates} />
        </div>
        <h2 className="champion-section-title">In-Game Stats</h2>
        <div className="bar-graphs">
          <Graph value={@state.average_kills} title="Average Kills" max=16 min=4 values={kill_stats} />
          <Graph value={@state.average_deaths} title="Average Deaths" max=16 min=7 values={death_stats} reverse=true />
          <Graph value={@state.average_assists} title="Average Assists" max=17 min=4 values={assist_stats} />
          <Graph value={@state.kda} title="Average KDA" max=3 min=1 />
        </div>
      </div>
    )
