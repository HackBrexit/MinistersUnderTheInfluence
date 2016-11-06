import React, { PropTypes } from "react"
import Radium from "radium"
import ImmutablePropTypes from "react-immutable-proptypes"
import pureRenderMixin from "react-addons-pure-render-mixin"

var Chart = require('./Chart');

export default Radium(React.createClass({

  displayName: "App",

  mixins: [pureRenderMixin],

  propTypes: {
  },

  getInitialState () {
    return {
      data: [
          {cx: 40, cy: 40, r: 15},
          {cx: 150, cy: 100, r: 40}
      ]
    };
  },

  render () {
    return <div>
      <Chart data={this.state.data} />
    </div>
  }
}))
