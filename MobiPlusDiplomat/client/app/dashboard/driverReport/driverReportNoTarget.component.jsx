import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchAgentsReportNTGridData } from '../../../redux/actions/reportGrid';
import { TwoLinesTextFormatterHtml } from '../../../share/components/Common/common';

class DriverReportNoTargetComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        }
    }

    componentDidMount() {
        this.props.dispatch(fetchAgentsReportNTGridData(this.props.filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchAgentsReportNTGridData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
        }
    }

    render() {
        let col = this.props.local.agentsReportNTGrid;
        let data = this.props.reportGrid.agentsReportNT || [];
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable data={data} striped hover condensed search pagination>
                                <TableHeaderColumn dataField="DriverName" thStyle={{ 'verticalAlign': 'top' }} isKey={true} headerAlign='center' dataAlign={recordpos} width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Driver}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ShipmentID" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='100' dataAlign='center' dataSort={true}>{col.ShipmentID}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Customer" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Customer}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ReportDescription" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true}>{col.ReportDescription}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Delivery" thStyle={{ 'verticalAlign': 'top' }} dataAlign='center' headerAlign='center' width='100' dataSort={true}>{col.Delivery}</TableHeaderColumn>
                            </BootstrapTable>
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
export default connect(mapStateToProps)(DriverReportNoTargetComponent);