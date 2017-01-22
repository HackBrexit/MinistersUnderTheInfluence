import React from "react"
import Radium from "radium"
import { Link } from 'react-router'

class OrgList extends React.Component {
  render () {
    return <div className="org-list">
      <p>Eventually this will be a dynamic list of organisations.</p>
      <ul>
        <li> <Link to="/demo">Hard-coded data (doesn't touch API)</Link> </li>
        <li> <Link to="/organisation/369/government-people">BAE</Link> </li>
      </ul>
    </div>
  }
}

export default Radium(OrgList);
