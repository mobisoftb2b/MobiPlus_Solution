import React, {Component} from 'react';
import {connect} from 'react-redux';
import {Grid, Row, Col, Panel} from 'react-bootstrap';
import Dialog from 'material-ui/Dialog';
import FlatButton from 'material-ui/FlatButton';
import {BootstrapTable, TableHeaderColumn} from 'react-bootstrap-table';
import {fetchCustomersDetailsGridData} from '../../../redux/actions/reportGrid';


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

class CustomersDialog extends Component {
    constructor(props) {
        super(props);
        this.state = {
            open: this.props.isDialogOpen || false
        };
    }

    componentDidMount() {
        let rowData = this.props.aData || {};
        this.props.dispatch(fetchCustomersDetailsGridData(rowData));
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.isDialogOpen !== this.state.open) {
            this.setState({open: nextProps.isDialogOpen});
            this.props.dispatch(fetchCustomersDetailsGridData(nextProps.aData));
        }
    }

    ImageFormatter(cell, row) {
        let src = `../../public/img/${cell}.png`;
        return (
            <img src={src} width='15px'/>
        );
    }

    TwoLinesTextFormatter(cell, row) {
        if (cell)
            return cell.replace('^', "<br />");
        return '';

    }

    render() {
        const col = this.props.local.customerGrid;
        const data = this.props.reportGrid.custDetailsData || [];
        const tdStyle = { whiteSpace: 'normal', 'font-size':'0.9em'};
        const thStyle = {verticalAlign:'top', whiteSpace: 'normal' };
        const recordpos = this.props.local.langSettings.shortLang == "he" ? 'right' : 'left';
        const actions = [
            <FlatButton
                label={this.props.local.buttonCaptions.CloseModal}
                primary={true}
                onClick={this.props.handleCloseDialog.bind(this)}/>
        ];
        return (
            <div>
                <Dialog
                    title={
                        <div>
                            <img src={closeImage} onClick={this.props.handleCloseDialog.bind(this)} style={closeImg}/>
                        </div>
                    }
                    actions={actions}
                    modal={false}
                    autoScrollBodyContent={true}
                    contentStyle={customContentStyle}
                    onRequestClose={this.props.handleCloseDialog.bind(this)}
                        open={this.props.isDialogOpen || false}>
                    <BootstrapTable data={data} striped hover>
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="ImgStatus" headerAlign='center'dataFormat={this.ImageFormatter} dataAlign="center" width='25'>.</TableHeaderColumn>
                        <TableHeaderColumn dataField="Shipment" tdStyle={tdStyle} thStyle={thStyle} headerAlign='center' width='80px' dataAlign='center' dataSort={true}>{col.Shipment}</TableHeaderColumn>
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="DriverName" headerAlign='center'dataAlign='center' width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.DriverName}</TableHeaderColumn>  
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="Customer" headerAlign='center' dataAlign={recordpos} isKey={true} width='200' dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.Customer}</TableHeaderColumn>   
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="CustomerAddress"headerAlign='center' dataAlign='center' width='70' dataSort={true}>{col.CustAddress}</TableHeaderColumn>
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="TaskDescription" headerAlign='center' dataAlign={recordpos} width='100' dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.TaskDescription}</TableHeaderColumn>
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="DeliveryNum" headerAlign='center' dataAlign={recordpos} width='100' dataFormat={this.TwoLinesTextFormatter} dataSort={true}>{col.DeliveryNum}</TableHeaderColumn>
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="Comment" headerAlign='center' dataAlign='center' width='70' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.Comment}</TableHeaderColumn>
                        <TableHeaderColumn tdStyle={tdStyle} thStyle={thStyle} dataField="Description" headerAlign='center' dataAlign='center' width='100' dataSort={true} dataFormat={this.TwoLinesTextFormatter}>{col.Description}</TableHeaderColumn>
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

export default connect(mapStateToProps)(CustomersDialog);



