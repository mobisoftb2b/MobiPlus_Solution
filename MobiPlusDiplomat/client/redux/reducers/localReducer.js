import * as ActionTypes from '../consts/actionTypes';

export default (state = {}, action) => {
    switch(action.type) {
        case ActionTypes.SET_LOCAL:
            return action.local;
        default:
            return state;
    }
};


