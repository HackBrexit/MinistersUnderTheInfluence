import React from "react"
import ReactDOM from "react-dom"
import {Provider} from "react-redux"
import {Router, Route, IndexRoute, hashHistory} from 'react-router'
import * as storage from "redux-storage"

import {store, engine} from "./Redux/store"
import App from "./app"
import PageLayout from "./containers/PageLayout"
import Home from "./components/Home"
import ChartContainer from "./containers/ChartContainer"

// now everything is set up, create a loader and use it to load the store
const load = storage.createLoader(engine)
const loaded = load(store)
loaded.then((newState) => {

  // render a router into the page

  ReactDOM.render(
    <Provider store={store}>
      <Router history={hashHistory}>
        <Route path="/" component={App} name="root">
          <Route component={PageLayout}>
            <IndexRoute component={Home} />
            <Route path="demo"
                   component={ChartContainer} sourceType="demo" />
            <Route path="organisation/:id/:targetType"
                   component={ChartContainer} sourceType="organisations" />
            <Route path="government-office/:id/:targetType"
                   component={ChartContainer} sourceType="government-offices" />
            <Route path="government-person/:id/:targetType"
                   component={ChartContainer} sourceType="people" />
            <Route path="organisation-person/:id/:targetType"
                   component={ChartContainer} sourceType="people" />
          </Route>
        </Route>
      </Router>
    </Provider>,
    document.getElementById("app")
  );
})
