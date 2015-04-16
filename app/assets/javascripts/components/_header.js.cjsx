@Header = React.createClass

  REGIONS: [
    {name: 'All Regions', selected: true, value: 'All'}
    {name: 'na', selected: false, value: 'na'}
    {name: 'br', selected: false, value: 'br'}
    {name: 'eune', selected: false, value: 'eune'}
    {name: 'euw', selected: false, value: 'euw'}
    {name: 'kr', selected: false, value: 'kr'}
    {name: 'lan', selected: false, value: 'lan'}
    {name: 'las', selected: false, value: 'las'}
    {name: 'oce', selected: false, value: 'oce'}
    {name: 'tr', selected: false, value: 'tr'}
    {name: 'ru', selected: false, value: 'ru'}
  ]

  PIVOTS: [
    {name: 'Popularity', selected: true, value:'popularity'}
    {name: 'Average Score', selected: true, value:'average_score'}
    {name: 'Win Rate', selected: false, value:'win_rate'}
    {name: 'Ban Rate', selected: false, value:'ban_rate'}
  ]

  home: (event) ->
    event.preventDefault()
    App.router.navigate("/", true)

  render: ->
    return (
      <div className="ui secondary menu app-header">
        <div className="left menu">
          <h3><a href='#' onClick={@home}>For What It's Urf</a></h3>
        </div>
        <Dropdown items={@REGIONS} title="regions" />
        <Dropdown items={@PIVOTS} title="pivots" />
        <div className="ui right vertical menu app-header-search">
          <Menu />
        </div>
      </div>
    )