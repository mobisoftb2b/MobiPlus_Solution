import * as ActionTypes from '../consts/actionTypes';

export default (state = {}, action) => {
    switch(action.type) {
        case ActionTypes.SET_WIDGET:
            return {
                ...state,
                widget: action.widget
            }
        case ActionTypes.SET_RADIAL_WIDGET:
            return {
                ...state,
                radwidget: action.radwidget
            }
        case ActionTypes.SET_DELIVERY_WIDGET:
            return {
                ...state,
                devWidget: action.devWidget
            }
        case ActionTypes.SET_AGENTRETURN_WIDGET:
            return {
                ...state,
                agRetWidget: action.agRetWidget
            }
        case ActionTypes.SET_TASK_WIDGET:
            return {
                ...state,
                taskWidget: action.taskWidget
            }
        case ActionTypes.SET_NONVISIT_WIDGET:
            return {
                ...state,
                nonvisitWidget: action.nonvisitWidget
            }

        default:
            return state;
    }
};


