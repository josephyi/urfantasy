class @Router extends Backbone.Router
  routes:
    '': 'root'
    'scoreboard'          : 'championLeaderboard'
    'scoreboard/top/:day' : 'championLeaderboard'
    'fantasy-leaderboard' : 'fantasyLeaderboard'

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
    console.log(day)
    PubSub.publish "main", content: <Scoreboard day={day} />

  fantasyLeaderboard: ->
    PubSub.publish "main", content: <FantasyLeaderboard />
