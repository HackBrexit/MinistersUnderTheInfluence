import React from "react"
import Radium from "radium"
import { Link } from "react-router"

import * as sorters from "../lib/sorters"

// This is a truly horrible UI design, but good enough for testing.
const TEMPLATES = {
  organisations: (id) =>
    <span>
      government {" "}
      <Link to={`/organisation/${id}/government-offices`}>offices</Link>
      {" "} and {" "}
      <Link to={`/organisation/${id}/government-people`}>people</Link>
    </span>,
  people: (id) =>
    <span>
      <Link to={`/person/${id}/government-offices`}>government offices</Link>
      {" "} and {" "}
      <Link to={`/person/${id}/government-people`}>their people</Link>,
      {" "} and {" "}
      <Link to={`/person/${id}/organisations`}>organisations</Link>
      {" "} and {" "}
      <Link to={`/person/${id}/organisation-people`}>their people</Link>
    </span>,
  "government-offices": (id) =>
    <span>
      <Link to={`/government-office/${id}/organisations`}>organisations</Link>
      {" "} and {" "}
      <Link to={`/government-office/${id}/organisation-people`}>their people</Link>
    </span>
};

function EntityList (props) {
  if (props.fetching) {
    return <p>Still fetching list of {props.entityType} ...</p>;
  }

  if (!props.fetched) {
    return <p>Didn't fetch list of {props.entityType} yet</p>;  // '
  }

  let sortedEntities = props.entitiesById.sortBy(data => data.get("name"));

  let template = TEMPLATES[props.entityType];
  let listItems = sortedEntities.map((data, id) =>
    <li key={id}>
      {data.get("name")} - meetings with {template(id)}
    </li>
  ).toArray();

  return (
    <ul>
      {listItems}
    </ul>
  )
}

EntityList.propTypes = {
  entityType: React.PropTypes.string.isRequired,
  fetching: React.PropTypes.bool.isRequired,
  fetched: React.PropTypes.bool.isRequired,
  entitiesById: React.PropTypes.object.isRequired,
};

module.exports = Radium(EntityList);
