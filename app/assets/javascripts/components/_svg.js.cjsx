@Svg = React.createClass
  render: ->
    <svg className={@props.classname} width="100%" height="100%" viewBox={@props.viewbox} preserveAspectRatio={@props.preserveAspectRatio}>
      <g className={@props.group_classname}></g>
    </svg>