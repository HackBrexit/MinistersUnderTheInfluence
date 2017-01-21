import * as actionTypes from "./action-types"

// example of a regular action
export const toggleAbout = () => {
  return {
    type: actionTypes.TOGGLE_ABOUT,
  }
}
