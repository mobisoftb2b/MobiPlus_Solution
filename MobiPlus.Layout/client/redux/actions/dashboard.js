import * as ActionTypes from '../consts/actionTypes';

export function changeTitle(title) {
    return {
        type: "SET_TITLE",
        title
    }
}