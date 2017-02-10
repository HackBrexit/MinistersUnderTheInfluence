import React from "react"
import Radium from "radium"
import { connect } from 'react-redux';

import * as actions from "../Redux/actions"

class EntityListContainer extends React.Component {
  componentWillMount () {
  }

  render () {
    let entityType = this.props.route.entityType;

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
// 
// export default connect(mapStateToProps)(Radium(EntityListContainer));

export default Radium(EntityListContainer);

