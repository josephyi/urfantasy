@Treemap = React.createClass
  URL: "/stat/urf"

  DEFAULT:
    color: 'popularity'
    size: 'matches'

  SCALES:
    popularity:
        range: ["#b4544b","#ccc","#6bba70"]
        domain: [5, 25, 50]
    ban_rate:
        range: ["#6bba70","#ccc","#b4544b"]
        domain: [5,25,50]
    win_rate:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [40,50,60]
    average_score:
      range: ["#7A1810","#3B3E40","#0F7015"]
      domain: [0,15,30]

  getInitialState: ->
    if @props and @props.data
      return _.extend @DEFAULT, @props
    else
      @get_data()
      return @DEFAULT

  componentDidMount: ->
    @_subscribeToEvents()

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    # When the reset button is clicked...
    PubSub.subscribe 'dropdown.regions', (msg, data) =>
      @setState
        region: data.value
      @get_data()

    PubSub.subscribe 'dropdown.pivots', (msg, data) =>
      console.log data.value
      @setState
        color: data.value

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'dropdown'

  update: (event) =>
    event.preventDefault() if event
    @get_data()

  get_data: ->
    url = @URL
    url += "?region=#{@state.region}" if @state?.region? and @state.region isnt 'All'

    d3.json(url, (error,response) =>
      @setState
        data:
          champions: "All"
          children: response
    )


  componentDidUpdate: ->
    @treemap = d3.layout.treemap()
        .round(false)
        .size([960, 500])
        .sticky(true)
        .value((d) =>
          return d[@state.size] + 5000
        )

    @color = d3.scale.linear()
      .range(@SCALES[@state.color].range)
      .domain(@SCALES[@state.color].domain)
    console.log(@state.data)
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

  render: ->
    content = if @state?.data? then <Svg /> else <LoadingIndicator />
    champion_detail = <ChampionDetail {...@state.selected_champion} /> if @state?.selected_champion?
    return (
      <div>
        {content}
        <ChampionDetail />
      </div>
    )