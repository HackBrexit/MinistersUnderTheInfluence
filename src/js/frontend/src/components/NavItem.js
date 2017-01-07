import React from "react";
import Radium from "radium";

class NavItem extends React.Component{

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <a href="#"><li onClick={this.props.onClick} style={[
        styles.base,
      ]}>
        <img style={[
          styles.img,
        ]} height='30px' src={this.props.iconData} />
      </li></a>
    )
  }
}

var styles = {
  base: {
    display:'inline',
    padding:'15px 10px',
    margin: '7px',
    backgroundColor:'#119DA4',
    borderRadius: '50%',
  },
  img:{
    verticalAlign:'middle',
  }
};



export default Radium(NavItem);
