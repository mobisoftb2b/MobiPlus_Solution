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
        const tdStyle = { whiteSpace: 'normal', 'font-size':'0.9em'};
        const thStyle = {verticalAlign:'top', whiteSpace: 'normal' };
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable data={data} striped hover condensed search  bodyStyle={{ maxHeight: '54vh', overflow: 'overlay' }}>
                                <TableHeaderColumn dataField="DriverName" tdStyle={tdStyle} thStyle={thStyle} isKey={true} headerAlign='center' dataAlign={recordpos} width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Driver}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ShipmentID" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='100' dataAlign='center' dataSort={true}>{col.ShipmentID}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Customer" tdStyle={tdStyle} thStyle={thStyle} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Customer}</TableHeaderColumn>
                                <TableHeaderColumn dataField="ReportDescription" tdStyle={tdStyle} thStyle={thStyle} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true}>{col.ReportDescription}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Delivery" tdStyle={tdStyle} thStyle={thStyle} dataAlign='center' headerAlign='center' width='100' dataSort={true}>{col.Delivery}</TableHeaderColumn>
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