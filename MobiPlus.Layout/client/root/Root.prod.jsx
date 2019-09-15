import React, { Component, PropTypes } from 'react';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';
import { createRoutes } from '../app/routes';

const Root = ({ store, history }) => (
    <Provider store={store}>
        <ConnectedRouter history={history}>
            { createRoutes() }
        </ConnectedRouter>
    </Provider>
);

Root.propTypes = {
    store: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
}

export default Root;
