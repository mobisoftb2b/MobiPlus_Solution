<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DistributionLineEdit.aspx.cs" Inherits="Pages_Compield_DistributionLineEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ניהול קווי חלוקה</title>

    <link href="../../css/PlanningTabs.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" />
    <script src="../../js/jquery-1.11.0.min.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>

    <script src="../../js/jquery-ui-resizeRight.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../scripts/moment.min.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../scripts/fullcalendar.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../scripts/he.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <link href="../../css/fullcalendar.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" />
    <script src="../../js/jquery.blockUI.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" type="text/javascript"></script>

    <script src="../../js/moment.min.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../js/fullcalendar.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../js/he.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../js/jquery.RowTimepicker.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <link href="../../css/jquery.RowTimepicker.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" />

    <script>
        $(function () {
            $("#Planningdiv").tabs();
        });
    </script>
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
<body id="RPBodyr" onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">


        <div>
            <ul>
                <li class="sideTabSelected" ><a onclick="" class="" >קו</a></li>
                <li class="sideTab" ><a onclick="" class="" >תכנון</a></li>
            </ul>
        </div>







        <div id="Planningdiv">
            <ul>
                <li><a href="#tab0" onclick="tabActive('LineToCust');"><span>הוספת קו ללקוח</span></a></li>
                <li><a href="#tab1" onclick="tabActive('SetLines');"><span>עריכת קווים</span></a></li>
                <li><a href="#tab2" onclick="tabActive('LineToAgent');"><span>הוספת קווים לסוכן</span></a></li>
            </ul>
            <div class="ContentRep">
                <div class="DLineContent " id="tab0">
                    <div class="DLine ">
                        <table>
                            <tr style="vertical-align: top;">
                                <td>
                                    <div class="CustGridContent ">
                                        <iframe id='CustGrid' frameborder='0' scrolling='no' src='' class='CustReport'></iframe>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <div id="EditBox" runat="server" style="display: none;" class="cssLinesBox">
                            <div class="LinesBox-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseEditBoxPopup();">×</button>
                                <h3 runat="server" id="myModalLabel">בחר קווי חלוקה ללקוח</h3>
                                <input id="Hidden1" type="hidden" />

                            </div>
                            <div class="LineGridContent">
                                <iframe id='LineGrid' frameborder='0' scrolling='no' src='' class='CustReport LineGrid'></iframe>
                            </div>
                            <input id="btnAddLine" type="button" value="אשר" onclick="addLinesToCust();" class="DLine-btn" />
                        </div>
                    </div>
                </div>
                <div class="DLineContent " id="tab1">
                    <div class="DLineContentSet">
                        <table>
                            <tr style="vertical-align: top;">
                                <td>
                                    <div class="LineGridContentM">
                                        <iframe id='LineGridM' frameborder='0' scrolling='no' src='' class='CustReport LineGrid'></iframe>
                                    </div>

                                </td>
                                <%--  <td>
                                    <div class="DLineHederDiv">ניהול קווים</div>
                                    <div class="DLineDiv">
                                        <table>
                                            <tr>
                                                <td>
                                                    <span>מספר קו :</span>
                                                </td>
                                                <td>
                                                    <input id="txtLineId" type="text" class="txtDLine " />

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>תיאור קו :</span>
                                                </td>
                                                <td>
                                                    <input id="txtLineDesc" type="text" class="txtDLine " />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table style="float: left">
                                                        <tr>
                                                            <td>
                                                                <input id="btnAddNewLine" type="button" value="הוסף" class="DLineAdd-btn" onclick="AddNewLine();" /></td>
                                                            <td>
                                                                <input id="btnUpdateLine" type="button" value="ערוך" class="DLineAdd-btn" onclick="UpdateLine();" /></td>
                                                            <td>
                                                                <input id="btnDelLine" type="button" value="מחק" class="DLineAdd-btn" onclick="DelLine();" /></td>
                                                        </tr>
                                                    </table>

                                                </td>
                                            </tr>
                                        </table>
                                    </div>

                                </td>--%>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="DLineContent " id="tab2">


                    <table>
                        <tr>
                            <td style="vertical-align: top;">
                                <div class="AgentsHederDiv">רשימת סוכנים</div>
                                <asp:ListBox CssClass="LBAgentsDLine" ID="AgentsList" runat="server" onchange="ActiveAgent();"></asp:ListBox>

                            </td>
                            <td>
                                <div id="LineToAgentCalendar" class="fc fc-ltr fc-unthemed "></div>
                            </td>
                            <td>
                                <div class="AgentsHederDiv">רשימת קווים</div>
                                <div id='wrap'>
                                    <div id='external-events' class="LineEvents">
                                    </div>
                                    <div style='clear: both'></div>
                                </div>


                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>


        <script type="text/javascript">

            var custKey = "";
            var DLineId = "";
            var DLineDesc = "";
            var lines = [];
            var TabSelected = "LineToCust";

            function tabActive(tab) {
                TabSelected = tab;
            }

            function DelLine() {
                DLineId = $("#txtLineId").val();
                DLineDesc = $("#txtLineDesc").val();

                DistributionLineUpdate(0, DLineId, DLineDesc);
            }
            function AddNewLine() {
                DLineId = $("#txtLineId").val();
                DLineDesc = $("#txtLineDesc").val();
                DistributionLineUpdate(1, DLineId, DLineDesc);
            }
            function UpdateLine() {
                DLineId = $("#txtLineId").val();
                DLineDesc = $("#txtLineDesc").val();
                DistributionLineUpdate(2, DLineId, DLineDesc);
            }
            function DistributionLineUpdate(op, LineId, LineDesc) {

                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetDistributionLine&Op=" + op + "&DistributionLineID=" + LineId + "&DistributionLineDescription=" + LineDesc + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "POST",
                    data: ""
                });
                request.done(function (response, textStatus, jqXHR) {
                    if (jqXHR.status == 200) {
                        alert("1 -" + jqXHR.responseText)
                        //getLineGrid();
                        //setTimeout(' setCheckBox();', 500);
                    } else {
                        alert("2 -" + jqXHR.responseText)
                    }
                });
                request.fail(function (jqXHR, textStatus, errorThrown) {
                    if (jqXHR.status == 200) {
                        getLineGridM();
                    } else {
                        alert("ארעה שגיאה:" + jqXHR.responseText)
                    }
                });

            }

            function ShowData(v1, v2) {

                switch (TabSelected) {
                    case "LineToCust":
                        custKey = v1.Cust_Key;
                        if (custKey != "" && custKey != null) {
                            request = $.ajax({
                                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetCustToDistribution&Cust_Key=" + custKey + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                                type: "POST",
                                data: ""
                            });
                            request.done(function (response, textStatus, jqXHR) {
                                resParams = jQuery.parseJSON(jqXHR.responseText);
                                getLineGrid();
                                setTimeout(' setCheckBox();', 500);

                                $('.cssLinesBox').css("display", "block");

                                $('.cssLinesBox').css("height", 562 + "px");
                                var top = 500;
                                $(".cssLinesBox").css({ top: top })
                                        .animate({ "top": "100px" }, "high");

                                $('#RPBodyr').block({ message: '' });
                                if (jqXHR.status == 200) {


                                } else {

                                }
                            });
                            request.fail(function (jqXHR, textStatus, errorThrown) {
                                if (jqXHR.status == 200) {
                                } else {
                                }
                            });
                        }
                        break;
                    case "SetLines":
                        DLineId = v1.DistributionLineID;
                        DLineDesc = v1.DistributionLineDescription;
                        if (DLineId != "" && DLineId != null) {
                            $("#txtLineDesc").val(DLineDesc);
                            $("#txtLineId").val(DLineId);
                        }
                        break;
                    case "LineToAgent":
                        break;
                    default:
                        break;
                }
            }

            function CloseEditBoxPopup() {
                $(".cssLinesBox").css({ top: 100 })
                                .animate({ "top": "-600" }, "high");
                $("#RPBodyr").unblock();

            }
            function setCheckBox() {
                lines = [];
                debugger;
                for (var i = 0; i < resParams.length; i++) {
                    var ch = "LineID" + resParams[i].DistributionLineID;
                    var line = { DistributionLineID: resParams[i].DistributionLineID };
                    lines[lines.length] = line;
                    $('.LineGrid')[0].contentWindow.document.getElementById(ch).checked = true;
                }
            }

            function AddToSelectedArr(rowPram) {
                var row = rowPram.split(';');
                var line = { DistributionLineID: row[0], DistributionLineDescription: row[1] };
                var ch = "LineID" + row[0];
                if ($('.LineGrid')[0].contentWindow.document.getElementById(ch).checked) {
                    var notExist = true;
                    for (var i = 0; i < lines.length; i++) {
                        if (lines[i].DistributionLineID == line.DistributionLineID) {
                            notExist = false;
                        }
                    }
                    if (notExist) {
                        lines[lines.length] = line;
                    }
                } else {
                    for (var i = 0; i < lines.length; i++) {
                        if (lines[i].DistributionLineID == line.DistributionLineID) {
                            lines.splice(i, 1);
                            break;
                        }
                    }
                }
            }


            function addLinesToCust() {

                if (custKey != "") {
                    var Slines = "";

                    for (var i = 0; i < lines.length; i++) {
                        if (i == 0) {
                            Slines += lines[i].DistributionLineID;
                        } else {
                            Slines += ";" + lines[i].DistributionLineID;
                        }
                    }
                    // alert(Slines);
                    request = $.ajax({
                        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_AddCustToDistribution&Cust_Key=" + custKey + "&lines=" + Slines + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                        type: "POST",
                        data: ""
                    });
                    request.done(function (response, textStatus, jqXHR) {

                    });
                    request.fail(function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status == 200) {

                            getCustGrid();
                            getLineGrid();
                            CloseEditBoxPopup();
                        } else {

                        }
                    });
                }
                else {
                    alert("לא נבחר לקוח");
                }

            }



            function getDistributionLine() {

                request = $.ajax({
                    url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetDistributionLine&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                    type: "POST",
                    data: ""
                });
                    request.done(function (response, textStatus, jqXHR) {

                        resParams = jQuery.parseJSON(jqXHR.responseText);

                        if ($(".DistributionLine").length > 0) {
                            for (var i = 0; i < $(".DistributionLine").length; i++) {
                                var element = $(".DistributionLine")[i--];
                                element.parentNode.removeChild(element);
                            }
                        }
                        for (var i = 0; i < resParams.length; i++) {
                            $("#external-events").append(" <div class='fcLine-event DistributionLine' style='text-align: center;'>" + resParams[i].DistributionLineDescription + "</div>");
                        }

                        $('#external-events .fcLine-event').each(function () {
                            // store data so the calendar knows to render an event upon drop
                            $(this).data('event', {
                                title: $.trim($(this).text()), // use the element's text as the event title
                                color: '#3A87AD',
                                stick: true // maintain when user navigates (see docs on the renderEvent method)
                            });

                            // make the event draggable using jQuery UI
                            $(this).draggable({
                                scroll: false,
                                helper: 'clone',
                                zIndex: 999,
                                revert: true,      // will cause the event to go back to its
                                revertDuration: 0  //  original position after the drag
                            });

                        });
                    });
                    request.fail(function (jqXHR, textStatus, errorThrown) {
                        alert(jqXHR.responseText);
                    });
                }


                getDistributionLine();


                $('#LineToAgentCalendar').fullCalendar({
                    buttonText: {
                        month: 'חודש',
                        week: 'שבוע',
                        day: 'יום'
                    },
                    header: {
                        left: 'nextYear,next,prev,prevYear today ',
                        center: 'title',
                        right: 'month,agendaWeek,agendaDay'
                    },
                    businessHours: {  // display business hours

                        start: "0:00", // a start time (10am in this example)
                        end: "24:00", // an end time (6pm in this example)
                        dow: [0, 1, 2, 3, 4, 5]

                    },
                    eventDurationEditable: false,
                    eventLimit: true, // allow "more" link when too many events
                    slotEventOverlap: false,
                    displayEventTime: true,
                    editable: true,
                    droppable: true, // this allows things to be dropped onto the calendar
                    eventStartEditable: function (date, allDay, jsEvent, view) {


                    },
                    height: 590,
                    dayClick: function (date, allDay, jsEvent, view) {
                        //var moment = $('#calendar').fullCalendar('getDate');

                        $('#LineToAgentCalendar').fullCalendar('changeView', 'agendaDay');
                        $('#LineToAgentCalendar').fullCalendar('gotoDate', date)
                    },

                    eventRender: function (event, element) {

                        var AgentId = "0";
                        var listA = document.getElementById('<% = AgentsList.ClientID %>');
                        for (var i = 0; i < listA.options.length; i++) {
                            if (listA.options[i].selected == true) {
                                AgentId = listA.options[i].value;
                            }
                        }
                        element.append("<div class='closeonDiv' ><span class='closeon'>X</span></div>");
                        element.find(".closeon").click(function () {
                            $('#LineToAgentCalendar').fullCalendar('removeEvents', event._id);
                        });

                    },
                    drop: function (event, element, revertFunc) {
                    },
                    eventDrop: function (event, dayDelta, revertFunc) {

                    },

                });


                function setLineToAgentCalendar() {

                    var startHour = '00:00';
                    var endHour = '23:30';
                    request = $.ajax({
                        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_RoutesGetSettings&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                        type: "POST",
                        data: ""
                    });
                    request.done(function (response, textStatus, jqXHR) {
                        resParams = jQuery.parseJSON(jqXHR.responseText);
                        var SHour;
                        var StartHour = new Date();
                        var EHour;
                        var EndHour = new Date();
                        if (resParams[0] != null && resParams[0] != "") {

                            SHour = [{ "id": 1, "start": resParams[0].StartHour }];
                            StartHour = new Date(SHour[0].start.match(/\d+/)[0] * 1);
                            EHour = [{ "id": 1, "start": resParams[0].EndHour }];
                            EndHour = new Date(EHour[0].start.match(/\d+/)[0] * 1);


                            SHourH = StartHour.getHours();
                            if (SHourH.toString().length == 1) { SHourH = "0" + SHourH; }
                            SHourM = StartHour.getMinutes();
                            if (SHourM.toString().length == 1) { SHourM = "0" + SHourM; }

                            EHourH = EndHour.getHours();
                            if (EHourH.toString().length == 1) { EHourH = "0" + EHourH; }
                            EHourM = EndHour.getMinutes();
                            if (EHourM.toString().length == 1) { EHourM = "0" + EHourM; }

                            startHour = SHourH + ":" + SHourM;
                            endHour = EHourH + ":" + EHourM;
                        }




                    });
                    request.fail(function (jqXHR, textStatus, errorThrown) {

                    });
                }
                function getCustGrid() {
                    $('#CustGrid')[0].src = '../RPT/ShowReport.aspx?Name=CustomersDistributionLine&WinID=1if_1&Width=' + 1132 + '&Height=' + 600 + '&ID=296';
                }
                getCustGrid();
                function getLineGrid() {

                    $('#LineGrid')[0].src = '../RPT/ShowReport.aspx?Name=DistributionLine&WinID=1if_1&Width=' + 320 + '&Height=' + 450 + '&ID=297';
                }
                getLineGrid();
                function getLineGridM() {

                    $('#LineGridM')[0].src = '../RPT/ShowReport.aspx?Name=DistributionLineSet&WinID=1if_1&Width=' + 1000 + '&Height=' + 560 + '&ID=299';
                }
                getLineGridM();
                // setLineToAgentCalendar()

        </script>
    </form>
</body>
</html>
