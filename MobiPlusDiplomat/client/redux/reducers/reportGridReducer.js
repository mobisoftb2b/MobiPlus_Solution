﻿import * as ActionTypes from '../consts/actionTypes';

export default (state = {}, action) => {
    switch(action.type) {
        case ActionTypes.REPORTGRID_SETTINGS:
            return {
                ...state,
                gridColums: action.gridColums
            }
        case ActionTypes.REPORTGRID_DATA:
            return {
                ...state,
                gridData: action.data
            }
        case ActionTypes.NESTEDGRID_DATA:
            return {
                ...state,
                nestedGrid: action.nestedGrid
            }
        case ActionTypes.DRIVERSTATUS_DATA:
            return {
                ...state,
                driverStatus: action.driverStatus
            }
        case ActionTypes.DRIVERSTATUSPOPUP_DATA:
            return {
                ...state,
                driverStatusPop: action.driverStatusPop
            }
        case ActionTypes.ENDDAY_DATA:
            return {
                ...state,
                endDayData: action.endDayData
            }
        case ActionTypes.ENDDAYDETAILS_DATA:
            return {
                ...state,
                endDayDetalsData: action.endDayDetalsData
            }
        case ActionTypes.COLLECTIONNOTES_DATA:
            return {
                ...state,
                collectionNotes: action.collectionNotes
            }
        case ActionTypes.AGENTSREPORT_DATA:
            return {
                ...state,
                agentsReport: action.agentsReport
            }
        case ActionTypes.AGENTSREPORTNT_DATA:
            return {
                ...state,
                agentsReportNT: action.agentsReportNT
            }
        default:
            return state;
    }
};


