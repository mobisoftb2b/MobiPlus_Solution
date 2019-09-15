import * as ActionTypes from  '../consts/actionTypes';

export default (state = {}, action) => {
    switch (action.type) {
        case ActionTypes.MAPSTRUCK_DATA:
            return {
                ...state,
                mapTruckData: action.mapTruckData
            }
        case ActionTypes.MAPSVISIT_DATA:
            return {
                ...state,
                mapVisitData: action.mapVisitData
            }
        case ActionTypes.MAPSROAD_DATA:
            return {
                ...state,
                mapRoadsData: action.mapRoadsData
            }
        default:
            return state;        
    }
}
