import * as ActionTypes from '../consts/actionTypes';
import 'isomorphic-fetch';

export function fetchDefaultWidgets(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_Widget_NotFullDeliveryAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(setWidget(w)));
}

export function setWidget(widget) {
    return {
        type: ActionTypes.SET_WIDGET,
        widget
    };
}

export function fetchRadialWidgets(params) {
    return (dispatch) => fetch('/api/Dashboard/POD_Widget_SelectAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(setRadialWidget(w)));
}

export function setRadialWidget(radwidget) {
    return {
        type: ActionTypes.SET_RADIAL_WIDGET,
        radwidget
    };
}    


export function fetchDeliveryWidgets(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_Widget_DeliveryAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(setDeliveryWidget(w)));
}

export function setDeliveryWidget(devWidget) {
    return {
        type: ActionTypes.SET_DELIVERY_WIDGET,
        devWidget
    };
}

export function fetchAgentReturnWidgets(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_Widget_AgentReturnAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(setAgRetWidget(w)));
}

export function setAgRetWidget(agRetWidget) {
    return {
        type: ActionTypes.SET_AGENTRETURN_WIDGET,
        agRetWidget
    };
}

export function fetchTaskWidgets(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_Widget_TasksAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(setTaskWidget(w)));
}

export function setTaskWidget(taskWidget) {
    return {
        type: ActionTypes.SET_TASK_WIDGET,
        taskWidget
    };
}

export function fetchNonVisitWidgets(params) {
    return (dispatch) => fetch('/api/Dashboard/Layout_POD_Widget_NonVisitAsync',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(setNonVisitWidget(w)));
}

export function setNonVisitWidget(nonvisitWidget) {
    return {
        type: ActionTypes.SET_NONVISIT_WIDGET,
        nonvisitWidget
    };
}