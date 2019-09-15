import React from 'react';
import ReactDOM from 'react-dom';
import { browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'
import initFilter from './share/server/defaultFilter.json';
import configureStore from './redux/store/configureStore';
import * as LocalBase from './share/components/Common/localBase';
import Root from './root/Root';
import { Router, Route, Link, hashHistory, useRouterHistory, IndexRoute } from 'react-router';
let localBase = LocalBase.GetLanguage(initFilter);
import 'mdn-polyfills/Object.assign';


var initialState = {
    local : localBase,
    auth: {},
    filter: initFilter
};

const store = configureStore(initialState);
const history = syncHistoryWithStore(browserHistory, store);

ReactDOM.render(
    <Root store={store} history={history}/>,
    document.getElementById('app')
);
