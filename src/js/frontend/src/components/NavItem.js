import React from "react";
import Radium from "radium";

class NavItem extends React.Component{

  constructor(props) {
    super(props)
  }

  render() {
    const target = this.props.newTab ? "_blank" : '';
    return (
      <a target={target}
      onClick={this.props.onClick}
      href={this.props.href}><li style={[
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
    padding:'15px 11px',
    margin: '7px',
    backgroundColor:'rgb(68, 196, 211)',
    borderRadius: '50%',
    transition: 'all 0.05s linear',

    ':hover': {
      backgroundColor: '#119DA4'
    },
  },
  img:{
    verticalAlign:'middle',
  }
};

export default Radium(NavItem);
