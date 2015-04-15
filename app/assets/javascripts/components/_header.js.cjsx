@Header = React.createClass

  render: ->
    return (
      <div className="ui secondary menu app-header">
        <div className="left menu">
          <h3>For What It's Urf</h3>
        </div>
        <div className="ui right vertical menu app-header-search">
          <Menu />
        </div>
      </div>
    )