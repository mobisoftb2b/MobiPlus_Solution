
//general

function tabActive(tab) {
    switch (tab) {
        case "Planning":
            TabSelected = "ActivePlanning";
            break;
        case "Calendar":
            TabSelected = "ActiveCalendar";
            break;
        case "LineToCust":
            TabSelected = "ActiveLineToCust";
            break;
        case "SetLines":
            TabSelected = "ActiveSetLines";
            break;
        case "LineToAgent":
            TabSelected = "ActiveLineToAgent";
            break;
        case "Inactive":
            TabSelected = "ActiveInactive";
            break;
        case "Settings":
            TabSelected = "ActiveSettings";
            break;
    }
    ActiveAgent()
}

function ActiveAgent() {
    
    var AgentId = findAgentID();
    
    switch (TabSelected) {
        case "ActivePlanning":
            $('#tdAgentsList').css("display", "");
            getGrid();

            break;
        case "ActiveCalendar":
            $('#tdAgentsList').css("display", "");
            setMainCalendar();
            $('#mainCalendar').fullCalendar('removeEvents', function (event) { return true; });
            if (AgentId != "0") {
                setTimeout("getEvents();", 1);
            }
            setTimeout("getInactiveEventsToMainCalendar();", 10);

            break;
        case "ActiveLineToCust":
            $('#tdAgentsList').css("display", "none");
            getCustGrid2();
            getLineGrid();
            break;
        case "ActiveSetLines":
            $('#tdAgentsList').css("display", "none");
            getLineGridM();
            break;
        case "ActiveLineToAgent":
            $('#tdAgentsList').css("display", "");

            setLineToAgentCalendar();
            $('#LineToAgentCalendar').fullCalendar('removeEvents', function (event) { return true; });
            setTimeout("getLineToAgentEvents();", 1);

            break;
        case "ActiveInactive":
            $('#tdAgentsList').css("display", "");
            setInActiveCalendar();
            getInActiveDaysType();
            $('#InActiveCalendar').fullCalendar('removeEvents', function (event) { return true; });
            if (AgentId == 0) {
                $('#Allexternal-events').css("display", "none");
                $('#external-events').css("display", "");
            }
            else {
                $('#Allexternal-events').css("display", "");
                $('#external-events').css("display", "none");
            }
            setTimeout("getInactiveEvents();", 10);
            break;
        case "ActiveSettings":
            $('#tdAgentsList').css("display", "none");
            OnInitSettings();
            getSettings();
            break;
        default:
            getGrid();

            break;
    }
}

function setPlane() {
    $('#liPlanning').css("display", "");
    $('#liCalendar').css("display", "");
    $('#liLineToCust').css("display", "none");
    $('#liSetLines').css("display", "none");
    $('#liLineToAgent').css("display", "none");
    $('#liInactive').css("display", "");
    $('#liSettings').css("display", "");

    $("#Planningdiv").tabs({ active: 0 });
    TabSelected = "ActivePlanning";
    ActiveAgent();
}

function setLine() {

    $('#liPlanning').css("display", "none");
    $('#liCalendar').css("display", "none");
    $('#liLineToCust').css("display", "");
    $('#liSetLines').css("display", "");
    $('#liLineToAgent').css("display", "");
    $('#liInactive').css("display", "");
    $('#liSettings').css("display", "");

    $("#Planningdiv").tabs({ active: 2 });
    TabSelected = "ActiveLineToCust";
    ActiveAgent();
}

function sideBarClick(itm) {
    switch (itm) {
        case "Plane":
            $("#sideTabPlane").attr('class', 'sideTabSelected');
            $("#sideTabLine").attr('class', 'sideTab');

            setPlane();
            break;
        case "Line":
            $("#sideTabPlane").attr('class', 'sideTab');
            $("#sideTabLine").attr('class', 'sideTabSelected');
            setLine();
        default:
            break;
    }
}

function findAgentID() {
    var AgentId = "0";
    var listA = $("#AgentsList")[0];// document.getElementById('<% = AgentsList.ClientID %>');
    for (var i = 0; i < listA.options.length; i++) {
        if (listA.options[i].selected == true) {
            AgentId = listA.options[i].value;
            return AgentId;
        }
    }
    return AgentId;
}

function ShowData(v1, v2) {
    debugger;
    switch (TabSelected) {
        case "ActiveLineToCust":
            if (v1.Cust_Key != undefined) {


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
                        setTimeout(' setCheckBox();', 1800);

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
            }
            break;
        case "ActiveSetLines":

            DLineId = v1.DistributionLineID;
            DLineDesc = v1.DistributionLineDescription;
            if (DLineId != "" && DLineId != null) {
                $("#txtLineDesc").val(DLineDesc);
                $("#txtLineId").val(DLineId);
            }
            break;
        default:
            break;
    }
}

function getCustGrid2() {
    $('#CustGrid2')[0].src = '../RPT/ShowReport.aspx?Name=CustomersDistributionLine&WinID=1if_1&Width=' + 1132 + '&Height=' + 600 + '&ID=296';
}

function getLineGrid() {

    $('#LineGrid')[0].src = '../RPT/ShowReport.aspx?Name=DistributionLine&WinID=1if_1&Width=' + 320 + '&Height=' + 450 + '&ID=297';
}

function getLineGridM() {

    $('#LineGridM')[0].src = '../RPT/ShowReport.aspx?Name=DistributionLineSet&WinID=1if_1&Width=' + 1090 + '&Height=' + 560 + '&ID=298';
}

function CloseErrorBox() {
    $(".cssErrorBox").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
    setTimeout('refreshHight();', 1);
}

function SendDayToErrorBox(day) {
    switch (day) {
        case 'Sun':
            OpenErrorBox("יום ראשון הוא יום ללא פעילות");
            break;
        case 'Mon':
            OpenErrorBox("יום שני הוא יום ללא פעילות");
            break;
        case 'Tue':
            OpenErrorBox("יום שלישי הוא יום ללא פעילות");
            break;
        case 'Wed':
            OpenErrorBox("יום רביעי הוא יום ללא פעילות");
            break;
        case 'Thu':
            OpenErrorBox("יום חמישי הוא יום ללא פעילות");
            break;
        case 'Fri':
            OpenErrorBox("יום שישי הוא יום ללא פעילות");
            break;
        case 'Sat':
            OpenErrorBox("יום שבת הוא יום ללא פעילות");
            break;
    }
}

function OpenErrorBox(massage) {
    txtError.innerText = massage;
    $('.cssErrorBox').css("display", "block");
    $(".cssErrorBox").css({ top: top })
     .animate({ "top": "100px" }, "high");
    $(".cssErrorBox").fadeOut(2000, function () { });

}

$('body').on('click', 'button.fc-prev-button', function () {
    //if (TabSelected == "ActiveCalendar") {
    //   $('#mainCalendar').fullCalendar('removeEvents', function (event) { return true; });
    //   getEvents();
    //} else {
    //    $('#InActiveCalendar').fullCalendar('removeEvents', function (event) { return true; });
    //    getInactiveEvents();
    //}
    ActiveAgent();
});

$('body').on('click', 'button.fc-next-button', function () {
    ActiveAgent();
});

$('body').on('click', 'button.fc-prevYear-button', function () {
    ActiveAgent();
});

$('body').on('click', 'button.fc-nextYear-button', function () {
    ActiveAgent();
});

$('body').on('click', 'button.fc-today-button', function () {
    ActiveAgent();
});

$('body').on('click', 'button.fc-month-button', function () {
    ActiveAgent();
});

$('body').on('click', 'button.fc-agendaWeek-button', function () {
    ActiveAgent();
});

$('body').on('click', 'button.fc-agendaDay-button', function () {
    ActiveAgent();
});
ActiveAgent



//Planning

function getInactiveEventsToMainCalendar() {
    var AgentId = findAgentID();
    var mainCalendar = $('#mainCalendar');
    var ViewStart = mainCalendar.fullCalendar('getView').start;// תאריך המופע הראשון בלוח
    var ViewEnd = mainCalendar.fullCalendar('getView').end;// תאריך המופע האחרון בלוח
    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetInActiveDays&AgentId=" + AgentId + "&ViewStart=" + ViewStart.toString() + "&ViewEnd=" + ViewEnd.toString() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ''
    });
    request.done(function (response, textStatus, jqXHR) {

        resParams = jQuery.parseJSON(jqXHR.responseText);
        if (resParams.length != 0) {
            var formattedEventData = [];
            for (var i = 0; i < resParams.length; i++) {
                if (AgentId != 0) {
                    formattedEventData.push({
                        title: resParams[i].title,
                        allDay: true,
                        start: resParams[i].start,
                        end: resParams[i].end,
                        color: '#E63946',
                        allDaySlot: true
                    });
                }
                else {
                    if (resParams[i].color == "#3A87AD") {
                        formattedEventData.push({
                            title: resParams[i].title,
                            allDay: true,
                            start: resParams[i].start,
                            end: resParams[i].end,
                            color: '#E63946',
                            allDaySlot: true
                        });
                    }
                }

            }
            mainCalendar.fullCalendar('addEventSource', formattedEventData);
        }

    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
    });
}

function getGrid() {
    alert(1);
    var AgentId = findAgentID();
    var height = 600;
    var width = 964;
    $('.CustReport')[0].src = '../RPT/ShowReport.aspx?Name=AgentRoutes&WinID=1if_1&Width=' + width + '&Height=' + height + '&AgentId=' + AgentId + '&ID=281';
}

function Addgrid() {
    var height = 600;
    var width = 964;
    $('.CustReport')[0].src = '../RPT/ShowReport.aspx?Name=AgentRoutes&WinID=1if_1&Width=' + width + '&Height=' + height + '&AgentId=0&ID=281';
}

//Calendar

function getEvents() {

    var AgentId = findAgentID();

    var mainCalendar = $('#mainCalendar');

    var ViewStart = mainCalendar.fullCalendar('getView').start;// תאריך המופע הראשון בלוח
    var ViewEnd = mainCalendar.fullCalendar('getView').end;// תאריך המופע האחרון בלוח
    var resParams;


    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetAllRoutes&ViewStart=" + ViewStart.format() + "&ViewEnd=" + ViewEnd.format() + "&AgentId=" + AgentId + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
        resParams = jQuery.parseJSON(jqXHR.responseText);
        var formattedEventData = [];
        for (var k = 0; k < resParams.length; k++) {
            formattedEventData.push({
                title: resParams[k].title,
                allDay: true,
                start: resParams[k].start,
                end: resParams[k].end,
                allDaySlot: true
            });
        }

        mainCalendar.fullCalendar('addEventSource', formattedEventData);
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
    });
}

function setMainCalendar() {

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
        $('#mainCalendar').fullCalendar({
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

                start: startHour, // a start time (10am in this example)
                end: endHour, // an end time (6pm in this example)
                dow: [0, 1, 2, 3, 4, 5]
            },
            eventLimit: true, // allow "more" link when too many events
            editable: false,
            droppable: false, // this allows things to be dropped onto the calendar
            height: 590,
            dayClick: function (date, allDay, jsEvent, view) {
                //var moment = $('#calendar').fullCalendar('getDate');

                $('#mainCalendar').fullCalendar('changeView', 'agendaDay');
                $('#mainCalendar').fullCalendar('gotoDate', date)
            }
        });



    });
    request.fail(function (jqXHR, textStatus, errorThrown) {

    });


}

//LineToCust

function CloseEditBoxPopup() {
    $(".cssLinesBox").css({ top: 100 })
                    .animate({ "top": "-600" }, "high");
    $("#RPBodyr").unblock();

}

function setCheckBox() {
    lines = [];

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
    //alert(lines);
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

        request = $.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_AddCustToDistribution&Cust_Key=" + custKey + "&lines=" + Slines + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
            type: "POST",
            data: ""
        });
        request.done(function (response, textStatus, jqXHR) {

        });
        request.fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 200) {

                $('#CustGrid2')[0].contentWindow.RefreshMD();

                getLineGrid();
                CloseEditBoxPopup();
            } else {

            }
        });
    }
    else {
        // alert("לא נבחר לקוח");
        OpenErrorBox("לא נבחר לקוח");
    }

}

//SetLines

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

            //getLineGrid();
            //setTimeout(' setCheckBox();', 500);
        } else {

        }
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
        if (jqXHR.status == 200) {
            getLineGridM();
        } else {
            //  alert("ארעה שגיאה:" + jqXHR.responseText)
            OpenErrorBox("ארעה שגיאה:" + jqXHR.responseText);
        }
    });

}



//LineToAgent

function getInactiveEventsToAgentCalendar() {
    var AgentId = findAgentID();
    var AgentCalendar = $('#LineToAgentCalendar');
    var ViewStart = AgentCalendar.fullCalendar('getView').start;// תאריך המופע הראשון בלוח
    var ViewEnd = AgentCalendar.fullCalendar('getView').end;// תאריך המופע האחרון בלוח

    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetInActiveDays&AgentId=" + AgentId + "&ViewStart=" + ViewStart.toString() + "&ViewEnd=" + ViewEnd.toString() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ''
    });
    request.done(function (response, textStatus, jqXHR) {

        resParams = jQuery.parseJSON(jqXHR.responseText);
        if (resParams.length != 0) {
            var formattedEventData = [];
            for (var i = 0; i < resParams.length; i++) {
                formattedEventData.push({
                    title: resParams[i].title,
                    allDay: true,
                    start: resParams[i].start,
                    end: resParams[i].end,
                    color: '#E63946',
                    allDaySlot: true
                });
            }
            AgentCalendar.fullCalendar('addEventSource', formattedEventData);
        }

    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
    });
}

function setLineToAgentCalendar() {
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

            var AgentId = findAgentID();
            element.append("<div class='closeonDiv' ><span class='closeon'>X</span></div>");
            element.find(".closeon").click(function () {
                $('#LineToAgentCalendar').fullCalendar('removeEvents', event._id);
                delLineToAgentEvent(AgentId, event.title, event.start._d);
            });
        },
        drop: function (event, element, revertFunc) {

            var AgentId = findAgentID();
            var WDays = _WorkDays.split(';');
            var isWorkDay = false;
            for (var i = 0; i < WDays.length; i++) {
                if (event._d.toString().substr(0, 3) == WDays[i].toString()) {
                    isWorkDay = true;
                }
            }


            if (AgentId != "0") {

                if (isWorkDay) {

                    var arrEvents = $('#LineToAgentCalendar').fullCalendar('clientEvents');
                    for (var i = 0; i < arrEvents.length; i++) {
                        try {
                            if (event._d.toString().substr(0, 24) == arrEvents[i].start._d.toString().substr(0, 24) && element.target.innerText == arrEvents[i].title) {
                                $('#LineToAgentCalendar').fullCalendar('removeEvents', arrEvents[i]._id);
                                // alert(" הוא יום ללא פעילות ");
                                SendDayToErrorBox(event._d.toString().substr(0, 3));
                                return;
                            }
                        } catch (e) { }
                    }
                }
                else {
                    request = $.ajax({
                        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_AddLineToAgent&AgentId=" + AgentId + "&DistributionLineDescription=" + escape(element.target.innerText) + "&Date=" + event._d + "&daysInterval=0&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                        type: "POST",
                        data: ""
                    });
                    request.done(function (response, textStatus, jqXHR) {
                    });
                    request.fail(function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status == 200) {
                            var arrEvents = $('#LineToAgentCalendar').fullCalendar('clientEvents');
                            if (jqXHR.responseText == "Exist") {
                                var first = true;
                                for (var i = 0; i < arrEvents.length; i++) {
                                    try {
                                        if (event._d.toString().substr(0, 24) == arrEvents[i].start._d.toString().substr(0, 24) && element.target.innerText == arrEvents[i].title) {
                                            if (first) {
                                                first = false;
                                                $('#LineToAgentCalendar').fullCalendar('removeEvents', arrEvents[i]._id);
                                                // alert("הקו - " + element.target.innerText + " כבר קיים ליום זה ");
                                                OpenErrorBox("הקו - " + element.target.innerText + " כבר קיים ליום זה ");
                                                return;
                                            }
                                        }
                                    } catch (e) { }
                                }
                            }
                            else {
                                for (var i = 0; i < arrEvents.length; i++) {
                                    try {
                                        if (event._d >= arrEvents[i].start._d && event._d < arrEvents[i].end._d && arrEvents[i].color == '#E63946') {
                                            for (var t = 0; t < arrEvents.length; t++) {
                                                if (event._d.toString().substr(0, 24) == arrEvents[t].start._d.toString().substr(0, 24) && element.target.innerText == arrEvents[t].title) {
                                                    $('#LineToAgentCalendar').fullCalendar('removeEvents', arrEvents[t]._id);
                                                    delLineToAgentEvent(AgentId, element.target.innerText, event._d)
                                                    //  alert("הקו - " + element.target.innerText + " לא ניתן לשייך קו ליום זה");
                                                    OpenErrorBox("הקו - " + element.target.innerText + " לא ניתן לשיוך ליום זה");
                                                    return;
                                                }
                                            }
                                        }
                                    } catch (e) { }
                                }
                            }
                        } else {
                            //alert("תקלה: ההגדרות לא נשמרו.");
                            OpenErrorBox("תקלה: ההגדרות לא נשמרו.");
                        }
                    });
                }
            }
            else {

                var arrEvents = $('#LineToAgentCalendar').fullCalendar('clientEvents');
                for (var i = 0; i < arrEvents.length; i++) {
                    try {
                        if (event._d.toString().substr(0, 24) == arrEvents[i].start._d.toString().substr(0, 24) && element.target.innerText == arrEvents[i].title) {
                            $('#LineToAgentCalendar').fullCalendar('removeEvents', arrEvents[i]._id);
                            // alert("לא נבחר סוכן");
                            OpenErrorBox("לא נבחר סוכן");
                            return;
                        }
                    } catch (e) { }
                }
            }

        },
        eventDrop: function (event, dayDelta, revertFunc) {

            Delta = (dayDelta._days * -1);
            var AgentId = findAgentID();
            var WDays = _WorkDays.split(';');
            var isWorkDay = false;
            for (var i = 0; i < WDays.length; i++) {
                if (event.start._d.toString().substr(0, 3) == WDays[i].toString()) {
                    isWorkDay = true;
                }
            }

            if (AgentId != "0") {
                if (isWorkDay) {

                    var arrEvents = $('#LineToAgentCalendar').fullCalendar('clientEvents');
                    for (var i = 0; i < arrEvents.length; i++) {
                        try {
                            if (event.start._d.toString().substr(0, 24) == arrEvents[i].start._d.toString().substr(0, 24) && event.title == arrEvents[i].title) {
                                //$('#LineToAgentCalendar').fullCalendar('removeEvents', arrEvents[i]._id);
                                revertFunc();
                                //alert(" הוא יום ללא פעילות ");
                                SendDayToErrorBox(event.start._d.toString().substr(0, 3));
                                return;
                            }
                        } catch (e) { }
                    }
                }
                else {
                    request = $.ajax({
                        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_AddLineToAgent&AgentId=" + AgentId + "&DistributionLineDescription=" + escape(event.title) + "&Date=" + event.start._d + "&daysInterval=" + dayDelta._days + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                        type: "POST",
                        data: ""
                    });
                    request.done(function (response, textStatus, jqXHR) {
                    });
                    request.fail(function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status == 200) {
                            var arrEvents = $('#LineToAgentCalendar').fullCalendar('clientEvents');
                            if (jqXHR.responseText == "Exist") {
                                // alert("הקו - " + event.title + " כבר קיים ליום זה ");
                                OpenErrorBox("הקו - " + event.title + " כבר קיים ליום זה ");
                                revertFunc();
                            }
                            else {
                                for (var i = 0; i < arrEvents.length; i++) {
                                    try {
                                        if (event.start._d >= arrEvents[i].start._d && event.start._d < arrEvents[i].end._d && arrEvents[i].color == '#E63946') {
                                            for (var t = 0; t < arrEvents.length; t++) {
                                                if (event.start._d.toString().substr(0, 24) == arrEvents[t].start._d.toString().substr(0, 24) && event.title == arrEvents[t].title) {
                                                    revertFunc();

                                                    AddLineToAgentEvent(AgentId, event.title, event.start._d, Delta);
                                                    //alert("הקו - " + event.title + " לא ניתן לשייך קו ליום זה");
                                                    OpenErrorBox("הקו - " + event.title + " לא ניתן לשייך קו ליום זה");
                                                    return;
                                                }
                                            }
                                        }
                                    } catch (e) { }
                                }
                            }
                        } else {
                            // alert("תקלה: ההגדרות לא נשמרו.");
                            OpenErrorBox("תקלה: ההגדרות לא נשמרו.");
                        }
                    });
                }

            } else {
                var arrEvents = $('#LineToAgentCalendar').fullCalendar('clientEvents');
                for (var i = 0; i < arrEvents.length; i++) {
                    try {
                        if (event.start._d.toString().substr(0, 24) == arrEvents[i].start._d.toString().substr(0, 24) && element.target.innerText == arrEvents[i].title) {
                            revertFunc();
                            //alert("לא נבחר סוכן");
                            OpenErrorBox("לא נבחר סוכן");

                            return;
                        }
                    } catch (e) { }
                }
            }


        },
    });
}

function getWorkDays() {
    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_RoutesGetSettings&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
        resParams = jQuery.parseJSON(jqXHR.responseText);
        if (resParams[0] != null && resParams[0] != "") {
            var WorkDays = (resParams[0].WorkDays).split(';');
            var first = true;
            _WorkDays = "";
            var WorkDay1 = true;
            var WorkDay2 = true;
            var WorkDay3 = true;
            var WorkDay4 = true;
            var WorkDay5 = true;
            var WorkDay6 = true;
            var WorkDay7 = true;

            for (var i = 0; i < WorkDays.length; i++) {
                switch (WorkDays[i]) {
                    case '1':
                        WorkDay1 = false;
                        break;
                    case '2':
                        WorkDay2 = false;
                        break;
                    case '3':
                        WorkDay3 = false;
                        break;
                    case '4':
                        WorkDay4 = false;
                        break;
                    case '5':
                        WorkDay5 = false;
                        break;
                    case '6':
                        WorkDay6 = false;
                        break;
                    case '7':
                        WorkDay7 = false;
                        break;
                }
            }
            if (WorkDay1) {
                if (first) {
                    first = false;
                    _WorkDays += "Sun";
                }
            }
            if (WorkDay2) {
                if (first) {
                    first = false;
                    _WorkDays += "Mon";
                } else {
                    _WorkDays += ";Mon";
                }
            }
            if (WorkDay3) {
                if (first) {
                    first = false;
                    _WorkDays += "Tue";
                } else {
                    _WorkDays += ";Tue";
                }
            }
            if (WorkDay4) {
                if (first) {
                    first = false;
                    _WorkDays += "Wed";
                } else {
                    _WorkDays += ";Wed";
                }
            }
            if (WorkDay5) {
                if (first) {
                    first = false;
                    _WorkDays += "Thu";
                } else {
                    _WorkDays += ";Thu";
                }
            }
            if (WorkDay6) {
                if (first) {
                    first = false;
                    _WorkDays += "Fri";
                } else {
                    _WorkDays += ";Fri";
                }
            }
            if (WorkDay7) {
                if (first) {
                    first = false;
                    _WorkDays += "Sat";
                } else {
                    _WorkDays += ";Sat";
                }

            }
        }

    });
    request.fail(function (jqXHR, textStatus, errorThrown) {

    });
}

function AddLineToAgentEvent(AgentId, DistributionLineDescription, Date, daysInterval) {

    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_AddLineToAgent&AgentId=" + AgentId + "&DistributionLineDescription=" + escape(DistributionLineDescription) + "&Date=" + Date + "&daysInterval=" + daysInterval + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
        if (jqXHR.status == 200) {
            if (jqXHR.responseText == "Exist") {
            }
        } else {
            //alert("תקלה: ההגדרות לא נשמרו.");
            OpenErrorBox("תקלה: ההגדרות לא נשמרו.");
        }

    });


}

function delLineToAgentEvent(AgentId, DistributionLineDescription, Date) {

    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_delLineToAgentEvent&AgentId=" + AgentId + "&DistributionLineDescription=" + escape(DistributionLineDescription) + "&Date=" + Date + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });

    request.done(function (response, textStatus, jqXHR) {

    });

    request.fail(function (jqXHR, textStatus, errorThrown) {
        if (jqXHR.status == 200) {

        } else {
            // alert("תקלה: ההגדרות לא נשמרו.");

            OpenErrorBox("תקלה: ההגדרות לא נשמרו.");
        }
    });

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
            $("#externalLine-events").append(" <div class='fcLine-event DistributionLine' style='text-align: center;'>" + resParams[i].DistributionLineDescription + "</div>");
        }

        $('#externalLine-events .fcLine-event').each(function () {
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
        //alert(jqXHR.responseText);
        OpenErrorBox(jqXHR.responseText);
    });
}

function getLineToAgentEvents() {

    var AgentId = findAgentID();

    var LineToAgentCalendar = $('#LineToAgentCalendar');

    var ViewStart = LineToAgentCalendar.fullCalendar('getView').start;// תאריך המופע הראשון בלוח
    var ViewEnd = LineToAgentCalendar.fullCalendar('getView').end;// תאריך המופע האחרון בלוח
    var resParams;


    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetLineToAgentEvents&ViewStart=" + ViewStart.format() + "&ViewEnd=" + ViewEnd.format() + "&AgentId=" + AgentId + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {



        resParams = jQuery.parseJSON(jqXHR.responseText);
        var formattedEventData = [];
        for (var k = 0; k < resParams.length; k++) {
            formattedEventData.push({
                title: resParams[k].title,
                allDay: true,
                start: resParams[k].start,
                end: resParams[k].end,
                allDaySlot: true
            });
        }

        LineToAgentCalendar.fullCalendar('addEventSource', formattedEventData);

        setTimeout("getInactiveEventsToAgentCalendar();", 1);
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
    });
}

//Inactive

function SaveInActiveDaysType(List) {
    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SaveInActiveDaysType&InActiveDaysTypes=" + List + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
        if (jqXHR.status == 200) {
            MassageApprov.innerText = "ההגדרות נשמרו בהצלחה.";
            $("#MassageApprov").fadeOut(1000, function () {
                $(this).text("")
            }).fadeIn();

        } else {
            //"<%=StrSrc("Failure")%>";
            MassageApprov.innerText = "תקלה: ההגדרות לא נשמרו.";
            $("#MassageApprov").fadeOut(1000, function () {
                $(this).text("")
            }).fadeIn();
        }
    });
}

function AddInActiveDays() {

    var ViewStart = $('#InActiveCalendar').fullCalendar('getView').start;// תאריך המופע הראשון בלוח
    var ViewEnd = $('#InActiveCalendar').fullCalendar('getView').end;// תאריך המופע האחרון בלוח
    var AgentId = findAgentID();
    var arrEvents = $('#InActiveCalendar').fullCalendar('clientEvents');
    var InActiveEvents = "";
    var first = true;
    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_RoutesGetInActiveDaysType&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
        resParams = jQuery.parseJSON(jqXHR.responseText);

        for (var i = 0; i < arrEvents.length; i++) {
            var isToAdd = false;
            if (ViewStart._d <= arrEvents[i].start._d && ViewEnd._d >= arrEvents[i].start._d) {
                if (AgentId == 0) {
                    if (arrEvents[i].color == "#3A87AD") {
                        isToAdd = true;
                    }
                }
                else {
                    if (arrEvents[i].color == "#339966") {
                        isToAdd = true;
                    }
                }
                if (isToAdd) {
                    if (first) {
                        first = false;
                        InActiveEvents += arrEvents[i].start._d.toString();
                    } else {
                        InActiveEvents += ";" + arrEvents[i].start._d.toString();
                    }
                    try {
                        InActiveEvents += ";" + arrEvents[i].end._d.toString();
                    } catch (e) {
                        InActiveEvents += ";"
                    }
                    var tit = arrEvents[i].title.toString();

                    for (var j = 0; j < resParams.length; j++) {

                        if (tit.length >= resParams[j].InActiveDaysTypeText.length) {
                            if (tit.substr(0, resParams[j].InActiveDaysTypeText.length) == resParams[j].InActiveDaysTypeText) {
                                tit = resParams[j].InActiveDaysTypeText;
                            }
                        }
                    }
                    InActiveEvents += ";" + escape(tit);
                }
            }
        }

        request = $.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetInActiveDays&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
            type: "POST",
            data: "AgentId=" + AgentId + "&InActiveEvents=" + InActiveEvents + "&ViewStart=" + ViewStart.toString() + "&ViewEnd=" + ViewEnd.toString(),
        });
        request.done(function (response, textStatus, jqXHR) {

        });
        request.fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 200) {



            } else {

            }
        });
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
    });
}

function getInactiveEvents() {
    var AgentId = findAgentID();
    var InActiveCalendar = $('#InActiveCalendar');

    var ViewStart = InActiveCalendar.fullCalendar('getView').start;// תאריך המופע הראשון בלוח
    var ViewEnd = InActiveCalendar.fullCalendar('getView').end;// תאריך המופע האחרון בלוח

    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_GetInActiveDays&AgentId=" + AgentId + "&ViewStart=" + ViewStart.toString() + "&ViewEnd=" + ViewEnd.toString() + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ''
    });
    request.done(function (response, textStatus, jqXHR) {

        resParams = jQuery.parseJSON(jqXHR.responseText);

        if (resParams.length != 0) {
            InActiveCalendar.fullCalendar('addEventSource', resParams);
        }

    });
    request.fail(function (jqXHR, textStatus, errorThrown) {


        //resParams = jQuery.parseJSON(jqXHR.responseText);
        //$('#InActiveCalendar').fullCalendar('addEventSource', resParams);
    });
}

function setInActiveCalendar() {

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
        $('#InActiveCalendar').fullCalendar({
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

                start: startHour, // a start time (10am in this example)
                end: endHour, // an end time (6pm in this example)
                dow: [0, 1, 2, 3, 4, 5]

            },
            eventLimit: true, // allow "more" link when too many events
            //eventLimitText: function (dayEventCount) {

            //    //var counter = 0;
            //    ////all_events.forEach(function (entry) {
            //    ////    if (entry['start'] == date.format()) {
            //    ////        counter++;
            //    ////    }
            //    ////    else if (entry['start'] <= date.format() && entry['end'] >= date.format()) {
            //    ////    
            //    ////    }
            //    ////});
            //    //return "סה''כ " + (dayEventCount).toString()+" - "+counter;
            //},
            slotEventOverlap: false,
            displayEventTime: true,
            editable: true,
            droppable: true, // this allows things to be dropped onto the calendar
            eventStartEditable: function (date, allDay, jsEvent, view) {


            },
            height: 590,
            dayClick: function (date, allDay, jsEvent, view) {
                //var moment = $('#calendar').fullCalendar('getDate');

                $('#InActiveCalendar').fullCalendar('changeView', 'agendaDay');
                $('#InActiveCalendar').fullCalendar('gotoDate', date)
            },

            eventRender: function (event, element) {
                var isToAdd = false;
                var AgentId = findAgentID();
                if (AgentId == 0) {
                    if (event.color == "#3A87AD") {
                        isToAdd = true;
                    }
                }
                else {
                    if (event.color == "#339966") {
                        isToAdd = true;
                    }
                }
                if (isToAdd) {
                    element.append("<div class='closeonDiv' ><span class='closeon'>X</span></div>");
                    element.find(".closeon").click(function () {
                        $('#InActiveCalendar').fullCalendar('removeEvents', event._id);
                        AddInActiveDays();
                    });
                }
            },
            drop: function (event, element, revertFunc) {

                AddInActiveDays();
            },
            eventDrop: function (event, dayDelta, revertFunc) {

                var AgentId = findAgentID();
                if (AgentId == "0") {
                    if (event.color == "#339966") {
                        revertFunc();
                        return;
                    }
                } else {
                    if (event.color == "#3A87AD") {
                        revertFunc();
                        return;
                    }
                }
                AddInActiveDays();

            },
            eventResize: function (event, delta, revertFunc) {
                var AgentId = findAgentID();
                if (AgentId == "0") {
                    if (event.color == "#339966") {
                        revertFunc();
                        return;
                    }
                } else {
                    if (event.color == "#3A87AD") {
                        revertFunc();
                        return;
                    }
                }
                AddInActiveDays();
            },
        });



    });
    request.fail(function (jqXHR, textStatus, errorThrown) {

    });
}


function getInActiveDaysType() {

    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_RoutesGetInActiveDaysType&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {

        resParams = jQuery.parseJSON(jqXHR.responseText);
        var liste = $("#InActiveDaysTypeList")[0];// document.getElementById('<% = InActiveDaysTypeList.ClientID %>');
        liste.options.length = 0;

        for (var i = 0; i < $(".InActiveDaysType").length; i++) {
            var element = $(".InActiveDaysType")[i--];
            element.parentNode.removeChild(element);
        }
        for (var i = 0; i < resParams.length; i++) {
            AddOpt = new Option(resParams[i].InActiveDaysTypeText, liste.options.length);
            liste.options[liste.options.length] = AddOpt;


            $("#external-events").append(" <div class='fc-event InActiveDaysType' style='text-align: center;'>" + resParams[i].InActiveDaysTypeText + "</div>");
            $("#Allexternal-events").append(" <div class='fcAll-event InActiveDaysType' style='text-align: center;'>" + resParams[i].InActiveDaysTypeText + "</div>");
        }
        $('#external-events .fc-event').each(function () {
            // store data so the calendar knows to render an event upon drop
            $(this).data('event', {
                title: $.trim($(this).text()), // use the element's text as the event title
                color: '#3A87AD',
                stick: true // maintain when user navigates (see docs on the renderEvent method)
            });

            // make the event draggable using jQuery UI
            $(this).draggable({
                zIndex: 999,
                revert: true,      // will cause the event to go back to its
                revertDuration: 0  //  original position after the drag
            });

        });
        $('#Allexternal-events .fcAll-event').each(function () {

            // store data so the calendar knows to render an event upon drop
            $(this).data('event', {
                title: $.trim($(this).text()), // use the element's text as the event title
                color: '#339966',
                stick: true // maintain when user navigates (see docs on the renderEvent method)
            });

            // make the event draggable using jQuery UI
            $(this).draggable({
                zIndex: 999,
                revert: true,      // will cause the event to go back to its
                revertDuration: 0  //  original position after the drag
            });

        });


    });
    request.fail(function (jqXHR, textStatus, errorThrown) {

    });
}

//Settings

function changeNumberOfWeeks() {
    var NumberOfWeeks = document.getElementById("NumberOfWeeks").value;
    SaveRoutesSettings("NumberOfWeeks", NumberOfWeeks, "NotDate")
}

function changeWorkDays() {
    var WorkDays = "";
    var firstVal = true;
    if (document.getElementById("cbSunday").checked) {
        WorkDays += escape(document.getElementById("cbSunday").value)
        if (firstVal) {
            firstVal = false;
        }
    }
    if (document.getElementById("cbMonday").checked) {
        if (firstVal) {
            firstVal = false;
        }
        else {
            WorkDays += ";"
        }
        WorkDays += escape(document.getElementById("cbMonday").value)
    }
    if (document.getElementById("cbTuesday").checked) {
        if (firstVal) {
            firstVal = false;
        }
        else {
            WorkDays += ";"
        }
        WorkDays += escape(document.getElementById("cbTuesday").value)
    }
    if (document.getElementById("cbWednesday").checked) {
        if (firstVal) {
            firstVal = false;
        }
        else {
            WorkDays += ";"
        }
        WorkDays += escape(document.getElementById("cbWednesday").value)
    }
    if (document.getElementById("cbThursday").checked) {
        if (firstVal) {
            firstVal = false;
        }
        else {
            WorkDays += ";"
        }
        WorkDays += escape(document.getElementById("cbThursday").value)

    }
    if (document.getElementById("cbFriday").checked) {
        if (firstVal) {
            firstVal = false;
        }
        else {
            WorkDays += ";"
        }
        WorkDays += escape(document.getElementById("cbFriday").value)
    }
    if (document.getElementById("cbSaturday").checked) {
        if (firstVal) {
            firstVal = false;
        }
        else {
            WorkDays += ";"
        }
        WorkDays += escape(document.getElementById("cbSaturday").value)
    }


    SaveRoutesSettings("WorkDays", WorkDays, "NotDate");
}

function changeStartDate() {
    var StartDate = document.getElementById("txtStartDate").value;
    if (StartDate != "") {
        SaveRoutesSettings("StartDate", StartDate, "Date");
    }
}

function changeStartHour(Etime) {

    var StartHour = document.getElementById("txtStartHour").value;
    // alert(StartHour);
    SaveRoutesSettings("StartHour", StartHour, "Date");
    $('.EndHour').timepicker('option', 'minTime', Etime);
}

function changeEndHour(Stime) {

    var EndHour = document.getElementById("txtEndHour").value;
    //alert(EndHour);
    SaveRoutesSettings("EndHour", EndHour, "Date");
    $('.StartHour').timepicker('option', 'maxTime', Stime);
}

function SaveRoutesSettings(ParameterId, ParameterValue, IsDate) {

    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SaveRoutesSettings&ParameterId=" + ParameterId + "&ParameterValue=" + ParameterValue + "&IsDate=" + IsDate + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
    });
    request.fail(function (jqXHR, textStatus, errorThrown) {
        if (jqXHR.status == 200) {
            MassageApprov.innerText = "ההגדרות נשמרו בהצלחה.";
            $("#MassageApprov").fadeOut(1000, function () {
                $(this).text("")
            }).fadeIn();
            //"<%=StrSrc("OrbitSaved")%>";

        } else {
            //"<%=StrSrc("Failure")%>";
            MassageApprov.innerText = "תקלה: ההגדרות לא נשמרו.";
            $("#MassageApprov").fadeOut(1000, function () {
                $(this).text("")
            }).fadeIn();
        }
    });
}

function AddNewKeypress() {
    if (event.which == 13) {
        AddToList();
    }
}

function OnInitSettings() {
    var StartDate = new Date();
    SDateD = StartDate.getDate();
    if (SDateD.toString().length == 1) { SDateD = "0" + SDateD; }
    SDateM = (StartDate.getMonth() + 1);
    if (SDateM.toString().length == 1) { SDateM = "0" + SDateM; }
    SDateY = StartDate.getFullYear();
    if (SDateY.toString().length == 1) { SDateY = "0" + SDateY; }
    document.getElementById("txtStartDate").value = SDateD + "/" + SDateM + "/" + SDateY;
    document.getElementById("txtStartHour").value = "00:00";
    document.getElementById("txtEndHour").value = "23:45";
    MassageApprov.innerText = "";
}

function getSettings() {

    request = $.ajax({
        url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_RoutesGetSettings&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
        type: "POST",
        data: ""
    });
    request.done(function (response, textStatus, jqXHR) {
        resParams = jQuery.parseJSON(jqXHR.responseText);
        if (resParams[0] != null && resParams[0] != "") {
            var SDate = [{ "id": 1, "start": resParams[0].StartDate }];
            var StartDate = new Date(SDate[0].start.match(/\d+/)[0] * 1);
            var SHour = [{ "id": 1, "start": resParams[0].StartHour }];
            var StartHour = new Date(SHour[0].start.match(/\d+/)[0] * 1);
            var EHour = [{ "id": 1, "start": resParams[0].EndHour }];
            var EndHour = new Date(EHour[0].start.match(/\d+/)[0] * 1);
            SDateD = StartDate.getDate();
            if (SDateD.toString().length == 1) { SDateD = "0" + SDateD; }
            SDateM = (StartDate.getMonth() + 1);
            if (SDateM.toString().length == 1) { SDateM = "0" + SDateM; }
            SDateY = StartDate.getFullYear();
            if (SDateY.toString().length == 1) { SDateY = "0" + SDateY; }

            SHourH = StartHour.getHours();
            if (SHourH.toString().length == 1) { SHourH = "0" + SHourH; }
            SHourM = StartHour.getMinutes();
            if (SHourM.toString().length == 1) { SHourM = "0" + SHourM; }

            EHourH = EndHour.getHours();
            if (EHourH.toString().length == 1) { EHourH = "0" + EHourH; }
            EHourM = EndHour.getMinutes();
            if (EHourM.toString().length == 1) { EHourM = "0" + EHourM; }

            document.getElementById("txtStartDate").value = SDateD + "/" + SDateM + "/" + SDateY;
            document.getElementById("txtStartHour").value = SHourH + ":" + SHourM;
            document.getElementById("txtEndHour").value = EHourH + ":" + EHourM;

            document.getElementById("NumberOfWeeks").value = resParams[0].NumberOfWeeksToCyclic;

            var WorkDays = (resParams[0].WorkDays).split(';');
            for (var i = 0; i < WorkDays.length; i++) {

                switch (WorkDays[i]) {
                    case '1':
                        document.getElementById("cbSunday").checked = true;
                        break;
                    case '2':
                        document.getElementById("cbMonday").checked = true;
                        break;
                    case '3':
                        document.getElementById("cbTuesday").checked = true;
                        break;
                    case '4':
                        document.getElementById("cbWednesday").checked = true;
                        break;
                    case '5':
                        document.getElementById("cbThursday").checked = true;
                        break;
                    case '6':
                        document.getElementById("cbFriday").checked = true;
                        break;
                    case '7':
                        document.getElementById("cbSaturday").checked = true;
                        break;
                }
            }
        }

    });
    request.fail(function (jqXHR, textStatus, errorThrown) {

    });

    getInActiveDaysType();
}

function AddToList() {
    var liste = $('#InActiveDaysTypeList')[0];// document.getElementById('<% = InActiveDaysTypeList.ClientID %>');
    var add = true;

    AddOpt = new Option($('#AddNewInActiveDays').val(), liste.options.length);
    for (var i = 0; i < liste.options.length; i++) {
        if (liste.options[i].text == AddOpt.text) {
            add = false;
        }
    }
    if (add && AddOpt.text != "") {
        liste.options[liste.options.length] = AddOpt;
    }
    var inActiveDaysTypeList = "";
    for (var i = 0; i < liste.options.length; i++) {
        if (i == 0) {
            inActiveDaysTypeList += escape(liste.options[i].label);
        }
        else {
            inActiveDaysTypeList += ";" + escape(liste.options[i].label);
        }
    }

    $('#AddNewInActiveDays').val("");
    SaveInActiveDaysType(inActiveDaysTypeList);
}

function delFromList() {
    var liste = $('#InActiveDaysTypeList')[0]; //document.getElementById('<% = InActiveDaysTypeList.ClientID %>');
    var howMany = liste.options.length;
    for (var i = 0; i < liste.options.length; i++) {
        liste.options[i].val;
        if (liste.options[i].selected == true) {
            liste.options.remove(i--);
        }
    }
    var inActiveDaysTypeList = "";
    for (var i = 0; i < liste.options.length; i++) {
        if (i == 0) {
            inActiveDaysTypeList += escape(liste.options[i].label);
        }
        else {
            inActiveDaysTypeList += ";" + escape(liste.options[i].label);
        }
    }

    SaveInActiveDaysType(inActiveDaysTypeList);
}








