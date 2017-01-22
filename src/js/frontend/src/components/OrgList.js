import React from "react"
import Radium from "radium"
import { Link } from 'react-router'

class OrgList extends React.Component {
  render () {
    return <div className="org-list">
      <p>Eventually this will be a dynamic list of organisations.</p>
      <ul>
        <li> <Link to="/organisation/369/meetings">BAE</Link> </li>
      </ul>
    </div>
  }
}

export default Radium(OrgList);
