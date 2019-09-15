import * as ActionTypes from '../consts/actionTypes';
import 'isomorphic-fetch';

export function fetchTabs(params) {
    return (dispatch) => fetch('/api/Layout/Layout_TabsItems_SelectByUserAsync', {
        method:'POST',
        body:JSON.stringify(params),
            headers: {
                "Content-Type": "application/json"
            }
        }).then(responce => responce.json())
        .then(t => dispatch(getTabs(t)));

}
export function getTabs(tabsData){
    return {
        type: ActionTypes.TABS_DATA,
        tabsData
    };
}