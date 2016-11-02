import React, { PropTypes } from "react"
import Radium from "radium"
import ImmutablePropTypes from "react-immutable-proptypes"
import pureRenderMixin from "react-addons-pure-render-mixin"

export default Radium(React.createClass({

  displayName: "App",

  mixins: [pureRenderMixin],

  propTypes: {
  },

  getInitialState () {
    return {text: ""}
  },

  onInputChange (event) {
    this.setState({text: event.target.value})
  },

  onButtonClick (event) {
    this.setState({text: ""})
  },

  render () {
    return <div>
        <input value={this.state.text} onChange={this.onInputChange} />
        <button onClick={this.onButtonClick}>Add</button>
    </div>
  }
}))
