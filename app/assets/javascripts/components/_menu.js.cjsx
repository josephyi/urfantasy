@Menu = React.createClass

  championLeaderboard: (event) ->
    event.preventDefault()
    PubSub.publish "main", content: @championLeaderboardElement()

  fantasyLeaderboard: (event) ->
    event.preventDefault()
    PubSub.publish "main", content: @fantasyLeaderboardElement()

  championLeaderboardElement: ->
    return <Scoreboard />

  fantasyLeaderboardElement: ->
    return <FantasyLeaderboard />


  render: ->
    return (
      <div className="ui vertical menu">
        <a className="item" onClick={@fantasyLeaderboard}>
          Fantasy Leaderboard
        </a>
        <a className="item" onClick={@championLeaderboard}>
          Champion Leaderboard
        </a>
        <a className="item">
          How to Play
        </a>
        <div className="item">
          <div className="ui transparent icon input">
            <input type="text" placeholder="Search champions..." />
            <i className="search icon"></i>
          </div>
        </div>
      </div>
    )


