<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomersGrid2.aspx.cs" Inherits="Pages_Compield_CustomersGrid" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>לקוחות</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/Main.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/json2.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css?Ver=<%=ClientVersion %>" />
    <script src="../../js/jquery.ui.touch-punch.min.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <script src="../../js/tree/jquery.tree.js?Ver=<%=ClientVersion %>" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css?Ver=<%=ClientVersion %>" rel="stylesheet" type="text/css" />
   <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        function styler() {
            var lang='<%= Lang %>';
             var href;
             switch (lang) {
                 case 'He':href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                 case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                  default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
             }
             document.getElementById('MainStyleSheet').href = href;
        }
        styler();
    </script>
    <script src="../../js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
    <script type="text/javascript">
        function NavAllFrame(val, ControlKeies) {
            parent.NavAllFrame(val, ControlKeies);
        }
        function SetH() {
            //alert($(window).height());
//            $('#dAll1').height($(window).height() / 2, 3 + "px");
//            $('.ifReport').height($(window).height() / 2.3 + "px");
//            var width = $(window).width() * 1.0;
//            $('.ifReport')[0].src = '../RPT/ShowReport.aspx?Name=CustomersGrid&WinID=1if_1&Width=' + width + '&Height=' + $(window).height() / 2.3;
        }
    </script>
</head>
<body onload="SetH();setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <div style="">
        <div id="dAll1">
        aaafdsafASf
            <iframe id='1if_1' frameborder='0' scrolling='no' src='' class=''  />
            ggggg
        </div>
        <div>
            aaaaaaaaaaaaaaaaaaaaaaaa
        </div>
        <table cellpadding="0" cellspacing="0" width="100%" style="height: 100%;">
            <tr>
                <td style="width: 150px; padding-right: 10px; padding-left: 10px; vertical-align: top;">
                    <div id="dItems" class="dMerchandiseItemNew" onclick="NavFrame(4);">
                        <div class="dMerchandiseItemText">
                            פרטי לקוח והרשאות
                        </div>
                    </div>
                    <div id="dCategories" class="dMerchandiseItemNew" onclick="NavFrame(3);">
                        <div class="dMerchandiseItemText">
                            אתרים
                        </div>
                    </div>
                    <div id="dCustomers" class="dMerchandiseItemNew" onclick="NavFrame(2);">
                        <div class="dMerchandiseItemText">
                            אנשי קשר
                        </div>
                    </div>
                    <div id="dAgents" class="dMerchandiseItemNew " onclick="NavFrame(1);">
                        <div class="dMerchandiseItemText">
                            פיננסי
                        </div>
                    </div>
                    <div id="Div1" class="dMerchandiseItemNew " onclick="NavFrame(1);">
                        <div class="dMerchandiseItemText">
                            ימי ביקור
                        </div>
                    </div>
                    <div id="Div2" class="dMerchandiseItemNew " onclick="NavFrame(1);">
                        <div class="dMerchandiseItemText">
                            מתקנים
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
