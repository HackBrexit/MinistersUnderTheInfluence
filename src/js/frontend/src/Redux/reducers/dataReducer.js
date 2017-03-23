import {fromJS, Map} from "immutable";

import * as actionTypes from "../action-types";
import entityData from "../../lib/entityData"

const initialEntityState = {
  fetching: false,  // We can show a spinner if this is true
  fetched: false,   // We can show an entity list if this is true
  byId: {},
};

const initialEntitiesState = entityData.validTypes.reduce(
  (obj, type) => {
    obj[type] = initialEntityState;
    return obj;
  },
  {}
);

const initialState = fromJS({
  entities: initialEntitiesState
});

export const dataReducer = (state = initialState, action) => {
  switch (action.type) {
    case actionTypes.ADD_ENTITY:
      return state.setIn(
        ["entities", action.entityType, "byId", action.id],
        fromJS(action.data)
      );

    case actionTypes.FETCH_ENTITIES_PENDING:
      return state.setIn(
        ["entities", action.meta.entityType, "fetching"],
        true,
      );

    case actionTypes.FETCH_ENTITIES_FULFILLED:
      let newState = state.setIn(
        ["entities", action.meta.entityType],
        Map({fetching: false, fetched: true})
      );

      return newState.mergeIn(
        ['entities', action.meta.entityType, 'byId'],
        action.payload.data.data.reduce(
          (obj, entity) => {
            obj[entity.id] = entity.attributes;
            return obj
          },
          {}
        )
      );

    case actionTypes.FETCH_ENTITIES_REJECTED:
      return state.setIn(
        ["entities", action.meta.entityType, "fetching"],
        false,
      );

    default:
      return state;
  }
}
