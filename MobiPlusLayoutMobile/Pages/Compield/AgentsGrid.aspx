<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AgentsGrid.aspx.cs" Inherits="Pages_Compield_CustomersGrid" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>לקוחות</title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <script src="../../js/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../../js/jquery-1.10.2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <script src="../../js/Main.js" type="text/javascript"></script>
    <script src="../../js/json2.js" type="text/javascript"></script>
    <script src="../../js/jquery-ui.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../../css/jquery-ui.css" />
    <script src="../../js/jquery.ui.touch-punch.min.js" type="text/javascript"></script>
    <link href="../../css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <link href="../../css/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery.jqGrid.js" type="text/javascript"></script>
    <script src="../../js/grid.locale-en.js" type="text/javascript"></script>
    <script src="../../js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="../../js/tree/jquery.tree.js" type="text/javascript"></script>
    <link href="../../css/tree/jquery.tree.css" rel="stylesheet" type="text/css" />
    <link href="../../css/Main.css" rel="stylesheet" type="text/css" />
    <link href="../../css/WebMain.css" rel="stylesheet" type="text/css" />
    <script src="../../js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
    <script type="text/javascript">
        var isFirstClick = true;
        function NavAllFrame(val, ControlKeies) {
            parent.NavAllFrame(val, ControlKeies);
        }
        function SetH() {
            //alert($(window).height());
            $('#dAll1').height($(window).height() + "px");
            $('.ifReport').height($(window).height() + "px");
            var width = $(window).width() - 200 * 1.0;
            $('.ifReport')[0].src = '../RPT/ShowReport.aspx?Name=AgentsGrid&WinID=1if_1&Width=' + width + '&Height=' + $(window).height();
        }
    </script>
</head>
<body onload="SetH();setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <div id="dAll1">
        <table cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td style="width: 150px; padding-right: 10px; padding-left: 10px; vertical-align: top;"
                    class="dMerchandiseItemNewTD">
                    <div id="dItems" class="dMerchandiseItemNew" onclick="NavFrame(4);">
                        <div class="dMerchandiseItemText">
                            פרטי סוכן והרשאות
                        </div>
                    </div>
                    <div id="dCategories" class="dMerchandiseItemNew" onclick="NavFrame(3);">
                        <div class="dMerchandiseItemText">
                            הודעות / התראות
                        </div>
                    </div>
                    <div id="dCustomers" class="dMerchandiseItemNew" onclick="NavFrame(2);">
                        <div class="dMerchandiseItemText">
                            משימות
                        </div>
                    </div>
                    <div id="dAgents" class="dMerchandiseItemNew " onclick="NavFrame(1);">
                        <div class="dMerchandiseItemText">
                            שאלונים
                        </div>
                    </div>
                    <div id="Div1" class="dMerchandiseItemNew " onclick="NavFrame(1);">
                        <div class="dMerchandiseItemText">
                            יעדים
                        </div>
                    </div>
                    <script type="text/javascript">
                        $('.dMerchandiseItemNewTD').width($(window).width() / 7 + "px");
                        $('.dMerchandiseItemNew').width($(window).width() / 7 + "px");
                    </script>
                </td>
                <td>
                    <iframe id='1if_1' frameborder='0' scrolling='no' src='' class='ifReport' />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
