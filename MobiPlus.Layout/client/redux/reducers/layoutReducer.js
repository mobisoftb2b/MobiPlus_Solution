import * as ActionTypes from '../consts/actionTypes';

export default (state = {}, action) => {
    switch(action.type) {
        case ActionTypes.LAYOUT_DATA:
            return {
                ...state,
                layoutData: action.layout
            }
        default:
            return state;
    }
};


