import React, { PropTypes } from "react"
import Radium from "radium"
import ImmutablePropTypes from "react-immutable-proptypes"
import pureRenderMixin from "react-addons-pure-render-mixin"
import ChartContainer from 'ChartContainer'

export default Radium(React.createClass({

  displayName: "App",

  mixins: [pureRenderMixin],

  render () {
    return <div>
      <ChartContainer/>
    </div>
  }
}))
