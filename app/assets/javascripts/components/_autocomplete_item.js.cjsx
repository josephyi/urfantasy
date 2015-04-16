@AutocompleteItem = React.createClass
  search: (event) ->
    event.preventDefault()
    PubSub.publish 'autocomplete', {search: @props.name}
    App.router.navigate("/champions/#{@props.champion_id}", true)

  render: ->
    return (
      <a href='#' className="item autocomplete" onClick={@search}>
        <img className="ui avatar image" src={@props.img} />
        {@props.name}
      </a>
    )