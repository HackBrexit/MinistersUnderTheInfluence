import React from "react"
import Radium from "radium"
import { Link } from 'react-router'

import BackToHome from './BackToHome'

function ChartTitle (props) {
  let description = props.sourceName && props.targetType ?
      <p style={{width: "50%", display: "inline"}}>
        Showing all meetings of {
          props.targetType.replace('-', ' ')
        } with {props.sourceName}
      </p>
    : "";

  return (
    <div>
      {description}
      <BackToHome />
    </div>
  )
}

ChartTitle.propTypes = {
  sourceName: React.PropTypes.string,
};

module.exports = Radium(ChartTitle);
