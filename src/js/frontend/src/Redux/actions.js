import * as actionTypes from "./action-types"

// example of a regular action
export const addMessage = (message) => {
  return {
    type: actionTypes.ADD_MESSAGE,
    payload: message
  }
}

// example of a thunk action
export const addMessageAsync = (message) => (dispatch) => {
  setTimeout(() => {
    dispatch(addMessage(message))
  }, 1000)
}
