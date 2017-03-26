import React from "react"
import Radium from "radium"
import { connect } from 'react-redux';

import * as actions from "../Redux/actions"
import entityData from "../lib/entityData"
import EntityList from "../components/EntityList"

class EntityListContainer extends React.Component {
  componentWillMount () {
    if (!this.props.fetched) {
      this.props.fetchEntities(this.props.route.entityType);
    }
  }

  render () {
    let entityType = this.props.route.entityType;

    if (! entityData.isValidType(entityType)) {
      return <div className="error">
        Invalid entity type {entityType}.
        Must be one of: {entityData.validTypes.join(", ")}
      </div>
    }

    return <div className="entity-list" style={[styles["entity-list"]]}>
      <EntityList
        entityType={entityType}
        fetching={this.props.fetching}
        fetched={this.props.fetched}
        entitiesById={this.props.entitiesById} />
    </div>
  }
}

const mapStateToProps = (state, ownProps) => {
  let entities = state.data.getIn(["entities", ownProps.route.entityType]);
  return {
    fetching: entities.get("fetching"),
    fetched: entities.get("fetched"),
    entitiesById: entities.get("byId"),
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    fetchEntities: (entityType) => {
      dispatch(actions.fetchEntities(entityType));
    }
  }
}

let styles = {
  "entity-list": {
    overflowY: "auto",
    height: "100%",
  }
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Radium(EntityListContainer));

