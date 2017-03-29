import {fromJS} from "immutable";
import {TOGGLE_ABOUT} from "../action-types";

const initialState = fromJS({
  showAboutScreen: false
});

export const uiReducer = (state = initialState, {type}) => {
  switch (type) {
    case TOGGLE_ABOUT:
      return state.set('showAboutScreen', !state.get('showAboutScreen'));
    default:
      return state;
  }
}
