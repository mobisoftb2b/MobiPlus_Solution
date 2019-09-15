import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchAgentsReportGridData } from '../../../redux/actions/reportGrid';
import { TwoLinesTextFormatterHtml } from '../../../share/components/Common/common';

class DriverReportComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        }
    }

    componentDidMount() {
        this.props.dispatch(fetchAgentsReportGridData(this.props.filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchAgentsReportGridData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
        }
    }

    render() {
        let col = this.props.local.agentsReportGrid;
        let data = this.props.reportGrid.agentsReport || [];
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable data={data} striped hover condensed search pagination>
                                <TableHeaderColumn dataField="DocStartTime" thStyle={{ 'verticalAlign': 'top' }} isKey={true} headerAlign='center' dataAlign='center' width='70' dataSort={true}>{col.DocStartTime}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverName" thStyle={{ 'verticalAlign': 'top' }} headerAlign='center' width='100' dataAlign={recordpos} dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.DriverName}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Reference" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Reference}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Customer" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Customer}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ShipmentNumber" thStyle={{ 'verticalAlign': 'top' }} dataAlign='center' headerAlign='center' width='70' dataSort={true}>{col.ShipmentNumber}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Item" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='80' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Item}</TableHeaderColumn>
                                <TableHeaderColumn dataField="QTY" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true}>{col.QTY}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ReasonDescription" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.ReasonDescription}</TableHeaderColumn>
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
export default connect(mapStateToProps)(DriverReportComponent);