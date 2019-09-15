<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AgentMap.aspx.cs" Inherits="Pages_Compield_AgentMap1" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="../../img/Map.ico" />
    <title>מסלול יומי</title>
    <style type="text/css">
        html, body, #map-canvas
        {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        .Title1
        {
            font-size: 18px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
        }
        .data
        {
            font-size: 14px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
        }
        .tbl
        {
            font-size: 14px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            width: 100%;
        }
        .HeadData
        {
            font-size: 22px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            text-align: center;
            padding: 5px;
            width: 97%;
            vertical-align: top;
        }
        .DateData
        {
            font-size: 16px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            text-align: center;
            padding: 5px;
            width: 92%;
            vertical-align: top;
        }
         .MaslulData
        {
            font-size: 22px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            text-align: center;
            padding: 5px;
            width: 92%;
            vertical-align: top;
        }
        .rtl
        {
            direction: rtl;
        }
        .logo1
        {
            text-align: left;
            vertical-align: top;
            padding-left: 5px;
        }
        .top1
        {
            vertical-align: top;
        }
        .msgData
        {
            height: 500px;
            margin-top: 200px;
            font-size: 26px;
            color: Gray;
            font-weight: 700;
            direction: rtl;
            text-align: center;
            padding: 5px;
            display: none;
            padding-left: 150px;
        }
    </style>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=iw&ie=UTF8&key=AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk">\
    </script>
    <%-- <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=iw&ie=UTF8&key=AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk">\
    </script>
    <script type="text/javascript">
        function initialize() {
//            var mapOptions = {
//                center: { lat: -34.397, lng: 150.644 },
//                zoom: 8
//            };
            var myLatlng = new google.maps.LatLng(32.0718148, 34.7818134);
            var myLatlng2 = new google.maps.LatLng(32.077697, 34.7812353);
            var myLatlng3 = new google.maps.LatLng(32.0828852, 34.7813994);
            var myLatlng4 = new google.maps.LatLng(32.088053, 34.7822709);
            var myLatlng5 = new google.maps.LatLng(32.0915922, 34.7830827);
            var myLatlng6 = new google.maps.LatLng(32.0955367, 34.7837225);
            var myLatlng7 = new google.maps.LatLng(32.0723904, 34.7783827);
            var myLatlng8 = new google.maps.LatLng(32.0732759, 34.776977);
            var myLatlng9 = new google.maps.LatLng(32.0740481, 34.7752588);
            var myLatlng10 = new google.maps.LatLng(32.0743677, 34.7747392);
            var myLatlng11 = new google.maps.LatLng(32.0757194, 34.7721062);
            var myLatlng12 = new google.maps.LatLng(32.0769281, 34.7698722);
            var myLatlng17 = new google.maps.LatLng(32.0779164, 34.7678876);

            var myLatlng34 = new google.maps.LatLng(32.0871589, 34.7820669);
            
            var mapOptions = {
                zoom: 15,
                center: myLatlng3
            }
            var map = new google.maps.Map(document.getElementById('map-canvas'),
            mapOptions);

            var marker = new google.maps.Marker(
            {
                position: myLatlng,
                map: map,
                title: '6: ועקנין אברהם - אבן גבירול 8, תל אביב'
            });
            var marker2 = new google.maps.Marker(
            {
                position: myLatlng2,
                map: map,
                title: '5: מיני מאנה - אבן גבירול 61, תל אביב'
            });

            var marker3 = new google.maps.Marker(
            {
                position: myLatlng3,
                map: map,
                title: '4: גדליהו רפאל - אבן גבירול 92, תל אביב'
            });

            var marker4 = new google.maps.Marker(
            {
                position: myLatlng4,
                map: map,
                title: '3: שופרסל שלי אבן גבירול - אבן גבירול 124, תל אביב'
            });

            var marker5 = new google.maps.Marker(
            {
                position: myLatlng5,
                map: map,
                title: '2: מיני סטור חזקיהו יעקב - אבן גבירול 163, תל אביב'
            });

            var marker6 = new google.maps.Marker(
            {
                position: myLatlng6,
                map: map,
                title: '1: י.נ דיזנגוף - אבן גבירול 193, תל אביב'
            });

            var marker7 = new google.maps.Marker(
            {
                position: myLatlng7,
                map: map,
                title: '7: שפע אלטק - שדרות בן ציון 134, תל אביב'
            });

            var marker8 = new google.maps.Marker(
            {
                position: myLatlng8,
                map: map,
                title: '8: מיני שרית - שדרות בן ציון 152, תל אביב'
            });


            var marker8 = new google.maps.Marker(
            {
                position: myLatlng8,
                map: map,
                title: '9: חימום ישיר - ניהול תחנות דלק ב - שדרות בן ציון 152, תל אביב'
            });

            var marker9 = new google.maps.Marker(
            {
                position: myLatlng9,
                map: map,
                title: '10: עוף והודו ברקת בע"מ פ"ת - בוגרשוב 152, תל אביב'
            });

            
            var marker10 = new google.maps.Marker(
            {
                position: myLatlng10,
                map: map,
                title: '11: טוסט קיו סק - בוגרשוב 100, תל אביב'
            });

            var marker11 = new google.maps.Marker(
            {
                position: myLatlng11,
                map: map,
                title: '12: י.ל ממתקים בע"מ -בוגרשוב 54, תל אביב'
            });

            var marker12 = new google.maps.Marker(
            {
                position: myLatlng12,
                map: map,
                title: '13: שמעונוביץ ישראל - בוגרשוב 26, תל אביב'
            });

            var marker17 = new google.maps.Marker(
            {
                position: myLatlng17,
                map: map,
                title: '14: ביזאייב פאינה - בוגרשוב 3, תל אביב'
            });

            
            
        }
        google.maps.event.addDomListener(window, 'load', initialize);
    </script>--%>
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
<body id="body1">
    <form runat="server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    <div>
        <table cellpadding="0" cellspacing="0" width="100%" class="rtl">
            <tr>
                <td style="padding-right:10px;">
                    <asp:Button runat="server" ID="btnShowAllPoints" Text="מסלול מלא" OnClientClick="SetHdn();" onclick="btnShowAllPoints_Click"/>
                </td>
                <td class="HeadData">
                    הצגת מיקום של מקדם
                    <%=AgentId %>
                    <br />
                    <span class="DateData">
                        <%=DateMap %></span>
                    <br />
                    <span class="MaslulData">
                        מסלול חלקי</span>
                </td>
                <td class="logo1">
                    <img src="../../img/dubekLogo.jpg"/>
                </td>
            </tr>
        </table>
    </div>
    <div class="msgData">
        אין נתונים</div>

        <asp:HiddenField runat="server" ID="hdnAllClick" Value="0"/>

    </form>
    <div id="map-canvas">
    </div>
    
    <script type="text/javascript">
        function initialize() {
            eval("<%=ScriptScr %>");

            if ($('#<%=hdnAllClick.ClientID%>').val() == "1") {
                $('#<%=hdnAllClick.ClientID%>').val("1");
                $('#<%=btnShowAllPoints.ClientID%>').val("מסלול חלקי");
				$('.MaslulData').text("מסלול מלא");
            }
            else {
                $('#<%=hdnAllClick.ClientID%>').val("0");
                $('#<%=btnShowAllPoints.ClientID%>').val("מסלול מלא");
				$('.MaslulData').text("מסלול חלקי");
            }
        }

        function SetHdn() {
            if ($('#<%=hdnAllClick.ClientID%>').val() == "0") {
                $('#<%=hdnAllClick.ClientID%>').val("1");
                $('#<%=btnShowAllPoints.ClientID%>').val("מסלול חלקי");
                $('.MaslulData').text("מסלול מלא");
            }
            else {
                $('#<%=hdnAllClick.ClientID%>').val("0");
                $('#<%=btnShowAllPoints.ClientID%>').val("מסלול מלא");
                $('.MaslulData').text("מסלול חלקי");
            }
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


        $('#body1').height($(document).height() - 180 + "px");


       
    </script>
</body>
</html>
