<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OnlineDriversMap.aspx.cs" Inherits="Pages_Compield_OnlineDriversMap" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cust Map</title>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />

    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/Main.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/json2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/tree/jquery.tree.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />

   <script type="text/javascript">
        function styler() {
            var lang = '<%= Lang %>';
            var href;
            switch (lang) {
                case 'He': href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;
        }
        styler();

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
    <style type="text/css">
        html, body, #map-canvas {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .labels {
            color: red;
            background-color: white;
            font-family: "Lucida Grande", "Arial", sans-serif;
            font-size: 12px;
            font-weight: bold;
            text-align: center;
            width: 80px;
            height: 15px;
            border: 2px solid black;
            white-space: nowrap;
        }
    </style>
</head>
<body onload="try{setTimeout('parent.CloseLoading();',10);}catch(e){};initMap();">
 <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=<%= Lang %>&ie=UTF8&key=AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk">
       
    </script>
    <script type="text/javascript" src="../../js/markerwithlabel.js"></script>
    <div style="padding-left: 0px; padding-right: 10px; width: 164px; vertical-align: top; float: right;">
        <form id="form2" runat="server">
            <asp:ScriptManager runat="server"></asp:ScriptManager>
            <input id="txtDate" runat="server" type="text" readonly="readonly" class="txtDateRoutes DateTimepicker" style="width: 160px;" />
            <br />
            <div class="AgentsHederDiv">רשימת נהגים</div>
            <asp:ListBox CssClass="LBAgents1" Width="160px" Height="300px" ID="AgentsList" runat="server" onchange="isFFirst='true'; AgentsListChange(this.value);"></asp:ListBox>

            <asp:UpdatePanel runat="server" UpdateMode="Always">
                <ContentTemplate>

                    <asp:HiddenField runat="server" ID="hdnAgentID" Value="" />
                    <asp:HiddenField runat="server" ID="hdnStrScript" Value="" />
                    <asp:HiddenField runat="server" ID="hdnRoad1" Value="" />
                    <asp:HiddenField runat="server" ID="hdnCountPoints" Value="0" />
                    <asp:HiddenField runat="server" ID="hdnArrTitle" Value="0" />
                    <asp:HiddenField runat="server" ID="hdnArrWinMsgs" Value="0" />
                    <asp:HiddenField runat="server" ID="hdnArrDistanceMsgs" Value="0" />
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdatePanel runat="server" UpdateMode="Conditional" ID="up5">
                <ContentTemplate>
                    <asp:Button runat="server" ID="btnGetData" OnClick="GetData" Style="display: none" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </form>
    </div>
    <div style="float: left; height: 100%;" id="MapObj">
        <div id="map-canvas"></div>
    </div>
    <script type="text/javascript">
        $('#MapObj').width($(window).width() - 178);

        function Refresh1() {

            isFFirst = "false";
            AgentsListChange($('#<%=AgentsList.ClientID%>').val());
        }
        var gMarkers = [];
        function Refresh(val) {
			try{
				isFFirst = "false";
				window.setTimeout('AgentsListChange($(\"#<%=AgentsList.ClientID%>\").val());', 5000);
			
				//alert(val);
				eval(val);
				if(val.indexOf("var mtLatlng = new")==-1)
				{
					var arr = pointsStr.split(';');
					var arrDT = strDT.split(';');
					for (var i = 0; i < arr.length; i++) {
					    var marker = GetMarker(arr[i].split(',')[2]);
					    if(marker)
					        moveMarker(marker, arr[i], arrDT[i]);
					}
				}
			}
			catch(e)
			{
			}
        }
        function GetMarker(AgentID)
        {
            //debugger;
            for (var i = 0; i < gMarkers.length; i++) {
                if(gMarkers[i].labelContent.indexOf(AgentID)>-1)
                {
                    return gMarkers[i];
                }
            }
            return null;
        }
        function moveMarker(marker, strPos , strDateTime) {
            var arrposition = strPos.split(',');
            var latlng = new google.maps.LatLng(arrposition[0], arrposition[1]);
            try {
                if (arrposition[0] > 0) {
                    marker.setPosition(latlng);
                    marker.setTitle(strDateTime.split(' ')[1] + ' ' + strDateTime.split(' ')[0]);
                }
            }
            catch (e) {
                alert(e);
            }
        }
        function AgentsListChange(val) {
            if (isFFirst == "true") {
                isFFirst = "false"
                $('#<%=btnGetData.ClientID%>')[0].click();
            }
            else {
                var request;
                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=DriversGPS_GetData&strDate=" + $("#<%=txtDate.ClientID%>").val() + "&AgentID=" + val + "&isFirst=" + isFFirst
                    + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "get",
                    data: ""
                });
                request.done(function (response, textStatus, jqXHR) {
                    isFFirst = "false";
                    Refresh(response);

                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        isFFirst = "false";
                        Refresh(jqXHR.responseText);

                    }
                });
            }
        }
        var isFFirst = "false";
        $('#<%=AgentsList.ClientID%>').val("0");
        setTimeout('AgentsListChange($(\"#<%=AgentsList.ClientID%>\").val());', 200);
    </script>
	 
    
    <script type="text/javascript">
        var gMarkers = new Array();
        function initMap() {
		
            eval($('#<%=hdnStrScript.ClientID %>').val());
			
            $('#<%=hdnStrScript.ClientID %>').val("");
            arrTitels = $('#<%=hdnArrTitle.ClientID %>').val().split(';');
            $('#<%=hdnArrTitle.ClientID %>').val("");
            arrWinMsgs = $('#<%=hdnArrWinMsgs.ClientID %>').val().split(';');
            $('#<%=hdnArrWinMsgs.ClientID %>').val("");
            arrDistanceMsgs = $('#<%=hdnArrDistanceMsgs.ClientID %>').val().split(';');
            $('#<%=hdnArrDistanceMsgs.ClientID %>').val("");

            var counterI = 0;
            for (var i = 0; i < $('#<%=hdnCountPoints.ClientID%>').val() * 1.0; i++) {

                var isFirst = false;
                if (i == 0)
                    isFirst = true

                var isLast = false;
                if (i == 0)
                    isLast = true



                
                }
            }

            var distance;
            var infoWindows = [];
            var arrTitels;
            var arrWinMsgs;
            var arrDistanceMsgs;
            function ShowRoad(lat0, lon0, lat1, lon1, map, myLatlng0, myLatlng1, isFirst, isLast, counter) {
                //debugger;
                var start = new google.maps.LatLng(lat0, lon0);
                var end = new google.maps.LatLng(lat1, lon1);

                var directionsDisplay = new google.maps.DirectionsRenderer({ suppressMarkers: true });//polylineOptions:{strokeColor:"#C7E1FB",strokeWeight:5},
                directionsDisplay.setMap(map); // map should be already initialized.
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
                        var startMarker;
                        if (isFirst) {
                            startMarker = new google.maps.Marker({
                                position: response.request.origin,
                                icon: image,
                                map: map,
                                title: (counter + 1) + '' + ' \n' + arrTitels[counter]
                            });
                        }
                        else {
                            startMarker = new google.maps.Marker({
                                position: response.request.origin,
                                icon: '../../img/Map-Pointer3.png',
                                title: (counter + 1) + '' + ' \n' + arrTitels[counter]
                            });
                        }

                        endMarker = new google.maps.Marker({
                            position: response.request.destination,
                            icon: image,
                            map: map,
                            title: (counter + 2) + '' + ' \n' + arrTitels[counter + 1]
                        });




                        google.maps.event.addListener(startMarker, 'click', function () {
                            request = $.ajax({
                                url: "../../Handlers/MainHandler.ashx?MethodName=GetDataForMap&Points=" + arrDistanceMsgs[counter].split('^')[0] + "&orgAddress=" + arrDistanceMsgs[counter].split('^')[1] + "&Lang=<%= Lang %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                            type: "GET",
                            data: ''
                        });
                        request.done(function (response, textStatus, jqXHR) {

                            resParams = jqXHR.responseText;
                        });
                        request.fail(function (jqXHR, textStatus, errorThrown) {

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
                    // if (arrDistanceMsgs[counter + 1]) {
                        google.maps.event.addListener(endMarker, 'click', function () {
                            request = $.ajax({
                                url: "../../Handlers/MainHandler.ashx?MethodName=GetDataForMap&Points=" + arrDistanceMsgs[counter + 1].split('^')[0] + "&orgAddress=" + arrDistanceMsgs[counter + 1].split('^')[1] + "&Lang=<%= Lang %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                                type: "GET",
                                data: ''
                            });
                            request.done(function (response, textStatus, jqXHR) {

                                resParams = jqXHR.responseText;
                            });
                            request.fail(function (jqXHR, textStatus, errorThrown) {

                                if (jqXHR.status == 200) {
                                    var arry = (arrDistanceMsgs[counter].split('^')[0] + "," + jqXHR.responseText.split('^')[1]).split(',');
                                    var myCheckPoint0 = new google.maps.LatLng(arry[0], arry[1]);
                                    var myCheckPoint1 = new google.maps.LatLng(arry[2], arry[3]);
                                    var distance = (formatMoney(getDistance(myCheckPoint0, myCheckPoint1), 1)) + " M";

                                    var infowindow = new google.maps.InfoWindow({ content: (counter + 2) + ' ' + ' <br/>' + arrWinMsgs[counter + 1] + jqXHR.responseText.split('^')[0] + "<br/>מרחק: " + distance });
                                    infoWindows.push(infowindow);
                                    closeAllInfoWindowsAndShowNewWindow(map, endMarker, infoWindows, infowindow);
                                }
                            });


                        });


                        var time = 0;
                        var hours = 0;
                        var minutes = 0;

                        var currentdate = new Date();


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
            }
    </script>
	
</body>
</html>

