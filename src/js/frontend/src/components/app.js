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
          {entity: "Lobbyists-are-us", meetingCount: 10},
          {entity: "Defenders of freendome", meetingCount: 2}
      ]
    };
  },

  render () {
    return <div>
      <Chart data={this.state.data} />
    </div>
  }
}))
