var Match = React.createClass({
  getInitialState: function () {
    console.log(this.props);
    return _.extend(this.props, {revealed:false});
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

  reveal: function(event) {
    event.preventDefault();

    this.setState(function(previousState, currentProps) {
      teams = _.sortBy(this.state.match.teams,'total_score', false)
      _.forEach(teams, function(team) {
        team.champions = _.sortByOrder(team.champions,'total_score', false);
      });

      return {
        teams: teams,
        revealed: true
      }
    });
  },

  render: function () {
    var _this = this;
    var teamNodes = this.state.match.teams.map(function ( team ) {
      return <ChampionList champions={team.champions} score={team.total_score} key={team.id} revealed={_this.state.revealed} />
    });

    return (
      <div className="team-list">
        <h1>{this.state.match.matchId}</h1>
        <a href="#" onClick={this.reveal}>REVEAL</a> &bull; &nbsp;
        <a href="#" onClick={this.refresh}>REFRESH</a>
        { teamNodes }
      </div>
    )
  }
});
