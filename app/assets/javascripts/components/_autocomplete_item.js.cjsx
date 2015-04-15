@AutocompleteItem = React.createClass
  search: (event) ->
    event.preventDefault()
    App.router.navigate("/champions/#{@props.champion_id}", true)

  render: ->
    return (
      <a className="item autocomplete" onClick={@search}>
        <img className="ui avatar image" src={@props.img} />
        {@props.name}
      </a>
    )