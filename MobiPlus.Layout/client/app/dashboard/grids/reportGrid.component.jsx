import React, { Component } from 'react';
import { Grid, Row, Col } from 'react-bootstrap';
import { connect } from 'react-redux';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { fetchReportGridColums, fetchReportGridData } from '../../../redux/actions/reportGrid';


class ReportGridComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            filter: this.props.filter
        };
    }

    componentDidMount(){
        this.props.dispatch(fetchReportGridColums(this.props.filter));
        this.props.dispatch(fetchReportGridData(this.props.filter));
    }
    
    renderGrid(){
        let colums = this.props.reportGrid.gridColums || [];
        //<TableHeaderColumn dataField="DeliveryStatus" thStyle={{ 'verticalAlign': 'top' }} dataAlign={recordpos} headerAlign='center' width='100' dataSort={true}>{col.DeliveryStatus}</TableHeaderColumn>
        if(this.state.gridMointed && this.props.reportGrid.gridData) {
            return colums.map(colum => 
                <TableHeaderColumn 
                    key={colum.ReportColID} 
                    dataField={}
                    dataAlign={recordpos} 
                    headerAlign='center' 
                    width='100' 
                    dataSort={true}>
                        {colum.ColCaption}
                </TableHeaderColumn>)            
        }
    }

    render(){
        let data = this.props.reportGrid.gridData;
        return 
        <div> 
            <BootstrapTable data={data} striped hover condensed search pagination>
               {this.renderGrid()}
            </BootstrapTable>
        </div>;
    }
}

const mapStateToProps = (state) => ({
    local: state.local,
    reportGrid: state.reportGrid,
    gridData : state.reportGrid.gridData
});


export default connect(mapStateToProps)(ReportGridComponent) ;