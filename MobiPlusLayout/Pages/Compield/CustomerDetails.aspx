<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerDetails.aspx.cs" Inherits="Pages_Compield_CustomerDetails" %>

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
                <asp:ScriptReference Path="~/js/customerDetails.js" />
                <asp:ScriptReference Path="~/js/dist/js/select2.min.js" />
                <asp:ScriptReference Path="~/js/jszip.min.js" />
            </Scripts>
            <Services>
                <asp:ServiceReference Path="~/Handlers/HardwareWebService.asmx" />
            </Services>
        </asp:ScriptManager>
   <div id="divCustomerDetails">
            <table id="grdCustomerDetails">
            </table>
            <div id="grdCustomerDetailsPager">
            </div>
        </div>
        <asp:HiddenField ID="hidMainDivHeight" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDriver_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidTaskDescription_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidShipment_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCustomer_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCustomerAddress_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDescription_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDeliveryNum_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidComment_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDeliveryTime_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDelivery_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidLanguage" ClientIDMode="Static" runat="server" />
    </form>
</body>
</html>
