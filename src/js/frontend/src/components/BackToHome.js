import React from "react"
import ReactDOM from "react-dom"
import Radium from "radium"
import { Link } from 'react-router'

const BackToHome = (props) =>
  <Link style={{float: "right"}} to="/">Back to home</Link>;

BackToHome.propTypes = {
  sourceName: React.PropTypes.string,
};

module.exports = Radium(BackToHome);
