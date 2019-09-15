<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ETA.aspx.cs" Inherits="Pages_Main_ETA" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MobiSoft ETA</title>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <link rel="SHORTCUT ICON" href="../../Img/NetWork.ico" />
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>

    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=iw&ie=UTF8&key=AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk">
    </script>
    
    </script>
    <style type="text/css">
        html, body, #map-canvas {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .RoundImg {
            top: 10px;
            right: 10px;
            position: absolute;
            width: 64px;
            height: 64px;
            z-index: 9999;
            background-image: url('../../Img/blackCircle.png');
            background-repeat: no-repeat;
            background-position: left top;
            color: white;
            text-align: center;
            font-size: 8px;
        }

        .head1 {
            margin-top: 17px;
        }

        .sETA {
            text-align: center;
            color: white;
            margin-top: 1px;
            direction: rtl;
            font-size: 16px;
        }

        .HeadCallRow {
            color: black;
            font-weight: 700;
            font-size: 16px;
        }

        .SecCallRow {
            color: black;
            font-weight: 500;
            font-size: 12px;
        }

        .CallRow {
            position: absolute;
            bottom: 0px;
            background-color: #F5F5F5;
            opacity: 0.9;
            z-index: 9999;
            width: 100%;
            direction: rtl;
            text-align: right;
        }

        .phone {
            cursor: pointer;
        }
    </style>
    <script type="text/javascript">
        function closeAllInfoWindowsAndShowNewWindow(map, marker, infoWindows, infowindow) {
            closeAllWindows(infoWindows);

            infowindow.open(map, marker);
        }
        function closeAllWindows(infoWindows) {
            for (var i = 0; i < infoWindows.length; i++) {
                infoWindows[i].close();
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
        <div class="RoundImg">
            <div class="head1">
                זמן הגעה משוער
            </div>
            <div class="sETA"></div>
        </div>
        <div class="CallRow">
            <table cellpadding="2" cellspacing="2" width="100%">
                <tr>
                    <td>
                        <img src="../../img/hogla.png" width="42px" />
                    </td>
                    <td>
                        <table cellpadding="2" cellspacing="2">
                            <tr>
                                <td class="HeadCallRow" runat="server" id="HeadCallRow1">גיל גולן
                                </td>
                            </tr>
                            <tr>
                                <td class="SecCallRow">נהג קימברלי חוגלה בדרך אלייך
                                </td>
                            </tr>

                        </table>
                    </td>
                    <td style="width: 24%"></td>
                    <td class="phone">
                        <a href="tel:+900300400" runat="server" id="aPhone">
                            <img src="../../img/phone.png" width="32px" /></a>
                    </td>
                </tr>
            </table>
        </div>
    </form>
    <div id="map-canvas">
    </div>
    <script type="text/javascript">
        function initialize() {

            eval("<%=ScriptScr %>");

            ShowRoad(<%=Road1%>,map, myLatlng0, myLatlng1);

            setTimeout(function(){
                $(document).height("2000px");
                window.scrollTo(0, 1);
                //alert();
            }, 0);
        }
        var distance;
        var infoWindows = [];
        
        function ShowRoad(lat0, lon0, lat1, lon1, map, myLatlng0, myLatlng1)
        {
            var start = new google.maps.LatLng(lat0, lon0);
            var end = new google.maps.LatLng(lat1, lon1);

            var directionsDisplay = new google.maps.DirectionsRenderer({  suppressMarkers:true });//polylineOptions:{strokeColor:"#C7E1FB",strokeWeight:5},
            directionsDisplay.setMap(map); // map should be already initialized.
            // directionsDisplay.setOptions( { suppressMarkers: true } );
            var request = {
                origin: start,
               
                destination: end,
                travelMode: google.maps.TravelMode.DRIVING
            };
            var directionsService = new google.maps.DirectionsService();
            
            directionsService.route(request, function (response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    directionsDisplay.setDirections(response);
                    // debugger;
                    startMarker = new google.maps.Marker({
                        position: response.request.origin,
                        icon: '../../img/truck.png',
                        map: map
                    });
                    endMarker = new google.maps.Marker({
                        position: response.request.destination,
                        icon: '../../img/flag.png',
                        map: map
                    });

                    var contentString='<%=contentString1%>';
                    var contentString2='<%=contentString2%>';

                    google.maps.event.addListener(startMarker, 'click', function() { 

                        var infowindow = new google.maps.InfoWindow({content: contentString}); 
                        infoWindows.push(infowindow);  
                        closeAllInfoWindowsAndShowNewWindow(map, startMarker,infoWindows,infowindow); });

                    google.maps.event.addListener(endMarker, 'click', function() { 

                        var infowindow = new google.maps.InfoWindow({content: contentString2}); 
                        infoWindows.push(infowindow);  
                        closeAllInfoWindowsAndShowNewWindow(map, endMarker,infoWindows,infowindow); });

                    distance = getDistance(myLatlng0,myLatlng1);

                 
                    var time = 0;
                    var hours = 0;
                    var minutes = 0;

                    var currentdate = new Date(); 
             
                    directionsService.route( request, function( response, status ) {

                        if ( status === 'OK' ) {
                            var point = response.routes[ 0 ].legs[ 0 ];
                            time = point.duration.text;//formatMoney(directions.getDuration().hours,0).replace(",","") + ":" + directions.getDuration().minutes; 
                           
                            var arr = time.split(' ');
                            for (var i = 0; i < arr.length; i++) {
                                if(arr.length<3)
                                {
                                    if(i%2==0)
                                    {
                                        minutes += arr[i] * 1.0;
                                        hours = 0;
                                    }
                                }
                                else
                                {
                                    if(i==2)
                                        minutes += arr[i] * 1.0;
                                    else if(i==0)
                                        hours += arr[i] * 1.0;
                                }
                            }

                            currentdate.setMinutes(currentdate.getMinutes()+minutes);
                            currentdate.setHours(currentdate.getHours()+hours);
                            hours = currentdate.getHours();
                            minutes = currentdate.getMinutes() ;  

                            if(minutes.toString().replace("-","") * 1.0 < 10)
                                minutes="0" + minutes.toString().replace("-","");

                            time = formatMoney(hours,0).replace(",","") + ":" + minutes; 

                            $('.sETA').text(time);

                        }
                    } );

                    

                    //alert(directions.getDuration().hours);
                    //time = formatMoney(directions.getDuration().hours,0).replace(",","") + ":" + directions.getDuration().minutes; 

                    //$('.sETA').text(time);
                }
            });
        }
        var rad = function (x) {
            return x * Math.PI / 180;
        };

        var getDistance = function (p1, p2) {
            var R = 6378137; // Earth’s mean radius in meter
            var dLat = rad(p2.lat() - p1.lat());
            var dLong = rad(p2.lng() - p1.lng());
            var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(rad(p1.lat())) * Math.cos(rad(p2.lat())) *
            Math.sin(dLong / 2) * Math.sin(dLong / 2);
            var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            var d = R * c;
            return d; // returns the distance in meter
        };
        google.maps.event.addDomListener(window, 'load', initialize);

       

        
    </script>
</body>
</html>
