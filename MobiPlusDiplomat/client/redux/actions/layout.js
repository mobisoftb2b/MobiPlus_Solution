import * as ActionTypes from '../consts/actionTypes';
import 'isomorphic-fetch';

export function fetchLayout(params) {
    return (dispatch) => fetch('/api/Layout/Layout_Reports2Form_SelectAll',{ 
        method: "POST",
        body: JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }})
        .then(responce => responce.json())
        .then(w => dispatch(getLayout(w)));
}

export function getLayout(layout) {
    return {
        type: ActionTypes.LAYOUT_DATA,
        layout
    };
}