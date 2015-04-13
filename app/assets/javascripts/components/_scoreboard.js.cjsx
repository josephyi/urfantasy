@Scoreboard = React.createClass
  getInitialState: ->
    if @props and @props.leaderboard
      return @props
    else
      @refresh()


  refresh: (event) ->
    event.preventDefault() if event

    $.ajax
      url: "http://104.236.170.77:3000/stat/urf?day=#{@props.day}",
      type: "GET",
      dataType: "json",
      crossDomain: true,
      success: (data) =>
        @setState(data)


  render: ->
    if @state.leaderboard?
      content = @state.leaderboard.map( (champion) =>
        return <Card
          img={"http://ddragon.leagueoflegends.com/cdn/5.7.2/img/champion/#{champion.key}.png"}
          title={champion.name}
          meta={champion.average_score}
          description={champion.average_kills} />
      )
    else
      content = <LoadingIndicator />

    return (
      <div className="ui cards">
        { content }
      </div>
    )


