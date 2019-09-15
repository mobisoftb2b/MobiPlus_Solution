import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Grid, Row, Col, Panel } from 'react-bootstrap';
import Dialog from 'material-ui/Dialog';
import FlatButton from 'material-ui/FlatButton';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchNestedGridData } from '../../../redux/actions/reportGrid';


const closeImg = {
    cursor: 'pointer', 
    float: 'right', 
    marginTop: '2px', 
    width: '20px'
};
const closeImage = '../../../../public/img/53504-200.png';

const customContentStyle = {
    width: '99%',
    maxWidth: 'none'
};

class ConcActivityDialog extends Component {
    constructor(props) {
        super(props);
        this.state = {
            open: this.props.isOpen || false
        };
    }

    componentDidMount() {
        this.setState({ open: this.props.isOpen });
        let rowData = this.props.aData || {};
        this.props.dispatch(fetchNestedGridData(rowData));
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.isOpen !== this.state.open) {
            this.setState({ open: nextProps.isOpen });
            this.props.dispatch(fetchNestedGridData(nextProps.aData));
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
        if(fieldValue!="")
            return row.STYLE_CollectedSurfaces;
    }

    render() {
        const col = this.props.local.concActivityGrid;
        const data = this.props.reportGrid.nestedGrid || [];
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const tdStyle = { whiteSpace: 'normal', 'font-size':'0.8em'};
        const thStyle = {verticalAlign:'top', whiteSpace: 'normal' };
        const actions = [
            <FlatButton
                label={this.props.local.buttonCaptions.CloseModal}
                primary={true}
                onClick={this.props.handleCloseDialog.bind(this)} />
        ];
        return (
            <div>
                <Dialog
                    title={
                        <div>
                            <img src={closeImage} onClick={this.props.handleCloseDialog.bind(this)} style={closeImg} />
                        </div>
                    }
                    actions={actions}
                    modal={false}
                    autoScrollBodyContent={true}
                    contentStyle={customContentStyle}
                    onRequestClose={this.props.handleCloseDialog.bind(this)}
                    open={this.props.isOpen || false} >
                    <BootstrapTable data={data} striped hover pagination={ true }>
                        <TableHeaderColumn dataField="ImgStatus" headerAlign='center' dataFormat={this.ImageFormatter} dataAlign="center" width='25' tdStyle={tdStyle} thStyle={thStyle}>.</TableHeaderColumn>
                        <TableHeaderColumn dataField="Shipment" headerAlign='center' dataAlign='center' width='100' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Shipment}</TableHeaderColumn>
                        <TableHeaderColumn dataField="DriverName" headerAlign='center' dataAlign={recordpos}  isKey={true} width='200' dataFormat={this.TwoLinesTextFormatter} dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverName}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Cycle" headerAlign='center' dataAlign='center' width='70' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Cycle}</TableHeaderColumn>                                                
                        <TableHeaderColumn dataField="SortOrder" headerAlign='center' dataAlign='center' width='70' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Order}</TableHeaderColumn>
                        <TableHeaderColumn dataField="ActualSortOrder" headerAlign='center' dataAlign='center' width='70' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.ActualSortOrder}</TableHeaderColumn>
                        <TableHeaderColumn dataField="CustomerDesc" headerAlign='center' dataAlign={recordpos} width='100' dataFormat={this.TwoLinesTextFormatter} dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Customer}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Address" headerAlign='center' dataAlign={recordpos} width='100' dataFormat={this.TwoLinesTextFormatter} dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Address}</TableHeaderColumn>
                        <TableHeaderColumn dataField="TravelHours" headerAlign='center' dataAlign='center' width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter} tdStyle={tdStyle} thStyle={thStyle}>{col.TravelHours}</TableHeaderColumn>
                        <TableHeaderColumn dataField="ServiceHours" headerAlign='center' dataAlign='center' width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter} tdStyle={tdStyle} thStyle={thStyle}>{col.ServiceHours}</TableHeaderColumn>
                        <TableHeaderColumn dataField="OriginalTime" headerAlign='center' dataAlign='center' width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter} tdStyle={tdStyle} thStyle={thStyle}>{col.OriginalTime}</TableHeaderColumn>
                        <TableHeaderColumn dataField="DeliveryTime" headerAlign='center' dataAlign='center' width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter} tdStyle={tdStyle} thStyle={thStyle}>{col.DeliveryTime}</TableHeaderColumn>
                        <TableHeaderColumn dataField="Delivery" headerAlign='center' dataAlign='center' width='80' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.Delivery}</TableHeaderColumn>
                        <TableHeaderColumn dataField="AgentReturn" headerAlign='center' dataAlign='center' width='70' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.AgentReturn}</TableHeaderColumn>
                        <TableHeaderColumn dataField="DriverReturn" headerAlign='center' dataAlign={recordpos} width='70' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverReturn}</TableHeaderColumn>
                        <TableHeaderColumn dataField="CollectedSurfaces" headerAlign='center' dataAlign='center' columnClassName={this.columnClassNameFormat} width='100' dataSort={true} tdStyle={tdStyle} thStyle={thStyle}>{col.CollectedSurfaces}</TableHeaderColumn>
                        <TableHeaderColumn dataField="DriverStatus" headerAlign='center' dataAlign={recordpos} dataFormat={this.TwoLinesTextFormatter} tdStyle={tdStyle} thStyle={thStyle}>{col.DriverStatus}</TableHeaderColumn>
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

export default connect(mapStateToProps)(ConcActivityDialog);



