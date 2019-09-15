import * as ActionTypes from  '../consts/actionTypes';

export default (state = {}, action) => {
    switch (action.type) {
        case ActionTypes.MENU_DATA:
            return {
                ...state,
                menuData: action.menuData
            }
        default:
            return state;        
    }
}

