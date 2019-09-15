import * as ActionTypes from '../consts/actionTypes';

import 'isomorphic-fetch';

export function fetchReportGridColums(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetReportColsAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(gridColData => dispatch(setReportGridColums(gridColData)));
}

export function setReportGridColums(gridColums) {
    return {
        type: ActionTypes.REPORTGRID_SETTINGS,
        gridColums
    };
}

//===========================  Concentration Activity Grid  Data ===============================================
export function fetchReportGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetReportDataAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
      .then(responce => responce.json())
      .then(data => dispatch(setReportGridData(data)));
}


export function setReportGridData(data) {
    return {
        type: ActionTypes.REPORTGRID_DATA,
        data
    };
}


 //===========================  Concentration Activity Popup Data ===============================================
export function fetchNestedGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_GetNestedDataAsync',{ 
            method: "POST",
            body: JSON.stringify(params),
            headers: {
                "Content-Type": "application/json"
            }})
        .then(responce => responce.json())
        .then(data => dispatch(setNestedGridData(data)));
}


export function setNestedGridData(nestedGrid) {
    return {
        type: ActionTypes.NESTEDGRID_DATA,
        nestedGrid
    };
}

//===========================  Driver Status Grid Data ===============================================
export function fetchDriverStatusGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_WEB_DriverStatusAllAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(data => dispatch(setDriverStatusData(data)));
}


export function setDriverStatusData(driverStatus) {
    return {
        type: ActionTypes.DRIVERSTATUS_DATA,
        driverStatus
    };
}

//===========================  Driver Status Grid Data Popup ===============================================
export function fetchDriverStatusPopupGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_DriverStatusPopUpAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(data => dispatch(setDriverStatusPopupData(data)));
}


export function setDriverStatusPopupData(driverStatusPop) {
    return {
        type: ActionTypes.DRIVERSTATUSPOPUP_DATA,
        driverStatusPop
    };
}

//===========================  EndOfDay Grid Data  ===============================================
export function fetchEndDayGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_EndDay_SelectAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(data => dispatch(setEndDayGridData(data)));
}


export function setEndDayGridData(endDayData) {
    return {
        type: ActionTypes.ENDDAY_DATA,
        endDayData
    };
}
      
export function fetchEndDayDetailsGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_WEB_EndDayDetails_SelectAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(data => dispatch(setEndDayDetailsGridData(data)));
}


export function setEndDayDetailsGridData(endDayDetalsData) {
    return {
        type: ActionTypes.ENDDAYDETAILS_DATA,
        endDayDetalsData
    };
}

//============================ Collection Notes Grid Data =================================================

export function fetchCollectionNotesGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_WEB_NotesCollectionAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(data => dispatch(setCollectionNotesGridData(data)));
}


export function setCollectionNotesGridData(collectionNotes) {
    return {
        type: ActionTypes.COLLECTIONNOTES_DATA,
        collectionNotes
    };
}

//==========================Agents Report Grid Data==========================================================                  

export function fetchAgentsReportGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_WEB_AgentsReportAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(data => dispatch(setAgentsReportGridData(data)));
}


export function setAgentsReportGridData(agentsReport) {
    return {
        type: ActionTypes.AGENTSREPORT_DATA,
        agentsReport
    };
}

export function fetchAgentsReportNTGridData(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_WEB_AgentsReportNoTargetAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(data => dispatch(setAgentsReportNTGridData(data)));
}


export function setAgentsReportNTGridData(agentsReportNT) {
    return {
        type: ActionTypes.AGENTSREPORTNT_DATA,
        agentsReportNT
    };
}
