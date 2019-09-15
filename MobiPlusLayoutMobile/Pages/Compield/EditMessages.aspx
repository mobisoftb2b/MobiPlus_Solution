<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditMessages.aspx.cs" Inherits="Pages_Compield_EditMessages" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>הודעות</title>
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
    <script src="../../js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
    <script type="text/javascript">
        var SelectedTab = 0;
        var lastCode = 0;
        var isFirstClick = true;

        function NavAllFrame(val, ControlKeies) {
            parent.NavAllFrame(val, ControlKeies);
        }
        function SetH() {
//            //alert($(window).height());
//            $('.ifReport').height($(window).height() / 2.3 + "px");
//            $('.CustGridsBox').height($(window).height() / 2.3 + "px");
//            var width = $(window).width() * 1.0;
//            $('.ifReport')[0].src = '../RPT/ShowReport.aspx?Name=CustomersGrid&WinID=1if_1&Width=' + width + '&Height=' + $(window).height() / 2.3;

        }
        function NavTab(TabID) {
            $('.ifTab').height($(window).height() + "px");
            var width = $(window).width() * 1.0;

            $('.c' + SelectedTab)[0].className = "dMerchandiseItem1" + " c" + SelectedTab.toString();
            SelectedTab = TabID;
            $('.c' + SelectedTab)[0].className = "dMerchandiseItem1 Selected" + " c" + TabID.toString();

            $('.ifTab')[0].src = '';

            switch (TabID) {
                case 0:
                    $('.ifTab')[0].src = 'Messages.aspx?Agents=true';
                    break;
                case 1:
                    $('.ifTab')[0].src = 'Messages.aspx?Agents=false';
                    break;
            }
        }
    </script>
    <style type="text/css">
        .dMerchandiseItem1
        {
            text-align: center;
            width: 200px;
            height: 30px;
            margin-top: 5px;
            margin-left: 5px;
            vertical-align: middle;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            border: 1px solid white;
            cursor: pointer;
            float: right;
            background-color: #264366;
            color: White;
        }
        .dMerchandiseItem1:hover
        {
            background-color: #FA6E58;
            color: White;
        }
        .dMerchandiseItem1.Selected
        {
            background-color: #FA6E58;
            color: White;
        }
        .dMerchandiseItem1.small1
        {
            width: 100px !important;
        }
        
        .dMerchandiseItemText
        {
            height: 100%;
            margin-top: 5px;
            font-size: 14px;
        }
        .CustGridsBox
        {
            width: 99.5%;
            background-color: White;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
            margin-right: 2px;
        }
    </style>
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <div>
    <table cellpadding="0" cellspacing="0" style="height: 100%; text-align: right; direction: rtl;">
            <tr>
                <td class="dMerchandiseItem1 Selected c0">
                    <div id="dItems" class="small1" onclick="NavTab(0);">
                        <div class="dMerchandiseItemText">
                            סוכנים
                        </div>
                    </div>
                </td>
                <td class="dMerchandiseItem1 c1">
                    <div id="dAgents" class="small1" onclick="NavTab(1);">
                        <div class="dMerchandiseItemText">
                            לקוחות
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <div class="CustGridsBox">
            <iframe id='IframeMSGs' frameborder='0' width="100%" height="100%" scrolling='no' class="ifTab" src="Messages.aspx?Agents=true" >
            </iframe>
        </div>
    </div>
    </form>
    <script type="text/javascript">
        $('#IframeMSGs').height($(document).height()+"px");
    </script>
</body>
</html>
