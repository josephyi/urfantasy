class @Router extends Backbone.Router
  routes:
    '': 'root'
    'scoreboard'          : 'championLeaderboard'
    'scoreboard/top/:day' : 'championLeaderboard'
    'fantasy-leaderboard' : 'fantasyLeaderboard'
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

  championLeaderboard: (day) ->
    day ?= 1
    PubSub.publish "main", content: <Scoreboard day={day} />

  fantasyLeaderboard: ->
    PubSub.publish "main", content: <FantasyLeaderboard />

  champion: (champion_id) ->
    # Clears out the content or else it wont get updated
    PubSub.publish "main", content:''
    PubSub.publish "main", content: <ChampionDetail champion_id={champion_id} />