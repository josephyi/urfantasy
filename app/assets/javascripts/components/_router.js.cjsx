class @Router extends Backbone.Router
  routes:
    'scoreboard' : 'championLeaderboard'
    'fantasy-leaderboard' : 'fantasyLeaderboard'

  navigate: ->
    super
    console.log('hi')

  championLeaderboard: (event) ->
    event.preventDefault() if event
    PubSub.publish "navigate", target:'/scoreboard'
    PubSub.publish "main", content: @championLeaderboardElement()

  fantasyLeaderboard: (event) ->
    event.preventDefault() if event
    PubSub.publish "navigate", target:'/fantasy-leaderboard'
    PubSub.publish "main", content: @fantasyLeaderboardElement()

  championLeaderboardElement: ->
    return <Scoreboard />

  fantasyLeaderboardElement: ->
    return <FantasyLeaderboard />