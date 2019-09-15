import React, { Component, PropTypes } from 'react';
import { Router } from 'react-router';
import { Provider } from 'react-redux';
import DevTools from '../dev/DevTools';
import Routes from '../app/routes';

const root = ({ store, history }) => (
  <Provider store={store}>
    <div>
      <Router history={history} routes={Routes} />
          <DevTools/>
    </div>
  </Provider>
);

root.propTypes = {
    store: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired
};
export default root;
