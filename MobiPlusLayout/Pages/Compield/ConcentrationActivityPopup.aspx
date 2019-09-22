﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ConcentrationActivityPopup.aspx.cs" Inherits="Pages_Compield_ConcentrationActivityPopup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="lnkUi" runat="server" rel="stylesheet" />
    <link id="lnkStruct" runat="server" rel="stylesheet" />
    <link href="../../css/redmond/jquery-ui.theme.css" rel="stylesheet" />
    <link href="../../css/redmond/css/ui.jqgrid.css" rel="stylesheet" />
    <link href="../../js/dist/css/select2.min.css" rel="stylesheet" />
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
                case 'Ge':
                    href = "../../css/MainLTR.css?SessionID=<%= Session.SessionID%>";
                    break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;

        })();

    </script>
   <script type="text/javascript" src="../../css/redmond/jquery.js"></script>
   <script type="text/javascript" src="../../css/redmond/jquery-ui-1.9.2.custom.js"></script>
   <script type="text/javascript" src="../../css/redmond/jqgrid/i18n/grid.locale-en.js"></script>
   <script type="text/javascript" src="../../css/redmond/jqgrid/jquery.jqGrid.js"></script>
   <script type="text/javascript" src="../../js/jquery.blockUI.js"></script>
    <script type="text/javascript" src="../../js/dist/js/select2.min.js"></script>
     <script type="text/javascript" src="../../js/jszip.min.js"></script>
    <script type="text/javascript" src="../../js/Main.js?se=<%=Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/concActivityPopup.js?se=<%=Session.SessionID%>"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/Handlers/HardwareWebService.asmx" />
            </Services>
        </asp:ScriptManager>
        <div id="divContActivityDetails">
            <table id="grdContActivityDetails">
            </table>
            <div id="grdContActivityDetailsPager">
            </div>
        </div>
         <asp:HiddenField ID="hidLanguage" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidShipment_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDriverName_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidOrder_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCycle_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidActualSortOrder_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCustomer_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidAddress_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidTravelHours_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidServiceHours_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidOriginalTime_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDeliveryTime_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDeliveries_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidAgentReturn_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDriverReturn_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidPallets_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDriverStatus_Grid_Header" ClientIDMode="Static" runat="server" />
         <asp:HiddenField ID="hidRouteAdherence_Grid_Header" ClientIDMode="Static" runat="server" />
    </form>
</body>
</html>
