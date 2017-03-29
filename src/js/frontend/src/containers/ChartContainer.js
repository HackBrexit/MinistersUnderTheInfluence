import React from "react"
import Radium from "radium"
import { connect } from 'react-redux';

import ChartTitle from "../components/ChartTitle"
import Chart from "../components/Chart"
import entityData from "../lib/entityData"
import * as actions from "../Redux/actions"

class ChartContainer extends React.Component {
  componentWillMount () {
    if (this.props.route.sourceType !== "demo" && !this.props.entityName) {
      this.getEntityName()
    }
  }

  render () {
    // This comes from the <Route> element in main.js
    let sourceType = this.props.route.sourceType;

    let targetType = this.props.params.targetType;
    let id = this.props.params.id;

    return <div className="chart-container">
      <ChartTitle sourceName={this.props.entityName}
                  targetType={targetType} />
      <Chart width="100%" height="100%"
             sourceType={sourceType}
             sourceId={id}
             targetType={targetType} />
    </div>
  }

  getEntityName () {
    entityData.fetch(
      this.props.route.sourceType,
      this.props.params.id,
      (json) => {
        let action = actions.addEntity(
          this.props.route.sourceType,
          this.props.params.id,
          json.data.attributes
        );
        this.props.dispatch(action);
      }
    )
  }
}

const mapStateToProps = (state, ownProps) => {
  if (ownProps.route.sourceType === "demo") {
    return { entityName: "demo" };
  }

  let entities = state.data.getIn(["entities", ownProps.route.sourceType]);
  let entity = entities.getIn(["byId", ownProps.params.id]);
  return {
    entityName: entity && entity.get("name"),
  };
};

export default connect(mapStateToProps)(Radium(ChartContainer));

