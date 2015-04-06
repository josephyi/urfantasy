@Scoreboard = React.createClass
  getInitialState: ->
    if _.isEmpty @props
      @refresh()
    else
      return @props


  refresh: (event) ->
    event.preventDefault() if event

    $.ajax
      url: "/test",
      type: "GET",
      dataType: "json",
      success: (data) =>
        @setState(data)


  render: ->
    champions = <div></div>
    if @state.match?.leaderboard?
      champions = @state.match.leaderboard.map( (champion) =>
        return <Card
          img={"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/#{champion.key}.png"}
          title={champion.name}
          meta={champion.total_score}
          key={champion.id}
          description={champion.stats.minionsKilled} />
      )

    return (
      <div className="ui cards">
        { champions }
      </div>
    )


