var Menu = React.createClass({
  render: function () {
    return (
      <div className="ui vertical menu">
        <a className="teal item">
          Fantasy Leaderboard
        </a>
        <a className="active item">
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
  }
});

