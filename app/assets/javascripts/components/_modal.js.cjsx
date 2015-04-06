@Modal = React.createClass

  getInitialState: ->
    isOpen: false
    animating: false

  componentDidMount: ->
    @_subscribeToEvents()
    # These dont work
    React.findDOMNode(@).addEventListener(AnimationEvent(), @animationEnded())
    React.findDOMNode(@).addEventListener(TransitionEvent(), @animationEnded())

  animationEnded: ->
    console.log('animation ended!')
    @setState animating: false

  componentWillUnmount: ->
    @_unsubscribeFromEvents()

  _subscribeToEvents: ->
    # When the reset button is clicked...
    PubSub.subscribe 'modal', (msg, data)=>
      @setState _.assign(data, {animating: true})
      setTimeout(@animationEnded, 1000) # hack because we cant get animationend events

  _unsubscribeFromEvents: ->
    PubSub.unsubscribe 'modal'

  _closeModal: (event) =>
    event.preventDefault()
    PubSub.publish 'modal', {isOpen: false}


  render: ->
    dimmerClass = "ui dimmer modals page fade transition "
    modalClass  = "ui modal scale transition "

    if @state.isOpen
      dimmerClass += "in visible active "
      modalClass  += "in visible active "
    else
      dimmerClass += "out "
      modalClass  += "out "
      unless @state.animating
        dimmerClass += "hidden "
        modalClass  += "hidden "
    if @state.animating
      dimmerClass += "animating active visible "
      modalClass  += "animating active visible "



    return (
      <div className={dimmerClass}>
        <div className={modalClass}>
          <i className="close icon" onClick={@_closeModal}></i>
          <div className="header">
            {this.state.title}
          </div>
          {this.state.content}
          {this.state.footer}
        </div>
      </div>
    )