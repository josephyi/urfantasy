@LoginModal = React.createClass

  render: ->
    <Modal title="foo" content="bar">
      <div className="ui input">
        <input type="text" placeholder="Username" />
      </div>
      <div className="ui input">
        <input type="password" placeholder="Password" />
      </div>
    </Modal>
