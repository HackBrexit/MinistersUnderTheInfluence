import immutableStorageDecorator from "./immutable-storage-decorator"
import {createStore, applyMiddleware} from "redux"
import thunkMiddleware from "redux-thunk"
import createLogger from 'redux-logger'
import {rootReducer, aboutReducer} from "./reducer"
import * as storage from "redux-storage"
import createEngine from "redux-storage-engine-localstorage"
import storageDebounce from 'redux-storage-decorator-debounce'

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

module.exports = {store, engine};
