@Treemap = React.createClass
  URL: "/stat/urf"

  DEFAULT:
    color: 'average_score'
    size: 'matches'

  SCALES:
    popularity:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [1, 25, 60]
    ban_rate:
      range: ["#0F7015","#3B3E40","#7A1810"]
      domain: [1,10,50]
    win_rate:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [40,50,60]
    average_score:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [0,15,30]
    kda:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [1.0,2.0,2.5]
    average_kills:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [4,9,14]
    average_deaths:
      range: ["#0F7015","#3B3E40","#7A1810"]
      domain: [9,10,11]
    average_assists:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [4,10,16]
    penta_kills:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [0,10,100]

  getInitialState: ->
    if @props and @props.data
      return _.extend @DEFAULT, @props
    else
      @_get_data()
      return @DEFAULT

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()


  # Don't update the component if we are just changing region or day
  # because the ajax call hasnt finished yet
  shouldComponentUpdate: (props, state) ->
    return false if state.region isnt @state.region
    return false if state.day    isnt @state.day
    return true

  componentDidUpdate: ->
    if @treemap
      @_update_graph()
    else
      @_build_graph()


  _subscribeToEvents: ->
    # When the reset button is clicked...
    PubSub.subscribe 'dropdown.regions', (msg, data) =>
      @setState
        region: data.value
      @_get_data()

    PubSub.subscribe 'dropdown.days', (msg, data) =>
      @setState
        day: data.value
      @_get_data()
        size: data.size || @state.size

    PubSub.subscribe 'dropdown.pivot_sizes', (msg, data) =>
      @setState
        size: data.value

    PubSub.subscribe 'dropdown.pivots', (msg, data) =>
      @setState
        color: data.value

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'dropdown'


  _get_data: ->
    url = @URL
    if @state?.region?  || @state?.day?
      params = {region: @state.region, day: @state.day}
      delete params["region"] if @state.region == 'All' || !@state?.region?
      delete params["day"] if @state.day == 'All' || !@state?.day?
      querystring = $.param params
      url += "?#{querystring}" if querystring.length > 0 # i sux at this

    d3.json(url, (error,response) =>
      @setState
        data:
          champions: "All"
          children: response
    )

  _update_graph: ->
    @color = @color
      .range(@SCALES[@state.color].range)
      .domain(@SCALES[@state.color].domain)

    @treemap = @treemap.value((d) =>
      return d[@state.size] )

    nodes = @treemap.nodes(@state.data)
      .filter((d) ->
        return !d.children )

    cells = d3.select(".treemap-points")
      .selectAll("g.cell")
      .data(nodes)

    cells.transition()
      .duration(750)
      .attr("transform", (d) ->
        return "translate(" + d.x + "," + d.y + ")"
      )

    cells.select("rect")
      .transition()
      .duration(750)
      .attr("width", (d) ->
        return d.dx
      )
      .attr("height", (d) ->
        return d.dy
      )
      .style("fill", (d) =>
        return @color( d[@state.color] )
      )

    cells.select("image")
      .attr("xlink:href", (d)-> "http://ddragon.leagueoflegends.com/cdn/5.7.2/img/champion/#{d.key}.png")


  _build_graph: ->
    @treemap = d3.layout.treemap()
        .round(true)
        .size([960, 500])
        .value((d) =>
          return d[@state.size] + 5000 )
        .sort((a,b) =>
          return a[@state.size] - b[@state.size] )

    @color = d3.scale.linear()
      .range(@SCALES[@state.color].range)
      .domain(@SCALES[@state.color].domain)

    nodes = @treemap.nodes(@state.data)
      .filter((d) ->
        return !d.children
      )

    cells = d3.select(".treemap-points")
      .selectAll("g.cell")
      .data(nodes)
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
        return @color( d[@state.color] )
      ).on('click', (d) =>
        PubSub.publish 'sidebar', _.extend(d, {isOpen: true})
      )

    cells.append("svg:image")
      .attr("xlink:href", (d)-> "http://ddragon.leagueoflegends.com/cdn/5.7.2/img/champion/#{d.key}.png")
      .attr("x", 0)
      .attr("y", 0)
      .attr("width", 20)
      .attr("height", 20)

    # cells.append("svg:rect")
    #   .attr("class", "cell-tooltip")
    #   .attr("x", 0)
    #   .attr("y", 0)
    #   .attr("width", 100)
    #   .attr("height", 20)
    #   .append("svg:text")
    #   .attr("class", "cell-tooltip-text")
    #   .attr("dy", 20)
    #   .attr("text-anchor", "middle")
    #   .text((d) ->
    #     return d.name )


  render: ->
    content = if @state?.data? then <Svg classname="treemap" group_classname="treemap-points" viewbox="0 0 960 500" preserveAspectRatio="none" /> else <LoadingIndicator />
    champion_detail = <ChampionDetail {...@state.selected_champion} /> if @state?.selected_champion?
    return (
      <div>
        {content}
        <ChampionDetail />
      </div>
    )