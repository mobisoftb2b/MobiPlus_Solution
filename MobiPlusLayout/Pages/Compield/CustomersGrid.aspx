<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomersGrid.aspx.cs" Inherits="Pages_Compield_CustomersGrid" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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
                 case 'He': href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                 case 'En': href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
             }
             document.getElementById('MainStyleSheet').href = href;
        }
        styler();
    </script>
    <script src="../../js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
    <script type="text/javascript">
        var SelectedTab = 5;
        var lastCode = 0;
        var isFirstClick = true;

        function NavAllFrame(val, ControlKeies) {
            parent.NavAllFrame(val, ControlKeies);
        }
        function SetH() {
            //alert($(window).height());
            $('.ifReport').height($(window).height() / 2.3 + "px");
            $('.CustGridsBox').height($(window).height() / 2.3 + "px");
            var width = $(window).width() * 1.0;
            $('.ifReport')[0].src = '../RPT/ShowReport.aspx?Name=CustomersGrid&WinID=1if_1&Width=' + width + '&Height=' + $(window).height() / 2.3;

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
                    $('.ifTab')[0].src = '../RPT/ShowReport.aspx?Code=' + lastCode + '&Name=None&WinID=1if_12&Width=' + width + '&Height=' + $(window).height();
                    break;
                case 3:
                    $('.ifTab')[0].src = '../RPT/ShowReport.aspx?Code=' + lastCode + '&Name=Contacts&WinID=1if_12&Width=' + width + '&Height=' + $(window).height();
                    break;
                case 5:
                    $('.ifTab')[0].src = '../RPT/ShowReport.aspx?Code=' + lastCode + '&Name=Mitkanim&WinID=1if_12&Width=' + width + '&Height=' + $(window).height();
                    break;
            }
        }
    </script>

</head>
<body onload="SetH();setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <div style="">
        <div id="dAll1">
            <iframe id='1if_1' frameborder='0' scrolling='no' src='' class='ifReport'></iframe>
        </div>
        <table class="tableCustomersGrid" cellpadding="0" cellspacing="0">
            <tr>
                <td class="dMerchandiseItem1 c0">
                    <div id="dItems" class="small1" onclick="NavTab(0);">
                        <div class="dMerchandiseItemText">
                            <%=StrSrc("CInformationPermissions")%>  
                        </div>
                    </div>
                </td>
                <td class="dMerchandiseItem1 c1">
                    <div id="dAgents" class="small1" onclick="NavTab(1);">
                        <div class="dMerchandiseItemText">
                           <%=StrSrc("Financial")%>   
                        </div>
                    </div>
                </td>
                <td class="dMerchandiseItem1 c2">
                    <div id="dCategories" class="small1" onclick="NavTab(2);">
                        <div class="dMerchandiseItemText">
                           <%=StrSrc("Sites")%>   
                        </div>
                    </div>
                </td>
                <td class="dMerchandiseItem1 c3">
                    <div id="dCustomers" class="small1" onclick="NavTab(3);">
                        <div class="dMerchandiseItemText">
                             <%=StrSrc("Contacts")%> 
                        </div>
                    </div>
                </td>
                <td class="dMerchandiseItem1 c4">
                    <div id="Div1" class="small1" onclick="NavTab(4);">
                        <div class="dMerchandiseItemText">
                            <%=StrSrc("VisitDays")%>  
                        </div>
                    </div>
                </td>
                <td class="dMerchandiseItem1 c5">
                    <div id="Div2" class="small1" onclick="NavTab(5);">
                        <div class="dMerchandiseItemText">
                            <%=StrSrc("Facilities")%>  
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <div class="CustGridsBox">
            <iframe id='Iframe1' frameborder='0' scrolling='no' src='' class='ifReport ifTab'>
            </iframe>
        </div>
    </div>
    </form>
    <script type="text/javascript">

        function openNewReport(id, RowID) {
            //            $('.ifTab').height("700px");
            //            var width = $(window).width() * 1.0;
            //            $('.ifTab')[0].src = '../RPT/ShowReport.aspx?Name=Contacts&RowID="+RowID+"&WinID=1if_1&Width=' + width + '&Height=' + $(window).height();
        }
        function NavNewReport(Code, RowID) {
            //            $('.ifTab').height($(window).height() + "px");
            //            var width = $(window).width() * 1.0;
            //            $('.ifTab')[0].src = '../RPT/ShowReport.aspx?Code='+Code+'&Name=Contacts&WinID=1if_1&Width=' + width + '&Height=' + $(window).height();
            lastCode = Code;
            NavTab(SelectedTab);
        }
        NavTab(SelectedTab);


    </script>
    <script type="text/javascript">
        $('.dMerchandiseItem1').width($(window).width() / 7 + "px");
        $('.dMerchandiseItemText').css("font-size", "12px");
    </script>
</body>
</html>
