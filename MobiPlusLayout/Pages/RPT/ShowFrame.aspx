<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowFrame.aspx.cs" Inherits="Pages_RPT_ShowFrame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%=StrSrc("Title")%></title>
    <link rel="stylesheet" href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" />
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
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
    <script type="text/javascript" src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js?Ver=<%=ClientVersion %>"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="dFrame">
        </div>
        <asp:HiddenField runat="server" ID="hdnSrcParams" />
    </form>
    <script type="text/javascript">
        var NewHeight = $(document).height() ;
        var NewWidth = $(document).width()-40 ;

        function GetIframe(Rep, id) {
            var i = 0;
            if (Rep.indexOf("Rep_7") > -1) {//pie
                return "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='ShowGrafPie.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + NewWidth + "&Height=" + NewHeight + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else if (Rep.indexOf("Rep_8") > -1) {//bar
                return "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='ShowGrafBar.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + NewWidth + "&Height=" + NewHeight + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else if (Rep.indexOf("Rep_9") > -1) {//clock
                return "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='ShowGrafClock.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + NewWidth + "&Height=" + NewHeight + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
            else {//grid
                return "<iframe id='if_" + i.toString() + "' frameborder='0' scrolling='no' src='ShowReport.aspx?ID=" + id + "&WinID=if_" + i.toString() + "&Width=" + NewWidth + "&Height=" + NewHeight + $('#<%=hdnSrcParams.ClientID %>').val() + "' class='ifReport' />";
            }
}
function ShowFrame(Rep, id) {
    $('#dFrame')[0].innerHTML = GetIframe(Rep, id);
           
}


$('#dFrame').height(NewHeight);

function ReloadPage() {
    window.location.href = window.location.href;
}
setTimeout('ReloadPage();', 5 * 60 * 1000);
    </script>
</body>
</html>
