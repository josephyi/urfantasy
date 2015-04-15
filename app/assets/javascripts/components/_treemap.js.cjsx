@Treemap = React.createClass
  getInitialState: ->
    if @props and @props.data
      return @props
    else
      @update()


  update: (event) ->
    event.preventDefault() if event

    d3.json("/stat/urf", (data) =>
      @setState(
        data:
          champions: "All",
          children: data
      )
    )

    return @state

  componentDidMount: ->
    el = @getDOMNode()
    @color = d3.scale.linear()
      .range(["#b4544b","#ccc","#6bba70"])
      .domain([0,15,30])

    @treemap = d3.layout.treemap()
        .round(false)
        .size([960, 500])
        .sticky(true)
        .value((d) ->
          return d.matches
        )

  componentDidUpdate: ->
    nodes = @treemap.nodes(@state.data)
    chart = d3.select(".treemap-points")
    cells = chart.selectAll("g.cell.parent").data(nodes)
                 .enter()
                 .append("svg:g")
                 .attr("class", "cell")
                 .attr("transform", (d) ->
                   return "translate(" + d.x + "," + d.y + ")"
                 )

    cells.append("svg:rect")
      .attr("class", "cell-box")
      .attr("width", (d) ->
        return d.dx
      )
      .attr("height", (d) ->
        return d.dy
      )
      .style("fill", (d) =>
        return @color(d.average_score)
      ).on('click', (d) =>
        PubSub.publish 'sidebar', _.extend(d, {isOpen: true})
      )



  render: ->
    content = if @state?.data? then <Svg /> else <LoadingIndicator />
    champion_detail = <ChampionDetail {...@state.selected_champion} /> if @state?.selected_champion?
    return (
      <div>
        {content}
        <ChampionDetail />
      </div>
    )