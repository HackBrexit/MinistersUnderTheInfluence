import React from "react"
import Radium from "radium"
import { connect } from 'react-redux';

import * as actions from "../Redux/actions"
import entityData from "../lib/entityData"

class EntityListContainer extends React.Component {
  componentWillMount () {
    this.props.fetchEntities(this.props.route.entityType);
  }

  render () {
    let entityType = this.props.route.entityType;

    if (! entityData.isValidType(entityType)) {
      return <div className="error">
        Invalid entity type {entityType}.
        Must be one of: {entityData.validTypes.join(", ")}
      </div>
    }

    return <div className="entity-list">
      List of {entityType} entities
    </div>
  }
}

// const mapStateToProps = (state) => {
//   return {
//     entities: state.get("entities"),
//   };
// };

const mapDispatchToProps = (dispatch) => {
  return {
    fetchEntities: (entityType) => {
      dispatch(actions.fetchEntities(entityType));
    }
  }
}

export default connect(null, mapDispatchToProps)(Radium(EntityListContainer));

