import * as ActionTypes from '../consts/actionTypes';

import 'isomorphic-fetch';

export function fetchUser() {
    return (dispatch) => fetch('/api/auth')
            .then(respnce => respnce.json())
            .then(user => dispatch(setUser(user)));
}

export function setUser(user) {
    return {
        type: ActionTypes.SET_USER,
        user
    };
}