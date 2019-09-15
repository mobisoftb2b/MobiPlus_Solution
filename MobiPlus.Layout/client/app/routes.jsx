import React from 'react';
//import ReactDOM from 'react-dom';
import { Route, Switch } from 'react-router';

import App from './app';
import LoginContainer from './auth/login.container';
import AuthenticatedComponent from './auth/requireAuthentication.component';
import DynamicRouter from './dynamicRouter/dynamic.router.container';

import Base from './../share/components/Layout/Base';

//import BasePage from './../share/components/Layout/BasePage';
//import BaseHorizontal from './../share/components/Layout/BaseHorizontal';

//import LayoutView from '../share/components/SingleView/LayoutView';

//import SubMenu from './../share/components/SubMenu/SubMenu';

export const createRoutes = () => (
    <App>
        <Switch>
            <Route exact path="/login" component={LoginContainer}/>
            <AuthenticatedComponent>
                <Base>
                    <DynamicRouter />
                </Base>
            </AuthenticatedComponent>
        </Switch>
    </App>
)