import React, { Component, PropTypes } from 'react';
import { Grid, Row, Col, Panel, Button, Table  } from 'react-bootstrap';
import { connect } from 'react-redux';
import { BuildGrid, PopulateGrid } from './grid.component.run';
import { DialogComponent } from './gridDialog.component';
import { fetchReportGridColums, fetchReportGridData } from '../../../redux/actions/reportGrid';



class Datatable extends Component {
      
    constructor(props) {
        super(props);
        this.state = {
            gridMointed: false,
            filter: this.props.filter
        };
    }

    mountTable() {
        let colums = this.props.reportGrid.gridColums || [];
        let gridColums = colums.map(colum => { return { 
            mData: colum.ColName,
            sWidth: colum.ColWidth+'%' 
        }});
        BuildGrid(gridColums);
        this.setState({ gridMointed: true });
    }

    componentDidUpdate(){
        if(!this.state.gridMointed && this.props.reportGrid.gridColums) {
            this.mountTable();
        }
    }

    
    componentDidMount() {        
        this.props.dispatch(fetchReportGridColums(this.state.filter));
        this.props.dispatch(fetchReportGridData(this.state.filter));

        $('#tlbConcentrationActivity tbody').on('dblclick', 'tr', function (e) {
            var tbl = $('#tlbConcentrationActivity').dataTable();              
            var aData = tbl.fnGetData(tbl.fnGetPosition(this));
            var iId = aData.AgentId;
        });   
    }


    render() {
        let colums = this.props.reportGrid.gridColums || [];
        let data = null;
        if(this.state.gridMointed && this.props.reportGrid.gridData) {
            data = this.props.reportGrid.gridData;
            PopulateGrid(data);            
        }

        return (
                <Grid fluid>                 
                    <Row>
                        <Col lg={ 12 }>
                            <Panel>
                                <Table id="tlbConcentrationActivity" bordered responsive striped hover>
                                    <thead>
                                        <tr>
                                            {
                                                colums.map(colum => <th key={colum.ReportColID}>{colum.ColCaption}</th>)
                                            }
                                        </tr>
                                    </thead>
                                    <tbody>
                                         
                                    </tbody>
                                </Table>
                             </Panel>
                        </Col>
                   </Row>
            </Grid>
    );
                                        }

}

Datatable.defaultProps = {
    reportGrid: {}
};
const mapStateToProps = (state) => ({
    local: state.local,
    reportGrid: state.reportGrid,
    gridData : state.reportGrid.gridData
});


export default connect(mapStateToProps)(Datatable) ;
