import * as actionTypes from "./action-types"

// These are action creators
// http://redux.js.org/docs/basics/Actions.html#action-creators

export const toggleAbout = () => {
  return {
    type: actionTypes.TOGGLE_ABOUT,
  }
}
