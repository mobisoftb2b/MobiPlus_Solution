import React, {Component} from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import DatePicker from 'material-ui/DatePicker';
import { connect } from 'react-redux';
var injectTapEventPlugin = require("react-tap-event-plugin");
import areIntlLocalesSupported from 'intl-locales-supported';
import { changeFilter } from '../../../redux/actions/filter';
import moment from 'moment';

injectTapEventPlugin();

class DatePickerInline extends Component{
    constructor(props){
        super(props);    
        let cDate = moment(this.props.filter.FromDate)._d;
        this.state = {
            currDate: cDate,
            filter: this.props.filter
        };
        
    }

    ChangeCurrDateHandler = (event, date) => {
        const filter = this.props.filter|| {};
        filter.FromDate =  moment(date).format('YYYYMMDD');
        this.props.dispatch(changeFilter(filter));
        this.setState({
            currDate: date
        });
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.setState({
                currDate: moment(nextProps.filter.FromDate)._d
            });
        }
    }

     
    render(){
        let  DateTimeFormat;
        if (areIntlLocalesSupported([this.props.local.langSettings.shortLang, this.props.local.langSettings.fullLang])) {
            DateTimeFormat = global.Intl.DateTimeFormat;
        }
        return (
            <div style={{ 'marginTop':'-22px'}}>
            <MuiThemeProvider>
                <DatePicker  hintText={this.props.local.filter.DATE}
                    DateTimeFormat={DateTimeFormat}
                    floatingLabelText={this.props.floatingLabelText}
                    okLabel={this.props.local.filter.OKLABEL}
                    cancelLabel={this.props.local.filter.CANCELLABEL}
                    locale={this.props.local.langSettings.fullLang} 
                    autoOk={this.props.autoOk}
                    mode={this.props.mode}
                    container={this.props.container}
                    fullWidth={true}
                    value={this.state.currDate}
                    onChange={this.ChangeCurrDateHandler}
                    />
                </MuiThemeProvider>            
            </div> 
            )   
     }
}


function mapStateToProps(state,action) {
    return {
        local: state.local,
    }
}

export default connect(mapStateToProps)(DatePickerInline);
