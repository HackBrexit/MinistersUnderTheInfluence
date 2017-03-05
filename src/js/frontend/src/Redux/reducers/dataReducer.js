import {fromJS} from "immutable";
import {ADD_ENTITY} from "../action-types";

const initialState = fromJS({
  entities: {
    people: {},
    organisations: {},
    "government-offices": {},
  },
});

export const dataReducer = (state = initialState, action) => {
  let {type, entityType, id, data} = action;

  switch (type) {
    case ADD_ENTITY:
      if (!state.has(entityType)) {
        console.error(`Received ADD_ENTITY action with invalid entity type ${entityType}`);
        return state;
      }
      return state.mergeDeep({
        [entityType]: {
          [id]: data
        },
      });
    default:
      return state;

  }
}
