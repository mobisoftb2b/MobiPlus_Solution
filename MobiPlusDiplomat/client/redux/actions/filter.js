import * as ActionTypes from '../consts/actionTypes';
import 'isomorphic-fetch';

export function fetchFilter() {
    return (dispatch) =>
        fetch('server/defaultFilter.json')
        .then(res => res.json())
        .then(filter => dispatch(changeFilter(filter)))
        .catch(err => console.error(err));

}

export function changeFilter(filter) {
    return {
        type: ActionTypes.FILTER_PARAMS,
        filter
    }
}