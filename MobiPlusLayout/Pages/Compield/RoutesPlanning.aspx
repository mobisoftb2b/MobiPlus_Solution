<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RoutesPlanning.aspx.cs" Inherits="Pages_Compield_RoutesPlanning" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>תכנון מסלולים</title>
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
    <script src="../../js/routes.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <script src="../../js/jquery.RowTimepicker.js?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"></script>
    <link href="../../css/jquery.RowTimepicker.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>" rel="stylesheet" />

   
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
        <div id="dAll" style="position:absolute;">

        <table>
            <tr>
                <td style="vertical-align: top; margin-right: 30px;">
                    <div style="margin-right: -33px; margin-left: 0; z-index: 99; position: relative;">
                        <ul>
                            <li id="sideTabPlane" class="sideTabSelected" onclick="sideBarClick('Plane');"><a class="">תכנון</a></li>
                            <li id="sideTabLine" class="sideTab" onclick="sideBarClick('Line');"><a onclick="sideBarClick('Line');" class="">קו</a></li>
                        </ul>
                    </div>
                </td>
                <td>
                    <div id="Planningdiv" style="position:fixed;top:0px;">
                        <div style="padding-right: 5px;">
                            <ul>
                                <li id="liPlanning"><a href="#tab0" onclick="tabActive('Planning');"><span>תכנון</span></a></li>
                                <li id="liCalendar"><a href="#tab1" onclick="tabActive('Calendar');"><span>לוח שנה</span></a></li>
                                <li id="liLineToCust" style="display: none"><a href="#tab2" onclick="tabActive('LineToCust');"><span>הוספת קו ללקוח</span></a></li>
                                <li id="liSetLines" style="display: none"><a href="#tab3" onclick="tabActive('SetLines');"><span>עריכת קווים</span></a></li>
                                <li id="liLineToAgent" style="display: none"><a href="#tab4" onclick="tabActive('LineToAgent');"><span>הוספת קווים לסוכן</span></a></li>
                                <li id="liInactive"><a href="#tab5" onclick="tabActive('Inactive');"><span>ימים לא פעילים</span></a></li>
                                <li id="liSettings"><a href="#tab6" onclick="tabActive('Settings');"><span>הגדרות</span></a></li>
                            </ul>
                        </div>
                        <div class="ContentRep">
                            <table>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td id="tdAgentsList" style="padding-left: 0px; padding-right: 10px;">
                                                    <div class="AgentsHederDiv">רשימת סוכנים</div>
                                                    <asp:ListBox CssClass="LBAgents1" Width="160px" Height="300px" ID="AgentsList" runat="server" onchange="ActiveAgent();"></asp:ListBox>
                                                </td>
                                                <td>
                                                    <div class="RoutesContent " id="tab0">
                                                        <iframe id='CustGrid' frameborder='0' scrolling='no' src='' class='CustReport'></iframe>
                                                    </div>
                                                    <div class="RoutesContent" id="tab1">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <div id="mainCalendar" class="fc fc-ltr fc-unthemed "></div>

                                                                </td>
                                                            </tr>
                                                        </table>

                                                    </div>
                                                    <div class="DLineContent " id="tab2">
                                                        <div class="DLine ">
                                                            <table>
                                                                <tr style="vertical-align: top;">
                                                                    <td>
                                                                        <div class="CustGridContent ">
                                                                            <iframe id='CustGrid2' frameborder='0' scrolling='no' src='' class='CustReport'></iframe>
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
                                                    <div class="DLineContent " id="tab3">
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
                                                    <div class="DLineContent " id="tab4">


                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <div id="LineToAgentCalendar" class="fc fc-ltr fc-unthemed "></div>
                                                                </td>
                                                                <td>
                                                                    <div class="AgentsHederDiv">רשימת קווים</div>
                                                                    <div id='wrap'>
                                                                        <div id='externalLine-events' class="LineEvents">
                                                                        </div>
                                                                        <div style='clear: both'></div>
                                                                    </div>


                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div class="RoutesContent" id="tab5">
                                                        <table>
                                                            <tr>
                                                                <td>

                                                                    <div id="InActiveCalendar" class="fc fc-ltr fc-unthemed "></div>

                                                                </td>
                                                                <td style="vertical-align: top; padding-top: 35px">
                                                                    <fieldset style="width: 120px; padding: 3px;">
                                                                        <legend>גרור אירוע</legend>
                                                                        <div id='wrap2'>

                                                                            <div id='external-events'>
                                                                            </div>
                                                                            <div id='Allexternal-events'>
                                                                            </div>
                                                                            <div style='clear: both'></div>
                                                                            <%--          <div style="margin-top: 20px;">
                                                                                <input id="SaveInActive" type="button" class="RoutesPlanning-btn" value="שמור אירועים" onclick="AddInActiveDays();" />
                                                                            </div>--%>
                                                                        </div>
                                                                    </fieldset>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div class="RoutesContent" id="tab6">

                                                        <div class="SettingsContent">
                                                            <h1>הגדרות</h1>
                                                            <table cellpadding="2" cellspacing="2">
                                                                <tr>
                                                                    <td>מספר שבועות במחזור:
                                                                    </td>
                                                                    <td>
                                                                        <select name="NumberOfWeeks" onchange="changeNumberOfWeeks();" id="NumberOfWeeks">
                                                                            <option value="1">1</option>
                                                                            <option value="2">2</option>
                                                                            <option value="3">3</option>
                                                                            <option value="4">4</option>
                                                                            <option value="5">5</option>
                                                                            <option value="6">6</option>
                                                                            <option value="7">7</option>
                                                                            <option value="8">8</option>
                                                                        </select>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>ימי עבודה:
                                                                    </td>
                                                                    <td>
                                                                        <table>
                                                                            <tr>
                                                                                <td>ראשון</td>
                                                                                <td>
                                                                                    <input id="cbSunday" value="1" type="checkbox" onchange="changeWorkDays();" name="cbIsZebra" /></td>
                                                                                <td>שני</td>
                                                                                <td>
                                                                                    <input id="cbMonday" value="2" type="checkbox" onchange="changeWorkDays();" name="cbIsZebra" /></td>
                                                                                <td>שלישי</td>
                                                                                <td>
                                                                                    <input id="cbTuesday" value="3" type="checkbox" onchange="changeWorkDays();" name="cbIsZebra" /></td>
                                                                                <td>רביעי</td>
                                                                                <td>
                                                                                    <input id="cbWednesday" value="4" type="checkbox" onchange="changeWorkDays();" name="cbIsZebra" /></td>
                                                                                <td>חמישי</td>
                                                                                <td>
                                                                                    <input id="cbThursday" value="5" type="checkbox" onchange="changeWorkDays();" name="cbIsZebra" /></td>
                                                                                <td>שישי</td>
                                                                                <td>
                                                                                    <input id="cbFriday" value="6" type="checkbox" onchange="changeWorkDays();" name="cbIsZebra" /></td>
                                                                                <td>שבת</td>
                                                                                <td>
                                                                                    <input id="cbSaturday" value="7" type="checkbox" onchange="changeWorkDays();" name="cbIsZebra" /></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>תאריך התחלת מחזור ראשון:
                                                                    </td>
                                                                    <td>
                                                                        <input id="txtStartDate" type="text" readonly="true" onchange="changeStartDate();" class="txtDate DTpicker" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>שעות פעילות:
                                                                    </td>
                                                                    <td>
                                                                        <table>
                                                                            <tr>
                                                                                <td>התחלה:</td>
                                                                                <td>
                                                                                    <input id="txtStartHour" type="text" onchange="changeStartHour(this.value);" class="txtTime3 StartHour FromTime" />
                                                                                </td>
                                                                                <td>סיום:</td>
                                                                                <td>
                                                                                    <input id="txtEndHour" type="text" onchange="changeEndHour(this.value);" class="txtTime3 EndHour ToTime" />

                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <fieldset class="">
                                                                            <legend>ארועים לגרירה</legend>
                                                                            <table>
                                                                                <tr style="vertical-align: top">
                                                                                    <td>
                                                                                        <input id="AddNewInActiveDays" onkeypress="AddNewKeypress();" type="text" class="txt180" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <input id="btnAddNewInActive" type="button" class="RoutesPlanning-btn" value="->" onclick="AddToList();" />

                                                                                    </td>
                                                                                    <td rowspan="4">
                                                                                        <asp:ListBox SelectionMode="Multiple" CssClass="LBEvents" ID="InActiveDaysTypeList" runat="server"></asp:ListBox>
                                                                                    </td>
                                                                                    <td>

                                                                                        <input id="btnDelInActiveDays" type="button" class="RoutesPlanning-btn" value="הסר" onclick="delFromList();" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </fieldset>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <span id="MassageApprov"></span>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>

                        </div>
                    </div>
                </td>
            </tr>
        </table>
</div>
        <div id="ErrorBox" runat="server" style="display: none;" class="cssErrorBox">
            <div class="Error-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="CloseErrorBox();">×</button>
                <h3 id="txtError"></h3>
            </div>
        </div>
       <%-- <div id="dLoading" class="loadingCust">
            <center>
            <img alt="" src="../../Img/loading1.gif" width="64px" />
            <br />
            <br />
            טוען נתונים...
        </center>
        </div>--%>


        <script type="text/javascript">
            var TabSelected = "";
            var custKey = "";
            var DLineId = "";
            var DLineDesc = "";
            var Delta = "";
            var lines = [];
            var _WorkDays = "";
            $(".DTpicker").datepicker({
                autoSize: true,         // automatically resize the input field 
                altFormat: 'yy-mm-dd',  // Date Format used
                firstDay: 0, // Start with Monday
                Date: new Date(),

                beforeShowDay: function (date) {
                    return [date.getDay() === 0, ''];
                } // Allow only one day a week
            }).on('changeDate', changeStartDate());

            $(".StartHour").timepicker({
                'minTime': '0:00',
                'maxTime': '23:45',

            });

            $(".EndHour").timepicker({
                'minTime': '0:00',
                'maxTime': '23:45'
            });



            Addgrid();
            getDistributionLine();
            setLineToAgentCalendar();
            getWorkDays()
        </script>
    </form>
     <script type="text/javascript">
        $(function () {
            

            
        });
        $(function () {
            
        });

        function setT()
        {
            $("#Planningdiv").tabs();
            $("#Planningdiv").css("direction", "rtl")
            $("#Planningdiv").css("text-align", "right");
            $("#PlanningNextdiv").tabs();
        }
        setTimeout('setT();',200);
    </script>
</body>
</html>
