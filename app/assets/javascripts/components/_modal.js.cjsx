@Modal = React.createClass

  componentDidMount: ->
    $(React.findDOMNode(this)).modal('show')

  render: ->
    return (
      <div className="ui modal">
        <i className="close icon"></i>
        <div className="header">
          {this.props.title}
        </div>
        <div className="content">
          {this.props.children}
        </div>
        <div className="actions">
          <div className="ui black button">
            Nope
          </div>
          <div className="ui positive right labeled icon button">
            Nooch
            <i className="checkmark icon"></i>
          </div>
        </div>
      </div>
    )