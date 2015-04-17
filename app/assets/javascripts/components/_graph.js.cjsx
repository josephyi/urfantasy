@Graph = React.createClass

  getInitialState: ->
    isOpen: false

  test: (event) ->
    event.preventDefault()
    @setState isOpen: !@state.isOpen

  render: ->
    range = ["#7A1810","#D9C007","#0F7015"]
    domain = [@props.min,(@props.max/2),@props.max]
    color = d3.scale.linear()
      .range(range)
      .domain(domain)
      .clamp(true) # https://www.youtube.com/watch?v=qf8_tn7lBIc

    color = color.range(range.reverse()) if @props.reverse

    width = (@props.value / @props.max) * 100
    background = color(@props.value)
    width = "#{width}%"

    sub_graphs = _.map(@props.values, (props) =>
      return (
        <SmallGraph title={props.title} value={props.value} min={@props.min} max={@props.max} reverse={@props.reverse} percent={@props.percent} />
      )
    )

    value  = @props.value
    value += "%" if @props.percent

    sub_graph_class  = "bar-graph-sub "
    sub_graph_class += "shown" if @state.isOpen
    expand_class = "chevron right icon"
    expand_class = "chevron down icon" if @state.isOpen

    expand = <i className={expand_class} onClick={@test}></i> if @props.values?.length

    return (
      <div className="bar-graph">
        <div className="bar-graph-title">{@props.title}</div>
        <div className="bar-graph-data">
          <div className="bar-graph-data-value" style={width:width,background:background}></div>
          <div className="bar-graph-value">{value}</div>
          {expand}
        </div>
        <div className={sub_graph_class}>
          {sub_graphs}
        </div>
      </div>
    )