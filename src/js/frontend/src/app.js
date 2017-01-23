import React, { PropTypes } from "react"
import Radium from "radium"
import ImmutablePropTypes from "react-immutable-proptypes"
import pureRenderMixin from "react-addons-pure-render-mixin"
import PageLayout from './containers/PageLayout'

export default React.createClass({

  displayName: "App",

  mixins: [pureRenderMixin],

  render () {
    return this.props.children;
  }
})
