import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchReportGridColums, fetchReportGridData } from '../../../redux/actions/reportGrid';
import ConcActivityDialog from './concActivityDialog.component';
import {TwoLinesTextFormatterHtml, PercentFormatter } from '../../../share/components/Common/common';

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
        console.log("ConcActivity onRowDoubleClickHandler");
    }
    handleCloseDialog() {
        this.setState({ isOpen: false });
    }

    renderDialog() {
        return (<ConcActivityDialog key={0} isOpen={this.state.isOpen} handleCloseDialog={this.handleCloseDialog.bind(this)} aData={this.state.aData} />);
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

    render() {
        let col = this.props.local.concActivityGrid;
        let data = this.props.reportGrid.gridData;
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const options = {
            onRowDoubleClick: this.onRowDoubleClickHandler.bind(this)
        }
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable data={data} striped hover condensed options={options} search pagination>
                                <TableHeaderColumn dataField="ImgStatus" headerAlign='center' dataFormat={this.ImageFormatter} dataAlign="center" width='30' >.</TableHeaderColumn>
                                <TableHeaderColumn dataField="AgentId" thStyle={{'verticalAlign':'top'}} isKey={true} dataAlign="center" headerAlign='center' dataAlign='center' width='100' dataSort={true}>{col.DriverID}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverName" thStyle={{'verticalAlign':'top'}} dataAlign={recordpos} headerAlign='center' width='200' dataSort={true}>{col.DriverName}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Shipment" thStyle={{'verticalAlign':'top'}} dataAlign="center" headerAlign='center' width='100' dataSort={true}>{col.Shipping}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Cycle" thStyle={{'verticalAlign':'top'}} dataAlign="center" headerAlign='center' width='70' dataSort={true}>{col.Cycle}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Visit" thStyle={{'verticalAlign':'top'}} dataAlign="center" headerAlign='center' width='70' dataSort={true}>{col.Visit}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Delivery" thStyle={{'verticalAlign':'top'}} dataAlign="center" headerAlign='center' width='80' dataSort={true}>{col.Delivery}</TableHeaderColumn>
                                <TableHeaderColumn dataField="NotVisited" thStyle={{'verticalAlign':'top'}} dataAlign="center" headerAlign='center' width='100' dataSort={true}>{col.NotVisited}</TableHeaderColumn>
                                <TableHeaderColumn dataField="NotFullDelivery" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='100' dataSort={true}>{col.NotFullDelivery}</TableHeaderColumn>
                                <TableHeaderColumn dataField="AgentReturn" thStyle={{'verticalAlign':'top'}} dataAlign={recordpos}  headerAlign='center' width='110' dataSort={true}>{col.AgentReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverReturn" thStyle={{'verticalAlign':'top'}} dataAlign={recordpos}  headerAlign='center' width='100' dataSort={true}>{col.DriverReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverStatus" thStyle={{'verticalAlign':'top'}} dataAlign={recordpos}  headerAlign='center' width='200' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.DriverStatus}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Progress" thStyle={{'verticalAlign':'top'}} dataAlign={recordpos}  headerAlign='center' dataFormat={this.PercentFormatter}>{col.Progress}</TableHeaderColumn>
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



