import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import Dialog from 'material-ui/Dialog';
import FlatButton from 'material-ui/FlatButton';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchDriverStatusPopupGridData } from '../../../redux/actions/reportGrid';


const closeImg = {
    cursor: 'pointer', float: 'right', marginTop: '2px', width: '20px'
};
const closeImage = '../../../../public/img/53504-200.png';
const customContentStyle = {
    width: '99%',
    maxWidth: 'none'
};

class DriverStatusDialog extends Component {
    constructor(props) {
        super(props);
        this.state = {
            open: this.props.isDialogOpen
        };
    }

    componentDidMount() {
        let rowData = this.props.aData || {};
        this.props.dispatch(fetchDriverStatusPopupGridData(rowData));
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.isDialogOpen !== this.state.open) {
            this.setState({ open: nextProps.isDialogOpen });
            this.props.dispatch(fetchDriverStatusPopupGridData(nextProps.aData));
        }
    }

    ImageFormatter(cell, row) {
        let src = `../../public/img/${cell}.png`;
        return (
            <img src={src} width='15px' />
        );
    }
    TwoLinesTextFormatter(cell, row) {
        if (cell)
            return cell.replace('^', "<br />");
        return '';

    }

    render() {
        const col = this.props.local.driverStatus;
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const driverStatusPop = this.props.reportGrid.driverStatusPop || [];
        const actions = [
            <FlatButton
                label={this.props.local.buttonCaptions.CloseModal}
                primary={true}
                onTouchTap={this.props.handleClose.bind(this)} />
        ];
        return (
            <div>
                <Dialog
                    title={
                        <div>
                            <img src={closeImage} onClick={this.props.handleClose.bind(this)} style={closeImg} />
                        </div>
                    }
                    actions={actions}
                    onRequestClose={this.props.handleClose.bind(this)}
                    modal={false}
                    autoScrollBodyContent={true}
                    contentStyle={customContentStyle}
                    open={this.props.isDialogOpen} >
                    <BootstrapTable data={driverStatusPop} striped={true} hover={true}>
                        <TableHeaderColumn dataField="TaskTime" thStyle={{'verticalAlign':'top'}} headerAlign='center' dataAlign="center" width='30' >{col.TaskTime}</TableHeaderColumn>
                        <TableHeaderColumn dataField="ShipmentID" thStyle={{'verticalAlign':'top'}} headerAlign='center' dataAlign='center' width='100' dataSort={true}>{col.ShipmentID}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Customer" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='200' dataAlign={recordpos} dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.Customer}</TableHeaderColumn>
                        <TableHeaderColumn dataField="CustAddress" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='200' dataAlign={recordpos} dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.CustAddress}</TableHeaderColumn>
                        <TableHeaderColumn dataField="TaskID" thStyle={{'verticalAlign':'top'}} isKey={true} headerAlign='center' width='70' dataSort={true}>{col.TaskID}</TableHeaderColumn>
                        <TableHeaderColumn dataField="DocNumber" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='70' dataSort={true}>{col.DocNumber}</TableHeaderColumn>
                        <TableHeaderColumn dataField="ReportCode" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='70' dataSort={true}>{col.ReportCode}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Description" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='80' dataAlign={recordpos} dataSort={true}>{col.Description}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Comment" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='80' dataAlign={recordpos} dataSort={true}>{col.Comment}</TableHeaderColumn>
                        <TableHeaderColumn dataField="LastChange" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='80' dataSort={true}>{col.LastChange}</TableHeaderColumn>
                    </BootstrapTable>
                </Dialog>
            </div>
        );
    }
}


const mapStateToProps = (state) => ({
    local: state.local,
    reportGrid: state.reportGrid,
    filter: state.filter
});

export default connect(mapStateToProps)(DriverStatusDialog);



