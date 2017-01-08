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
        <h1>What is Ministers Under the Influence?</h1>
          <p>The aim of Ministers: Under the Influence is to unearth public-but-obscure information about who ministers are meeting. By making this data more accessible we can hope to better hold our government to account. We hope this will feed into a wider project about tracking who is influencing our elected politicians.</p>
          <p>Ministers: Under the Influence is a project that came out of the <a href="http://www.HackBrexit.org" target="_blank">#HackBrexit</a> Hackathon which took place over a weekend. The project has now been pushed into the Hack Brexit accelerator programme and will be developed further over the next few months.</p>
          <h2>Hackathon History</h2>
          <p>During the hackathon the team at Unlock Democracy was in attendance and presented their work to the attendees. They also challenged us to find a solution to the problem of obscure ministerial data and Ministers Under the Influence was born, influenced by the Under the Influence project.</p>
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
