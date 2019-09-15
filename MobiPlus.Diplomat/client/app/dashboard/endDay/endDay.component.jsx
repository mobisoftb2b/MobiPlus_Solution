import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import { BootstrapTable, TableHeaderColumn, ExportCSVButton } from 'react-bootstrap-table';
import { fetchEndDayGridData } from '../../../redux/actions/reportGrid';
import EndDayDialog from './endDayDialog.component';
import FlatButton from 'material-ui/FlatButton';

class EndDayComponent extends Component {
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
        this.props.dispatch(fetchEndDayGridData(filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            this.props.dispatch(fetchEndDayGridData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
        }
    }

    onRowDoubleClickHandler(row) {
        let params = {
            CountryID: this.state.filter.CountryID,
            DistrID: this.state.filter.DistrID,
            FromDate: this.state.filter.FromDate,
            AgentID: row.DriverID
        }
        console.log("DriverStatus onRowDoubleClick");
        this.setState({ isDialogOpen: true, aData: params });
    }
    createCustomExportCSVButton = (onClick) => {
        return (
            <FlatButton label={this.props.local.buttonCaptions.ExportCSV} primary={true} onClick={ () => this.handleExportCSVButtonClick(onClick)} />);
    }

    handleExportCSVButtonClick = (onClick) => {
        onClick();
    }

    handleCloseDialog() {
        this.setState({ isDialogOpen: false });
    }

    renderDialog() {
        return (<EndDayDialog key={5} isDialogOpen={this.state.isDialogOpen} handleClose={this.handleClose.bind(this)} aData={this.state.aData} />);
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
        return row.STYLE_CollectedSurfaces;       
    }

    handleClose() {
        this.setState({ isDialogOpen: false });
    }

    render() {
        let col = this.props.local.endDayGrid;
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const tdStyle = { whiteSpace: 'normal', 'font-size':'0.9em'};
        const thStyle = {verticalAlign:'top', whiteSpace: 'normal' };
        let data = this.props.reportGrid.endDayData;
        const options = {
            onRowDoubleClick: this.onRowDoubleClickHandler.bind(this),
            exportCSVBtn: this.createCustomExportCSVButton.bind(this)
        }
        return (
            <Grid fluid>
                <Row>
                    <Col lg={12}>
                        <Panel>
                            <BootstrapTable data={data} striped hover condensed options={options} search exportCSV>
                                <TableHeaderColumn dataField="ImgStatus" headerAlign='center' dataFormat={this.ImageFormatter} dataAlign="center" width='30' >.</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverID" tdStyle={tdStyle} thStyle={thStyle} isKey={true} headerAlign='center' dataAlign="center" width='100' dataSort={true}>{col.DriverID}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverName" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='200' dataAlign={recordpos} dataSort={true}>{col.DriverName}</TableHeaderColumn>
                                <TableHeaderColumn dataField="Delivery" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='100' dataAlign="center" dataSort={true}>{col.Delivery}</TableHeaderColumn>
                                <TableHeaderColumn dataField="AgentReturn" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='100' dataAlign="center" dataSort={true}>{col.AgentReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DriverReturn" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='100' dataAlign="center" dataSort={true}>{col.DriverReturn}</TableHeaderColumn>
                                <TableHeaderColumn dataField="CollectedSurfaces" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='80' dataAlign="center" columnClassName={this.columnClassNameFormat} dataSort={true}>{col.CollectedSurfaces}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DistansePlanned" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='100' dataAlign="center" dataSort={true}>{col.DistansePlanned}</TableHeaderColumn>
                                <TableHeaderColumn dataField="DistanseReal" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' dataAlign="center" dataFormat={this.TwoLinesTextFormatter} width='100' dataSort={true}>{col.DistanseReal}</TableHeaderColumn>
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

export default connect(mapStateToProps)(EndDayComponent);



