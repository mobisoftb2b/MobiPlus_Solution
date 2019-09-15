import React, {Component} from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import DatePicker from 'material-ui/DatePicker';
import { connect } from 'react-redux';
import areIntlLocalesSupported from 'intl-locales-supported';
import { changeFilter } from '../../../redux/actions/filter';
import moment from 'moment';



class DatePickerInline extends Component{
    constructor(props){
        super(props);    
        let cDate = moment(this.props.filter.FromDate)._d;
        this.state = {
            currDate: cDate
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
            this.setState({ currDate: moment(nextProps.filter.FromDate)._d });
        }
    }
    
    formatDate(date){
        return  date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear();
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
                        formatDate = {this.formatDate.bind(this)}
                        firstDayOfWeek={0}
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
