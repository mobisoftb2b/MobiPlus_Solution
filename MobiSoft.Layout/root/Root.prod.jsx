import React, { Component, PropTypes } from 'react';
import { Router } from 'react-router';
import { Provider } from 'react-redux';
import routes from '../app/routes';

const Root = ({ store, history }) => (
    <Provider store={store}>
        <Router history={history} routes={routes}/>
    </Provider>
);

Root.propTypes = {
    store: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
}

export default Root;
