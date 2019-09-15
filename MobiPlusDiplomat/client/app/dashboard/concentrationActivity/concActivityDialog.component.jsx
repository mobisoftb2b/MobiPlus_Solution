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

    render() {
        const col = this.props.local.concActivityGrid;
        const data = this.props.reportGrid.nestedGrid || [];
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const actions = [
            <FlatButton
                label={this.props.local.buttonCaptions.CloseModal}
                primary={true}
                onTouchTap={this.props.handleCloseDialog.bind(this)} />
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
                    open={this.props.isOpen} >
                    <BootstrapTable data={data} striped hover>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="ImgStatus" headerAlign='center' dataFormat={this.ImageFormatter} dataAlign="center" width='25' >.</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="Shipment" headerAlign='center' dataAlign='center' width='100' dataSort={true}>{col.Shipment}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="DriverName" headerAlign='center' dataAlign={recordpos}  isKey={true} width='200' dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.DriverName}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="ActualSortOrder" headerAlign='center' dataAlign={recordpos} width='70' dataSort={true}>{col.ActualSortOrder}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="Customer" headerAlign='center' dataAlign={recordpos} width='100' dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.Customer}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="Address" headerAlign='center' dataAlign={recordpos} width='100' dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.Address}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="TravelHours" headerAlign='center' dataAlign={recordpos} width='70' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.TravelHours}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="ServiceHours" headerAlign='center' dataAlign={recordpos} width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.ServiceHours}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="OriginalTime" headerAlign='center' dataAlign={recordpos} width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.OriginalTime}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="DeliveryTime" headerAlign='center' dataAlign={recordpos} width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.DeliveryTime}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="Delivery" headerAlign='center' dataAlign={recordpos} width='100' dataSort={true}>{col.Delivery}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="AgentReturn" headerAlign='center' dataAlign={recordpos} width='100' dataSort={true}>{col.AgentReturn}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="DriverReturn" headerAlign='center' dataAlign={recordpos} width='100' dataSort={true}>{col.DriverReturn}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="CollectedSurfaces" headerAlign='center' dataAlign={recordpos} width='100' dataSort={true}>{col.CollectedSurfaces}</TableHeaderColumn>
                        <TableHeaderColumn thStyle={{'verticalAlign':'top'}} dataField="DriverStatus" headerAlign='center' dataAlign={recordpos} dataFormat={this.TwoLinesTextFormatter}>{col.DriverStatus}</TableHeaderColumn>
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



