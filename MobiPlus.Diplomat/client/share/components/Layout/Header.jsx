import React from 'react';
import pubsub from 'pubsub-js';
import { connect } from 'react-redux';
import HeaderRun from './Header.run'
import { NavDropdown, MenuItem } from 'react-bootstrap';
import { browserHistory } from 'react-router';
import Logout from '../Common/logout';
import { logoutUser } from '../../../redux/actions/auth';
import LoadingBar from 'react-redux-loading-bar'


class Header extends React.Component {

    componentDidMount() {
        HeaderRun();     
    }

    handleSelect(key) {
        Logout();
        browserHistory.push("/login?next=/");
    }

    toggleUserblock(e) {
        e.preventDefault();
        pubsub.publish('toggleUserblock');
    }

    render() {
        const ddAlertTitle = (
            <span>
                <em className="icon-logout"></em>
            </span>
        );
        return (
            <header className="topnavbar-wrapper">
                <LoadingBar  style={{ backgroundColor: 'blue', height: '5px' }}/>
                { /* START Top Navbar */ }
                <nav role="navigation" className="navbar topnavbar">
                    { /* START navbar header */ }
                    <div className="navbar-header">
                        <a href="#/" className="navbar-brand">
                            <div className="brand-logo">
                                <img src="public/img/logo.png" alt="App Logo" className="img-responsive" />
                            </div>
                            <div className="brand-logo-collapsed">
                                <img src="public/img/main_launcher.ico" alt="App Logo" style={{'width':'30px', 'marginTop':'9px'}} className="img-responsive" />
                            </div>
                        </a>
                    </div>
                    { /* END navbar header */ }
                    { /* START Nav wrapper */ }
                    <div className="nav-wrapper">
                        { /* START Left navbar */ }
                        <ul className="nav navbar-nav">
                            <li>
                                { /* Button used to collapse the left sidebar. Only visible on tablet and desktops */ }
                                <a href="#" data-trigger-resize="" data-toggle-state="aside-collapsed" className="hidden-xs">
                                    <em className="fa fa-navicon"></em>
                                </a>
                                { /* Button to show/hide the sidebar on mobile. Visible on mobile only. */ }
                                <a href="#" data-toggle-state="aside-toggled" data-no-persist="true" className="visible-xs sidebar-toggle">
                                    <em className="fa fa-navicon"></em>
                                </a>
                            </li>
                            { /* START User avatar toggle */ }
                            <li>
                                { /* Button used to collapse the left sidebar. Only visible on tablet and desktops */ }
                                <a id="user-block-toggle" href="#" onClick={ this.toggleUserblock }>
                                    <em className="icon-user"></em>
                                </a>
                            </li>
                            { /* END User avatar toggle */ }
                        </ul>
                        { /* END Left navbar */ }
                        { /* START Right Navbar */ }
                        <ul className="nav navbar-nav navbar-right">
                            { /* Search icon */ }
                            <li>
                                <a href="#" data-search-open="">
                                    <em className="icon-magnifier"></em>
                                </a>
                            </li>
                                    { /* START Alert menu */ }                                   
                            <NavDropdown noCaret eventKey={ 3 } title={ ddAlertTitle } onSelect={this.handleSelect.bind(this)} id="basic-nav-dropdown" >
                                <MenuItem className="animated flipInX" eventKey={1}>Logout</MenuItem>
                            </NavDropdown>
                            { /* END Alert menu */ }
                            { /* START Offsidebar button */ }
                            <li>
                                <a href="#" data-toggle-state="offsidebar-open" data-no-persist="true">
                                    <em className="icon-notebook"></em>
                                </a>
                            </li>
                            { /* END Offsidebar menu */ }
                        </ul>
                        { /* END Right Navbar */ }
                    </div>
                    { /* END Nav wrapper */ }
                    { /* START Search form */ }
                    <form role="search" action="search.html" className="navbar-form">
                        <div className="form-group has-feedback">
                            <input type="text" placeholder="Type and hit enter ..." className="form-control" />
                            <div data-search-dismiss="" className="fa fa-times form-control-feedback"></div>
                        </div>
                        <button type="submit" className="hidden btn btn-default">Submit</button>
                    </form>
                    { /* END Search form */ }
                </nav>
                { /* END Top Navbar */ }
            </header>
            );
    }

}

Header.defaultProps = {
    user: {}
};
const mapStateToProps = (state) => ({
    local: state.local,
    user: state.auth.user
});


export default connect(mapStateToProps)(Header);