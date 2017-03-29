import React from "react"
import Radium from "radium"
import { Link } from 'react-router'

class OrgList extends React.Component {
  render () {
    return <div className="org-list">
      <p>
        Eventually this home page will allow you to choose from dynamic lists
        of organisations, people, government offices etc.
      </p>
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
      <p>
        Here are sample URLs you can use to visualize parts of the
        data set relating to a given organisation.  They assume that
        the organisation BAE Systems has id 369 in the database, that
        David Cameron has id 755, and that the FCO has id 437, so
        currently you will have to manually adjust the URLs to point
        to the right ids, but we'll hopefully fix that soon.
      </p>
      <ul>
        <li>
          <Link to="/organisation/369/government-people">
            See which ministers met with BAE Systems the most
          </Link>
        </li>
        <li>
          <Link to="/organisation/369/government-offices">
            See which government offices met with BAE Systems the most
          </Link>
        </li>
        <li>
          <Link to="/government-person/755/organisations">
            See which organisations met with David Cameron the most
          </Link>
        </li>
        <li>
          <Link to="/government-office/437/organisations">
            See which organisations met with the Foreign &amp; Commonwealth
            Office the most
          </Link>
        </li>
      </ul>
    </div>
  }
}

export default Radium(OrgList);
