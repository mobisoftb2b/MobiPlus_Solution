import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import Dialog from 'material-ui/Dialog';
import FlatButton from 'material-ui/FlatButton';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchEndDayDetailsGridData } from '../../../redux/actions/reportGrid';


const closeImg = {
    cursor: 'pointer', float: 'right', marginTop: '2px', width: '20px'
};
const closeImage = '../../../../public/img/53504-200.png';

const customContentStyle = {
    width: '99%',
    maxWidth: 'none'
};

class EndDayDialog extends Component {
    constructor(props) {
        super(props);
        this.state = {
            open: this.props.isDialogOpen
        };
    }

    componentDidMount() {
        let rowData = this.props.aData || {};
        this.props.dispatch(fetchEndDayDetailsGridData(rowData));
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.isDialogOpen !== this.state.open) {
            this.setState({ open: nextProps.isDialogOpen });
            this.props.dispatch(fetchEndDayDetailsGridData(nextProps.aData));
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
    columnClassNameFormat(fieldValue, row, rowIdx, colIdx) {
        return row.STYLE_CollectedSurfaces;
    }


    render() {
        const col = this.props.local.endDayGrid;
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const endDayDetalsData = this.props.reportGrid.endDayDetalsData || [];
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
                    modal={false}
                    onRequestClose={this.props.handleClose.bind(this)}
                    autoScrollBodyContent={true}
                    contentStyle={customContentStyle}
                    open={this.props.isDialogOpen} >
                    <BootstrapTable data={endDayDetalsData} striped={true} hover={true}>
                        <TableHeaderColumn dataField="ImgStatus" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' dataAlign="center" width='30' dataFormat={this.ImageFormatter} ></TableHeaderColumn>
                        <TableHeaderColumn dataField="Shipment" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' dataAlign='center' width='150' dataSort={true}>{col.ShipmentDetails}</TableHeaderColumn>
                        <TableHeaderColumn dataField="DriverName" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='200' dataAlign={recordpos} dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.DriverName}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Order" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='80' dataAlign='center' dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.Order}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Customer" thStyle={{ 'verticalAlign': 'top' }} isKey={true} headerAlign='center' width='200' dataSort={true} dataAlign={recordpos}>{col.Customer}</TableHeaderColumn>
                        <TableHeaderColumn dataField="CustomerAddress" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='200' dataAlign={recordpos} dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.Address}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Delivery" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='70' dataSort={true} dataAlign="center">{col.Delivery}</TableHeaderColumn>
                        <TableHeaderColumn dataField="AgentReturn" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='80' dataAlign="center" dataSort={true}>{col.AgentReturn}</TableHeaderColumn>
                        <TableHeaderColumn dataField="DriverReturn" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='80' dataAlign="center" dataSort={true}>{col.DriverReturn}</TableHeaderColumn>
                        <TableHeaderColumn dataField="CollectedSurfaces" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='80'  dataAlign="center" dataSort={true} columnClassName={this.columnClassNameFormat}>{col.CollectedSurfaces}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Status" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='150' dataAlign={recordpos} dataSort={true}>{col.Status}</TableHeaderColumn>
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

export default connect(mapStateToProps)(EndDayDialog);



