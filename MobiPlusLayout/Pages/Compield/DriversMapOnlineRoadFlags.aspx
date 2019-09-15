﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DriversMapOnlineRoadFlags.aspx.cs" Inherits="Pages_Compield_DriversMapOnlineRoadFlags" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="lnkUi" runat="server" rel="stylesheet" />
    <link id="lnkStruct" runat="server" rel="stylesheet" />
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
     <link href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <%--<link href="../../css/redmond/jquery-ui.theme.css" rel="stylesheet" />--%>
    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />

    <script type="text/javascript">
        (function () {
            var lang = '<%= SessionLanguage %>';
            var href;
            switch (lang.toLowerCase()) {
                case 'he':
                    href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>";
                    break;
                case 'en':
                    href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>";
                    break;
                case 'ge':
                    href = "../../css/MainLTR.css?SessionID=<%= Session.SessionID%>";
                    break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;
        })();

    </script>
</head>
<body>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=<%= SessionLanguage %>&ie=UTF8&key=AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk"></script>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Path="~/css/redmond/jquery.js" />
                <asp:ScriptReference Path="~/js/jquery-ui.js" />
                <asp:ScriptReference Path="~/js/markerwithlabel.js" />
                <asp:ScriptReference Path="~/js/lodash.js" />
                <asp:ScriptReference Path="~/js/Main.js" />
               
            </Scripts>
            <Services>
                <asp:ServiceReference Path="~/Handlers/HardwareWebService.asmx" />
            </Services>
        </asp:ScriptManager>
        <script type="text/javascript" src="../../js/driverMap.js?as=<%= Session.SessionID%>"></script>
        <script>
            $.datepicker.setDefaults({ yearRange: '2010:c', onSelect: function() { alert('changed');}});
        </script>
        <div>
        </div>
        <div style="padding-left: 0px; padding-right: 10px; width: 164px; vertical-align: top; float: right;">

            <input id="txtDate" runat="server" type="text" readonly="readonly" class="txtDateRoutes DateTimepicker" style="width: 160px;" />
            <br />
            <div>
                <asp:CheckBox ID="cbOnline" runat="server" ClientIDMode="Static" />
                <br />
                <asp:CheckBox ID="cbFlags" runat="server" ClientIDMode="Static" />
                <br />
                <asp:CheckBox ID="cbRoad" runat="server" ClientIDMode="Static" />
                <br />
                <asp:CheckBox ID="cbRealDirection" Visible="false" runat="server" Text="4" ClientIDMode="Static" />
            </div>
            <div style="height:15px"><span id="commentGPS" style="color:red"></span></div>
            <div class="AgentsHederDiv"><%=StrSrc("DriversList")%></div>
            <div>
                <asp:ListBox CssClass="LBAgents1" Width="160px" Height="600px" ID="AgentsList" runat="server" ClientIDMode="Static"></asp:ListBox>
            </div>
            <asp:HiddenField runat="server" ID="hdnCustomCoord" ClientIDMode="Static" />
            <asp:HiddenField runat="server" ID="hdnSessionLanguage" ClientIDMode="Static" />
            <asp:HiddenField runat="server" ID="hdnLat" ClientIDMode="Static" />
            <asp:HiddenField runat="server" ID="hdnLon" ClientIDMode="Static" />
        </div>

        <div style="float: left; height: 100%;" id="MapObj">
            <div id="map-canvas"></div>
	    <div id="divInfoWin" class="ui-widget-content gm-style-mtc map-info-window"></div>
        </div>
    </form>
</body>
</html>
