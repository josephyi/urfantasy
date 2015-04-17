@BarGraph = React.createClass
  DEFAULT: {}

  getInitialState: ->
    if @props and @props.data
      return _.extend @DEFAULT, @props
    else
      @_get_data()
      return @DEFAULT

  componentDidUpdate: ->


  _get_data: ->


  _update_graph: ->


  _build_graph: ->


  render: ->
    return (
      <Svg classname="bar-graph" viewbox="0 0 500 100" />
    )