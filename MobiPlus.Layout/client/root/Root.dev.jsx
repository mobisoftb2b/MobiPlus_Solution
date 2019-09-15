import React, { Component, PropTypes } from 'react';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';
import DevTools from '../dev/DevTools';
import { createRoutes } from '../app/routes';

const root = ({ store, history }) => (
  <Provider store={store}>
    <div>
      <ConnectedRouter history={history}>
          { createRoutes() }
      </ConnectedRouter>
      <DevTools store={store} />
    </div>
  </Provider>
);

root.propTypes = {
    store: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
};

export default root;
