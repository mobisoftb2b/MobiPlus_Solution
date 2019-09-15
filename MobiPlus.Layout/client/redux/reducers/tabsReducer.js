import * as ActionTypes from '../consts/actionTypes';

export default (state= {}, action) => {
    switch (action.type) {
    case ActionTypes.TABS_DATA:
        return {
            ...state,
            tabsData:action.tabsData
        }
        default:
            return state;
    }

}
