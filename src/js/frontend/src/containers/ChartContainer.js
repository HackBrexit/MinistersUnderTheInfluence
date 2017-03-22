import React from "react"
import Radium from "radium"
import { connect } from 'react-redux';

import ChartTitle from "../components/ChartTitle"
import Chart from "../components/Chart"
import entityData from "../lib/entityData"
import * as actions from "../Redux/actions"

class ChartContainer extends React.Component {
  componentWillMount () {
    if (this.props.route.sourceType !== "demo") {
      this.getEntityName()
    }
  }

  render () {
    let sourceType = this.props.route.sourceType;
    let targetType = this.props.params.targetType;
    let id = this.props.params.id;
    let entities = this.props.entities; // comes in via mapStateToProps
    let sourceData = entities && entities.get(sourceType);
    let entityData = sourceData && sourceData.get(id);
    let entityName = entityData && entityData.get("name");

    return <div className="chart-container">
      <ChartTitle sourceName={entityName}
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

const mapStateToProps = ({ data }) => {
  return {
    entities: data.get('entities'),
  };
};

export default connect(mapStateToProps)(Radium(ChartContainer));

