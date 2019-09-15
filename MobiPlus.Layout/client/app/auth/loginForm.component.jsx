import React, {PropTypes} from 'react';
import { connect } from 'react-redux';
import { fetchUser } from '../../redux/actions/auth';


class LoginComponent extends React.Component {
    constructor(props){
        super(props);
        this.state = {credentials: {}}
    }

    onChange(e) {
        const field = e.target.id;
        const credentials = this.state.credentials;
        credentials[field] = e.target.value;
        return this.setState({credentials: credentials});
    }

    handleSubmit(e) {
        e.preventDefault();
        this.props.dispatch(fetchUser(this.state.credentials));
    }

    render() {
        let local = this.props.local;
        return (
           <div>
                <form role="form" data-parsley-validate="" noValidate className="mb-lg">
                    <div className="form-group has-feedback">
                        <input id="UserName" type="text" autoFocus="true" onChange={this.onChange.bind(this)} placeholder={ local.login.loginForm.USERNAMEPLACEHOLDER } autoComplete="off" required="required" className="form-control" />
                        <span className="fa fa-users form-control-feedback text-muted"></span>
                    </div>
                    <div className="form-group has-feedback">
                        <input id="UserPassword" type="password"  onChange={this.onChange.bind(this)}   placeholder={ local.login.loginForm.PASSWORD }  required="required" className="form-control" />
                        <span className="fa fa-lock form-control-feedback text-muted"></span>
                    </div>                    
                    <button type="submit" onClick={ this.handleSubmit.bind(this) }  className="btn btn-block btn-info mt-lg">{ local.login.loginForm.LOGINBUTTON }</button>
                </form>
            </div>
            );
    }

}



const mapStateToProps = (state) => ({
    local: state.local
});


export default connect(mapStateToProps)(LoginComponent);


