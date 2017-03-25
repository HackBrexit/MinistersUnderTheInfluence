import React from "react"
import Radium from "radium"
import { Link } from 'react-router'

class Home extends React.Component {
  render () {
    return <div className="home">
      <ul>
        <li>
          <Link to="/demo">
            Visualize hard-coded fake data (doesn't touch the
            API, so useful for testing / demoing / developing the frontend)
          </Link> 
        </li>
      </ul>
      <ul>
        <li>
          <Link to="/organisations">
            See all organisations
          </Link>
        </li>
        <li>
          <Link to="/government-offices">
            See all government offices
          </Link>
        </li>
        <li>
          <Link to="/people">
            See all people
          </Link>
        </li>
      </ul>
    </div>
  }
}

export default Radium(Home);
