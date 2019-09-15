import React, {Component} from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn  } from 'react-bootstrap-table';
import { fetchTasksData, fetchDeleteTasks } from '../../redux/actions/tasks';
import  TaskDialog  from './taskDialog.component';
import FlatButton from 'material-ui/FlatButton';
import { changeFilter } from '../../redux/actions/filter';


class TasksGrid extends Component{
    constructor(props){
        super(props);
        this.state = {
            filter:this.props.filter,
            isOpen:false,
            rowData: {}
        };
    }

    componentDidMount() {
        let filter = this.props.filter || {};
        this.props.dispatch(fetchTasksData(filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if(nextProps.filter !== state){
            this.props.dispatch(fetchTasksData(nextProps.filter));
            this.setState({filter:nextProps.filter });
        }
    }
    renderDialog() {
        return (<TaskDialog key={1} 
                    handleSaveClose={this.handleSaveClose.bind(this)}
                    handleClose={this.handleClose.bind(this)} 
                    isDialogOpen={this.state.isDialogOpen} 
                    rowData={this.state.rowData} />);
    }

    handleInsertButtonClick = (onClick) => {
        let params = {
            CountryID: this.state.filter.CountryID,
            DistrID : this.state.filter.DistrID,
            FromDate : this.state.filter.FromDate,
            AgentID : null
        }
        this.setState({ isDialogOpen: true, rowData: params });
    }

    handleDeleteButtonClick = (onClick) => {
        let params = {
            CountryID: this.state.filter.CountryID,
            DistrID : this.state.filter.DistrID,
            FromDate : this.state.filter.FromDate,
            AgentID : null
        }
        onClick();
    }
    createCustomInsertButton = (onClick) => {
        return (
            <FlatButton
                label={this.props.local.buttonCaptions.AddTask}
                primary={true}
                onClick={ () => this.handleInsertButtonClick(onClick) } />
        );
    }
    createCustomDeleteButton = (onClick) => {
        return (
             <FlatButton
                label={this.props.local.buttonCaptions.DeleteTask}
                primary={true}
                onClick={ () => this.handleDeleteButtonClick(onClick) } />
            );
    }
    customConfirm(next, dropRowKeys) {
        const dropRowKeysStr = dropRowKeys.join(',');
        let deleted = this.props.local.deleteRowWarnings.deleted;
        let deletedText = this.props.local.deleteRowWarnings.deletedText;
        let cancelled = this.props.local.deleteRowWarnings.Cancelled;
        let cancelledText = this.props.local.deleteRowWarnings.CancelledText;
        swal({
            title: this.props.local.deleteRowWarnings.confirmTitle,
            text: this.props.local.deleteRowWarnings.confirmMainText,
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: this.props.local.deleteRowWarnings.confirmButtonText,
            cancelButtonText: this.props.local.deleteRowWarnings.cancelButtonText,
            closeOnConfirm: false,
            closeOnCancel: false
        }, function(isConfirm) {
            if (isConfirm) {                                    
                swal(deleted, deletedText, "success");
                next();
            } else {
                swal(cancelled, cancelledText, "error");
            }
        });
    }
    onAfterDeleteRow(rowKeys){
        this.props.dispatch(fetchDeleteTasks(rowKeys)); 
    }
    onRowDoubleClick(row){
        this.setState({ isDialogOpen: true, rowData: row });
    }
    handleSaveClose(){
        let filter = this.props.filter;
        filter.IsUpdated = !filter.IsUpdated;
        this.props.dispatch(changeFilter(filter));
        this.setState({ isDialogOpen: false });
    }

    handleClose(){
        this.setState({ isDialogOpen: false });
    }        

    render() {
        let col = this.props.local.tasksDataGrid;
        let data = this.props.tasksData; 
        const options = {
            onRowDoubleClick: this.onRowDoubleClick.bind(this),
            insertBtn: this.createCustomInsertButton.bind(this),
            deleteBtn: this.createCustomDeleteButton.bind(this),
            afterDeleteRow: this.onAfterDeleteRow.bind(this),
            handleConfirmDeleteRow: this.customConfirm.bind(this)
        };
        const selectRowProp = {
            mode: 'checkbox'
        };
        return (
             <Grid fluid>                 
                    <Row>
                        <Col lg={ 12 }>
                            <Panel>
                                <BootstrapTable data={data} search options={ options } insertRow deleteRow={true} selectRow={selectRowProp} striped hover condensed>
                                    <TableHeaderColumn dataField="TaskID" thStyle={{'verticalAlign':'top'}} isKey={true}  headerAlign='center' dataAlign='center' width='100' dataSort={true}>{col.TaskID}</TableHeaderColumn>
                                    <TableHeaderColumn dataField="TaskUser"  thStyle={{'verticalAlign':'top'}} width='100' dataSort={true}>{col.TaskUser}</TableHeaderColumn>
                                    <TableHeaderColumn dataField="CustomerCode"  thStyle={{'verticalAlign':'top'}}  width='100' dataSort={true}>{col.CustomerCode}</TableHeaderColumn>
                                    <TableHeaderColumn dataField="CustAddress" thStyle={{'verticalAlign':'top'}} width='100' editable={{ type: 'textarea' }} dataSort={true}>{col.CustAddress}</TableHeaderColumn>
                                    <TableHeaderColumn dataField="CustCity" thStyle={{'verticalAlign':'top'}} width='100' dataSort={true}>{col.CustCity}</TableHeaderColumn>
                                    <TableHeaderColumn dataField="TaskTypeDesc" thStyle={{'verticalAlign':'top'}} width='100' editable={{type: 'textarea'}} dataSort={true}>{col.TaskTypeDesc}</TableHeaderColumn>
                                    <TableHeaderColumn dataField="TaskDesc" thStyle={{'verticalAlign':'top'}} width='100' editable={{ type: 'textarea' }} dataSort={true}>{col.TaskDesc}</TableHeaderColumn>
                                </BootstrapTable>
                                 <div>{this.renderDialog()}</div>
                            </Panel>
                        </Col>
                    </Row>
            </Grid>
        );
                                    }
}


const mapStateToProps = (state) => ({
    local: state.local,
    filter: state.filter,
    tasksData: state.tasks.tasksData,
    user: state.auth.user
});

export default connect(mapStateToProps)(TasksGrid) ;


