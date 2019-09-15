import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchDriverStatusGridData } from '../../../redux/actions/reportGrid';
import DriverStatusDialog from './driverStatusDialog.component';

class DriverStatus extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter,
            isDialogOpen: false,
            aData: {}
        };
    }

    componentDidMount() {
        let filter = this.props.filter || {};
        filter.ReportID = 257;
        this.props.dispatch(fetchDriverStatusGridData(filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchDriverStatusGridData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
        }
    }

    handleClose() {
        this.setState({ isDialogOpen: false });
    }

    onRowDoubleClick(row) {
        let params = {
            CountryID: this.state.filter.CountryID,
            DistrID: this.state.filter.DistrID,
            FromDate: this.state.filter.FromDate,
            AgentID: row.DriverID
        }
        console.log("DriverStatus onRowDoubleClick");
        this.setState({ isDialogOpen: true, aData: params });
    }

    renderDialog() {
        return (<DriverStatusDialog key={1} isDialogOpen={this.state.isDialogOpen} handleClose={this.handleClose.bind(this)} aData={this.state.aData} />);
    }

    TwoLinesTextFormatter(cell, row) {
        if (cell)
            return cell.replace('^', "<br />");
        return '';
    }

    ImageFormatter(cell, row) {
        let src = `../../public/img/${cell}.png`;
        return (
            <img src={src} width='15px' />
        );
    }

    columnClassNameFormat(fieldValue, row, rowIdx, colIdx) {
        if (fieldValue == 'YES1')
            return "BackGreen";
        else
            return "BackRed";
    }

    render() {
        let col = this.props.local.driverStatus;
        let data = this.props.reportGrid.driverStatus;
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const options = {
            onRowDoubleClick: this.onRowDoubleClick.bind(this)
        };
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable data={data} hover={true} options={options} pagination search>
                                <TableHeaderColumn dataField="DriverID" thStyle={{'verticalAlign':'top'}} isKey={true} headerAlign='center' dataAlign='center' width='100' dataSort={true}>{col.DriverID}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverName" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='300' dataSort={true}>{col.DriverName}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Cycle" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='70' dataAlign='center' dataSort={true}>{col.Cycle}</TableHeaderColumn>
                                <TableHeaderColumn dataField="UpdateDate" thStyle={{'verticalAlign':'top'}} headerAlign='center' width='100' dataAlign='center' dataSort={true}>{col.UpdateDate}</TableHeaderColumn>
                                <TableHeaderColumn dataField="imgLineDownload" thStyle={{'verticalAlign':'top'}} headerAlign='center' dataAlign='center' columnClassName={this.columnClassNameFormat} dataFormat={this.ImageFormatter} dataSort={true}>{col.LineDownload}</TableHeaderColumn>
                                <TableHeaderColumn dataField="imgWise" thStyle={{'verticalAlign':'top'}} headerAlign='center' dataAlign='center' dataFormat={this.ImageFormatter} columnClassName={this.columnClassNameFormat} dataSort={true}>{col.Wise}</TableHeaderColumn>
                                <TableHeaderColumn dataField="imgArriveBB" thStyle={{'verticalAlign':'top'}} hidden headerAlign='center' dataAlign='center' dataFormat={this.ImageFormatter} dataSort={true} columnClassName={this.columnClassNameFormat}>{col.ImgArriveBB}</TableHeaderColumn>
                                <TableHeaderColumn dataField="imgLeaveBB" thStyle={{'verticalAlign':'top'}} hidden headerAlign='center' dataAlign='center' dataFormat={this.ImageFormatter} dataSort={true} columnClassName={this.columnClassNameFormat}>{col.ImgLeaveBB}</TableHeaderColumn>
                                <TableHeaderColumn dataField="imgToDiplomat" thStyle={{'verticalAlign':'top'}} headerAlign='center' dataAlign='center' dataFormat={this.ImageFormatter} dataSort={true} columnClassName={this.columnClassNameFormat}>{col.ToDiplomat}</TableHeaderColumn>
                                <TableHeaderColumn dataField="imgLineEnded" thStyle={{'verticalAlign':'top'}} headerAlign='center' dataSort={true} dataAlign='center' dataFormat={this.ImageFormatter} columnClassName={this.columnClassNameFormat}>{col.LineEnded}</TableHeaderColumn>
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

export default connect(mapStateToProps)(DriverStatus);



