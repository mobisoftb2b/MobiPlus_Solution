﻿/// <reference path="_references.js" />
/// <reference path="~/js/markerwithlabel.js" />
/// <reference path="~/css/redmond/jqgrid/grid.base.js" />
/// <reference path="Main.js" /> 

var map = '', arrLatLon = [], line = new google.maps.Polyline,
    polyline = [], arrMarker = [], arrPointsVisits = [], infoWindows = [], gMarkers = [],
    arrPointLatLon = [], arrPointMarker = [], pMarkers = [], arrTitels = [], markerArray = [];
var directionsDisplay = new google.maps.DirectionsRenderer();
var driverMap = {
    InitMap: function () {
        let lat = parseFloat($("#hdnLat").val());
        let lon = parseFloat($("#hdnLon").val());
        let cbOnline = $("#cbOnline").prop("checked");

        const mapOptions = {
            zoom: 8,
            center: new google.maps.LatLng(lat, lon),
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
        if (cbOnline) driverMap.InitTrucks();
    },
    InitTrucks: function () {
        window.parent.ShowLoading();
        const countryID = $.QueryString["CountryID"] == undefined ? 1000 : $.QueryString["CountryID"];
        let coord = $("#hdnCustomCoord").val();
        let agentID = $("#AgentsList").val();
        let date = $("#txtDate").val();
        let cbOnline = $("#cbOnline").prop("checked");
        const image = '../../img/truck2.png';

        HardwareWebService.MPLayout_GetDriverGPSLocationByCountry(agentID == null ? "0" : agentID, date, countryID,
            function (dtPoints) {
                if (dtPoints.length > 0) {
                    for (let i = 0; i < dtPoints.length; i++) {
                        let tooltip = new google.maps.InfoWindow();
                        let point = dtPoints[i];
                        let location = new google.maps.LatLng(point.DriverGPSLocation.Lat, point.DriverGPSLocation.Lng);
                        arrLatLon.push(location);
                        if (cbOnline) {
                            let marker = new MarkerWithLabel({
                                position: location, draggable: false, raiseOnDrag: false,
                                map: map, labelContent: (parseInt(point.AgentID) + " - " + point.AgentName), labelAnchor: new google.maps.Point(34, 0), labelClass: 'labels', icon: image
                            });
                            if (dtPoints.length == 1) {
                                //    map.panTo(location);
                                map.setCenter(location);
                                map.setZoom(12);
                            }

                            let listener = google.maps.event.addListener(marker, 'click',
                                function (e) {
                                    tooltip.setContent(point.DriverGPSLocation.Comment);
                                    tooltip.setPosition(this.getPosition());
                                    tooltip.open(map);
                                    map.panTo(marker.position);
                                    map.setCenter(location);
                                    map.setZoom(12);
                                });
                            arrMarker.push(marker);
                            gMarkers.push(listener);
                        }
                    }
                } else { map.setZoom(8); }
                window.parent.CloseLoading();
            },
            function (ex) {
                console.log(ex.mesage);
                window.parent.CloseLoading();
            });
    },
    InitVistPoint: function () {
        window.parent.ShowLoading();
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
        let cbFlags = $("#cbFlags").prop("checked");
        let agentID = $("#AgentsList").val();
        let date = $("#txtDate").val();
        var distanceMsgs = [], winMsgs = [];

        HardwareWebService.MPLayout_GetCustomersCord(agentID == null ? "0" : agentID, date, cid, did,
          function (response) {
              let dtPoints = JSON.parse(response).rows;
              if (dtPoints) {
                  for (let i = 0; i < dtPoints.length; i++) {
                      let point = dtPoints[i];
                      let tooltip = new google.maps.InfoWindow();
                      let location = new google.maps.LatLng(point.Location.Lat, point.Location.Lng);
                      arrPointLatLon.push(location);
                      arrTitels.push(point.CustomerName);
                      distanceMsgs.push(point.Location.Lat + "," + point.Location.Lng + "^;");
                      winMsgs.push(point.CustomerName + " ;");
                      if (cbFlags) {
                          var image = '../../img/' + point.Color + '.png';
                          let marker = new google.maps.Marker({
                              position: location,
                              map: map,
                              icon: image,
                              zIndex: 1,
                              title: point.CustomerName
                          })
                          arrPointMarker.push(marker);
                          marker.setMap(map);
                          google.maps.event.addListener(marker, 'click',
                              function (e) {
                                  tooltip.setContent(twoLinesTextFormatter(point.Location.Comment));
                                  tooltip.setPosition(this.getPosition());
                                  tooltip.open(map);
                              });
                          pMarkers.push(marker);
                      }
                  }
              }
              setTimeout(window.parent.CloseLoading(), 1500);
          },
          function (ex) {
              console.log(ex.mesage);
              setTimeout(window.parent.CloseLoading(), 1000);
          });
    },
    ////================ cbRoad checkbox click ============================================================
    InitRoutsView: function () {
        window.parent.ShowLoading();

        let agentID = $("#AgentsList").val();
        let date = $("#txtDate").val();
        var params = $.QueryString;
        var agentObj = {
            AgentID: agentID == null ? "0" : agentID,
            Date: date,
            CountryID: params.CountryID
        };
        HardwareWebService.MPLayout_GetCustomersRoadCord(agentObj,
            function (response) {
                let points = JSON.parse(response).rows;
                driverMap.InitDriveMap(points);
                //driverMap.CalculateAndDisplayRoute(points);
            },
            function (ex) {
                console.log(ex.mesage);
                setTimeout(window.parent.CloseLoading(), 1000);
            });
    },
    InitDriveMap: function (allPoints) {
        window.parent.ShowLoading();
        
        driverMap.ClearDirections();
        var directionsService = new window.google.maps.DirectionsService();
        var bounds = new google.maps.LatLngBounds();

        var result = _.groupBy(allPoints, 'AgentCode');
        $.each(result, function (i, value) {
            if (value.length > 1) {
                try {
                    var col = common.getRandomColor();//'rgb(' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ')';
                    driverMap.DirRequest(directionsService, directionsDisplay, value, function (path) {
                        polyline.push(new google.maps.Polyline({
                            clickable: false,
                            map: map,
                            path: path,
                            strokeColor: col,
                            strokeOpacity: 1,
                            strokeWeight: 5
                        }));
                    });
                } catch (e) {
                    console.log(e.message);
                }
            }
        });
        if (allPoints.length == 0) map.setZoom(8);
        setTimeout(window.parent.CloseLoading(), 2000);
    },
    DirRequest: function (service, directionsDisplay, travelWaypoints, userFunction, waypointIndex, path) {
        var waypoints = [];

        var stepDisplay = new google.maps.InfoWindow;
        let image = "../../img/flag_maps.png";
        $.each(travelWaypoints, function (i, value) {
            try {
                const location = new google.maps.LatLng(value.Location.Lat, value.Location.Lng);
                waypoints.push({ location: new google.maps.LatLng(value.Location.Lat, value.Location.Lng) });
                let marker = new google.maps.Marker({
                    position: location,
                    map: map,
                    icon: image,
                    zIndex: 1,
                    title: value.Location.Comment
                });
                map.panTo(marker.position);
                //map.setCenter(location);
                //map.setZoom(9);
                google.maps.event.addListener(marker, 'click', function () {
                    $.ajax({
                        url: "../Handlers/MainHandler.ashx?MethodName=GetDataForMap&Points=" + value.Location.Comment + "&orgAddress=" + value.Location.Comment + "&Lang=<%= Lang %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                        type: "GET"
                    }).done(function (response, textStatus, jqXHR) {
                        resParams = jqXHR.responseText;
                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status == 200) {
                            var arry = (arrDistanceMsgs[counter].split('^')[0] + "," + jqXHR.responseText.split('^')[1]).split(',');
                            var myCheckPoint0 = new google.maps.LatLng(arry[0], arry[1]);
                            var myCheckPoint1 = new google.maps.LatLng(arry[2], arry[3]);
                            var distance = (formatMoney(getDistance(myCheckPoint0, myCheckPoint1), 1)) + " M";
                            var infowindow = new google.maps.InfoWindow({ content: (counter + 1) + ' <br/>' + arrWinMsgs[counter] + jqXHR.responseText.split('^')[0] + "<br/>מרחק: " + distance });
                            infoWindows.push(infowindow);
                            closeAllInfoWindowsAndShowNewWindow(map, startMarker, infoWindows, infowindow);
                        }
                    });
                });
                markerArray.push(marker);

            } catch (e) { console.log(e.message); }
        });
        waypointIndex = typeof waypointIndex !== 'undefined' ? waypointIndex : 0;
        path = typeof path !== 'undefined' ? path : [];

        var s = driverMap.DirGetNextSet(waypoints, waypointIndex);
        var startl, endl, request;

        try {

            startl = s[0].shift()['location'];
            endl = s[0].pop()['location'];
            map.setCenter(startl);
            map.setZoom(9);
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
        console.log(request);

        try {
            service.route(request, function (response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    path = path.concat(response.routes[0].overview_path);
                    if (s[1] != null) {
                        setTimeout(driverMap.DirRequest(service, directionsDisplay, travelWaypoints, userFunction, s[1], path), 100);
                    } else {
                        userFunction(path);
                    }
                    setTimeout(window.parent.CloseLoading(), 2000);

                } else {
                    console.log(status);
                }

            });
        } catch (e) {
            console.log(e.message);
        }
    },
    DirGetNextSet: function (waypoints, startIndex) {
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
    },
    DrawRoute: function (routeData, directionsService, bounds, polylines, pathColor) {
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
    },
    ClearMarkers: function () {
        for (let i = 0; i < arrMarker.length; i++) {
            arrMarker[i].setMap(null);
            google.maps.event.clearInstanceListeners(arrMarker[i]);
        }
        for (let i = 0; i < gMarkers.length; i++) {
            google.maps.event.removeListener(gMarkers[i]);
        }
    },
    ClearDirections: function () {
        for (let i = 0; i < markerArray.length; i++) {
            markerArray[i].setMap(null);
        }
        line.setMap(null);
        directionsDisplay.setMap(null);
        for (let i = 0; i < polyline.length; i++) {
            polyline[i].setMap(null);
        }
    },
    ClearPointMarkers: function () {
        for (let i = 0; i < arrPointMarker.length; i++) {
            arrPointMarker[i].setMap(null);
        }
        for (let i = 0; i < pMarkers.length; i++) {
            pMarkers[i].setMap(null);
        }

    },
    CloseAllInfoWindowsAndShowNewWindow: function (map, marker, infoWindows, infowindow) {
        CloseAllWindows(infoWindows);
        infowindow.open(map, marker);
    },
    CloseAllWindows: function (infoWindows) {
        for (let i = 0; i < infoWindows.length; i++) {
            infoWindows[i].close();
        }
    },
    AnimateMapZoomTo: function (map, targetZoom) {
        var currentZoom = arguments[2] || map.getZoom();
        if (currentZoom != targetZoom) {
            google.maps.event.addListenerOnce(map, 'zoom_changed', function (event) {
                animateMapZoomTo(map, targetZoom, currentZoom + (targetZoom > currentZoom ? 1 : -1));
            });
            setTimeout(function () { map.setZoom(currentZoom) }, 80);
        }
    },
    GetPolyline: function(result) {
        let polyline = new google.maps.Polyline({
            path: []
        });
        let path = result.routes[0].overview_path;
        let legs = result.routes[0].legs;
        for (let i = 0; i < legs.length; i++) {
            let steps = legs[i].steps;
            for (j = 0; j < steps.length; j++) {
                let nextSegment = steps[j].path;
                for (let k = 0; k < nextSegment.length; k++) {
                    polyline.getPath().push(nextSegment[k]);
                }
            }
        }
        return polyline;
    },
    CreateInfoWindow: function () {
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];   
        HardwareWebService.MPLayout_GetInfoWindow(cid,
            function (points) {
                let info = JSON.parse(points);
                if (info.length > 0) {
                    for (let i = 0; i < info.length; i++) {
                        let infoDiv = "<p style='text-align: center'><div style='white-space: nowrap'><div style='display: inline;'>"
                         + "<img src='../../img/" + info[i].Color + ".png' style='width: 20px;' alt=" + info[i].Color + " title=" + info[i].Color + " /></div>"
                         + "<div style='display: inline; white-space: nowrap;font-size:14px; vertical-align: super'>" + info[i].CustStatusDesc + "</div></div></p>";
                        $("#divInfoWin").append(infoDiv);
                    }
                    $("#divInfoWin").draggable();
                }
            });
    }
};

$(function () {
    $('#MapObj').width($(window).width() - 178);
    driverMap.CreateInfoWindow();
    driverMap.InitMap();
    $("#AgentsList").on("change", function () {
        window.parent.ShowLoading();
        var cbOnline = $("#cbOnline").prop("checked");
        var cbFlags = $("#cbFlags").prop("checked");
        var cbRoad = $("#cbRoad").prop("checked");
        driverMap.ClearMarkers();
        driverMap.ClearPointMarkers();
        driverMap.ClearDirections();
        if (cbOnline) driverMap.InitTrucks();
        if (cbFlags) driverMap.InitVistPoint();
        if (cbRoad) driverMap.InitRoutsView(1);
        setTimeout(window.parent.CloseLoading(), 2000);
    });

    $.datepicker.setDefaults($.datepicker.regional[$("#hdnSessionLanguage").val()]);
    $("#txtDate").datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: 'dd/mm/yy',
        onSelect: function (dateText) {
            $("#AgentsList").trigger("change");
        }
    });
    $("#cbOnline").on("change", function () {
        if ($(this).prop("checked"))
            driverMap.InitTrucks();
        else {
            driverMap.ClearMarkers();
        }
    });
    $("#cbFlags").on("change", function () {
        if ($(this).prop("checked"))
            driverMap.InitVistPoint();
        else
            driverMap.ClearPointMarkers();
    });
    $("#cbRoad").on("change", function () {
        if ($(this).prop("checked"))
            driverMap.InitRoutsView(1);
        else
        { driverMap.ClearDirections(); }
    });
    // map options
    setTimeout(window.parent.CloseLoading(), 2000);

});




