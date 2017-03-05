import {combineReducers} from "redux";
import * as actionTypes from "./action-types";
import {uiReducer} from "./reducers/uiReducer";
import {dataReducer} from "./reducers/dataReducer";

export const rootReducer = combineReducers({
  ui: uiReducer,
  data: dataReducer,
});
