import React from 'react';
import {connect} from 'react-redux';

import { push } from 'react-router-redux';

class AuthenticatedComponent extends React.Component {

    componentWillMount() {
        this.checkAuth();
    }

    componentWillReceiveProps(nextProps) {
        this.checkAuth();
    }


    checkAuth() {            
        if (this.props.user!=null && !this.props.user.isAuthenticated) {
            let redirectAfterLogin = this.props.location.pathname;
            this.props.dispatch(push(`/login?next=${redirectAfterLogin}`));
        }
    }

    render() {
        return (
            <div>
                {this.props.user.isAuthenticated === true
                    ? this.props.children
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
    user: state.auth.user,
    location: state.router.location
});

export default connect(mapStateToProps)(AuthenticatedComponent);