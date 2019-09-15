import * as ActionTypes from '../consts/actionTypes';
import 'isomorphic-fetch';


export function fetchMenu(params){
    return (dispatch) => fetch('/api/Layout/Layout_MenuItems_SelectByUserAsync', {
        method:'POST',
        body:JSON.stringify(params),
        headers: {
            "Content-Type": "application/json"
        }
    }).then(responce => responce.json())
      .then(w => dispatch(getMenu(w)));
}


export function getMenu(menuData){
    return {
        type: ActionTypes.MENU_DATA,
        menuData
    };
}



