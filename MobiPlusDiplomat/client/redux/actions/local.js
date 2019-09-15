import * as ActionTypes from '../consts/actionTypes';

export function setLocal(local) {
    return {
        type: ActionTypes.SET_LOCAL,
        local
    }
}

export function fetchLocal(name) {
    return (dispatch) => fetch('public/server/i18n/site-' + name + '.json')
            .then(res => res.json())
            .then(local => dispatch(setLocal(local)));
}