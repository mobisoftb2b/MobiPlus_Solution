<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowSections.aspx.cs" Inherits="Pages_RPT_ShowSections" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>


    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        function styler() {
            var lang='<%= Lang %>';
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
<body  onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server"></asp:ScriptManager>
    <div runat="server" id="SectionsDiv">
    
    </div>
    </form>
    <script type="text/javascript">
        //$(".FragmentAfteDivr")[i].style.marginRight = "-10px";
        function ReloadPage() {
            window.location.href = window.location.href;
        }
        setTimeout('ReloadPage();', 5 * 60 * 1000);
    </script>
</body>
</html>
