var Champion = React.createClass({
  render: function () {
    return (
      <div>
        <img src={"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/"+ this.props.url_name +".png"} />
        <h4>{ this.props.name }</h4>
        <p>{ this.props.revealed ? this.props.score : '' }</p>
      </div>
    )
  }
});