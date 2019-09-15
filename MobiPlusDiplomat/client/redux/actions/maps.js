import * as ActionTypes from '../consts/actionTypes';
import 'isomorphic-fetch';

export function fetchTrucksData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetDriverGPSLocationByCountryAsync', {
        method: 'POST',
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
        .then(w => dispatch(getMaps(w)));
}

export function getMaps(mapTruckData) {
    return {
        type: ActionTypes.MAPSTRUCK_DATA,
        mapTruckData
    };
}

export function fetchVisitData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetCustomersCordAsync', {
        method: 'POST',
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
        .then(w => dispatch(getVisitCoord(w)));
}

export function getVisitCoord(mapVisitData) {
    return {
        type: ActionTypes.MAPSVISIT_DATA,
        mapVisitData
    };
}

export function fetchRoadsData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetCustomersRoadCordAsync', {
        method: 'POST',
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
        .then(w => dispatch(getRoadsCoord(w)));
}

export function getRoadsCoord(mapRoadsData) {
    return {
        type: ActionTypes.MAPSROAD_DATA,
        mapRoadsData
    };
}