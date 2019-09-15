import * as ActionTypes from  '../consts/actionTypes';

export default (state = {}, action) => {     
    switch (action.type) {
        case ActionTypes.TASKS_DATA:
            return {
                ...state,
                tasksData: action.tasksData
            }  
        case ActionTypes.AGENTSLIST_DATA:
            return {
                ...state,
                agentList: action.agentList
            }
        case ActionTypes.TASKSTYPES_DATA:
            return {
                ...state,
                taskTypes: action.taskTypes
            }              
        case ActionTypes.TASKSRESULT_DATA:
            return {
                ...state,
                taskResult: action.taskResult
            }
        case ActionTypes.DELETEDTASKS_DATA:
            return {
                ...state,
                deletedTask: action.deletedTask
            }
        default:
            return state;        
    }
}

