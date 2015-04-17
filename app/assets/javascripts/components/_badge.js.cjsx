@Badge = React.createClass

  render: ->
    return (
      <div className="champion-badge" style={background:@props.color}>
        #{@props.value} in {@props.title}
      </div>
    )