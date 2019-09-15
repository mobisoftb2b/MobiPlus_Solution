import * as ActionTypes from '../consts/actionTypes';
import 'isomorphic-fetch';


export function fetchTasksData(params){
    return (dispatch) => fetch('/api/Dashboard/Layout_Tasks_GetAllTasksAsync', {
        method:'POST',
        body:JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
      .then(w => dispatch(getTasks(w)));
} 
export function getTasks(tasksData){
    return {
        type: ActionTypes.TASKS_DATA,
        tasksData
    };
}


export function fetchAgentListData(params){
    return (dispatch) => fetch('/api/Dashboard/GetAgentsLAsync', {
        method:'POST',
        body:JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
      .then(w => dispatch(getAgentList(w)));
} 
export function getAgentList(agentList){
    return {
        type: ActionTypes.AGENTSLIST_DATA,
        agentList
    };
}


export function fetchGetTaskTypes(params){
    return (dispatch) => fetch('/api/Dashboard/Layout_GetTaskTypesAsync', {
        method:'POST',
        body:JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
      .then(w => dispatch(getTaskTypes(w)));
}
export function getTaskTypes(taskTypes){
    return {
        type: ActionTypes.TASKSTYPES_DATA,
        taskTypes
    };
}

export function fetchSaveTask(params){
    return (dispatch) => fetch('/api/Dashboard/Layout_SaveTaskAsync', {
        method:'POST',
        body:JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
      .then(w => dispatch(saveTask(w)));
}

export function saveTask(taskResult){
    return {
        type: ActionTypes.TASKSRESULT_DATA,
        taskResult
    };
}

export function fetchDeleteTasks(tasks){
    return (dispatch) => fetch('/api/Dashboard/Layout_DeleteTaskAsync', {
        method:'POST',
        body:JSON.stringify(tasks),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
      .then(w => dispatch(deleteTask(w)));
}
export function deleteTask(deletedTask){
    return {
        type: ActionTypes.DELETEDTASKS_DATA,
        deletedTask
    };
}