@Autocomplete = React.createClass
  render: ->
    if @props.list
      list = @props.list.map((champion) =>
        return <AutocompleteItem
          name={champion.key}
          champion_id={champion.champion_id}
          img={"http://ddragon.leagueoflegends.com/cdn/5.7.2/img/champion/#{champion.key}.png"} />
      )

    return (
      <div class="ui selection list">
        {list}
      </div>
    )