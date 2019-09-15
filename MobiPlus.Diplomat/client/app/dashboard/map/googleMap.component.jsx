import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import { withGoogleMap, GoogleMap, Marker, InfoWindow, DirectionsRenderer } from "react-google-maps";
import { TwoLinesTextFormatter } from '../../../share/components/Common/common';
import { fetchFilter } from '../../../redux/actions/filter';

const loader = "../../../../public/img/loading.gif";
const iconUrl = '../../../../public/img/truck2.png';
const Gray = '../../../../public/img/Gray.png';
const Green = '../../../../public/img/Green.png';
const Orange = '../../../../public/img/Orange.png';
const Red = '../../../../public/img/Red.png';

const mapContainer = <div style={{ height: "90vh", width: "100%" }} />

class GoogleMapsComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            markers: [],
            zoom: 10,
            directions: [],
            location: {}
        }
        this.map = {};
        this.handleMarkerClick = this.handleMarkerClick.bind(this);
        this.handleCloseClick = this.handleCloseClick.bind(this);
    }


    loadMapMarkers(mapData) {
        let markers = this.transformMarkers(mapData);
        let visitData = this.transformVisitData(mapData);
        this.setState({ markers: [...markers, ...visitData] });
        if (this.props.filter.AgentID) this.transformRouteData(mapData);
    }

    transformMarkers(mapData) {
        let markersData = mapData.mapTruckData || [];
        let location;
        if (markersData.length > 0) {
            location = new google.maps.LatLng(parseFloat(markersData[0].DriverGPSLocation.Lat), parseFloat(markersData[0].DriverGPSLocation.Lng));
            this.setState({ location: location });
        }
        else {
            location = this.getStatesCoord();
            this.setState({ location: location });
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
            this.setState({ location: location });
        }
        return markersData.map(a => ({
            position: {
                lat: parseFloat(a.Location.Lat),
                lng: parseFloat(a.Location.Lng),
            },
            icon: this.getIcon(a.Color),
            title: `${a.CustomerName} - ${a.CustomerID}`,
            content: TwoLinesTextFormatter(a.Location.Comment),
            key: a.CustomerID,
            defaultAnimation: 2,
        }));
    }

    transformRouteData(mapData) {
        let routeData = mapData.mapRoadsData || [];
        this.setState({ directions: [] });
        const directionsService = new google.maps.DirectionsService();
        //const result = _.groupBy(routeData, 'AgentId');
        var chunk_size = 23;
        if (routeData.length > 0) {

            var routesGroups = routeData.map(function (e, i) {
                return i % chunk_size === 0 ? routeData.slice(i, i + chunk_size) : null;
            }).filter(function (e) {
                return e;
            });


            const fetchGroup = () => {
                let waypoints = [];
                console.log(routesGroups.length);
                var group = routesGroups.pop();
                group.forEach(value => {
                    try {
                        waypoints.push({ location: new google.maps.LatLng(value.Location.Lat, value.Location.Lng) });
                    }
                    catch (e) {
                        console.log(e.message);
                    }
                });

                directionsService.route({
                    origin: waypoints.shift().location,
                    destination: waypoints.pop().location,
                    travelMode: google.maps.TravelMode.DRIVING,
                    waypoints: waypoints,
                    travelMode: google.maps.TravelMode.DRIVING,
                    unitSystem: google.maps.UnitSystem.METRIC,
                    optimizeWaypoints: false,
                    provideRouteAlternatives: false,
                    avoidHighways: false,
                    avoidTolls: false
                }, (result, status) => {
                    if (status === google.maps.DirectionsStatus.OK) {
                        console.log(result);
                        this.setState({ directions: [...this.state.directions, result] });
                        if (routesGroups.length > 0) {
                            fetchGroup();
                        }
                    }
                });
            };
            fetchGroup();
        }
        else {
            this.setState({ directions: [] })
        }

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

    getRandomColor() {
        var letters = '0123456789ABCDEF';
        var color = '#';
        for (var i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return '#0119cb';
    }

    getStatesCoord() {
        if (this.props.filter) {
            let countryCoord = this.props.filter.CountryLanLng;
            let arrLatLng = countryCoord.split(',');
            return new google.maps.LatLng(parseFloat(arrLatLng[0]), parseFloat(arrLatLng[1]));
        }
    }


    componentDidMount() {
        this.props.dispatch(fetchFilter());
        this.loadMapMarkers(this.props.mapData);
        this.setState({
            location: this.getStatesCoord(),
            directions: []
        });
    }


    componentWillReceiveProps(nextProps) {
        if (nextProps.mapData.mapTruckData !== this.props.mapData.mapTruckData ||
            nextProps.mapData.mapVisitData !== this.props.mapData.mapVisitData ||
            nextProps.mapData.mapRoadsData !== this.props.mapData.mapRoadsData) {
            this.loadMapMarkers(nextProps.mapData);
        }
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

    handleMapLoad(map) {
        if (map) {
            this.map = map;
            map.panTo(this.state.location);
        }
    }

    render() {
        let color = this.getRandomColor();
        const ContainerGoogleMap = withGoogleMap(props => (
            <GoogleMap
                ref={props.onMapLoad}
                zoom={props.zoom}
                center={props.defaultCenter}
                onClick={props.onMapClick}>
                {props.markers.map((marker, index) => {
                    const onClick = () => props.onMarkerClick(marker);
                    const onCloseClick = () => props.onCloseClick(marker);
                    return (
                        <Marker
                            key={index}
                            position={marker.position}
                            labelContent={marker.title}
                            labelAnchor={new google.maps.Point(34, 0)}
                            icon={marker.icon}
                            title={marker.title}
                            onClick={onClick}>
                            {marker.showInfo && (
                                <InfoWindow onCloseClick={onCloseClick}>
                                    <div>
                                        {marker.content}
                                    </div>
                                </InfoWindow>
                            )}
                        </Marker>
                    );
                })}
                {
                    props.routes.map(route => <DirectionsRenderer
                        options={{ suppressMarkers: true, polylineOptions: { strokeColor: props.routeColor } }}
                        directions={route} />)
                }
            </GoogleMap>
        ));
        return (
            <div>
                <ContainerGoogleMap
                    loadingElement={
                        <div className="loader">
                            <img src={loader} alt="loading" />
                        </div>
                    }
                    containerElement={<div style={{ height: `750px` }} />}
                    mapElement={<div style={{ height: `750px` }} />}
                    zoom={this.state.zoom}
                    routeColor={color}
                    routes={this.state.directions}
                    onMapLoad={this.handleMapLoad.bind(this)}
                    markers={this.state.markers}
                    onMarkerClick={this.handleMarkerClick}
                    onCloseClick={this.handleCloseClick}
                />
            </div>
        );
    }
}


const mapStateToProps = (state) => ({
    local: state.local,
    filter: state.filter,
    user: state.auth.user,
    mapData: state.mapData,
    filterData: state.filterData
});


export default connect(mapStateToProps)(GoogleMapsComponent);

