/// <reference path="../../../share/components/Common/utils.js" />
import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import InitDriveMap, {InitTrucks} from './map.container.run';
import MapRun from './map.container.run';
import Utils from '../../../share/components/Common/utils';


const iconUrl = '../../../../public/img/truck2.png';
const Gray = '../../../../public/img/Gray.png';
const Green = '../../../../public/img/Green.png';
const Orange = '../../../../public/img/Orange.png';
const Red = '../../../../public/img/Red.png';


class NativeGoogleMapsComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            markers: []
        }           
        this.map = {};
        this.directionsService = new google.maps.DirectionsService({
            suppressMarkers: true
        });
        this.directionsDisplay = new google.maps.DirectionsRenderer;

        this.handleMarkerClick = this.handleMarkerClick.bind(this);
        this.handleCloseClick = this.handleCloseClick.bind(this);
    }

    loadMapMarkers(mapData) {
        let markers = this.transformMarkers(mapData);
        let visitData = this.transformVisitData(mapData);
        this.setState({ markers: [...markers, ...visitData] });
        //TruckVisit(this.map, this.state.markers);
        this.transformRouteData(mapData);
    }

    transformMarkers(mapData) {
        let markersData = mapData.mapTruckData || [];
        let location;
        if (markersData.length > 0) {
            location = new google.maps.LatLng(parseFloat(markersData[0].DriverGPSLocation.Lat), parseFloat(markersData[0].DriverGPSLocation.Lng));
            this.map.panTo(location);
        }
        return markersData.map(a => ({
            position: {
                lat: parseFloat(a.DriverGPSLocation.Lat),
                lng: parseFloat(a.DriverGPSLocation.Lng),
            },
            icon: iconUrl,
            title: `${a.DriverName} - ${a.DriverID}`,
            content: a.DriverGPSLocation.Comment,
            key: a.DriverID,
            defaultAnimation: 2,
        }));
    }

    transformVisitData(mapData) {

        let markersData = mapData.mapVisitData || [];
        let location;
        if (markersData.length > 0) {
            location = new google.maps.LatLng(parseFloat(markersData[0].Location.Lat), parseFloat(markersData[0].Location.Lng));
            //this.map.panTo(location);
        }
        return markersData.map(a => ({
            position: {
                lat: parseFloat(a.Location.Lat),
                lng: parseFloat(a.Location.Lng),
            },
            icon: this.getIcon(a.Color),
            title: `${a.CustomerName} - ${a.CustomerID}`,
            content: a.Location.Comment,
            key: a.CustomerID,
            defaultAnimation: 2,
        }));

    }

    transformRouteData(mapData) {         
        let routeData = mapData.mapRoadsData || [], path = typeof path !== 'undefined' ? path : [];
        
        let waypoints = [];
        const resultRouts = _.groupBy(routeData, 'AgentId');
       
        InitDriveMap(this.map,this.directionsService, this.directionsDisplay, resultRouts);
    }

    getIcon(color) {
        switch (color) {
            case "Red":
                return Red;
            case "Gray":
                return Gray;
            case "Green":
                return Green;
            case "Orange":
                return Orange;
        }
    }


    componentDidMount() {
        this.map = new google.maps.Map(document.getElementById("dvMap"),{
            center: new google.maps.LatLng(32.2777255, 34.8614782),
            zoom: 10,
            scrollwheel: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        google.maps.event.addListenerOnce(this.map, 'idle', function(){
            google.maps.event.trigger(this.map, "resize");  
        });
        this.loadMapMarkers(this.props.mapData);  
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.mapData.mapTruckData !== this.props.mapData.mapTruckData ||
            nextProps.mapData.mapVisitData !== this.props.mapData.mapVisitData ||
            nextProps.mapData.mapRoadsData !== this.props.mapData.mapRoadsData) {
            google.maps.event.trigger(this.map, "resize"); 
            this.loadMapMarkers(nextProps.mapData);
        }
    }
    handleWindowResize() {
        const nextCenter = this.map.getCenter();
        console.log( 'nextCenter: ' + JSON.stringify(nextCenter) );
        google.maps.event.trigger(this.map, "resize");          
    }

    handleCloseClick(targetMarker) {
        this.setState({
            markers: this.state.markers.map(marker => {
                if (marker === targetMarker) {
                    return {
                        ...marker,
                            showInfo: false,
                    };
            }
                return marker;
    }),
});
}

handleMarkerClick(targetMarker) {
    this.setState({
        markers: this.state.markers.map(marker => {
            if (marker === targetMarker) {
                return {
                    ...marker,
                        showInfo: true,
                };
        }
            return marker;
}),
});
}

render() {
    return (
        <div id='mapContainer' style={{ height: `750px`, width: `100%` }}>
           <div id="dvMap" className='dvMap' style={{ height: `750px`, width: `100%` }} /> 
</div>
        );
}
}

const mapStateToProps = (state) => ({
    local: state.local,
    filter: state.filter,
    user: state.auth.user,
    mapData: state.mapData
});


export default connect(mapStateToProps)(NativeGoogleMapsComponent);

