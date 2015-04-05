var Scoreboard = React.createClass({
  getInitialState: function () {
    return this.props;
  },

  refresh: function(event) {
    event.preventDefault();

    $.ajax({
      url: "/test",
      type: "GET",
      dataType: "json",
      success: function ( data ) {
        this.setState(data);
      }.bind(this)
    });
  },


  render: function () {
    var _this = this;
    var champions = this.state.leaderboard.map(function ( champion ) {
      return <Card
        img={"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/"+ champion.key +".png"}
        title={champion.name}
        meta={champion.total_score}
        key={champion.id}
        description={champion.stats.minionsKilled} />
    });

    return (
      <div className="ui cards">
        { champions }
      </div>
    )
  }
});
