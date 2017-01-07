import React from "react";
import NavItem from '../components/NavItem';
import { connect } from 'react-redux';
import { toggleAbout } from '../Redux/actions';

class HelpButton extends React.Component{

  constructor(props) {
    super(props)

    this._handleClick = this._handleClick.bind(this);
  }

  _handleClick(){
    this.props.toggleAbout();
  }

  render() {
    return (
      <NavItem iconData={questionMarkData} onClick={this._handleClick}/>
    )
  }
}

var styles = {
  base: {
    lineHeight:"12vh",
    float: 'right'
  },
};

var questionMarkData = "data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTYuMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgd2lkdGg9IjY0cHgiIGhlaWdodD0iNjRweCIgdmlld0JveD0iMCAwIDMxLjM1NyAzMS4zNTciIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDMxLjM1NyAzMS4zNTc7IiB4bWw6c3BhY2U9InByZXNlcnZlIj4KPGc+Cgk8cGF0aCBkPSJNMTUuMjU1LDBjNS40MjQsMCwxMC43NjQsMi40OTgsMTAuNzY0LDguNDczYzAsNS41MS02LjMxNCw3LjYyOS03LjY3LDkuNjJjLTEuMDE4LDEuNDgxLTAuNjc4LDMuNTYyLTMuNDc1LDMuNTYyICAgYy0xLjgyMiwwLTIuNzEyLTEuNDgyLTIuNzEyLTIuODM4YzAtNS4wNDYsNy40MTQtNi4xODgsNy40MTQtMTAuMzQzYzAtMi4yODctMS41MjItMy42NDMtNC4wNjYtMy42NDMgICBjLTUuNDI0LDAtMy4zMDYsNS41OTItNy40MTQsNS41OTJjLTEuNDgzLDAtMi43NTYtMC44OS0yLjc1Ni0yLjU4NEM1LjMzOSwzLjY4MywxMC4wODQsMCwxNS4yNTUsMHogTTE1LjA0NCwyNC40MDYgICBjMS45MDQsMCwzLjQ3NSwxLjU2NiwzLjQ3NSwzLjQ3NmMwLDEuOTEtMS41NjgsMy40NzYtMy40NzUsMy40NzZjLTEuOTA3LDAtMy40NzYtMS41NjQtMy40NzYtMy40NzYgICBDMTEuNTY4LDI1Ljk3MywxMy4xMzcsMjQuNDA2LDE1LjA0NCwyNC40MDZ6IiBmaWxsPSIjRkZGRkZGIi8+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPC9zdmc+Cg==";

const mapDispatchToProps = (dispatch) => {
  return {
    toggleAbout: () => {
      dispatch(toggleAbout())
    }
  }
}

export default connect(null, mapDispatchToProps)(HelpButton);
