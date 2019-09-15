import * as ActionTypes from '../consts/actionTypes';

export default (state = {}, action) => {
    switch(action.type) {         
        case ActionTypes.COUNTRY_DATA:
            return {
                ...state,
                countryData: action.countryData
            }
        case ActionTypes.DISTRIBUTION_DATA:
            return {
                ...state,
                distrData: action.distrData
            }
        case ActionTypes.DRIVER_DATE:
            return {
                ...state,
                driverData: action.driverData
            }
        default:
            return state;
    }
};


