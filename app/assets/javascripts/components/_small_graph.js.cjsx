@SmallGraph = React.createClass

  render: ->
    range = ["#7A1810","#D9C007","#0F7015"]
    domain = [@props.min,((@props.max+@props.min)/2),@props.max]
    color = d3.scale.linear()
      .range(range)
      .domain(domain)
      .clamp(true) # https://www.youtube.com/watch?v=qf8_tn7lBIc

    color = color.range(range.reverse()) if @props.reverse

    width = ((@props.value-@props.min) / (@props.max-@props.min)) * 100
    background = color(@props.value)
    width = "#{width}%"

    value  = @props.value
    value += "%" if @props.percent

    return (
      <div className="small bar-graph">
        <div className="small bar-graph-title">{@props.title}</div>
        <div className="small bar-graph-data">
          <div className="small bar-graph-data-value" style={width:width,background:background}></div>
          <div className="small bar-graph-value">{value}</div>
        </div>
      </div>
    )