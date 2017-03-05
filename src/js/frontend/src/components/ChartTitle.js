import React from "react"
import ReactDOM from "react-dom"
import Radium from "radium"
import { Link } from 'react-router'

function ChartTitle (props) {
  let description = props.sourceName ?
      <p style={{width: "50%", display: "inline"}}>
        Showing all meetings of {props.targetType} with {props.sourceName}
      </p>
    : "";

  return (
    <div>
      {description}
      <Link style={{float: "right"}} to="/">Back to home</Link>
    </div>
  )
}

ChartTitle.propTypes = {
  sourceName: React.PropTypes.string,
};

module.exports = Radium(ChartTitle);
