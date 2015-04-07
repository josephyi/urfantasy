class @Router extends Backbone.Router
  routes:
    '': 'root'
    'scoreboard'          : 'championLeaderboard'
    'fantasy-leaderboard' : 'fantasyLeaderboard'

  navigate: (fragment, options) ->
    super
    console.log('hi')
    PubSub.publish "navigate", target:fragment


  root: ->
    PubSub.publish "main", content: <Home />

  championLeaderboard: ->
    PubSub.publish "main", content: <Scoreboard />

  fantasyLeaderboard: ->
    PubSub.publish "main", content: <FantasyLeaderboard />
