import * as actionTypes from "./action-types"

// These are action creators
// http://redux.js.org/docs/basics/Actions.html#action-creators

export const toggleAbout = () => {
  return {
    type: actionTypes.TOGGLE_ABOUT,
  }
}

export const addEntity = (entityType, id, data) => {
  return {
    type: actionTypes.ADD_ENTITY,
    entityType,
    id,
    data,
  }
}
