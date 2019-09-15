import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchCollectionNotesGridData } from '../../../redux/actions/reportGrid';
import { TwoLinesTextFormatterHtml } from '../../../share/components/Common/common';

class CollectionNotesComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        }
    }

    componentDidMount() {
        this.props.dispatch(fetchCollectionNotesGridData(this.props.filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchCollectionNotesGridData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
        }
    }

    render() {
        let col = this.props.local.notesCollectionGrid;
        let data = this.props.reportGrid.collectionNotes || [];
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const tdStyle = { whiteSpace: 'normal', 'font-size':'0.9em'};
        const thStyle = {verticalAlign:'top', whiteSpace: 'normal' };
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable data={data} striped hover condensed search bodyStyle={{ maxHeight: '54vh', overflow: 'overlay' }}>
                                <TableHeaderColumn dataField="AgentID" tdStyle={tdStyle} thStyle={thStyle} isKey={true} headerAlign='center' dataAlign='center' width='100' dataSort={true}>{col.AgentID}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverName" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='100' dataAlign={recordpos} dataSort={true}>{col.DriverName}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Customer" tdStyle={tdStyle} thStyle={thStyle} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.Customer}</TableHeaderColumn>
                                <TableHeaderColumn dataField="TaskDescription" tdStyle={tdStyle} thStyle={thStyle} dataAlign={recordpos} headerAlign='center' width='70' dataSort={true}>{col.TaskDescription}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DeliveryNum" tdStyle={tdStyle} thStyle={thStyle} dataAlign='center' headerAlign='center' width='70' dataSort={true}>{col.DeliveryNum}</TableHeaderColumn>
                                <TableHeaderColumn dataField="InvoiceComment" tdStyle={tdStyle} thStyle={thStyle} dataAlign={recordpos} headerAlign='center' width='80' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.InvoiceComment}</TableHeaderColumn>
                                <TableHeaderColumn dataField="CustomerComment" tdStyle={tdStyle} thStyle={thStyle} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true} dataFormat={TwoLinesTextFormatterHtml}>{col.CustomerComment}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DeliveryStatus" tdStyle={tdStyle} thStyle={thStyle} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true}>{col.DeliveryStatus}</TableHeaderColumn>
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
export default connect(mapStateToProps)(CollectionNotesComponent);