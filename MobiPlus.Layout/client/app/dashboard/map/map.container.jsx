import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { fetchTrucksData, fetchVisitData, fetchRoadsData, getMaps, getVisitCoord, getRoadsCoord } from '../../../redux/actions/maps';
import { Grid, Row, Col, Panel, Button, Table } from 'react-bootstrap';
import DriverList from '../../task/driverList.component';
import ContentWrapper from '../../../share/components/Layout/ContentWrapper';
import MapComponent from './googleMap.component';
//import MapComponent from './nativeMap.component';


class MapContainer extends Component {
    constructor(props, context) {
        super(props, context);
        this.state = {
            showingInfoWindow: false,
            activeMarker: {},
            selectedPlace: {},
            IsTrucks: true,
            IsVisits: false,
            IsRoads: false,
            agentID: null,
            filter: this.props.filter
        };
    }

    componentDidMount() {
        this.props.dispatch(fetchTrucksData(this.props.filter));
    }

    componentWillReceiveProps(nextProps) {
        let state = this.state.filter;
        if (nextProps.filter !== state) {
            if(this.state.IsTrucks) this.props.dispatch(fetchTrucksData(nextProps.filter));
            if(this.state.IsVisits) this.props.dispatch(fetchVisitData(nextProps.filter));
            if(this.state.IsRoads) this.props.dispatch(fetchRoadsData(nextProps.filter));
            this.setState({ filter: nextProps.filter });
        }
    }

    handleRequestChange = (event, index) => {
        let filter = this.props.filter || {};
        filter.AgentID = index;
        this.setState({ agentID: index });
        if(this.state.IsTrucks) this.props.dispatch(fetchTrucksData(filter));
        if(this.state.IsVisits) this.props.dispatch(fetchVisitData(filter));
        if(this.state.IsRoads)this.props.dispatch(fetchRoadsData(filter));
    }

    //=========================================================================================================
    handleTrucksChange = (event) => {
        const target = event.target;
        let value = target.type === 'checkbox' ? target.checked : target.value;
        this.setState({IsTrucks:value});
        if (value){ 
            this.props.dispatch(fetchTrucksData(this.props.filter));            
        }else{
            this.props.dispatch(getMaps([])); 
        }

    }
    handleVisitsChange = (event) => {
        const target = event.target;
        let value = target.type === 'checkbox' ? target.checked : target.value;
        this.setState({IsVisits:value});
        if (value) {
            this.props.dispatch(fetchVisitData(this.props.filter));
        } else{
            this.props.dispatch(getVisitCoord([])); 
        }
    }
    handleRoadsChange = (event) => {
        const target = event.target;
        let value = target.type === 'checkbox' ? target.checked : target.value;
        this.setState({IsRoads:value});
        if (value) {
            this.props.dispatch(fetchRoadsData(this.props.filter));
        }
        else{
            this.props.dispatch(getRoadsCoord([]));
        }
    }
    //=========================================================================================================

    onInfoWindowClose() {
        this.setState({
            showingInfoWindow: false,
            activeMarker: null
        });
    }


    renderDriverList() {
        return (<DriverList handleRequestChange={this.handleRequestChange.bind(this)} />);
    }

    renderMap(mapData){
        return (<MapComponent mapData={mapData} />);
    }

    render() {
        return (
            <ContentWrapper>
                <Col lg={2}>
                    <Row>
                        <Panel>
                            <Row>
                                <Col sm={10}>
                                    <div className="form-group">
                                        <Col sm={4}>
                                            <label className="switch">
                                                <input type="checkbox" defaultChecked onChange={this.handleTrucksChange.bind(this)} />
                                                <em></em>
                                            </label>
                                        </Col>
                                        <Col sm={8}>
                                            <label className="control-label">{this.props.local.mapsSettings.TrucksView}</label>
                                        </Col>
                                    </div>
                                </Col>
                            </Row>
                            <Row>
                                <Col sm={10}>
                                    <div className="form-group">
                                        <Col sm={4}>
                                            <label className="switch">
                                                <input type="checkbox" onChange={this.handleVisitsChange.bind(this)} />
                                                <em></em>
                                            </label>
                                        </Col>
                                        <Col sm={8}>
                                            <label className="control-label">{this.props.local.mapsSettings.VisitView}</label>
                                        </Col>
                                    </div>
                                </Col>
                            </Row>
                            <Row>
                                <Col sm={10}>
                                    <div className="form-group">
                                        <Col sm={4}>
                                            <label className="switch">
                                                <input type="checkbox" onChange={this.handleRoadsChange.bind(this)} />
                                                <em></em>
                                            </label>
                                        </Col>
                                        <Col sm={8}>
                                            <label className="control-label">{this.props.local.mapsSettings.RoadsView}</label>
                                        </Col>
                                    </div>
                                </Col>
                            </Row>
                        </Panel>
                    </Row>
                    <Row>
                        <Panel>
                            {this.renderDriverList()}
                        </Panel>
                    </Row>
                </Col>
                <Col lg={10}>
                    <Panel bsClass='gmap'>
                            {this.renderMap(this.props.mapData)}
                    </Panel>
                </Col>
            </ContentWrapper >
        );
    }
}

const mapStateToProps = (state) => ({
    local: state.local,
    filter: state.filter,
    user: state.auth.user,
    mapData: state.mapData
});

//const WrappedContainer = GoogleApiWrapper({
//    apiKey: ("AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk")
//})(MapContainer);

export default connect(mapStateToProps)(MapContainer);






