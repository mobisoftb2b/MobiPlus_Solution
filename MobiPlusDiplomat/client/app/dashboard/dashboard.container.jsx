import React, { Component } from 'react';
import { Grid, Row, Col, Dropdown, MenuItem, Panel, Tab, Tabs } from 'react-bootstrap';
import { connect } from 'react-redux';
import { fetchCountry, fetchDistribution, fetchDrivers } from '../../redux/actions/cascade';
import { fetchReportGridColums, fetchReportGridData, fetchEndDayGridData } from '../../redux/actions/reportGrid';
import ContentWrapper from '../../share/components/Layout/ContentWrapper';
//---------------------- Componemts ---------------------------//
import ConcActivity from './concentrationActivity/concActivity.component';
import DriverStatusGrid from './driverStatus/driverStatus.component';
import EndDayComponentGrig from './endDay/endDay.component';
import FilterDropdown from './filter.component';
import CollectionNotes from './collectionNotes/collectionNotes.component';
import DriverReportContainer from './driverReport/driverReport.container';
//---------------------- Widgets ---------------------------//
import NotFullDeliveryWidget from './widgets/unDeliveryWidget.component';
import RadialWidget from './widgets/radialWidget.component';
import DeliveryWidget from './widgets/deliveryWidget.component';
import AgentReturnWidget from './widgets/agentReturnWidget.component';
import TaskWidget from './widgets/taskWidget.component';
import NotVisitedWidget from './widgets/unVisitedWidget.component';
//---------------------- Filter ---------------------------//
import { changeFilter } from '../../redux/actions/filter';
import MapContainer from './map/map.container';

const lgHidden = [];	

class DashboardContainer extends Component {
    constructor(props, context) {
        super(props, context);
        this.state = {
            key: 1,
            mountOnEnter: true,
            unmountOnExit: true
        };

    }
    handleSelect(key) {
        if(key==3)this.props.dispatch(changeFilter(this.props.filter));
        this.setState({
            key
        });
    }

    componentDidMount() {
        this.props.dispatch(fetchCountry(this.props.filter));
        this.props.dispatch(fetchDistribution(this.props.filter));
        this.props.dispatch(fetchDrivers(this.props.filter));
        this.props.dispatch(fetchReportGridData(this.props.filter));
        this.props.dispatch(fetchEndDayGridData(this.props.filter));
    }

    renderFilter() {
        return (<div><FilterDropdown HiddenColName={lgHidden} noCaret initFilterData={this.props.filterData} /></div>);
    }

    renderGrid() {
        return (<div><ConcActivity gridData={this.props.gridData} /></div>);
    }

    renderDriverStatusGrid() {
        return (<div><DriverStatusGrid /></div>);
    }

    renderEndDayComponentGrig() {
        return (<div><EndDayComponentGrig /></div>);
    }

    renderDriverReportGrid(){
        return <DriverReportContainer />;
    }

    render() {
        let local = this.props.local;
        let cid = this.props.user.FilterParams.CountryID;
        const style = {
            display:cid==1000?'none':'block'
        }
        return (
            <div>
                <ContentWrapper>
                    <Tabs activeKey={this.state.key} onSelect={this.handleSelect.bind(this)} justified id="tabID">
                        <Tab eventKey={1} title={local.dashboard.tabs.MAIN}>
                            <Row>
                                <Col lg={1}>{this.renderFilter()}</Col>
                            </Row>
                            <Row >
                                <Col lg={2}>
                                    <RadialWidget />
                                </Col>
                                <Col lg={2}>
                                    <DeliveryWidget />
                                </Col>
                                <Col lg={2}>
                                    <AgentReturnWidget />
                                </Col>
                                <Col lg={2}>
                                    <TaskWidget />
                                </Col>
                                <Col lg={2}>
                                    <NotFullDeliveryWidget />
                                </Col>
                                <Col lg={2}>
                                    <NotVisitedWidget />
                                </Col>
                            </Row>
                            <Row >
                                <Col md={12} >{this.renderGrid(this.state)}</Col>
                            </Row>
                        </Tab>
                        <Tab eventKey={2} title={local.dashboard.tabs.DRIVERSTATUS}>
                            <Row>
                                <Col lg={1}>{this.renderFilter()}</Col>
                            </Row>
                            <Row >
                                <Col md={12} >{this.renderDriverStatusGrid()}</Col>
                            </Row>
                        </Tab>
                        <Tab eventKey={3} title={local.dashboard.tabs.MAP}>
                            <Row>
                                <Col lg={9}>{this.renderFilter()}</Col>
                            </Row>
                            <Row>
                                <Col lg={11}><div style={{height: '100vh'}}><MapContainer /></div> </Col>
                            </Row>
                        </Tab>           
                        <Tab eventKey={4} title={local.dashboard.tabs.ENDDAY}>
                           <Row>
                                <Col lg={1}>{this.renderFilter()}</Col>
                            </Row>
                            <Row >
                                <Col md={12} >{this.renderEndDayComponentGrig()}</Col>
                            </Row>
                        </Tab>
                         <Tab eventKey={5} title={local.dashboard.tabs.COLLECTIONNOTES}>
                           <Row>
                                <Col lg={1}>{this.renderFilter()}</Col>
                            </Row>
                            <Row >
                                <Col md={12} ><CollectionNotes/></Col>
                            </Row>
                        </Tab>
                        <Tab eventKey={6} title={local.dashboard.tabs.DRIVERREPORT}>
                           <Row>
                                <Col lg={1}>{this.renderFilter()}</Col>
                            </Row>
                            <Row >
                                <Col md={12} >{this.renderDriverReportGrid()}</Col>
                            </Row>
                        </Tab>
                    </Tabs>
                </ContentWrapper>
            </div>
        );
    }
}

function mapStateToProps(state, action) {
    return {
        widget: state.dashboard.widget,
        local: state.local,
        gridData: state.reportGrid.gridData,
        filterData: state.filterData,
        filter: state.filter,
        user: state.auth.user
    };
}

export default connect(mapStateToProps)(DashboardContainer);