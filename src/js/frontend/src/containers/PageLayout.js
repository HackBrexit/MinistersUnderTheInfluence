import React from "react";
import Radium from "radium";
import { connect } from 'react-redux';
import ChartContainer from "./ChartContainer";
import Header from "../components/Header";
import About from "../components/About"

class PageLayout extends React.Component {
  constructor(props) {
    super(props);
  }

  render () {
    return (
      <div
      style={[
        styles.base,
      ]}
      className="app-container">
        <Header />
        <About shouldDisplay={this.props.showAboutScreen} />
        <ChartContainer/>
      </div>
    )
  }
}

var styles = {
  base: {
    height:"100vh",
    overflow: 'hidden',
  }
}

const mapStateToProps = (state) => {
    return {
        showAboutScreen: state.showAboutScreen,
    };
};

export default connect(mapStateToProps, null)(Radium(PageLayout));
