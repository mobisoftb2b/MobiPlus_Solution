<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowFrame.aspx.cs" Inherits="Pages_RPT_ShowFrame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>הצגת דוח</title>
    <link rel="stylesheet" href="../../css/jquery-ui-1.9.2.custom.css" />
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <link rel="stylesheet" href="../../css/Main.css" />
    <script type="text/javascript" src="../../js/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../../js/jquery-ui-resizeRight.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="dFrame">
    </div>
    <asp:HiddenField runat="server" id="hdnSrcParams"/>
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
