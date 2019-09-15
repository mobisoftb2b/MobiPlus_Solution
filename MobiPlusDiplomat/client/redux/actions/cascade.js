import * as ActionTypes from '../consts/actionTypes';

import 'isomorphic-fetch';

//============================= Select country ====================================================

export function fetchCountry(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetCountryDataAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(setCountry(w)));
}

export function setCountry(countryData) {
    return {
        type: ActionTypes.COUNTRY_DATA,
        countryData
    };
}

//============================= Select distribution ====================================================

export function fetchDistribution(countryID) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetDistributionDataAsync',{ 
        method: "POST",
        body: JSON.stringify(countryID),
        headers: {
            "Content-Type": "application/json"
        }})
      .then(responce => responce.json())
      .then(data => dispatch(setDistributionData(data)));
}


export function setDistributionData(distrData) {
    return {
        type: ActionTypes.DISTRIBUTION_DATA,
        distrData
    };
}

//============================= Select driver ====================================================

export function fetchDrivers(data) {
   
    return (dispatch) => fetch('/api/Dashboard/Layout_GetDriverDataAsync',{ 
        method: "POST",
        body: JSON.stringify(data),
        headers: {
            "Content-Type": "application/json"
        }})
      .then(responce => responce.json())
      .then(d => dispatch(setDDriversData(d)));
}


export function setDDriversData(driverData) {
    return {
        type: ActionTypes.DRIVER_DATE,
        driverData
    };
}
