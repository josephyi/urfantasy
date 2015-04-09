@ChampionDetail = React.createClass
  getInitialState: ->
    if @props and @props.name
      return @props
    else
      @refresh()


  refresh: (event) ->
    event.preventDefault() if event

    $.ajax
      url: "/champions/#{@props.champion_id}",
      type: "GET",
      dataType: "json",
      success: (data) =>
        console.log(data)
        @setState(data)


  render: ->
    console.log(@state)
    if @state.name?
      return (
        <div className="ui cards">
          <h1>{@state.name}</h1>
          <img src={"http://ddragon.leagueoflegends.com/cdn/5.7.2/img/champion/#{@state.key}.png"} />
          <Statistic label="Average Score" value={@state.average_score} />
          <Statistic label="Average Kills" value={@state.average_kills} />
          <Statistic label="Average Deaths" value={@state.average_deaths} />
          <Statistic label="Wins" value={@state.wins} />
          <Statistic label="Losses" value={@state.losses} />
        </div>
      )
    else if @state.server_error?
      return ( <h1>ERROR</h1> )
    else
      return ( <LoadingIndicator /> )

