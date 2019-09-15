import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn, ExportCSVButton } from 'react-bootstrap-table';
import 'react-bootstrap-table/css/react-bootstrap-table.css';
//import 'react-bootstrap-table/css/react-bootstrap-table-all.min.css';
import { fetchReportGridColums, fetchReportGridData } from '../../../redux/actions/reportGrid';
import ConcActivityDialog from './concActivityDialog.component';
import { PercentFormatter } from '../../../share/components/Common/common';
import FlatButton from 'material-ui/FlatButton';

class ConcActivity extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter,
            isOpen: false,
            aData: {}
        };
    }

    componentDidMount() {
        let filter = this.props.filter || {};
        filter.ReportID = 257;
        this.props.dispatch(fetchReportGridData(filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchReportGridData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
        }
    }

    onRowDoubleClickHandler(row) {
        this.setState({ isOpen: true, aData: row });
    }

    handleCloseDialog() {
        this.setState({ isOpen: false });
    }

    renderDialog() {
        return (<ConcActivityDialog key={0} isOpen={this.state.isOpen} handleCloseDialog={this.handleCloseDialog.bind(this)} aData={this.state.aData} />);
    }

    createCustomExportCSVButton = (onClick) => {
        return (
            <FlatButton label={this.props.local.buttonCaptions.ExportCSV} primary={true} onClick={ () => this.handleExportCSVButtonClick(onClick)} />);
    }

    handleExportCSVButtonClick = (onClick) => {
        onClick();
    }

    PercentFormatter(cell, row) {
        const percentComplete = cell + '%';
        return (<div className="progress" style={{ marginTop: '20px' }}>
            <div className="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style={{ width: percentComplete }}>{percentComplete}</div>
        </div>);
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
        let col = this.props.local.concActivityGrid;
        let data = this.props.reportGrid.gridData;
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
                            <BootstrapTable data={data} striped hover condensed options={options} search scrollTop={ 'Bottom' } exportCSV>
                                <TableHeaderColumn dataField="ImgStatus" headerAlign='center' dataFormat={this.ImageFormatter} dataAlign="center" width='30px' tdStyle={tdStyle} thStyle={thStyle}>.</TableHeaderColumn>
                                <TableHeaderColumn dataField="TaskDate" dataAlign="center" headerAlign='center' dataAlign='center' width='80' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.TaskDate}</TableHeaderColumn>
                                <TableHeaderColumn dataField="AgentId" isKey={true} dataAlign="center" headerAlign='center' dataAlign='center' width='80' dataSort={true} tdStyle={tdStyle} thStyle={thStyle} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverID}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverName" dataAlign={recordpos} headerAlign='center' width='200px' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverName}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Shipment" dataAlign="center" headerAlign='center' width='60px' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Shipping}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Cycle" dataAlign="center" headerAlign='center' width='50' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Cycle}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Visit" dataAlign="center" headerAlign='center' width='70' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Visit}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Delivery" dataAlign="center" headerAlign='center' width='80' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Delivery}</TableHeaderColumn>
                                <TableHeaderColumn dataField="NotVisited" dataAlign="center" headerAlign='center' width='70' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.NotVisited}</TableHeaderColumn>
                                <TableHeaderColumn dataField="NotFullDelivery" dataAlign='center' headerAlign='center' width='80' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.NotFullDelivery}</TableHeaderColumn>
                                <TableHeaderColumn dataField="AgentReturn" dataAlign='center'  headerAlign='center' width='90' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.AgentReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverReturn" dataAlign='center'  headerAlign='center' width='60' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Tasks}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Tasks" dataAlign='center'  headerAlign='center' width='60' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverStatus" tdStyle={tdStyle} thStyle={thStyle}dataAlign={recordpos}  headerAlign='center' width='200' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.DriverStatus}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Progress" dataAlign={recordpos}  headerAlign='center' width='150' dataFormat={this.PercentFormatter} tdStyle={tdStyle} thStyle={thStyle}>{col.Progress}</TableHeaderColumn>
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

export default connect(mapStateToProps)(ConcActivity);



