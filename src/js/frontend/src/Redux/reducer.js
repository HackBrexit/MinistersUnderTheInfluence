import {Map as IMap, List as IList} from "immutable";
import * as actionTypes from "./action-types";

////////////////////////////////////////////////////////////////////////////////
// root reducer

// FIXME: switch to use combineReducers?
// http://redux.js.org/docs/api/combineReducers.html

export function rootReducer (state = IMap(), action) {
  return state.merge({
    showAboutScreen: aboutReducer(state.get("showAboutScreen", undefined),
                                  action),
  })
  return state;
}

////////////////////////////////////////////////////////////////////////////////
// accountsy stuff

// const defaultState = IMap({
//   showAboutScreen: false,
// });

const defaultState = {
  showAboutScreen: false,
};

export function aboutReducer(state = defaultState.showAboutScreen, {type}) {
  switch (type) {
    case actionTypes.TOGGLE_ABOUT:
      return !state;
    default:
      return state;
  }
}
