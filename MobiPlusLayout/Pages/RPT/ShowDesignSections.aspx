<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowDesignSections.aspx.cs" Inherits="Pages_RPT_ShowSections" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../js/jquery-1.11.0.min.js?SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/main.js?SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery-1.10.2.js?SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js?SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery.ui.touch-punch.min.js?SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/grid.locale-en.js?SessionID=<%= Session.SessionID%>"></script>
    <script src="../../js/jquery.blockUI.js?SessionID=<%= Session.SessionID%>" type="text/javascript"></script>
    <script type="text/javascript" src="../../js/json2.js?SessionID=<%= Session.SessionID%>"></script>
    <script type="text/javascript" src="../../js/jquery.jqGridWithSearch.js?SessionID=<%= Session.SessionID%>"></script>

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
    </script>
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
        <div runat="server" id="SectionsDiv">
        </div>
        <asp:HiddenField runat="server" ID="hdnData" Value="" />
    </form>
    <script type="text/javascript">
        //$(".FragmentAfteDivr")[i].style.marginRight = "-10px";
        function ReloadPage() {
            window.location.href = window.location.href;
        }
        function NavSec() {
            var data = $.parseJSON(unescape($('#<%=hdnData.ClientID%>').val()));

            ridmd = 0;
            var row = data;
            var selr = 1;
            var Row = row;
            //alert('<%=RowOpenReport %>');
            if ('<%=RowOpenReport %>' != '0') {

               // alert(4);
                        parent.parent.openNewReportNewr("<%=RowOpenReport %>", selr, data[selr - 1]);

                        try {

                            parent.parent.NavNewReport(data[selr - 1].Code, selr);
                        }
                        catch (e) {
                        }
                    }
                    if ('<%=RowOpenForm %>' != '0') {

                var selr = jQuery('#jQGrid').jqGrid('getGridParam', 'selrow');
                parent.parent.openNewForm("<%=RowOpenForm %>", selr);
                    }

                    if ('<%=RowOpenRoutes %>' != '0') {
                var data = $('#jQGrid').jqGrid('getGridParam', 'data');
                var selr = jQuery('#jQGrid').jqGrid('getGridParam', 'selrow');
                parent.parent.openRoutesCustEdit(data[selr - 1], selr);

            }
        }
        setTimeout('ReloadPage();', 5 * 60 * 1000);
        $(".TempletBox").click(NavSec);

    </script>
</body>
</html>
