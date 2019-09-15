import * as ActionTypes from '../consts/actionTypes';


export default (state = {}, action) => {    
    switch(action.type) {
        case ActionTypes.FILTER_PARAMS:
        return {
            ...state,                
            filter: action.filter
        }
    default:
        return state;
    }
};


