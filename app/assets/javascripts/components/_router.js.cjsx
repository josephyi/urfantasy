class @Router extends Backbone.Router
  routes:
    '': 'root'
    'about': 'about'
    'champions/:champion_id' : 'champion'

  initialize: ->
    # The initial pageload doesn't fire the navigate event, just the route's method
    # but I want to publish that event still to update the state of things like the menu
    PubSub.publish "navigate", target: decodeURI(window.location.pathname)

  navigate: (fragment, options) ->
    super
    PubSub.publish "navigate", target:fragment


  root: ->
    PubSub.publish "main", content: <Home />

  about: ->
    PubSub.publish "main", content: <About />

  champion: (champion_id) ->
    # Clears out the content or else it wont get updated
    PubSub.publish "main", content:''
    PubSub.publish "main", content: <ChampionPage champion_id={champion_id} />