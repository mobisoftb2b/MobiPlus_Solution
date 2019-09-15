import * as ActionTypes from '../consts/actionTypes';
import { combineReducers } from 'redux';
import { routerReducer as routing } from 'react-router-redux'


const dashboard = (state = {}, action) => {
    switch(action.type) {
        case ActionTypes.SET_TITLE:
            return {
                ...state,
                    title: state.title + ' - ' + action.title
    }
        default:
            return state;
}
};

const user = (state = {}, action) => {
    switch(action.type) {
        case ActionTypes.SET_USER:
            return {
                ...state,
                    current: action.user
    }
        default:
            return state;
}
};

const rootReducer = combineReducers({
    dashboard,
    user,
    routing
});

export default rootReducer;