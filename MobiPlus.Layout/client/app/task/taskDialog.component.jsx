import React, {Component} from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col } from 'react-bootstrap';
import Dialog from 'material-ui/Dialog';
import FlatButton from 'material-ui/FlatButton';
import TextField from 'material-ui/TextField';
import DatePicker from 'material-ui/DatePicker';
import SelectField from 'material-ui/SelectField';
import MenuItem from 'material-ui/MenuItem';
import areIntlLocalesSupported from 'intl-locales-supported';
import moment from 'moment';
import { fetchAgentListData, fetchGetTaskTypes, fetchSaveTask } from '../../redux/actions/tasks';


class TaskDialog extends Component{
    constructor(props){
        super(props);        
        const fromDate = moment(this.props.filter.FromDate)._d;
        const toDate = new Date();        
        fromDate.setDate(fromDate.getDate());
        toDate.setDate(fromDate.getDate() + 1);
        this.state = {
            fromDate: fromDate, 
            toDate: toDate,
            selectedDriver:0,
            selectedType: 0,
            taskID:0,
            txtCustomer: '',
            txtAddress:'',
            txtCity:'',
            txtTaskDesc:'',
            filter:this.props.filter,
            open: this.props.isDialogOpen,            
            messages : {
                driverMessage:'',
                customerMessage:'',
                addressMessage:'',
                cityMessage:'',
                typeTaskMessage:'',
                typeDescMessage:''
            }

        };
    }
    componentDidMount() {
        this.props.dispatch(fetchAgentListData(this.props.filter));
        this.props.dispatch(fetchGetTaskTypes(this.props.filter));
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.isDialogOpen !== this.state.open) {
            this.setState({ 
                open: nextProps.isDialogOpen,
                taskID:nextProps.rowData.TaskID,
                selectedDriver:nextProps.filter.AgentID,
                fromDate:  new Date(moment(nextProps.rowData.DateFrom).format('L')),
                toDate: new Date(moment(this.state.toDate).format('L')),
                selectedType: nextProps.rowData.TaskTypeID,
                txtCustomer: nextProps.rowData.CustomerCode,
                txtAddress: nextProps.rowData.CustAddress,
                txtCity:nextProps.rowData.CustCity,
                txtTaskDesc:nextProps.rowData.TaskDesc
            });
        }
    }

    renderAgentLst(){
        const agentList =  this.props.agentList || [];
        return (
            agentList.map(a =>
                <MenuItem key={a.DriverID} value={a.DriverID}  primaryText={a.DriverName} />
        ));
    }

    renderTaskType(){
        const taskTypes =  this.props.taskTypes || [];
        return (
            taskTypes.map(a =>
                <MenuItem key={a.TaskTypeID} value={a.TaskTypeID}  primaryText={a.TaskTypeDesc} />
        ));
    }
    
    handleChangeAgentLst(event, index, value) {
        this.setState({selectedDriver:value});
        if(value>0) this.setState({ messages: { driverMessage:''} });
    }
     handleChangeTaskType(event, index, value) {
         this.setState({selectedType:value});
         if(value>0) this.setState({ messages: { typeTaskMessage:''} });
    }
    _handleStartInput(event, date) {  
        this.setState({
            fromDate : date
        }); 
    } 
    _handleEndInput(event, date) { 
        this.setState({ 
            toDate : date
        });  
    }     

    handleSaveTask(event){     
        if(this.state.selectedDriver==null || this.state.selectedDriver == 0){
            this.setState({ messages: { driverMessage:'This field is required'} });
            return false;
        } else{this.setState({ messages: { driverMessage:''} });} 
        if(!this.refs.Customer.getValue()){
            this.setState({ messages: { customerMessage:'This field is required'} });
            return false;
        } else{this.setState({ messages: { customerMessage:''} });}
        //if(!this.refs.Address.getValue()){
        //    this.setState({ messages: { addressMessage:'This field is required'} });
        //    return false;
        //} else{this.setState({ messages: { addressMessage:''} });}
        //if(!this.refs.City.getValue()){
        //    this.setState({ messages: { cityMessage:'This field is required'} });
        //    return false;
        //} else{this.setState({ messages: { cityMessage:''} });}
        if(this.state.selectedType==undefined || this.state.selectedType == 0){
            this.setState({ messages: { typeTaskMessage:'This field is required'} });
            return false;
        } else{this.setState({ messages: { typeTaskMessage:''} });}
        //if(!this.refs.TaskDesc.getValue()){
        //    this.setState({ messages: { typeDescMessage:'This field is required'} });
        //    return false;
        //} else{this.setState({ messages: { typeDescMessage:''} });}  

        let taskData = {
            TaskID: this.state.taskID,
            AgentID : this.state.selectedDriver,
            CustomerCode : this.refs.Customer.getValue(),
            CustAddress: this.refs.Address.getValue(), 
            CustCity: this.refs.City.getValue(),
            DateFrom: moment(this.state.fromDate).format('YYYYMMDD'),
            DateTo: moment(this.state.toDate).format('YYYYMMDD'),
            TaskTypeID: this.state.selectedType,
            TaskTypeDesc: this.refs.TaskDesc.getValue(),
            UserID: this.props.filter.UserID,
            CountryID:this.props.filter.CountryID 
        }

        this.props.dispatch(fetchSaveTask(taskData));
        this.props.handleSaveClose();
    }

    render() {
        let  DateTimeFormat;
        if (areIntlLocalesSupported([this.props.local.langSettings.shortLang, this.props.local.langSettings.fullLang])) {
            DateTimeFormat = global.Intl.DateTimeFormat;
        }
        const col = this.props.local.driverStatus;
        const recordpos = this.props.local.langSettings.shortLang == "he"? 'right' : 'left';
        const driverStatusPop = this.props.reportGrid.driverStatusPop||[];
        const closeImg = {
            cursor:'pointer', float:{recordpos}, width: '20px'
        };

        const actions = [
             <FlatButton
                label={this.props.local.buttonCaptions.SaveTask}
                primary={true} 
                onTouchTap={this.handleSaveTask.bind(this)} />,
            <FlatButton
                label={this.props.local.buttonCaptions.CloseModal}
                primary={true}
                onTouchTap={this.props.handleClose.bind(this) } />
        ];
        return (   
            <div>
                <Dialog
                    title={this.props.local.tasksDataGrid.TaskEdit_Title}
                actions={actions}
                modal={false}
                autoScrollBodyContent={true}
                open={this.props.isDialogOpen} >
              <Grid fluid>                 
                <Row>
                    <Col lg={6}>
                         <SelectField id='Driver' ref='Driver' hintText={this.props.local.tasksDataGrid.TaskEdit_Driver} 
                            value={this.state.selectedDriver}
                            onChange={this.handleChangeAgentLst.bind(this)} 
                            floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_Driver} 
                            fullWidth={true} errorText={this.state.messages.driverMessage} >
                                {this.renderAgentLst()}
                        </SelectField>
                    </Col>
                    <Col lg={6}>
                        <TextField id='Customer' ref='Customer' hintText={this.props.local.tasksDataGrid.TaskEdit_Customer} defaultValue={this.state.txtCustomer}
                            floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_Customer} fullWidth={true} errorText={this.state.messages.customerMessage} />
                        </Col>
                    </Row>
                    <Row>
                         <Col lg={6}>
                            <TextField id='Address' ref='Address' hintText={this.props.local.tasksDataGrid.TaskEdit_Address} defaultValue={this.state.txtAddress}
                            floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_Address} fullWidth={true} errorText={this.state.messages.addressMessage} />
                        </Col>
                         <Col lg={6}>
                            <TextField id='City' ref='City' hintText={this.props.local.tasksDataGrid.TaskEdit_City} defaultValue={this.state.txtCity}
                            floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_City} fullWidth={true} errorText={this.state.messages.cityMessage} />
                        </Col>
                    </Row>
                    <Row>
                         <Col lg={6}>
                            <DatePicker 
                                DateTimeFormat={DateTimeFormat} 
                                hintText={this.props.local.tasksDataGrid.TaskEdit_FromDate} 
                                fullWidth={true}
                                locale={this.props.local.langSettings.fullLang}
                                floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_FromDate} 
                                id='FromDate' 
                                ref='FromDate' 
                                value={this.state.fromDate}
                                container="inline"  
                                mode='portrait'  
                                autoOk={true} 
                                onChange={this._handleStartInput.bind(this)} />                                             
                        </Col>
                         <Col lg={6}>
                            <DatePicker 
                                DateTimeFormat={DateTimeFormat}
                                hintText={this.props.local.tasksDataGrid.TaskEdit_ToDate}  
                                fullWidth={true}
                                floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_ToDate} 
                                id='ToDate' 
                                ref='ToDate' 
                                value={this.state.toDate}
                                container="inline"  
                                mode='portrait'  
                                locale={this.props.local.langSettings.fullLang} 
                                autoOk={true} 
                                onChange={this._handleEndInput.bind(this)} />  
                        </Col>
                    </Row>
                    <Row>
                     <Col lg={6}>
                          <SelectField id='TypeTask' ref='TypeTask' hintText={this.props.local.tasksDataGrid.TaskEdit_TypeTask} 
                            value={this.state.selectedType}
                            onChange={this.handleChangeTaskType.bind(this)} 
                            floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_TypeTask} 
                            fullWidth={true} errorText={this.state.messages.typeTaskMessage} >
                                {this.renderTaskType()}
                          </SelectField>
                         </Col>
                         <Col lg={6}>
                            <TextField id='TaskDesc' ref='TaskDesc' defaultValue={this.state.txtTaskDesc}
                            multiLine={true} hintText={this.props.local.tasksDataGrid.TaskEdit_TaskDesc}  errorText={this.state.messages.typeDescMessage}
                            rows={2} floatingLabelText={this.props.local.tasksDataGrid.TaskEdit_TaskDesc} fullWidth={true} />
                        </Col>
                    </Row>
                </Grid>
            </Dialog>
        </div>
     );
  }
}


const mapStateToProps = (state) => ({
    local: state.local,
    reportGrid: state.reportGrid,
    agentList: state.tasks.agentList,
    taskTypes: state.tasks.taskTypes,
    filter: state.filter
});

export default connect(mapStateToProps)(TaskDialog) ;



