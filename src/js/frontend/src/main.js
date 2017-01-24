import React from "react"
import ReactDOM from "react-dom"
import App from "./app"
import {Router, Route, IndexRoute, hashHistory} from 'react-router'
import immutableStorageDecorator from "./Redux/immutable-storage-decorator"
import {createStore, applyMiddleware} from "redux"
import {Provider} from "react-redux"
import thunkMiddleware from "redux-thunk"
import {rootReducer, aboutReducer} from "./Redux/reducer"
import * as storage from "redux-storage"
import createEngine from "redux-storage-engine-localstorage"
import storageDebounce from 'redux-storage-decorator-debounce'
import createLogger from 'redux-logger'
import PageLayout from "./containers/PageLayout"
import Home from "./components/Home"
import ChartContainer from "./containers/ChartContainer"

////////////////////////////////////////////////////////////////////////////////
// redux stuff

// wrap our main reducer in a storage reducer - this intercepts LOAD actions and
// calls the merger function to merge in the new state
const reducer = storage.reducer(rootReducer, (oldState, newState) => newState)
// const reducer = aboutReducer;

// create a storage engine, with decorators to convert plain JS into Immutable
// and "debounce" storage so it's not happening all the time
const engine = storageDebounce(immutableStorageDecorator(createEngine("muti-frontend")), 2000)
// create storage middleware, which triggers a save action after every normal action
const storageMiddleware = storage.createMiddleware(engine)
// create logger middleware
const loggerMiddleware = createLogger({
  stateTransformer: (state) => state.toJS(),
  // you can filter out certain actions from logging
  //predicate: (getState, action) => action.type !== CALCULATION_NEEDS_REFRESH
})

// now create our redux store, applying all our middleware
// const store = createStore(reducer, applyMiddleware(
//   thunkMiddleware, // first, so function results get transformed
//   loggerMiddleware, // now log everything at this state
//   storageMiddleware // finally the storage middleware
// ))


const store = createStore(
  reducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

// now everything is set up, create a loader and use it to load the store
const load = storage.createLoader(engine)
const loaded = load(store)
loaded.then((newState) => {

  ////////////////////////////////////////////////////////////////////////////////
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
