/// <reference path="_references.js" />
/// <reference path="~/js/markerwithlabel.js" />
/// <reference path="~/css/redmond/jqgrid/grid.base.js" />
/// <reference path="Main.js" /> 

var map = '', arrLatLon = [], line = new google.maps.Polyline,
    polyline = [], arrMarker = [], arrPointsVisits = [], infoWindows = [], gMarkers = [],
    arrPointLatLon = [], arrPointMarker = [], pMarkers = [], arrTitels = [], markerArray = [];
var directionsDisplay = new google.maps.DirectionsRenderer();
var driverMap = {
    InitMap: function () {
        window.parent.CloseLoading()
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
            },
            function (ex) {
                console.log(ex.mesage);
            });
    },
    InitVistPoint: function () {
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
          },
          function (ex) {
              console.log(ex.mesage);
          });
    },
    ////================ cbRoad checkbox click ============================================================
    InitRoutsView: function () {

        let agentID = $("#AgentsList").val();
        let date = $("#txtDate").val();
        var params = $.QueryString;
        var agentObj = {
            AgentID: agentID == null ? "0" : agentID,
            Date: date,
            CountryID: params.CountryID
        };
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
        HardwareWebService.MPLayout_GetCustomersRoadCord(agentObj, date, cid, did,
            function (response) {
                let points = JSON.parse(response).rows;

                driverMap.InitDriveMap(points);
                //driverMap.CalculateAndDisplayRoute(points);
            },
            function (ex) {
                console.log(ex.mesage);
            });
    },
    InitDriveMap: function (allPoints) {


        driverMap.ClearDirections();

        var service = new window.google.maps.DirectionsService();
        var map = new google.maps.Map(document.getElementById('map-canvas'));

        if (allPoints.length > 0) {
            window.parent.ShowLoading()
        }
        var filterLocations = allPoints.map(x=>x.Location);

        // list of points
        var stations = filterLocations.map(x=>({ "lat": Number(x.Lat), "lng": Number(x.Lng) }))

        // Zoom and center map automatically by stations (each station will be in visible map area)
        var lngs = stations.map(function (station) { return station.lng; });
        var lats = stations.map(function (station) { return station.lat; });
        map.fitBounds({
            west: Math.min.apply(null, lngs),
            east: Math.max.apply(null, lngs),
            north: Math.min.apply(null, lats),
            south: Math.max.apply(null, lats),
        });

        // Divide route to several parts because max stations limit is 25 (23 waypoints + 1 origin + 1 destination)
        for (var i = 0, parts = [], max = 25 - 1; i < stations.length; i = i + max)
            parts.push(stations.slice(i, i + max + 1));

        // Service callback to process service results
        var service_callback = function (response, status) {
            if (status != 'OK') {
                console.log('Directions request failed due to ' + status);
                alert("עקב ריבוי נקודות מוצג מסלול חלקי")
                return;
            }
            var renderer = new google.maps.DirectionsRenderer;
            renderer.setMap(map);
            renderer.setOptions({ suppressMarkers: true, preserveViewport: true });
            renderer.setDirections(response);
        };

        var millisecondsToWait = 1200;

        (function theLoop(i) {
            setTimeout(function () {
                var waypoints = [];
                for (var j = 1; j < parts[i].length - 1; j++)
                    waypoints.push({ location: parts[i][j], stopover: false });
                // Service options
                var service_options = {
                    origin: parts[i][0],
                    destination: parts[i][parts[i].length - 1],
                    waypoints: waypoints,
                    travelMode: google.maps.TravelMode.DRIVING
                };
                service.route(service_options, service_callback);
                if (parts.length > ++i) {
                    theLoop(i);
                } else {
                    window.parent.CloseLoading();
                }
            }, millisecondsToWait);
        })(0);





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
    GetPolyline: function (result) {
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
        var cbOnline = $("#cbOnline").prop("checked");
        var cbFlags = $("#cbFlags").prop("checked");
        var cbRoad = $("#cbRoad").prop("checked");
        driverMap.ClearMarkers();
        driverMap.ClearPointMarkers();
        driverMap.ClearDirections();
        if (cbOnline) driverMap.InitTrucks();
        if (cbFlags) driverMap.InitVistPoint();
        if (cbRoad) driverMap.InitRoutsView(1);

    });
    let cid = $.QueryString["CountryID"] == undefined ? "1000" : $.QueryString["CountryID"];
    $.datepicker.setDefaults($.datepicker.regional[$("#hdnSessionLanguage").val()]);
    $("#txtDate").datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: 'dd/mm/yy',
        onSelect: function (dateText) {
            $("#AgentsList").trigger("change");
            HardwareWebService.MPLayout_GetDriverGPSActivity(dateText, cid,
            function (dtPoints) {
                $("#AgentsList").empty();
                if (dtPoints.length > 0) {
                    $.each(dtPoints, function () {
                        $('#AgentsList').append(new Option(this.AgentName + (this.AgentID === 0 ? "" : " " + this.AgentID), this.AgentID));
                    });
                }
            },
           function (ex) {
               console.log(ex.mesage);
           });
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


});




