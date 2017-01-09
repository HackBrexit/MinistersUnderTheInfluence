import React from "react";
import Radium from "radium";
import NavItem from './NavItem';

class About extends React.Component{

  constructor(props) {
    super(props)
  }

  render() {
    const aboutContainerClass = this.props.shouldDisplay ? '' : 'hiddenFlyover' ;

    return (
      <div className={aboutContainerClass}
      style={[
        styles.aboutContainer,
      ]}>
        <div style={[
          styles.aboutContent,
        ]}>
        <a href='#' onClick={this.props.closeFlyover}><img style={[styles.close]}src={closeAboutData}/></a>
        <h1>What is Ministers Under the Influence?</h1>
          <p>The aim of Ministers: Under the Influence is to unearth public-but-obscure information about who ministers are meeting. By making this data more accessible we can hope to better hold our government to account. We hope this will feed into a wider project about tracking who is influencing our elected politicians.</p>
          <p>Ministers: Under the Influence is a project that came out of the <a href="http://www.HackBrexit.org" target="_blank">#HackBrexit</a> Hackathon which took place over a weekend. The project has now been pushed into the Hack Brexit accelerator programme and will be developed further over the next few months.</p>
          <h2>Hackathon History</h2>
          <p>During the hackathon the team at Unlock Democracy was in attendance and presented their work to the attendees. They also challenged us to find a solution to the problem of obscure ministerial data and Ministers Under the Influence was born, influenced by the Under the Influence project.</p>

        <h1>Hack Brexit Open Source Accelerator</h1>
          <p>Join the Hack Brexit fortnightly Wednesday meetup group <a href="https://www.meetup.com/Hack-Brexit/" target="_blank">here</a></p>
          <p>Join the Hack Brexit slack group <a href="https://hackbrexit.herokuapp.com/" target="_blank">here</a></p>
        <h2>What is the accelerator all about?</h2>
        <p>
          The accelerator is a three month programme that takes 2 of the 10 projects created during Hack Brexit weekend to push them to the next level The goal is to run regular monthly meetings for the teams to present and discuss their projects progress, hosted by <a href="https://www.thoughtworks.com/locations/london" target="_blank">ThoughtWorks London.</a> During this period we help source additional volunteers to work with the teams on the projects and connect the team members to the wider Hack Brexit meetup community.
        </p>
        <h2>Why are we doing this?</h2>
        <p>We want to continue from the success of the <a href="http://www.HackBrexit.org" target="_blank">Hack Brexit</a> hackathon on the 23-4 July to bring together technical and non-technical people to create tech solutions to drive dialog, unity and positive action beyond Brexit. We want to sustainably support and scale up projects that have a clear positive impact on society and respond to one of the three key themes we chose for the weekend:
        <ol>
          <li>Truth, fiction, & accountability;</li>
          <li>Tolerance & prejudice;</li>
          <li>Effective organising & campaigning.</li>
        </ol></p>

        </div>
      </div>
    )
  }
}

var closeAboutData = "data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTYuMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgd2lkdGg9IjMycHgiIGhlaWdodD0iMzJweCIgdmlld0JveD0iMCAwIDM0OC4zMzMgMzQ4LjMzNCIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMzQ4LjMzMyAzNDguMzM0OyIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+CjxnPgoJPHBhdGggZD0iTTMzNi41NTksNjguNjExTDIzMS4wMTYsMTc0LjE2NWwxMDUuNTQzLDEwNS41NDljMTUuNjk5LDE1LjcwNSwxNS42OTksNDEuMTQ1LDAsNTYuODUgICBjLTcuODQ0LDcuODQ0LTE4LjEyOCwxMS43NjktMjguNDA3LDExLjc2OWMtMTAuMjk2LDAtMjAuNTgxLTMuOTE5LTI4LjQxOS0xMS43NjlMMTc0LjE2NywyMzEuMDAzTDY4LjYwOSwzMzYuNTYzICAgYy03Ljg0Myw3Ljg0NC0xOC4xMjgsMTEuNzY5LTI4LjQxNiwxMS43NjljLTEwLjI4NSwwLTIwLjU2My0zLjkxOS0yOC40MTMtMTEuNzY5Yy0xNS42OTktMTUuNjk4LTE1LjY5OS00MS4xMzksMC01Ni44NSAgIGwxMDUuNTQtMTA1LjU0OUwxMS43NzQsNjguNjExYy0xNS42OTktMTUuNjk5LTE1LjY5OS00MS4xNDUsMC01Ni44NDRjMTUuNjk2LTE1LjY4Nyw0MS4xMjctMTUuNjg3LDU2LjgyOSwwbDEwNS41NjMsMTA1LjU1NCAgIEwyNzkuNzIxLDExLjc2N2MxNS43MDUtMTUuNjg3LDQxLjEzOS0xNS42ODcsNTYuODMyLDBDMzUyLjI1OCwyNy40NjYsMzUyLjI1OCw1Mi45MTIsMzM2LjU1OSw2OC42MTF6IiBmaWxsPSIjMDAwMDAwIi8+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPGc+CjwvZz4KPC9zdmc+Cg=="

var styles = {
  aboutContainer: {
    height:'83vh',
    position: 'fixed',
    padding: '15px',
    transition: '0.5s ease all',
    // backgroundColor: '#999',
  },

  aboutContent: {
    position: 'relative',
    height:'100%',
    overflowY: 'scroll',
    padding: '0 20px',
    backgroundColor: 'white',
    borderRadius:'3px',
    WebkitBoxShadow: '0px 0px 20px 8px rgba(0,0,0,0.3)',
    MozBoxShadow: '0px 0px 20px 8px rgba(0,0,0,0.3)',
    boxShadow: '0px 0px 20px 8px rgba(0,0,0,0.3)',
  },

  close: {
    height: '20px',
    position: 'absolute',
    top: '10px',
    right: '10px',
  }
};

export default Radium(About);
