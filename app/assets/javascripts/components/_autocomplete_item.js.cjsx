@AutocompleteItem = React.createClass
  search: (event) ->
    event.preventDefault()
    App.router.navigate("/champions/#{@props.champion_id}", true)

  render: ->
    return (
      <div className="item" onClick={@search}>
        <img className="ui avatar image" src={@props.img} />
        <div className="content">
          <div className="header">{@props.name}</div>
        </div>
      </div>
    )