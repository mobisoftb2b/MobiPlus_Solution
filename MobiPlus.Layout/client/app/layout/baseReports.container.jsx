import React, { Component, PropTypes } from 'react';
import { Grid, Row, Col, Dropdown, MenuItem, Panel  } from 'react-bootstrap';
import { connect } from 'react-redux';
import * as CONST from '../../share/components/Common/constants';

import JqGrid from '../dashboard/grids/grid.component';
import WidgetContainer from '../dashboard/widgets/widget.container';


class BaseReportContainer extends Component{
    constructor(props, context) {
        super(props, context);
    }
    
    getNeededReportByType(report) {
        let rt = report.data.Report.ReportTypeID || 0;
        switch (rt) {
            case CONST.REP_REPORTS.REP_GRID_REPORT:
                return (<div className="directionGrid2"><JqGrid /></div>);
            case CONST.REP_REPORTS.REP_COMPILED:
                return (<div className="directionGrid2"></div>);
            case CONST.REP_REPORTS.REP_WEBCONTROL:
                return (<div className="directionGrid2"></div>);
            case CONST.REP_REPORTS.REP_DASHBOARD_WIDGET:
                return (<div className="directionGrid2"><WidgetContainer key={report.data.Report.ReportID} reportsData={report.data}  /></div>);
            case CONST.REP_REPORTS.REP_DESIGN_WIDGET:
                return (<div className="directionGrid2"><WidgetContainer reportsData={report.data}/></div>);
        }
        return report.i;
    }

    render() {
        let el = this.props.reportsData;
        return (
            <span>{this.getNeededReportByType(el)}</span>
            );
    }

}


function mapStateToProps(state,action) {
    return {
        local: state.local
    };
}


export default connect(mapStateToProps)(BaseReportContainer)