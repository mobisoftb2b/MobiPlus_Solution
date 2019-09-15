import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Route, Switch, Redirect } from 'react-router';

import { connect } from 'react-redux';

import DashboardContainer from '../dashboard/dashboard.container';
import TaskContainer from '../task/task.container';
import HardwareContainer from '../hardware/hardware.container';

const Hey = () => (<div>Hey</div>);

function getContainer(componentType){
    switch(componentType){
        case 'dashboard':
            return DashboardContainer;
        case 'tasks':
            return TaskContainer;
        case 'hardware':
            return HardwareContainer;
        default:
            return Hey;
    }
}

class DynamicRouter extends Component {
  
    render() {
        let { menuData, router } = this.props;
        return (
           <Switch>
               {
                   menuData.map(item => (
                        <Route key={ item.FormID } path={`/${item.RoutePath}`} component={ getContainer(item.RoutePath) }/>
                   ))
               }    
               <Route exact path="/" render={() => (<Redirect to="/dashboard" />)} />
            </Switch>
        );
    }

}

function mapStateToProps(state) {
    return {
        menuData: (state.menuData || {}).menuData || [],
        router: state.router
    };
}

export default connect(mapStateToProps)(DynamicRouter);