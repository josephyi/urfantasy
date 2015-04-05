var Statistic = React.createClass({
  render: function () {
    return (
      <div className="ui statistic">
        <div className="label">
          {this.props.label}
        </div>
        <div className="value">
          {this.props.value}
        </div>
      </div>
    )
  }
});