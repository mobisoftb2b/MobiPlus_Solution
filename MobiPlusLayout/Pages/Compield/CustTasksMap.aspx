﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustTasksMap.aspx.cs" Inherits="Pages_CustTasksMap" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cust Map</title>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />

    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../js/tree/jquery.tree.js" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css" rel="stylesheet" type="text/css" />
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css" />


    <script type="text/javascript">
        function styler() {
            var lang = '<%= Lang %>';
            var href;
            switch (lang) {
                case 'He': href = "../../css/Main.css?SessionID=<%= Session.SessionID%>"; break;
                case 'En': href = "../../css/MainLTR.css?SessionID=<%= Session.SessionID%>"; break;
                default: href = "../../css/Main.css?SessionID=<%= Session.SessionID%>"; break;
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
    </style>
    <script type="text/javascript">
       
    </script>
</head>
<body onload="try{setTimeout('parent.CloseLoading();',10);}catch(e){}">
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=<%= Lang %>&ie=UTF8&key=AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk">
       
    </script>
    <form id="form2" runat="server">

        <div>

            <table id="tblMain" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td style="padding-left: 0px; padding-right: 10px; width: 164px; vertical-align: top;">

                        <asp:ScriptManager runat="server"></asp:ScriptManager>
                        <input id="txtDate" runat="server" type="text" readonly="readonly" class="txtDateRoutes DateTimepicker" style="width: 160px;" />
                        <br />
                        <div class="AgentsHederDiv"><%=StrSrc("DriversList")%></div>
                        <asp:ListBox CssClass="LBAgents1" Width="160px" Height="300px" ID="AgentsList" runat="server" onchange="AgentsListChange(this.value);"></asp:ListBox>
                        
                        <asp:UpdatePanel runat="server" UpdateMode="Always">
                            <ContentTemplate>

                                <asp:HiddenField runat="server" ID="hdnAgentID" Value="" />
                                <asp:HiddenField runat="server" ID="hdnStrScript" Value="" />
                                <asp:HiddenField runat="server" ID="hdnRoad1" Value="" />
                                <asp:HiddenField runat="server" ID="hdnCountPoints" Value="0" />
                                <asp:HiddenField runat="server" ID="hdnArrTitle" Value="0" />
                                <asp:HiddenField runat="server" ID="hdnArrPointsVisits" Value="0" />
                                <asp:HiddenField runat="server" ID="hdnArrWinMsgs" Value="0" />
                                <asp:HiddenField runat="server" ID="hdnArrDistanceMsgs" Value="0" />
                            </ContentTemplate>
                        </asp:UpdatePanel>

                    </td>
                    <td>
                        <div id="map-canvas"></div>
                    </td>
                </tr>
            </table>

        </div>
        <asp:UpdatePanel runat="server" UpdateMode="Conditional" ID="up5">
                            <ContentTemplate>
                                <asp:Button runat="server" ID="btnInit" OnClick="init" Style="display: none" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
    </form>

    <script type="text/javascript">
        $(".DateTimepicker").datepicker({
            monthNamesShort: ['ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי', 'יוני',
              'יולי', 'אוגוסט', 'ספטמבר', 'אוקטובר', 'נובמבר', 'דצמבר'],
            dayNamesShort: ['א\'', 'ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'ש\''],
            dayNamesMin: ['א\'', 'ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'ש\''],
            changeMonth: true,
            changeYear: true,
            dateFormat: 'dd/mm/yy',
            //Date.now()
            onSelect: function (dateText) { }
        });
        //$("#<%=txtDate.ClientID%>").val('28/03/2016');

        
<%--        function initialize() {
            eval("<%=ScriptScr %>");
        }

        google.maps.event.addDomListener(window, 'load', initialize);--%>

        $('#tblMain').height($(window).height());
        var d = new Date();

        var month = d.getMonth() + 1;
        var day = d.getDate();

        var output = (day < 10 ? '0' : '') + day + '/' +
                        (month < 10 ? '0' : '') + month + '/' +
                        d.getFullYear();
        $("#<%=txtDate.ClientID%>").val(output);

        function AgentsListChange(val) {
            $('#<%=hdnAgentID.ClientID%>').val(val);
            $('#<%=btnInit.ClientID%>')[0].click();
        }


        function initialize() {
            arrTitels = $('#<%=hdnArrTitle.ClientID %>').val().split(';');
            eval($('#<%=hdnStrScript.ClientID %>').val());
            $('#<%=hdnStrScript.ClientID %>').val("");
           
            arrPointsVisits = $('#<%=hdnArrPointsVisits.ClientID %>').val().split(',');
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

                if (i + 1 <= $('#<%=hdnCountPoints.ClientID%>').val() * 1.0 - 1.0) {
                    if (arrPointsVisits[i] == "0") {
                        //eval('ShowRoad(myLatlng' + i.toString() + '.lat(),myLatlng' + (i).toString() + '.lng(),myLatlng' + (i + 1).toString() + '.lat(),myLatlng' + (i + 1).toString() + '.lng(),map,myLatlng' + i.toString() + ',myLatlng' + (i + 1).toString() + ',' + isFirst + ',' + isLast + ',' + i + ')', 0);
                    }
                    else {
                        var j = -1;
                        var isFound = false;

                        for (j = 0; j < $('#<%=hdnCountPoints.ClientID%>').val(); j++) {
                            if (arrPointsVisits[j] == "1" && j!=i) {
                                {
                                    isFound = true;
                                    break;
                                }
                            }
                            
                        }
                        if (isFound)
                            eval('ShowRoad(myLatlng' + i.toString() + '.lat(),myLatlng' + (i).toString() + '.lng(),myLatlng' + (j).toString() + '.lat(),myLatlng' + (j).toString() + '.lng(),map,myLatlng' + i.toString() + ',myLatlng' + (j).toString() + ',' + isFirst + ',' + isLast + ',' + i + ')', 1);
                    }
                }
                else {
                    counterI = i;
                    var marker1 = new google.maps.Marker(
                          {
                              position: myLatlng0,
                              map: map,
                              icon: image,
                              title: arrTitels[i]
                          });

                    google.maps.event.addListener(marker1, 'click', function () {

                        request = $.ajax({
                            url: "../../Handlers/MainHandler.ashx?MethodName=GetDataForMap&Points=" + arrDistanceMsgs[counterI].split('^')[0] + "&orgAddress=" + arrDistanceMsgs[counterI].split('^')[1] + "&Lang=<%= Lang %>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                            type: "GET",
                            data: ''
                        });
                        request.done(function (response, textStatus, jqXHR) {

                        });
                        request.fail(function (jqXHR, textStatus, errorThrown) {

                            if (jqXHR.status == 200) {
                                var arry = (jqXHR.responseText.split('^')[1]).split(',');
                                var myCheckPoint0 = new google.maps.LatLng(arry[0], arry[1]);
                                var myCheckPoint1 = new google.maps.LatLng(arry[2], arry[3]);
                                var distance = (formatMoney(getDistance(myCheckPoint0, myCheckPoint1), 1)) + " M";
                                var infowindow = new google.maps.InfoWindow({ content: arrWinMsgs[counterI] + jqXHR.responseText.split('^')[0].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח") });//+ "<br/>מרחק: " + distance
                                infoWindows.push(infowindow);
                                closeAllInfoWindowsAndShowNewWindow(map, marker1, infoWindows, infowindow);
                            }
                        });
                    });
                }
            }
        }
        var distance;
        var infoWindows = [];
        var arrTitels;
        var arrPointsVisits;
        var arrWinMsgs;
        var arrDistanceMsgs;
        function ShowRoad(lat0, lon0, lat1, lon1, map, myLatlng0, myLatlng1, isFirst, isLast, counter,pointStatus) {
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
                        if (pointStatus == 0) {
                            startMarker = new google.maps.Marker({
                                position: response.request.origin,
                                icon: '../../img/Map-Pointer1.png',
                                map: map,
                                title: (counter + 1) + '' + ' \n' + arrTitels[counter].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח")
                            });
                        }
                        else if(pointStatus == 1)
                        {
                            startMarker = new google.maps.Marker({
                                position: response.request.origin,
                                icon: '../../img/Map-PointerGreen.png',
                                map: map,
                                title: (counter + 1) + '' + ' \n' + arrTitels[counter].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח")
                            });
                        }
                    }
                    else {
                        if (pointStatus == 0) {
                            startMarker = new google.maps.Marker({
                                position: response.request.origin,
                                icon: '../../img/Map-PointerRed.png',
                                title: (counter + 1) + '' + ' \n' + arrTitels[counter].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח")
                            });
                        }
                        else if (pointStatus == 1) {
                            startMarker = new google.maps.Marker({
                                position: response.request.origin,
                                icon: '../../img/Map-PointerGreen.png',
                                title: (counter + 1) + '' + ' \n' + arrTitels[counter].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח")
                            });
                        }
                    }

                    if (pointStatus == 0) {
                       
                        endMarker = new google.maps.Marker({
                            position: response.request.destination,
                            icon: '../../img/Map-PointerRed.png',
                            map: map,
                            //title: (counter + 2) + '' + ' \n' + arrTitels[counter + 1].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח")
                            title: 'aa'
                        });
                    }
                    else if (pointStatus == 1) {
                        endMarker = new google.maps.Marker({
                            position: response.request.destination,
                            icon: '../../img/Map-PointerGreen.png',
                            map: map,
                            //title: (counter + 2) + '' + ' \n' + arrTitels[counter + 1].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח")
                            title: 'aa'
                        });
                    }




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
                                var infowindow = new google.maps.InfoWindow({ content: (counter + 1) + ' <br/>' + arrWinMsgs[counter] + jqXHR.responseText.split('^')[0].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח") });//+ "<br/>מרחק: " + distance
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

                                    var infowindow = new google.maps.InfoWindow({ content: (counter + 2) + ' ' + ' <br/>' + arrWinMsgs[counter + 1] + jqXHR.responseText.split('^')[0].replace("Customer address", "//Customer address").replace("כתובת לקוח", "//כתובת לקוח") });//+ "<br/>מרחק: " + distance 
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
            };
            AgentsListChange('-1');


    </script>
</body>
</html>
