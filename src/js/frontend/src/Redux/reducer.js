import {Map as IMap, List as IList} from "immutable";
import * as actionTypes from "./action-types";

////////////////////////////////////////////////////////////////////////////////
// root reducer

export function rootReducer (state = IMap(), action) {
  return state.merge({
    showAboutScreen: aboutReducer(state.get("showAboutScreen", undefined), action),
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

export function aboutReducer(state = defaultState, {type}) {
  let newState = Object.assign({}, state);

  switch (type) {
    case actionTypes.TOGGLE_ABOUT:
      newState.showAboutScreen = !newState.showAboutScreen;
      return newState;
    default:
      return newState;
  }
}
