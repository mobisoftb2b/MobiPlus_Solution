import * as ActionTypes from '../consts/actionTypes';

import 'isomorphic-fetch';

export function fetchUser(data) {
    return (dispatch) => fetch('/api/auth/UserLogin',
        { 
            method: "POST",
            body: JSON.stringify(data),
            headers: {
                "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(user => dispatch(setUser(user)));
}

export function loadFromSession() {
    if ('user' in sessionStorage) {
        var userFromSession = JSON.parse(sessionStorage.user);
        return setUser(userFromSession);
    } else {
        return { type: "NO_SESSION" };
    }
}

export function setUser(user) {
    sessionStorage.user = JSON.stringify(user);
    return {
        type: ActionTypes.LOGIN_USER_SUCCESS,
        user
    };
}

