import * as ActionTypes from '../consts/actionTypes';

export default (state = {}, action) => {    
    switch(action.type) {
        case ActionTypes.LOGIN_USER_SUCCESS:
            return {
                ...state,                
                user: action.user
            }
        default:
            return state;
    }
};
