@Dropdown = React.createClass
  getInitialState: ->
    return _.extend @props, {active: false, selected: @props.items[0]}

  toggle: (event) ->
    event.preventDefault()
    @setState active: !@state.active

  select: (item,event) ->
    event.preventDefault()
    App.router.navigate("/", true)
    PubSub.publish "dropdown.#{@state.title}", item
    PubSub.publish 'sidebar', {isOpen: false}
    @setState
      selected: item
      active: false

  render: ->
    items = @state.items.map( (item) =>
      class_name = "item "
      class_name += "active selected" if item.name is @state.selected.name
      return (
        <div className={class_name} onClick={@select.bind(this,item)}>
          {item.name}
        </div>
      )
    )

    label_class  = "ui dropdown label left menu "
    label_class += "active visible" if @state.active

    menu_class  = "menu "
    menu_class += "transition visible" if @state.active

    return (
      <div className={label_class} onClick={@toggle}>
        <span class="text">{@state.label}</span>
        <div className="text">{@state.selected.name}</div>
        <i className="dropdown icon"></i>
        <div className={menu_class}>
          {items}
        </div>
      </div>
    )