import React from 'react';
//import ReactDOM from 'react-dom';
import { Route, IndexRoute } from 'react-router';

import App from './app';
import DashboardContainer from './dashboard/dashboard.container';
import LoginContainer from './auth/login.container';
import TaskContainer from './task/task.container';
import HardwareContainer from './hardware/hardware.container';
import {requireAuthentication} from './auth/requireAuthentication.component';

import Base from './../share/components/Layout/Base';
import BasePage from './../share/components/Layout/BasePage';
//import BaseHorizontal from './../share/components/Layout/BaseHorizontal';

import LayoutView from '../share/components/SingleView/LayoutView';

import SubMenu from './../share/components/SubMenu/SubMenu';


export default (
<Route path="/" component={App}>        
    <Route path="login" component={LoginContainer}/>
      <Route component={requireAuthentication(Base)}> 
        <IndexRoute component={DashboardContainer} />               
        <Route path="dashboard" component={DashboardContainer}/>
        <Route path="layout" component={LayoutView}/>
        <Route path="submenu" component={SubMenu}/>
        <Route path="tasks" component={TaskContainer}/>
        <Route path="hardware" component={HardwareContainer}/>
    </Route>
</Route>
)
