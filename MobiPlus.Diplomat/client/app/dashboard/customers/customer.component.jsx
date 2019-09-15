import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn, ExportCSVButton } from 'react-bootstrap-table';
import { fetchCustomersGridData } from '../../../redux/actions/reportGrid';
import { TwoLinesTextFormatterHtml } from '../../../share/components/Common/common';
import CustomersDialog from './customerDialog.component';
import FlatButton from 'material-ui/FlatButton';



class CustomersComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter,
            isOpen: false,
            aData: {}
        }
    }

    componentDidMount() {
        this.props.dispatch(fetchCustomersGridData(this.props.filter));
        this.refs.table1.forceUpdate();
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchCustomersGridData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
            this.refs.table1.forceUpdate();
        }
    }

    ImageFormatter(cell, row) {
        let src = `../../public/img/${cell}.png`;
        return (
            <img src={src} width='15px' />
        );
    }

    columnClassNameFormat(fieldValue, row, rowIdx, colIdx) {
        if(fieldValue!="")
            return row.STYLE_CollectedSurfaces;
    }

    onRowDoubleClickHandler(row) {
        let params = {
            CountryID: this.state.filter.CountryID,
            DistrID: this.state.filter.DistrID,
            FromDate: this.state.filter.FromDate,
            AgentID: row.DriverID,
            CustomerID: row.CustomerID
        }
        this.setState({ isDialogOpen: true, aData: params });
    }

    handleCloseDialog() {
        this.setState({ isDialogOpen: false });
    }

    createCustomExportCSVButton = (onClick) => {
        return (
          <FlatButton label={this.props.local.buttonCaptions.ExportCSV} primary={true} onClick={ () => this.handleExportCSVButtonClick(onClick)} />);
    }
    handleExportCSVButtonClick = (onClick) => {
        onClick();
    }

    renderDialog() {
        return (<CustomersDialog key={5} isDialogOpen={this.state.isDialogOpen} handleCloseDialog={this.handleCloseDialog.bind(this)} aData={this.state.aData} />);
        }

    render() {
        let col = this.props.local.customerGrid;
        let data = this.props.reportGrid.customersData || [];
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const tdStyle = { whiteSpace: 'normal', 'font-size':'0.9em'};
        const thStyle = {verticalAlign:'top', whiteSpace: 'normal' };
        const options = {
            onRowDoubleClick: this.onRowDoubleClickHandler.bind(this),
            exportCSVBtn: this.createCustomExportCSVButton.bind(this)
        }
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable ref="table1" data={data} hover condensed options={options} search scrollTop={'Bottom'} exportCSV>
                                <TableHeaderColumn dataField="ImgStatus" headerAlign='center' dataFormat={this.ImageFormatter} dataAlign="center" width='25' tdStyle={tdStyle} thStyle={thStyle} >.</TableHeaderColumn>
                                <TableHeaderColumn dataField="TaskDate" headerAlign='center' hidden dataAlign='center' width='75' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.TaskDate}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Shipment" isKey={true} headerAlign='center' width='65' dataAlign='center' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Shipment}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Driver" dataAlign={recordpos} headerAlign='center' width='150' dataSort={true} dataFormat={TwoLinesTextFormatterHtml} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverName}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Customer" dataAlign={recordpos} headerAlign='center' width='200' dataSort={true} dataFormat={TwoLinesTextFormatterHtml} tdStyle={tdStyle} thStyle={thStyle}>{col.Customer}</TableHeaderColumn>
                                <TableHeaderColumn dataField="CustomerAddress" dataAlign={recordpos} headerAlign='center' width='200' dataSort={true} dataFormat={TwoLinesTextFormatterHtml} tdStyle={tdStyle} thStyle={thStyle}>{col.CustAddress}</TableHeaderColumn>
                                <TableHeaderColumn dataField="TravelHours" dataAlign={recordpos} headerAlign='center' width='90' dataSort={true} dataFormat={TwoLinesTextFormatterHtml} thStyle={thStyle}>{col.TravelHours}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ServiceHours" dataAlign={recordpos} headerAlign='center' width='90' dataSort={true} dataFormat={TwoLinesTextFormatterHtml} thStyle={thStyle}>{col.ServiceHours}</TableHeaderColumn>
                                <TableHeaderColumn dataField="OriginalTime" dataAlign={recordpos} headerAlign='center' width='90' dataSort={true} thStyle={thStyle} dataFormat={TwoLinesTextFormatterHtml}>{col.OriginalTime}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DeliveryTime" dataAlign='center' headerAlign='center' width='90' dataSort={true} thStyle={thStyle} dataFormat={TwoLinesTextFormatterHtml}>{col.DeliveryTime}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Delivery" headerAlign='center' dataAlign='center' width='60' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Deliveries}</TableHeaderColumn>
                                <TableHeaderColumn dataField="AgentReturn" headerAlign='center' dataAlign={recordpos} width='60' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.AgentReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverReturn" headerAlign='center' dataAlign='center' width='60' columnClassName={this.columnClassNameFormat} dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="CollectedSurfaces" headerAlign='center' dataAlign='center' width='60' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Pallets}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ReportGPS_Lat" headerAlign='center' dataAlign='center' width='80' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.ReportGPS_Lat}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ReportGPS_Lon" headerAlign='center' dataAlign='center' width='80' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.ReportGPS_Lon}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Quality" headerAlign='center' dataAlign='center' width='45' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Quality}</TableHeaderColumn>
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
    reportGrid: state.reportGrid,
    filter: state.filter,
    user: state.auth.user
});
export default connect(mapStateToProps)(CustomersComponent);