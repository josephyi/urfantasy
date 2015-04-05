var Card = React.createClass({
  render: function () {
    return (
      <div className="ui card">
        <div className="image">
          <img src={this.props.img} />
        </div>
        <div className="content">
          <a className="header">{ this.props.title }</a>
          <div className="meta">
            <span className="date">{ this.props.meta }</span>
          </div>
          <Statistic label="test" value={this.props.description} />
          <div className="description">
            { this.props.description }
          </div>
        </div>
        <div className="extra content">
          <i className="user icon"></i>
        </div>
      </div>
    )
  }
});