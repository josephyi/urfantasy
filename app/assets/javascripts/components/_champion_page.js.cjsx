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
      @setState response
    )

  render: ->
    return (<LoadingIndicator />) unless @state.avg_kill_stats?

    return (
      <div className="champion-page">
        <div className="champion-header">
          <div className="champion-title">
            <span className="champion-name">{@state.name}</span>
          </div>
          <img className="champion-img" src={"http://ddragon.leagueoflegends.com/cdn/img/champion/splash/#{@state.key}_0.jpg"} />
        </div>
      </div>
    )
