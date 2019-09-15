import React, {Component} from 'react';
import {connect} from 'react-redux';
import {browserHistory} from 'react-router'
import { fetchLocal } from '../../../redux/actions/local';
import SelectField from 'material-ui/SelectField';
import MenuItem from 'material-ui/MenuItem';
import Cookies from 'universal-cookie';
import * as LangTypes from '../Common/constants';


class SelectLanguage extends Component {
    constructor(props) {
        super(props);
        this.state = {
            value: $.localStorage.get(LangTypes.storageKey) || LangTypes.preferredLang
        };
    }

    handleChange(event, index, value) {
        this.setState({value: value})
        const cookies = new Cookies();
        $.localStorage.set(LangTypes.storageKey, value);
        cookies.set(LangTypes.language, value, {path: '/'});
        //this.props.dispatch(fetchLocal(value));
        //if (value !== "he" && $('html').prop('dir') == 'rtl') {
            location.reload();
        // }
        // else if (value == "he" && $('html').prop('dir') == 'ltr') {
        //     location.reload();
        // }
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchLocal(this.key));
            this.setState({filter: nextProps.filter});
        }
    }

    render() {
        let local = this.props.local;
        return (
            <div>
                <SelectField
                    floatingLabelText={local.offsidebar.LANGUAGES}
                    value={this.state.value}
                    fullWidth={false}
                    onChange={this.handleChange.bind(this)}>
                    <MenuItem value={'he'} primaryText="עברית"/>
                    <MenuItem value={'en'} primaryText="English"/>
                    <MenuItem value={'gr'} primaryText="ქართული"/>
                </SelectField>
            </div>
        );
    }
}


function mapStateToProps(state, action) {
    return {
        local: state.local,
    }
}

export default connect(mapStateToProps)(SelectLanguage);