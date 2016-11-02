import {Map as IMap, List as IList} from "immutable";
import * as actionTypes from "./action-types";

////////////////////////////////////////////////////////////////////////////////
// root reducer

export function rootReducer (state = IMap(), action) {
  return state.merge({
    messages: messagesReducer(state.get("messages", undefined), action),
  })
}

////////////////////////////////////////////////////////////////////////////////
// accountsy stuff

const defaultMessageListState = IList()

function messagesReducer (state = defaultMessageListState, {type, payload}) {
  switch (type) {
    case actionTypes.ADD_MESSAGE:
      return state.push(payload)
    default:
      return state
  }
}
