import React from "react";
import Radium from "radium";
import { connect } from 'react-redux';
import Header from "../components/Header";
import About from "../components/About";
import { toggleAbout } from '../Redux/actions';

const HEADER_HEIGHT = 12;

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
        <Header height={HEADER_HEIGHT + "vh"} />
        <About shouldDisplay={this.props.showAboutScreen} closeFlyover={this._closeFlyover}/>
        <div id="app-content" style={[styles.main]}>
          {this.props.children}
        </div>
      </div>
    )
  }
}

let styles = {
  base: {
    height: "100vh",
    overflow: 'hidden',
  },
  main: {
    height: (100 - HEADER_HEIGHT) + "vh",
  },
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
