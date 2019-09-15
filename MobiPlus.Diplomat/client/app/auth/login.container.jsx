import React, { Component } from 'react';
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import LoginComponent from './loginForm.component';
import initFilter from '../../share/server/defaultFilter.json';
import { AlertList, Alert, AlertContainer } from "react-bs-notifier";
import { changeFilter } from '../../redux/actions/filter';


class LoginContainer extends Component {
   constructor(props) {
        super(props); 
        this.state = {
            position: "top-right",
            alerts: [],
            timeout: 1000,
            newMessage: this.props.local.login.wrongLogin.message
        };
    }

    isAuthenticated(){
        if(this.props.user!=null && this.props.user.isAuthenticated) {
            let filter = initFilter|| {};
            filter.CountryID = this.props.user.FilterParams.CountryID;
            filter.DistrID = this.props.user.FilterParams.DistrID;
            this.props.dispatch(changeFilter(filter));
            browserHistory.push(this.props.location.query.next || '/');
        }
        else{
            this.generate();
        }
    }

    componentWillMount(){
       /// this.isAuthenticated();
    }

    componentDidUpdate(prevProps, prevState) { 
        if(prevState.alerts === this.state.alerts)
            this.isAuthenticated();
    }
    
    generate() {
        const newAlert ={
            id: (new Date()).getTime(),
            type: 'danger',
            headline: this.props.local.login.wrongLogin.headline,
            message: this.state.newMessage
        };
        this.setState({
            alerts: [...this.state.alerts, newAlert]
        });
        return false;
    }

    onAlertDismissed(alert) {
        const alerts = this.state.alerts;
        const idx = alerts.indexOf(alert);

        if (idx >= 0) {
            this.setState({
                alerts: [...alerts.slice(0, idx), ...alerts.slice(idx + 1)]
            });
        }
    }

    clearAlerts() {
        this.setState({
            alerts: []
        });
    }

    render() {
		return(
            <div className="block-center mt-xl wd-xl">
                <div className="panel panel-info panel-flat">
                    <div className="panel-heading text-center">
                        <a href="#">
                            <img src="public/img/logo.png" alt="Image" className="block-center img-rounded img-responsive" />
                        </a>
                    </div>
                    <div className="panel-body">
                        <p className="text-center pv">{ this.props.local.login.loginForm.LOGINTITLE }</p>
                        <LoginComponent  />
                        <AlertList
				            position={this.state.position}
				            alerts={this.state.alerts}
				            timeout={this.state.timeout}
				            onDismiss={this.onAlertDismissed.bind(this)}
                        />
                    </div>
                </div>
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