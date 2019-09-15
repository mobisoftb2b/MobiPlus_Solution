<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DriverReport.aspx.cs" Inherits="Pages_Compield_DriverReport" %>

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
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Path="~/css/redmond/jquery.js" />
                <asp:ScriptReference Path="~/css/redmond/jquery-ui-1.9.2.custom.js" />
                <asp:ScriptReference Path="~/css/redmond/jqgrid/i18n/grid.locale-en.js" />
                <asp:ScriptReference Path="~/css/redmond/jqgrid/jquery.jqGrid.js" />
                <asp:ScriptReference Path="~/js/jquery.blockUI.js" />
                <asp:ScriptReference Path="~/js/Main.js" />
                <asp:ScriptReference Path="~/js/driverReport.js" />
		<asp:ScriptReference Path="~/js/jszip.min.js" />
            </Scripts>
            <Services>
                <asp:ServiceReference Path="~/Handlers/HardwareWebService.asmx" />
            </Services>
        </asp:ScriptManager>

        <table style="width:100%">
            <tr>
                <td style="width: 60%; vertical-align:top">
                    <div id="divDriverReport">
                        <table id="grdDriverReport">
                        </table>
                        <div id="grdDriverReportPager">
                        </div>
                    </div>
                </td>
                <td style="width: 40%; vertical-align:top">
                    <div id="divNotVisit">
                        <table id="grdNotVisit">
                        </table>
                        <div id="grdNotVisitPager">
                        </div>
                    </div>
                </td>
            </tr>
        </table>



        <asp:HiddenField ID="hidDocDate_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDocStartTime_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDriverName_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidReference_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidShipmentNumber_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCustomerData_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidItem_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidOrigCases_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCaseQuantity_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidQTY_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidReturnResCode_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidLanguage" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidReasonDescription_Grid_Header" ClientIDMode="Static" runat="server" />

        <asp:HiddenField ID="hidTaskDate_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidShipmentID_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidTaskID_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDelivery_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidReportDescription_Grid_Header" ClientIDMode="Static" runat="server" />

        <asp:HiddenField ID="hidAddbuttonCaption" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidSearchButtonCaption" runat="server" ClientIDMode="Static" />
    </form>
</body>
</html>
