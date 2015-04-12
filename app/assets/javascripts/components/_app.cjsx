@App = React.createClass

  componentDidMount: ->
    App.router = new Router()
    Backbone.history.start({ root: '/', pushState:true })



  render: ->
    <div>
      <Header/>
      <div className="ui grid">
        <div className="four wide column">
          <Menu/>
        </div>
        <div className="twelve wide column">
          <Main/>
        </div>
      </div>
      <Modal/>
    </div>