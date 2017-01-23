import React from "react";
import Radium from "radium";

class NavItem extends React.Component{

  constructor(props) {
    super(props)
  }

  render() {
    const target = this.props.newTab ? "_blank" : '';
    return (
      <li key={this.props.href} style={[
        styles.li,
      ]}>
        <a style={[
          styles.a,
        ]}
        target={target}
        onClick={this.props.onClick}
        href={this.props.href}>
          <img style={[
            styles.img,
          ]} src={this.props.iconData} />
        </a>
      </li>

    )
  }
}

let styles = {
  li: {
    display:'block',
    margin: '4vh 7px 0 0',
    float:'left',
    borderRadius: '50%',
    transition: 'all 0.05s linear',

    ':hover': {
      margin: '3.5vh 7px 0 0',
    },
  },
  a: {
    padding:'15px 11px',
    backgroundColor:'rgb(68, 196, 211)',
    borderRadius: '50%',
    transition: 'all 0.05s linear',
    boxShadow: '#119DA4 0 0 0 0',

    ':hover': {
      boxShadow: '#119DA4 0 0.5vh 0 0',
    },
  },
  img:{
    height:'30px',
    verticalAlign:'middle',
  }
};

export default Radium(NavItem);
