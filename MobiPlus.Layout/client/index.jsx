import React from 'react';
import ReactDOM from 'react-dom';
import { Route } from 'react-router';
import createHistory from 'history/createBrowserHistory';

import Root from './root/Root';
import * as LocalBase from './share/components/Common/localBase';

import initFilter from './share/server/defaultFilter.json';
import configureStore from './redux/store/configureStore';

let localBase = LocalBase.GetLanguage(initFilter);


var initialState = {
    local : localBase,
    auth: {},
    filter: initFilter
};  

const history = createHistory();
const store = configureStore(initialState, history);

ReactDOM.render(
    <Root store={store} history={history}/>,
    document.getElementById('app')
);
