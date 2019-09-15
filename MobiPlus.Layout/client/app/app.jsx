import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router'

import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import InitLoadThemes from '../share/components/Common/load-themes';
import { loadFromSession } from '../redux/actions/auth';

import '../share/styles/bootstrap.scss';
import '../share/styles/app.scss'

InitLoadThemes();

class App extends Component {

    componentWillMount() {
        this.props.dispatch(loadFromSession());
    }
  
    render() {
        return (
            <MuiThemeProvider>
                <div style={{ height: '100vh' }}>
                    { this.props.children }
                </div>
            </MuiThemeProvider>
        );
    }

}

App.propTypes = {
    children: PropTypes.element
}

export default withRouter(connect()(App));