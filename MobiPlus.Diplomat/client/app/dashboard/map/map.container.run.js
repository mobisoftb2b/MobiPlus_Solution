import _ from 'lodash';
const image = '../../../../public/img/roadPin.png';

export default (map, directionsService, directionsDisplay,  allPoints) => {
    const _map = map;
    const bounds = new google.maps.LatLngBounds();
    const result = _.groupBy(allPoints, 'AgentId');
   

    let polyline = [];
    $.each(allPoints, function(i, value){
        try {
            var col = getRandomColor();//'rgb(' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ')';
            DirRequest(directionsService, directionsDisplay, value, function (path) {
                polyline.push(new google.maps.Polyline({
                    clickable: false,
                    map: _map,
                    path: path,
                    strokeColor: col,
                    strokeOpacity: 1,
                    strokeWeight: 5
                }));
            });
        } catch (e) {
            console.log(e.message);
        }
    });

    //_.find(virt, (obj) => { return obj.WidgetType === item.WidgetType; });

    function DirRequest (service, directionsDisplay, travelWaypoints, userFunction, waypointIndex, path) {
        var waypoints = [];

        var stepDisplay = new google.maps.InfoWindow;
        $.each(travelWaypoints, function (i, value) {
            try {
                const location = new google.maps.LatLng(value.Location.Lat, value.Location.Lng);
                waypoints.push({ location: new google.maps.LatLng(value.Location.Lat, value.Location.Lng) });
                let marker = new google.maps.Marker({
                    position: location,
                    icon: image,
                    map: _map,
                    zIndex: 1,
                    title: value.Location.Comment
                });
                _map.panTo(location);
            } 
            catch (e) { 
                console.log(e.message); 
            }
        });
        waypointIndex = typeof waypointIndex !== 'undefined' ? waypointIndex : 0;
        path = typeof path !== 'undefined' ? path : [];

        var s = DirGetNextSet(waypoints, waypointIndex);
        var startl, endl, request;

        try {
            startl = s[0].shift()['location'];
            endl = s[0].pop()['location'];
            map.setCenter(startl);
            //map.setZoom(9);
            request = {
                origin: startl,
                destination: endl,
                waypoints: s[0],
                travelMode: google.maps.TravelMode.DRIVING,
                unitSystem: google.maps.UnitSystem.METRIC,
                optimizeWaypoints: false,
                provideRouteAlternatives: false,
                avoidHighways: false,
                avoidTolls: false
            };
        } catch (e) {
            console.log(e.message);
        }
        //console.log(request);

        try {
            service.route(request, function (response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    path = path.concat(response.routes[0].overview_path);
                    directionsDisplay.setDirections(response);
                    if (s[1] != null) {
                        setTimeout(DirRequest(service, directionsDisplay, travelWaypoints, userFunction, s[1], path), 200);
                    } else {
                        userFunction(path);
                    }

                } else {
                    console.log(status);
                }

            });
        } catch (e) {
            console.log(e.message);
        }
    }

    function DirGetNextSet(waypoints, startIndex) {
        var MAX_WAYPOINTS_PER_REQUEST = 8;

        var w = [];

        if (startIndex > waypoints.length - 1) { return [w, null]; }
        var endIndex = startIndex + MAX_WAYPOINTS_PER_REQUEST;
        endIndex += 2;
        if (endIndex > waypoints.length - 1) { endIndex = waypoints.length; }

        for (let i = startIndex; i < endIndex; i++) {
            w.push(waypoints[i]);
        }

        if (endIndex != waypoints.length) {
            return [w, endIndex -= 1];
        } else {
            return [w, null];
        }
    }

    function getRandomColor () {
        var letters = '0123456789ABCDEF';
        var color = '#';
        for (var i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    }

    function DrawRoute(routeData, directionsService, bounds, polylines, pathColor) {
        for (let i = 0; i < routeData.length; i++) {
            if ((i + 1) < routeData.length) {
                var src = new google.maps.LatLng(parseFloat(routeData[i].Location.Lat),
                          parseFloat(routeData[i].Location.Lng));
                var des = new google.maps.LatLng(parseFloat(routeData[i + 1].Location.Lat),
                  parseFloat(routeData[i + 1].Location.Lng));
                try {
                    directionsService.route({
                        origin: src,
                        destination: des,
                        travelMode: google.maps.DirectionsTravelMode.DRIVING
                    }, function (result, status) {
                        if (status == google.maps.DirectionsStatus.OK) {
                            var path = new google.maps.MVCArray();
                            var poly = new google.maps.Polyline({
                                map: map,
                                strokeColor: pathColor
                            });
                            for (let q = 0, len = result.routes[0].overview_path.length; q < len; q++) {
                                path.push(result.routes[0].overview_path[q]);
                                bounds.extend(result.routes[0].overview_path[q]);
                            }
                            poly.setPath(path);
                            polylines.push(poly);
                            map.fitBounds(bounds);
                        }
                        else {
                            console.log(status);
                        }
                    });
                } catch (e) {
                    console.log(e.message);
                }
            }
        }
    }
};


