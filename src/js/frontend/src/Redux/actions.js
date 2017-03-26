import * as actionTypes from "./action-types"
import entityData from "../lib/entityData"

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
    meta: { entityType },
    id,
    data,
  }
}

export const fetchEntities = (entityType) => {
  const request = entityData.fetchEntitiesRequest(entityType);

  // When dispatched, redux-promise-middleware will handle this and
  // magically dispatch FETCH_ENTITIES_{PENDING,FULFILLED,REJECTED}
  // actions according to the 3 possible stages of the conversation
  // with the API endpoint.
  return {
    type: actionTypes.FETCH_ENTITIES,
    meta: { entityType },
    payload: request
  }
}
