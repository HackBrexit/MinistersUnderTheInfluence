import React from "react";
import Radium from "radium";
import { connect } from 'react-redux';
import ChartContainer from "./ChartContainer";
import Header from "../components/Header";
import About from "../components/About";
import { toggleAbout } from '../Redux/actions';


class PageLayout extends React.Component {
  constructor(props) {
    super(props);

    this._closeFlyover = this._closeFlyover.bind(this);
  }

  _closeFlyover() {
    this.props.toggleAbout();
  }

  render () {
    return (
      <div
      style={[
        styles.base,
      ]}
      className="app-container">
        <Header />
        <About shouldDisplay={this.props.showAboutScreen} closeFlyover={this._closeFlyover}/>
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

const mapDispatchToProps = (dispatch) => {
  return {
    toggleAbout: () => {
      dispatch(toggleAbout())
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Radium(PageLayout));
