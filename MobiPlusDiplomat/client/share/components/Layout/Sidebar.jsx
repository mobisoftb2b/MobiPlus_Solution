import React from 'react';
import { Router, Route, Link, History, withRouter } from 'react-router';
import { connect } from 'react-redux';
import pubsub from 'pubsub-js';
import { Collapse } from 'react-bootstrap';
import SidebarRun from './Sidebar.run';
import { fetchMenu } from '../../../redux/actions/menu';

import MenuBuilder from  '../Common/menuBuilder';

class Sidebar extends React.Component {

    constructor(props, context) {
        super(props, context);

        this.state = {
            userBlockCollapse: false,
            collapse: {
                layout: this.routeActive(['layout']),
                submenu: this.routeActive(['submenu']),
                tasks: this.routeActive(['tasks'])
            }
        };
        this.pubsub_token = pubsub.subscribe('toggleUserblock', () => {
            this.setState({
                userBlockCollapse: !this.state.userBlockCollapse
            });
        });
    }

    componentDidMount() {
        SidebarRun(this.navigator.bind(this)); 
        this.props.dispatch(fetchMenu( {UserID : this.props.user.UserID,LanguageID: this.props.local.langSettings.langID }));
    }

    navigator(route) {
        this.props.router.push(route);
    }

    componentWillUnmount() {
        pubsub.unsubscribe(this.pubsub_token);
    }

    routeActive(paths) {
        paths = Array.isArray(paths) ? paths : [paths];
        for (let p in paths) {
            if (this.props.router.isActive(paths[p]) === true)
                return true;
        }
        return false;
    }

    toggleItemCollapse(stateName) {
        var newCollapseState = {};
        for (let c in this.state.collapse) {
            if (this.state.collapse[c] === true && c !== stateName)
                this.state.collapse[c] = false;
        }
        this.setState({
            collapse: {
                [stateName]: !this.state.collapse[stateName]
            }
        });
    }

    render() {
        let local = this.props.local;
        let menu = this.props.menuData.menuData || [];
        MenuBuilder(menu);
        return (
            <aside className='aside'>
                { /* START Sidebar (left) */ }
                <div className="aside-inner">
                    <nav data-sidebar-anyclick-close="" className="sidebar">
                        { /* START sidebar nav */ }
                        <ul className="nav">
                            { /* START user info */ }
                            <li className="has-user-block">
                                <Collapse id="user-block" in={ this.state.userBlockCollapse }>
                                    <div>
                                        <div className="item user-block">
                                    { /* User picture */ }
                                            <div className="user-block-picture">
                                                <div className="user-block-status">
                                                    <img src="public/img/user/matan.png" alt="Avatar" width="60" height="60" className="img-thumbnail img-circle" />
                                                    <div className="circle circle-success circle-lg"></div>
                                                </div>
                                            </div>
                                    { /* Name and Job */ }
                                            <div className="user-block-info">
                                                <span className="user-block-name">Hello, { this.props.user.FirstName }</span>
                                                <span className="user-block-role">{this.props.user.Description}</span>
                                            </div>
                                        </div>
                                    </div>
                                </Collapse>
                            </li>
                                    { /* END user info */ }
                           
                            <li className="nav-heading ">
                                <span>{ local.sidebar.heading.HEADER }</span>
                            </li>
                                    { 
                                menu.map(m=> 
                                    <li key={m.FormID}  className={ this.routeActive(m.RoutePath) ? 'active' : '' }>
                                        <Link to={m.RoutePath} title={m.RoutePath}>
                                            <em className={m.CssIcon}></em>
                                            <span>{ m.FormName }</span>
                                        </Link>
                                    </li>
                                )                               
                            }                            
                             { /* Iterates over all sidebar items
                            <li className={ this.routeActive('dashboard') ? 'active' : '' }>
                                <Link to="dashboard" title="Dashboard">
                                <em className="icon-grid"></em>
                                <span>{ local.sidebar.nav.DASHBOARD }</span>
                                 </Link>
                             </li>

                            <li className={ this.routeActive('layout') ? 'active' : '' }>
                                <Link to="layout" title="Single View">
                                <em className="fa fa-truck"></em>
                                <span>{ local.sidebar.nav.SINGLEVIEW }</span>
                                </Link>
                            </li>

                            <li className={ this.routeActive(['submenu']) ? 'active' : '' }>
                                <div className="nav-item" onClick={ this.toggleItemCollapse.bind(this, 'submenu') }>
                                    <div className="pull-right label label-info">1</div>
                                    <em className="icon-speedometer"></em>
                                    <span>{ local.sidebar.nav.menu.MENU }</span>
                                </div>
                                <Collapse in={ this.state.collapse.submenu } timeout={ 100 }>
                                    <ul id="submenu" className="nav sidebar-subnav">
                                        <li className="sidebar-subnav-header">תפריט</li>
                                        <li className={ this.routeActive('submenu') ? 'active' : '' }>
                                            <Link to="submenu" title="Submenu">
                                            <span>{ local.sidebar.nav.menu.SUBMENU }</span>
                                            </Link>
                                        </li>
                                    </ul>
                                </Collapse>
                            </li>

                     */ }
                        </ul>
                        { /* END sidebar nav */ }
                    </nav>
                </div>
                { /* END Sidebar (left) */ }
            </aside>
            );
    }

}

function mapStateToProps(state,action) {
    return {
        local: state.local,
        user: state.auth.user,
        menuData: state.menuData,
        filter: state.filter
    }
}

export default connect(mapStateToProps)(withRouter(Sidebar));


