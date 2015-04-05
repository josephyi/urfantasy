var Champion = React.createClass({
  render: function () {
    return (
      <div class="ui card">
        <div class="image">
          <img src={"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/"+ this.props.url_name +".png"} />
        </div>
        <div class="content">
          <a class="header">{ this.props.name }</a>
          <div class="meta">
            <span class="date">{ this.props.revealed ? this.props.score : '' }</span>
          </div>
          <div class="description">
          </div>
        </div>
        <div class="extra content">
          <i class="user icon"></i>
        </div>
      </div>
    )
  }
});