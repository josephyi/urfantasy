@App = React.createClass

  componentDidMount: ->
    App.router = new Router()
    Backbone.history.start({ root: '/', pushState:true })



  render: ->
    <div className="app">
      <Header/>
      <Main/>
    </div>