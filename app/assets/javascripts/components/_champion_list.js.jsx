var ChampionList = React.createClass({


  render: function () {
    var _this = this;
    var championNodes = this.props.champions.map(function ( champion ) {
      return <Champion url_name={champion.key} name={champion.name} score={champion.total_score} key={champion.id} revealed={_this.props.revealed} />
    });

    return (
      <div className="champion-list">
        <h2>Team {this.props.key}</h2>
        <h3>Score: { this.props.revealed ? this.props.score : ''}</h3>
        { championNodes }
      </div>
    )
  }
});
