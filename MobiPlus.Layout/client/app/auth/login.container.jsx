import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import url from 'url';

import LoginComponent from './loginForm.component';
import initFilter from '../../share/server/defaultFilter.json';

import { changeFilter } from '../../redux/actions/filter';


class LoginContainer extends Component {

    isAuthenticated(){
        if(this.props.user!=null && this.props.user.isAuthenticated) {
            let filter = initFilter|| {};
            filter.CountryID = this.props.user.FilterParams.CountryID;
            filter.DistrID = this.props.user.FilterParams.DistrID;
            filter.UserID = this.props.user.UserID;
            this.props.dispatch(changeFilter(filter));

            let { query } = url.parse(this.props.location.search, true);
            this.props.dispatch(push(query.next || '/'));
        }
    }

    componentWillMount(){
        this.isAuthenticated();
    }

    componentDidUpdate() {     
        this.isAuthenticated();
    }
    
    
    render() {
        return(
               <div className="block-center mt-xl wd-xl">
                { /* START panel */ }
                <div className="panel panel-info panel-flat">
                    <div className="panel-heading text-center">
                        <a href="#">
                            <img src="public/img/logo.png" alt="Image" className="block-center img-rounded" />
                        </a>
                    </div>
                    <div className="panel-body">
                        <p className="text-center pv">{ this.props.local.login.loginForm.LOGINTITLE }</p>
                        <LoginComponent />
                    </div>
                </div>
        { /* END panel */ }
        </div>
            );

    }

}

LoginContainer.defaultProps = {
    user: {}
}

const mapStateToProps = (state) => ({
    local: state.local,
    user: state.auth.user
});


export default connect(mapStateToProps)(LoginContainer) ;