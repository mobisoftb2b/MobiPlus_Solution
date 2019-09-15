import React from 'react';
import {connect} from 'react-redux';
import { browserHistory } from 'react-router';

export function requireAuthentication(Component) {

    class AuthenticatedComponent extends React.Component {

        componentWillMount() {
            this.checkAuth();
        }

        componentWillReceiveProps(nextProps) {
            this.checkAuth();
        }


        checkAuth() {
            if (!(this.props.user != null && !this.props.user.isAuthenticated)) {
            } else {
                let redirectAfterLogin = this.props.location.pathname;
                browserHistory.push(`/login?next=${redirectAfterLogin}`);
            }
        }

        render() {
            return (
                <div>
                    {this.props.user.isAuthenticated === true
                        ? <Component {...this.props}/>
                        : null
                    }
                </div>
            );

        }
    }

    AuthenticatedComponent.defaultProps = {
        user: {}
    }

    const mapStateToProps = (state) => ({        
        user: state.auth.user
    });

    return connect(mapStateToProps)(AuthenticatedComponent);

}