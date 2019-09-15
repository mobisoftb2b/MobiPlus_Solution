<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Routes.aspx.cs" Inherits="Pages_Compield_Routes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>מסלולים</title>
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
    <script src="../../js/jquery.RowTimepicker.js"></script>
    <link href="../../css/jquery.RowTimepicker.css" rel="stylesheet" />
    <script type="text/javascript">
        function CloseEditBoxPopup() {
            parent.$(".routes").css({ top: 100 })
                            .animate({ "top": "-640" }, "high");
            parent.$('#dBody').unblock();
            MassageApprov.innerText = "";
        }
        $(".DateTimepicker").text = Date.now();


    </script>
</head>
<body id="dBodyr" onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
        <div>
            <div class="BodyRoutes">
                <div class="HeadRoutes">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td>
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">×</button>
                            </td>
                            <td style="" class="HeadRoutesText">תכנון זמנים למסלול עבור - <%= CustName %>
                            </td>

                        </tr>
                    </table>
                </div>
                <fieldset class="fieldset1">
                    <legend><%=StrSrc("ErrorSaving")%>תבנית מופע חוזר</legend>
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="vertical-align: top">
                                <table cellpadding="2" cellspacing="2">
                                    <tr>
                                        <td>
                                            <asp:RadioButtonList runat="server" ID="rblPeriods">
                                                <asp:ListItem Selected="True" Text="מחזורי" Value="1" onchange="ShowRoutes('rblPeriods_0');"></asp:ListItem>
                                                <asp:ListItem Selected="False" Text="תאריך" Value="2" onchange="ShowRoutes('rblPeriods_1');"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="RoutesLine"></td>
                            <td style="vertical-align: top; padding-right: 10px">
                                <div runat="server" id="CyclicRoutes" class="CyclicRoutes">
                                </div>
                                <div class="DateRoutes">
                                    <table cellpadding="2" cellspacing="2">
                                        <tr>
                                            <td><%=StrSrc("Date")%></td>
                                            <td>
                                                <input id="txtRouteDate" type="text" readonly="true" class="txtDateRoutes DateTimepicker" />
                                            </td>

                                            <td rowspan="4">
                                                <asp:ListBox SelectionMode="Multiple" CssClass="LBDates" ID="DateList" runat="server"></asp:ListBox>
                                            </td>

                                        </tr>
                                        <tr>

                                            <td><%=StrSrc("FromTime")%>: </td>
                                            <td>
                                                <input id="txtFromTimeDate" type="text" onchange="changeStart(this.value)" class="txtTime2 StartHour FromTime" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%=StrSrc("ToTime")%>: </td>
                                            <td>
                                                <input id="txtToTimeDate" type="text" onchange="changeEnd(this.value)" class="txtTime2 EndHour ToTime" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input id="btnDelDate" type="button" class="Routes-del-btn" value="מחק" onclick="delFromList();" />
                                                <input id="btnAddDate" type="button" class="Routes-del-btn" value="הוסף" onclick="SendToAdd();" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="DailyRoutes">
                                    <table cellpadding="2" cellspacing="2">
                                        <tr>
                                            <td><%=StrSrc("Every")%>
                                            </td>
                                            <td>
                                                <input id="txtInterval" type="text" class="txtDailyRoutes" maxlength="2" />
                                            </td>
                                            <td><%=StrSrc("Days")%>
                                            </td>
                                            <td style="width: 777px;" rowspan="4"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><%=StrSrc("FromTime")%>: </td>
                                            <td>
                                                <input id="txtFromTimeDaily" type="text" onchange="changeStart(this.value)" class="txtTime2 StartHour FromTime" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><%=StrSrc("ToTime")%>: </td>
                                            <td>
                                                <input id="txtToTimeDaily" type="text" onchange="changeEnd(this.value)" class="txtTime2 EndHour ToTime" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <input id="btnDelInterval" type="button" class="Routes-del-btn" value="מחק" onclick="DelInterval();" />
                                            </td>

                                        </tr>
                                    </table>
                                </div>
                                <div class="WeeklyRoutes">
                                    <table cellpadding="2" cellspacing="2">
                                        <tr>
                                            <td style="width: 20px"></td>
                                            <td class="RouteDays"><%=StrSrc("Sunday")%>
                                            </td>
                                            <td class="RouteDays"><%=StrSrc("Monday")%>
                                            </td>
                                            <td class="RouteDays"><%=StrSrc("Tuesday")%>
                                            </td>
                                            <td class="RouteDays"><%=StrSrc("Wednesday")%>
                                            </td>
                                            <td class="RouteDays"><%=StrSrc("Thursday")%>
                                            </td>
                                            <td class="RouteDays"><%=StrSrc("Friday")%>
                                            </td>
                                            <td class="RouteDays"><%=StrSrc("Saturday")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td class="tdDay">
                                                <div class="day-content">
                                                    <table>
                                                        <tr>
                                                            <td rowspan="2">
                                                                <div id="Wday01" class="Wday01 RouteDayNotSelected" onclick="SetRoutesSelected('Wday01');">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="RouteTimeWday01" onclick="OpenTimeDiv('w','01');">
                                                                    <table>
                                                                        <tr>
                                                                            <td><%=StrSrc("S")%>
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtFTimeWDay01" type="text" readonly="true" class="txtTime FromTime" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>

                                                                            <td><%=StrSrc("E")%>  
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtTTimeWDay01" type="text" readonly="true" class="txtTime ToTime" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>

                                                    </table>
                                                </div>
                                            </td>
                                            <td class="tdDay">
                                                <div class="day-content">
                                                    <table>
                                                        <tr>
                                                            <td rowspan="2">
                                                                <div id="Wday02" class="Wday02 RouteDayNotSelected" onclick="SetRoutesSelected('Wday02');">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="RouteTimeWday02" onclick="OpenTimeDiv('w','02');">

                                                                    <table>
                                                                        <tr>
                                                                            <td><%=StrSrc("S")%>
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtFTimeWDay02" type="text" readonly="true" class="txtTime FromTime" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>

                                                                            <td><%=StrSrc("E")%>  
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtTTimeWDay02" type="text" readonly="true" class="txtTime ToTime" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <td class="tdDay">
                                                <div class="day-content">
                                                    <table>
                                                        <tr>
                                                            <td rowspan="2">
                                                                <div id="Wday03" class="Wday03 RouteDayNotSelected" onclick="SetRoutesSelected('Wday03');">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="RouteTimeWday03" onclick="OpenTimeDiv('w','03');">

                                                                    <table>
                                                                        <tr>
                                                                            <td><%=StrSrc("S")%>
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtFTimeWDay03" type="text" readonly="true" class="txtTime FromTime" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>

                                                                            <td><%=StrSrc("E")%>  
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtTTimeWDay03" type="text" readonly="true" class="txtTime ToTime" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <td class="tdDay">
                                                <div class="day-content">
                                                    <table>
                                                        <tr>
                                                            <td rowspan="2">
                                                                <div id="Wday04" class="Wday04 RouteDayNotSelected" onclick="SetRoutesSelected('Wday04');">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="RouteTimeWday04" onclick="OpenTimeDiv('w','04');">

                                                                    <table>
                                                                        <tr>
                                                                            <td><%=StrSrc("S")%>
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtFTimeWDay04" type="text" readonly="true" class="txtTime FromTime" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>

                                                                            <td><%=StrSrc("E")%>  
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtTTimeWDay04" type="text" readonly="true" class="txtTime ToTime" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <td class="tdDay">
                                                <div class="day-content">
                                                    <table>
                                                        <tr>
                                                            <td rowspan="2">
                                                                <div id="Wday05" class="Wday05 RouteDayNotSelected" onclick="SetRoutesSelected('Wday05');">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="RouteTimeWday05" onclick="OpenTimeDiv('w','05');">

                                                                    <table>
                                                                        <tr>
                                                                            <td><%=StrSrc("S")%>
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtFTimeWDay05" type="text" readonly="true" class="txtTime FromTime" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>

                                                                            <td><%=StrSrc("E")%>  
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtTTimeWDay05" type="text" readonly="true" class="txtTime ToTime" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <td class="tdDay">
                                                <div class="day-content">
                                                    <table>
                                                        <tr>
                                                            <td rowspan="2">
                                                                <div id="Wday06" class="Wday06 RouteDayNotSelected" onclick="SetRoutesSelected('Wday06');">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="RouteTimeWday06" onclick="OpenTimeDiv('w','06');">

                                                                    <table>
                                                                        <tr>
                                                                            <td><%=StrSrc("S")%>
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtFTimeWDay06" type="text" readonly="true" class="txtTime FromTime" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>

                                                                            <td><%=StrSrc("E")%>  
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtTTimeWDay06" type="text" readonly="true" class="txtTime ToTime" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <td class="tdDay">
                                                <div class="day-content">
                                                    <table>
                                                        <tr>
                                                            <td rowspan="2">
                                                                <div id="Wday07" class="Wday07 RouteDayNotSelected" onclick="SetRoutesSelected('Wday07');">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="RouteTimeWday07" onclick="OpenTimeDiv('w','07');">

                                                                    <table>
                                                                        <tr>
                                                                            <td><%=StrSrc("S")%>
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtFTimeWDay07" type="text" readonly="true" class="txtTime FromTime" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>

                                                                            <td><%=StrSrc("E")%>  
                                                                            </td>
                                                                            <td>
                                                                                <input id="txtTTimeWDay07" type="text" readonly="true" class="txtTime ToTime" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <%--          <div class="DailyRoutes">
                        <br />
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td style="width: 651px;"></td>
                                <td><%=StrSrc("FromDate")%>: </td>
                                <td>
                                    <input id="txtFromDateD" type="text" readonly="true" class="txtDateRoutes DateTimepicker" />


                                </td>
                                <td style="width: 25px;"></td>
                                <td><%=StrSrc("ToDate")%>: </td>
                                <td>
                                    <input id="txtToDateD" type="text" readonly="true" class="txtDateRoutes DateTimepicker" />

                                </td>

                            </tr>
                        </table>
                    </div>
                    <div class="WeeklyRoutes">
                        <br />
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td style="width: 651px;"></td>
                                <td><%=StrSrc("FromDate")%>: </td>
                                <td>
                                    <input id="txtFromDateW" type="text" readonly="true" class="txtDateRoutes DateTimepicker" />
                                </td>
                                <td style="width: 25px;"></td>
                                <td><%=StrSrc("ToDate")%>: </td>
                                <td>
                                    <input id="txtToDateW" type="text" readonly="true" class="txtDateRoutes DateTimepicker" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="CyclicRoutes">
                        <br />
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td style="width: 651px;"></td>
                                <td><%=StrSrc("FromDate")%>: </td>
                                <td>
                                    <input id="txtFromDateC" type="text" readonly="true" class="txtDateRoutes DateTimepicker" />
                                </td>
                                <td style="width: 25px;"></td>
                                <td><%=StrSrc("ToDate")%>: </td>
                                <td>
                                    <input id="txtToDateC" type="text" readonly="true" class="txtDateRoutes DateTimepicker" />
                                </td>
                            </tr>
                        </table>
                    </div>--%>
                    <div class="Routes-Approv-div">
                        <%--   <div id="MassageApprov" class="MassageApprov"></div>--%>
                        <span id="MassageApprov"></span>
                        <input id="btnApprov" type="button" class="Routes-Approv-btn" value="<%=StrSrc("Approve")%>" onclick="SetRoutes();" />
                    </div>

                </fieldset>

            </div>
        </div>
        <div id="TimePopover" runat="server" class="TimePopover">
            <div class="TimePopover-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseTimePopover();">×</button>
                <h3 runat="server" id="myModalLabel"><%=StrSrc("TimeEdit")%></h3>
                <table>
                    <tr>
                        <td><%=StrSrc("S")%>
                        </td>
                        <td>
                            <input id="txtFTimePop" type="text" onchange="changeStart(this.value)" class="txtTime2 StartHour FromTime" />
                        </td>
                        <td>&nbsp;&nbsp;
                        </td>

                        <td><%=StrSrc("E")%>  
                        </td>
                        <td>
                            <input id="txtTTimePop" type="text" onchange="changeEnd(this.value)" class="txtTime2 EndHour ToTime" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5">
                            <input id="btnApprovTime" type="button" class="Routes-ApprovTime-btn" value="אישור" onclick="ApprovTime();" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:HiddenField runat="server" ID="hdnDaily" />
        <asp:HiddenField runat="server" ID="hdnWeekly" />
        <asp:HiddenField runat="server" ID="hdnCyclic" />
        <asp:HiddenField runat="server" ID="hdnByDate" />
        <asp:HiddenField runat="server" ID="hdnRouteDates" />

    </form>
    <script type="text/javascript">
        var CustKey = '<%= Cust_Key %>';

        var hdnDailyClientID = '<%=hdnDaily.ClientID %>';
        var hdnWeeklyClientID = '<%=hdnWeekly.ClientID %>';
        var hdnCyclicClientID = '<%=hdnCyclic.ClientID %>';
        var hdnByDateClientID = '<%=hdnByDate.ClientID %>';
        var dayForTime;
        var Op;
        function hideRouteTime() { $('.RouteTime').hide(); }
        hideRouteTime();
        function HideNotWorkDays() {

            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_RoutesGetSettings&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "POST",
                data: ""
            });
            request.done(function (response, textStatus, jqXHR) {
                resParams = jQuery.parseJSON(jqXHR.responseText);
                var NumberOfWeeks = resParams[0].NumberOfWeeksToCyclic;
                if (resParams[0] != null && resParams[0] != "") {

                    var WorkDays = (resParams[0].WorkDays).split(';');
                    var WorkDay1 = false;
                    var WorkDay2 = false;
                    var WorkDay3 = false;
                    var WorkDay4 = false;
                    var WorkDay5 = false;
                    var WorkDay6 = false;
                    var WorkDay7 = false;

                    for (var i = 0; i < WorkDays.length; i++) {
                        switch (WorkDays[i]) {
                            case '1':
                                WorkDay1 = true;
                                break;
                            case '2':
                                WorkDay2 = true;
                                break;
                            case '3':
                                WorkDay3 = true;
                                break;
                            case '4':
                                WorkDay4 = true;
                                break;
                            case '5':
                                WorkDay5 = true;
                                break;
                            case '6':
                                WorkDay6 = true;
                                break;
                            case '7':
                                WorkDay7 = true;
                                break;
                        }
                    }
                    if (!WorkDay1) {
                        $('.Wday01')[0].className = "NotWorkDays";
                        $('.RouteTimeWday01').hide();
                        for (var i = 1; i <= (NumberOfWeeks * 7) ; i = i + 7) {
                            var num = i.toString();
                            if (num.length == 1) { num = "0" + num; }
                            try {
                                $('.Cday' + num)[0].className = "NotWorkDays";
                                $('.RouteTimeCday' + num).hide();
                            } catch (e) { }
                        }
                    }
                    if (!WorkDay2) {
                        $('.Wday02')[0].className = "NotWorkDays";
                        $('.RouteTimeWday02').hide();
                        for (var i = 2; i <= (NumberOfWeeks * 7) ; i = i + 7) {
                            var num = i.toString();
                            if (num.length == 1) { num = "0" + num; }
                            try {
                                $('.Cday' + num)[0].className = "NotWorkDays";
                                $('.RouteTimeCday' + num).hide();
                            } catch (e) { }
                        }
                    }
                    if (!WorkDay3) {
                        $('.Wday03')[0].className = "NotWorkDays";
                        $('.RouteTimeWday03').hide();
                        for (var i = 3; i <= (NumberOfWeeks * 7) ; i = i + 7) {
                            var num = i.toString();
                            if (num.length == 1) { num = "0" + num; }
                            try {
                                $('.Cday' + num)[0].className = "NotWorkDays";
                                $('.RouteTimeCday' + num).hide();
                            } catch (e) { }
                        }
                    }
                    if (!WorkDay4) {
                        $('.Wday04')[0].className = "NotWorkDays";
                        $('.RouteTimeWday04').hide();
                        for (var i = 4; i <= (NumberOfWeeks * 7) ; i = i + 7) {
                            var num = i.toString();
                            if (num.length == 1) { num = "0" + num; }
                            try {
                                $('.Cday' + num)[0].className = "NotWorkDays";
                                $('.RouteTimeCday' + num).hide();
                            } catch (e) { }
                        }
                    }
                    if (!WorkDay5) {
                        $('.Wday05')[0].className = "NotWorkDays";
                        $('.RouteTimeWday05').hide();
                        for (var i = 5; i <= (NumberOfWeeks * 7) ; i = i + 7) {
                            var num = i.toString();
                            if (num.length == 1) { num = "0" + num; }
                            try {
                                $('.Cday' + num)[0].className = "NotWorkDays";
                                $('.RouteTimeCday' + num).hide();
                            } catch (e) { }
                        }
                    }
                    if (!WorkDay6) {

                        $('.Wday06')[0].className = "NotWorkDays";
                        $('.RouteTimeWday06').hide();
                        for (var i = 6; i <= (NumberOfWeeks * 7) ; i = i + 7) {
                            var num = i.toString();
                            if (num.length == 1) { num = "0" + num; }
                            try {
                                $('.Cday' + num)[0].className = "NotWorkDays";
                                $('.RouteTimeCday' + num).hide();
                            } catch (e) { }
                        }
                    }
                    if (!WorkDay7) {

                        $('.Wday07')[0].className = "NotWorkDays";
                        $('.RouteTimeWday07').hide();
                        for (var i = 7; i <= (NumberOfWeeks * 7) ; i = i + 7) {
                            var num = i.toString();
                            if (num.length == 1) { num = "0" + num; }
                            try {
                                $('.Cday' + num)[0].className = "NotWorkDays";
                                $('.RouteTimeCday' + num).hide();
                            } catch (e) { }
                        }
                    }




                    var SHour = [{ "id": 1, "start": resParams[0].StartHour }];
                    var StartHour = new Date(SHour[0].start.match(/\d+/)[0] * 1);
                    var EHour = [{ "id": 1, "start": resParams[0].EndHour }];
                    var EndHour = new Date(EHour[0].start.match(/\d+/)[0] * 1);
                    SHourH = StartHour.getHours();
                    if (SHourH.toString().length == 1) { SHourH = "0" + SHourH; }
                    SHourM = StartHour.getMinutes();
                    if (SHourM.toString().length == 1) { SHourM = "0" + SHourM; }
                    EHourH = EndHour.getHours();
                    if (EHourH.toString().length == 1) { EHourH = "0" + EHourH; }
                    EHourM = EndHour.getMinutes();
                    if (EHourM.toString().length == 1) { EHourM = "0" + EHourM; }

                    //alert(d);
                    var MinTime = SHourH + ":" + SHourM;
                    var MaxTime = EHourH + ":" + EHourM;


                    //var TimingType = resParams[0].TimingType;
                    //switch (TimingType) {
                    //    case 1:
                    //        $('#rblPeriods_0')[0].checked = true;
                    //        ShowRoutes('rblPeriods_0');
                    //        break;
                    //    case 2:
                    //        $('#rblPeriods_1')[0].checked = true;
                    //        ShowRoutes('rblPeriods_1');
                    //        break;
                    //    case 3:
                    //        $('#rblPeriods_2')[0].checked = true;
                    //        ShowRoutes('rblPeriods_2');
                    //        break;
                    //    case 4:
                    //        $('#rblPeriods_3')[0].checked = true;
                    //        ShowRoutes('rblPeriods_3');
                    //        break;
                    //}
                    $(".StartHour").timepicker({
                        'minTime': MinTime,
                        'maxTime': MaxTime
                    });
                    $(".EndHour").timepicker({
                        'minTime': MinTime,
                        'maxTime': MaxTime
                    });
                    $(".FromTime").val("06:00");
                    $(".ToTime").val("06:30");
                }
                GetRoutes();
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {

            });
        }
        HideNotWorkDays();
        function changeStart(Etime) {
            $('.EndHour').timepicker('option', 'minTime', Etime);
            debugger;

            for (var i = 0; i < $(".StartHour").length; i++) {
                if ($(".StartHour")[i].value > $(".EndHour")[i].value) {
                    $(".EndHour")[i].value = Etime;
                }
            }
        }
        function changeEnd(Stime) {
            $('.StartHour').timepicker('option', 'maxTime', Stime);
            debugger;
            for (var i = 0; i < $(".StartHour").length; i++) {
                if ($(".StartHour")[i].value > $(".EndHour")[i].value) {
                    $(".StartHour")[i].value = Stime;
                }
            }
        }

        function DelInterval() {
            $('#txtInterval').val("");
        }
        function OpenTimeDiv(op, day) {

            $('.TimePopover').css("display", "block");
            $(".TimePopover").css({ top: 900 }).animate({ "top": "100px" }, "high");

            $('#dBodyr').block({ message: '' });
            dayForTime = day;
            Op = op;
        }
        function ApprovTime() {

            if (Op == "w") {
                $('#txtFTimeWDay' + dayForTime).val($('#txtFTimePop').val());
                $('#txtTTimeWDay' + dayForTime).val($('#txtTTimePop').val());
            } else {
                $('#txtFTimeCDay' + dayForTime).val($('#txtFTimePop').val());
                $('#txtTTimeCDay' + dayForTime).val($('#txtTTimePop').val());
            }

            CloseTimePopover();
        }

        function CloseTimePopover() {


            $(".TimePopover").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
            $("#dBodyr").unblock();
        }

        function ShowRoutes(id) {
            $('.DailyRoutes').hide();
            $('.WeeklyRoutes').hide();
            $('.CyclicRoutes').hide();
            $('.DateRoutes').hide();

            switch (id) {
                case "rblPeriods_0":
                    $('.CyclicRoutes').show();
                    break;
                case "rblPeriods_1":
                    $('.DateRoutes').show();
                    break;
            }
        }
        ShowRoutes("rblPeriods_0");
        function SetRoutesSelected(cls) {

            if ($('.' + cls)[0].className == cls + " RouteDayNotSelected") {
                $('.' + cls)[0].className = cls + " RouteDaySelected";
                $('.RouteTime' + cls).show();
            }
            else {
                if ($('.' + cls)[0].className == cls + " RouteDaySelected") {
                    $('.' + cls)[0].className = cls + " RouteDayNotSelected";
                    $('.RouteTime' + cls).hide();
                }

            }

        }
        var fdate = new Date(Date.now());
        var fday = fdate.getDate();
        if (fday.toString().length == 1) { fday = "0" + fday; }
        var fmonth = (fdate.getMonth() + 1);
        if (fmonth.toString().length == 1) { fmonth = "0" + fmonth; }
        var fyear = fdate.getFullYear();
        $("#txtRouteDate").val(fday + "/" + fmonth + "/" + fyear);




        $(".DateTimepicker").datepicker({
            monthNamesShort: ['ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי', 'יוני',
              'יולי', 'אוגוסט', 'ספטמבר', 'אוקטובר', 'נובמבר', 'דצמבר'],
            dayNamesShort: ['א\'', 'ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'ש\''],
            dayNamesMin: ['א\'', 'ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'ש\''],
            changeMonth: true,
            changeYear: true,
            dateFormat: 'dd/mm/yy',
            onSelect: function (dateText) { }
        });

        $('.BodyRoutes').height($(window).height());



        function SetRoutes() {
            var Interval = $("#txtInterval").val();
            var TimeFromD = $("#txtFromTimeDaily").val();
            var TimeToD = $("#txtToTimeDaily").val();
            var WDays = "";
            var CDays = "";
            var RouteDates = "";
            var TimeFromRDate = $("#txtFromTimeDate").val();
            var TimeToRDate = $("#txtToTimeDate").val();

            var firstW = true;
            var firstC = true;

            var DateList = document.getElementById('<% = DateList.ClientID %>');
            for (var i = 0; i < DateList.options.length; i++) {
                if (i == 0) {
                    RouteDates += DateList.options[i].label;
                }
                else {
                    RouteDates += ";" + DateList.options[i].label;
                }
            }
            for (var i = 0; i < $(".RouteDaySelected").length; i++) {
                if ($('.RouteDaySelected')[i].className.substr(0, 1) == 'W') {

                    var day = $('.RouteDaySelected')[i].className.substr(4, 2);

                    if (firstW) {
                        firstW = false;
                        WDays += day + ";" + $("#txtFTimeWDay" + day).val() + ";" + $("#txtTTimeWDay" + day).val();

                    }
                    else {
                        WDays += ";" + day + ";" + $("#txtFTimeWDay" + day).val() + ";" + $("#txtTTimeWDay" + day).val();
                    }
                }
                else {
                    var day = $('.RouteDaySelected')[i].className.substr(4, 2);

                    if (firstC) {
                        firstC = false;
                        CDays += day + ";" + $("#txtFTimeCDay" + day).val() + ";" + $("#txtTTimeCDay" + day).val();

                    }
                    else {
                        CDays += ";" + day + ";" + $("#txtFTimeCDay" + day).val() + ";" + $("#txtTTimeCDay" + day).val();
                    }
                }

            }

            addRoutes(Interval, TimeFromD, TimeToD, WDays, CDays, RouteDates);
        }
        function addRoutes(Interval, TimeFromD, TimeToD, WDays, CDays, RouteDates) {
            var request;

            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetRoutes&CustKey=" + CustKey + "&Interval=" + Interval + "&TimeFromD=" + TimeFromD + "&TimeToD=" + TimeToD + "&WDays="
                + WDays + "&CDays=" + CDays + "&RouteDates=" + RouteDates + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "POST",
                data: ""
            });
            request.done(function (response, textStatus, jqXHR) {
    
                $("#MassageApprov").val("<%=StrSrc("OrbitSaved")%>");
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
               
                if (jqXHR.status == 200) {
                 
                    parent.document.getElementById("if_0").contentWindow.document.getElementById("CustGrid").contentWindow.RefreshMD();
                    setTimeout(" CloseEditBoxPopup();",400);
                } else {
                    $("#MassageApprov").innerText = "<%=StrSrc("Failure")%>";
                    MassageApprov.innerText = "<%=StrSrc("Failure")%>";
                }

            });
        }

        function SendToAdd() {
            var date = $('#txtRouteDate').val()
            var SH = $('#txtFromTimeDate').val();
            var EH = $('#txtToTimeDate').val();
            AddToList(EH + "  " + SH + "  " + date);

        }
        function AddToList(opt) {
            var liste = document.getElementById('<% = DateList.ClientID %>');
            var NotExist = true;
              AddOpt = new Option(opt, liste.options.length);
              for (var i = 0; i < liste.options.length; i++) {
                  debugger;
                 // alert(liste.options[i].innerHTML + " == " + AddOpt.innerHTML);
                  if (liste.options[i].innerHTML.substr(14, 20) == AddOpt.innerHTML.substr(14, 20)) {
                      NotExist = false;

                      MassageApprov.innerText = "תכנון לתאריך זה כבר קיים";
                      $("#MassageApprov").fadeOut( 1000,function () {
                          $(this).text("")
                      }).fadeIn();
                  }
              }

              if (AddOpt != "" && NotExist) {
                  liste.options[liste.options.length] = AddOpt;
              }

          }

          function delFromList() {
              var liste = document.getElementById('<% = DateList.ClientID %>');
            var howMany = liste.options.length;


            for (var i = 0; i < liste.options.length; i++) {
                if (liste.options[i].selected == true) {
                    liste.options.remove(i--);
                    MassageApprov.innerText = "התכנון נמחק";
                    $("#MassageApprov").fadeOut(1000, function () {
                        $(this).text("")
                    }).fadeIn();
                }

            }
        }

        function GetRoutes() {
            //RoutesDaily
            if ($('#' + hdnDailyClientID)[0].value != "") {
                var arrDaily = $('#' + hdnDailyClientID)[0].value.split(';');
                $("#txtInterval").val(arrDaily[0]);
                //$("#txtFromDateD").val(arrDaily[1]);
                //$("#txtToDateD").val(arrDaily[2]);
                $("#txtFromTimeDaily").val(arrDaily[3]);
                $("#txtToTimeDaily").val(arrDaily[4]);
            }

            //RoutesByDate
            if ($('#' + hdnByDateClientID)[0].value != "") {
                var arrByDate = $('#' + hdnByDateClientID)[0].value.split(';');
                for (var i = 0; i < arrByDate.length; i++) {
                    AddToList(arrByDate[i]);
                }

                //$("#txtRouteDate").val(arrByDate[0]);
                //$("#txtFromTimeDate").val(arrByDate[1]);
                //$("#txtToTimeDate").val(arrByDate[2]);
            }

            //RoutesWeekly
            for (var i = 0; i < 7; i++) {
                $('.RouteTimeWday0' + (i + 1)).hide();
            }
            if ($('#' + hdnWeeklyClientID)[0].value != "") {
                var arrWeekly = $('#' + hdnWeeklyClientID)[0].value.split(';');
                //$("#txtFromDateW").val(arrWeekly[0]);
                //$("#txtToDateW").val(arrWeekly[1]);

                for (var i = 0; i < arrWeekly.length; i = i + 3) {
                    var day = arrWeekly[i];
                    if (day.toString().length == 1) { day = "0" + day; }
                    $("#Wday" + day)[0].className = "Wday" + day + " RouteDaySelected";
                    $('.RouteTimeWday' + day).show();
                    $("#txtFTimeWDay" + day).val(arrWeekly[i + 1]);
                    $("#txtTTimeWDay" + day).val(arrWeekly[i + 2]);
                }
            }


            //RoutesCyclic
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_RoutesGetSettings&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "POST",
                data: ""
            });
                request.done(function (response, textStatus, jqXHR) {
                    resParams = jQuery.parseJSON(jqXHR.responseText);
                    var NumberOfWeeks = resParams[0].NumberOfWeeksToCyclic;

                    for (var i = 0; i < NumberOfWeeks * 7; i++) {
                        var num = (i + 1);
                        if (num.toString().length == 1) { num = "0" + num; }
                        try {
                            $('.RouteTimeCday' + num).hide();
                        } catch (e) {

                        }
                    }
                    if ($('#' + hdnCyclicClientID)[0].value != "") {
                        var arrCyclic = $('#' + hdnCyclicClientID)[0].value.split(';');
                        //$("#txtFromDateC").val(arrCyclic[0]);
                        //$("#txtToDateC").val(arrCyclic[1]);
                        for (var i = 0; i < arrCyclic.length ; i = i + 3) {
                            var day = arrCyclic[i];

                            if (day.toString().length == 1) { day = "0" + day; }
                            $("#Cday" + day)[0].className = "Cday" + day + " RouteDaySelected";
                            $('.RouteTimeCday' + day).show();
                            $("#txtFTimeCDay" + day).val(arrCyclic[i + 1]);
                            $("#txtTTimeCDay" + day).val(arrCyclic[i + 2]);
                        }
                    }
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {

                });
            }
    </script>
</body>
</html>
