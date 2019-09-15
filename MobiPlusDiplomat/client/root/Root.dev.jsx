import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Router } from 'react-router';
import { Provider } from 'react-redux';
import DevTools from '../dev/DevTools';
import Routes from '../app/routes';


const root = ({ store, history }) => (
  <Provider store={store}>
    <div>
      <Router history={history} routes={Routes} />
      <DevTools store={store} />
    </div>
  </Provider>
);

root.propTypes = {
    store: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
};
export default root;
