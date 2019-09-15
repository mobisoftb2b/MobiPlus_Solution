import React from 'react';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import App from './app';
import DashboardContainer from './dashboard/dashboard.container';
import LoginContainer from './auth/login.container';
import TaskContainer from './task/task.container';
import HardwareContainer from './hardware/hardware.container';
import {requireAuthentication} from './auth/requireAuthentication.component';

import Base from './../share/components/Layout/Base';
import BasePage from './../share/components/Layout/BasePage';

import LayoutView from '../share/components/SingleView/LayoutView';

import SubMenu from './../share/components/SubMenu/SubMenu';

function errorLoading(err) {
    console.error('Dynamic page loading failed', err);
}

function loadRoute(cb) {
    return (module) => cb(null, module.default);
}

const routes = {
    component: App,
    childRoutes: [
      {
          path: '/',
          getComponent(location, cb) {
              System.import('dashboard/dashboard')
                .then(loadRoute(cb))
                .catch(errorLoading);
          }
      },
      {
          path: 'layout',
          getComponent(location, cb) {
              System.import('layout')
                .then(loadRoute(cb))
                .catch(errorLoading);
          }
      },
      {
          path: 'tasks',
          getComponent(location, cb) {
              System.import('tasks')
                .then(loadRoute(cb))
                .catch(errorLoading);
          }
      },
    ]
};

export default () => <Router history={browserHistory} routes={routes} />;
