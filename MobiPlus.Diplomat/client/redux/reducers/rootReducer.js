import * as ActionTypes from '../consts/actionTypes';
import { combineReducers } from 'redux';
import { routerReducer as routing } from 'react-router-redux'
import { loadingBarReducer } from 'react-redux-loading-bar'
import  auth  from './authReducer';
import  dashboard  from './dashboardReducer';
import  local  from './localReducer';
import  reportGrid  from './reportGridReducer';
import  filterData from './cascadeReducer';
import  layoutData from './layoutReducer';
import  menuData from './menuReducer';
import filter from './filterReducer';
import tasks from './tasksReducer';
import mapData from './mapsReducer';

const rootReducer = combineReducers({
    dashboard,
    auth,
    local,
    routing,
    reportGrid,
    filterData,
    layoutData,
    menuData,
    filter,
    tasks,
    mapData,
    loadingBar: loadingBarReducer
});

const appReducer = (state, action) => {
    if (action.type === ActionTypes.LOGOUT_USER) {
        state = undefined;
    }

    return rootReducer(state, action);
}

export default rootReducer;