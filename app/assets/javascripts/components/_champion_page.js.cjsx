@ChampionPage = React.createClass
  DEFAULT: {}
  URL: '/stat/champion/'

  getInitialState: ->
    return _.extend @DEFAULT, @props

  componentDidMount: ->
    @get_data() unless @state.data

  componentWillUnmount: ->

  get_data: ->
    url = @URL + @state.champion_id

    d3.json(url, (error,response) =>
      console.log response
      @setState response
    )

  render: ->
    return (<LoadingIndicator />) unless @state.avg_kill_stats?
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
        </div>
        <h2 className="champion-section-title">Game Stats</h2>
        <div className="bar-graphs">
          <Graph value={@state.popularity} title="Popularity" max=50 min=1 percent=true values={pick_ban_ratio} />
          <Graph value={@state.pick_rate} title="Pick Rate" max=10 min=1 percent=true values={pick_rates} />
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
