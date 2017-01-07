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
        <h1>Hack Brexit Open Source Accelerator</h1>
          <p>Join the Hack Brexit fortnightly Wednesday meetup group <a href="https://www.meetup.com/Hack-Brexit/" target="_blank">here</a></p>
          <p>Join the Hack Brexit slack group <a href="https://hackbrexit.herokuapp.com/" target="_blank">here</a></p>
        <h2>What is the accelerator all about?</h2>
        <ul>
          <li>A three month programme that takes 2 of the 10 projects created during Hack Brexit weekend.</li>
          <li>Run regular monthly meetings for the teams to present and discuss their projects progress, hosted by ThoughtWorks London.</li>
          <li>Help source additional volunteers to work with the teams on the projects.</li>
          <li>The organising committee will be on hand to provide planning and process assistance over the whole 3 months, and tap into expertise from ThoughtWorks and Code First: Girls community.</li>
          <li>The organising committee will manage external communications for the open source accelerator to help spread the word.</li>
          <li>At the end of 3 months we will run a final external presentation event with external attendees, we will analyse the progress and development of the project along with its future potential for continuing to grow.</li>
          <li>Connect the team members to the wider Hack Brexit meetup community.</li>
        </ul>
        <h2>Why are we doing this?</h2>
        <p>We want to continue from the success of the Hack Brexit hackathon on the 23-4 July to bring together technical and non-technical people to create tech solutions to drive dialog, unity and positive action beyond Brexit. We want to sustainably support and scale up projects that have a clear positive impact on society and respond to one of the three key themes we chose for the weekend:</p>
        <ol>
          <li>Truth, fiction, & accountability;</li>
          <li>Tolerance & prejudice;</li>
          <li>Effective organising & campaigning.</li>
        </ol>
        <h2>T&Cs for accelerator projects</h2>
        <ul>
          <li>An open source project publicly available & accessible to all.</li>
          <li>Projects are created in a repository under the Hack Brexit public repository with an MIT License.</li>
          <li>Projects have an IP that is open to all & can be used by anyone.</li>
          <li>Projects speak to one of the three key themes identified at the Hack (Truth, Fiction & Accountability; Tolerance & prejudice; Effective organising & campaigning) or a future theme as agreed by the community.</li>
          <li>Commitment to work with a group of volunteers on the project for a duration of 3 months.</li>
          <li>Work alongside your project team volunteers & the Hack Brexit organisers to plan the outcomes for at least 3 months.</li>
          <li>Be a project that has scope to continue to be worked on by others in the future.</li>
        </ul>
        <h2>Meetup agenda</h2>
        <p>"Fortnightly meeting for the teams within Hack Brexit's accelerator programme to present and discuss their progress. We've taken forward two of the projects from July's hackathon to participate in our open-source accelerator programme:"</p>
        <ul>
          <li><p>What the fact <a href="https://github.com/HackBrexit/WhatTheFact/wiki/Accelerator---1st-Meetup----MVP-discussion" target="_blank"> read the wiki here</a></p></li>

          <li><p>Ministers under the influence <a href="https://github.com/HackBrexit/MinistersUnderTheInfluence/wiki/Accelerator-1st-Meetup-MVP-discussion" target="_blank"> read the wiki here</a></p></li>
        </ul>

        <p>We look forward to seeing you there!
          <br>
        </br>
        <span>Hack Brexit Team</span>
        </p>
        </div>
      </div>
    )
  }
}

var styles = {
  aboutContainer: {
    height:'87vh',
    position: 'fixed',
    padding: '15px',
    transition: '0.5s ease all',
    // backgroundColor: '#999',
  },

  aboutContent: {
    height:'90%',
    overflowY: 'scroll',
    padding: '20px',
    backgroundColor: 'white',
    borderRadius:'10px',
    WebkitBoxShadow: '0px 0px 20px 8px rgba(0,0,0,0.3)',
    MozBoxShadow: '0px 0px 20px 8px rgba(0,0,0,0.3)',
    boxShadow: '0px 0px 20px 8px rgba(0,0,0,0.3)',
  }
};

export default Radium(About);
