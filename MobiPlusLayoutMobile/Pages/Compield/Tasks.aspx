<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Tasks.aspx.cs" Inherits="Pages_Compield_Tasks" %>

<%@ Register TagPrefix="ctl" Src="~/Controls/ctlPopulations.ascx" TagName="ctlPopulations" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>משימות</title>
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
        function CloseEditWinTaskItemBox() {
            $(".EditWinTaskItemBox").css({ top: 100 })
                            .animate({ "top": "-600" }, "high");
            $("#dBodyr").unblock();
        }
        function DateFormatteryyyymmdd(cellValue, options, rowObject) {
            if (cellValue)
                return cellValue.toString().substr(6, 2) + "/" + cellValue.toString().substr(4, 2) + "/" + cellValue.toString().substr(0, 4);
            else
                return cellValue;
        }
        var arrIDs = [];
        var arrTasks = [];
        function BoldFormatter(cellValue, options, rowObject) {
            //debugger;
            var scr = " onclick='OpenTask(\"" + options.rowId + "\");'";
            if (!(rowObject["TaskID"])) {
                scr = " onclick='OpenTask(\"" + arrIDs[options.rowId.replace('jQGridghead_0_', '')] + "\");'";
            }
            else {
                scr = " onclick='OpenTask(\"" + options.rowId + "\");'"
                var isNotFound = true;
                for (var i = 0; i < arrIDs.length; i++) {
                    if (arrTasks[i] == rowObject["TaskID"]) {
                        isNotFound = false;
                        break;
                    }
                }
                if (isNotFound) {
                    arrIDs.push(options.rowId);
                    arrTasks.push(rowObject["TaskID"]);
                }
            }
            return "<div style='font-weight:700;' " + scr + ">" + cellValue + "</div>";
        }
        function summaryType(val, name, record) {

            if (typeof (val) === "string" || typeof (val) == 'image') {
                val = ''; //{ max: false, totalCount: 0, checkedCount: 0 };
            }

            return val;
        }
        function mysum(val, name, record) {
            return "<div id='div" + record["TaskID"] + "'>סה''כ:" + "</div>";
        }
    </script>
    <style type="text/css">
        .ui-jqgrid .ui-jqgrid-bdiv
        {
            overflow-y: auto;
            min-height: 480px;
        }
        .ui-jqgrid-titlebar
        {
            background-color: #E2E3E4;
        }
        .ui-jqgrid-sortable
        {
            font-size: 14px;
            font-weight: 700;
        }
        .ui-pg-table
        {
            background-color: #E2E3E4;
            font-size: 14px;
        }
        .ui-jqgrid tr.jqgrow td
        {
            white-space: normal !important;
        }
        #searchmodfbox_jQGrid
        {
            background-color: gray !important;
        }
        .ui-paging-info
        {
            display: none;
        }
    </style>
</head>
<body onload="setTimeout('parent.CloseLoading();',10);">
    <form id="form1" runat="server">
    <div>
        <div class="">
            <table id="jQGrid">
            </table>
            <div id="jQGridPager">
            </div>
        </div>
    </div>
    <div>
        <ctl:ctlPopulations runat="server" ID="ctlPopulationsR" ShowItems="false" ShowCategories="false" />
    </div>
    <div id="dEditWinTaskItemBox" class="EditWinTaskItemBox">
        <div class="JumpWiX" style="padding-right: 3px; padding-top: 2px;">
            <img alt="סגור" src="../../img/X.png" class="imngX" onclick="CloseEditWinTaskItemBox();" />
        </div>
        <div style="padding-top: 3px; background-color: #244062;">
            <center>
                <div id="sHeadEdit">
                    עריכת משימה
                </div>
            </center>
        </div>
        <br />
        <table cellpadding="4" cellspacing="2">
            <tr>
                <td class="EditForm item" style="vertical-align: top;">
                    נושא:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlTopics" Width="200px">
                    </asp:DropDownList>
                </td>
                <td class="EditForm item" style="vertical-align: top;">
                    אחריות:
                </td>
                <td class="EditForm val">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <a id="aPop" href="#" onclick="ShowCtlPopulations();" style="color: Blue;"><div style="color:Black;text-decoration:'none' !important;">טוען...<img alt="טוען..." src="../../img/loading1.gif" width="16px"/></div></a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    תת נושא:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtSubTopic" Width="196px"></asp:TextBox>
                </td>
                <td class="EditForm item">
                    מדווח:
                </td>
                <td class="EditForm val">
                    &nbsp;&nbsp;
                    <asp:DropDownList runat="server" ID="ddlReportUser" Width="200px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item">
                    סיווג:
                </td>
                <td class="EditForm val">
                    <asp:DropDownList runat="server" ID="ddlClassifications" Width="200px">
                    </asp:DropDownList>
                </td>
                <td class="EditForm item" style="vertical-align: top;">
                    עדיפות:
                </td>
                <td class="EditForm val">
                    &nbsp;&nbsp;
                    <asp:DropDownList runat="server" ID="ddlPriority" Width="200px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="EditForm item" style="vertical-align: top;">
                    משימה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtTask" Width="194px" TextMode="MultiLine" Rows="9"></asp:TextBox>
                </td>
                <td colspan="2" rowspan="2">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="EditForm item">
                                זמן דיווח:
                            </td>
                            <td class="EditForm val">
                                <asp:TextBox runat="server" ID="txtDateReport" Width="196px" CssClass="dtp dtp1"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10px; font-size: 1px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="EditForm item">
                                זמן לסיום:
                            </td>
                            <td class="EditForm val">
                                <asp:TextBox runat="server" ID="txtDateFinish" Width="196px" CssClass="dtp dtp2"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10px; font-size: 1px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="EditForm item">
                                סגור:
                            </td>
                            <td class="EditForm val">
                                <asp:CheckBox runat="server" ID="cbClosed" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10px; font-size: 1px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td class="EditForm item">
                                סטטוס:
                            </td>
                            <td class="EditForm val">
                                <asp:DropDownList runat="server" ID="ddlStatuses" Width="200px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td style="height: 10px; font-size: 1px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td class="EditForm item">
                                תאריך סטאטוס:
                            </td>
                            <td class="EditForm val">
                                <asp:TextBox runat="server" ID="txtStatusDate" Width="196px"></asp:TextBox>
                                <%--CssClass="dtp dtp2"--%>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10px; font-size: 1px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="EditForm item">
                                מתאריך:
                            </td>
                            <td class="EditForm val">
                                <asp:TextBox runat="server" ID="txtFromDate" Width="196px" CssClass="dtpN dtp1"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10px; font-size: 1px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="EditForm item">
                                עד תאריך:
                            </td>
                            <td class="EditForm val">
                                <asp:TextBox runat="server" ID="txtToDate" Width="196px" CssClass="dtpN dtp1"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 10px; font-size: 1px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="EditForm item">
                                זמן לתצוגה:
                            </td>
                            <td class="EditForm val">
                                <asp:TextBox runat="server" ID="txtAlarmDate" Width="196px" CssClass="dtptime dtp3"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="EditForm item" style="vertical-align: top;">
                    הערה:
                </td>
                <td class="EditForm val">
                    <asp:TextBox runat="server" ID="txtNote" Width="194px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </td>
            </tr>
            <%--<tr>
                <td class="EditForm item">
                    אוכלוסיות:
                </td>
                <td class="EditForm val" colspan="3">
                    <a id="aPop" href="#" onclick="ShowCtlPopulations();" style="color: Blue;">אוכלוסיות</a>
                </td>
            </tr>--%>
        </table>
        <div id="div3" style="text-align: center; float: none; padding-top: 10px;">
            <input type="button" value="שמור" class="MSBtnGeneral" style="background-image: url('../../Img/ok.png');
                width: 80px;" onclick="SetTaskData('0');" />
            <asp:HiddenField runat="server" ID="hdnridmd" />
        </div>
    </div>
    <div style="display: none;">
    </div>
    </form>
    <script type="text/javascript"> 
    function SetTaskData(isToDelete) {
            if( $('#aPop').text()=="אוכלוסיות" || ($('#<%=ctlPopulationsR.hdnParentsPopulationID %>').val() =="" && $('#<%=ctlPopulationsR.hdnItemsPopulationID %>').val() ==""))  
            {
                alert("אנא בחר אוכלוסיות");
                return;
            }
            if(!$('#<%=ddlTopics.ClientID %>').val())
            {
                alert("אנא בחר נושא");
                return;
            }

            if($('#<%=txtFromDate.ClientID %>').val()=="")
            {
                alert("אנא בחר מתאריך");
                return;
            }

            if($('#<%=txtToDate.ClientID %>').val()=="")
            {
                alert("אנא בחר עד תאריך");
                return;
            }

            if($('#<%=txtAlarmDate.ClientID %>').val()=="")
            {
                alert("אנא בחר זמן לתצוגה");
                return;
            }
            var ConditionID="2";
            //if($('#<%=txtDateReport.ClientID %>')[0].checked)
               // ConditionID="3";
            var request;
            /*context.Request.QueryString["DateFrom"].ToString(), context.Request.QueryString["DateTo"].ToString(), 
                        context.Request.QueryString["AlarmDate"].ToString()*/
            request = $.ajax({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_SetTaskData&TaskID=" + ridmd + "&ClassificationID="+ $('#<%=ddlClassifications.ClientID %>').val() + "&TopicID="+ $('#<%=ddlTopics.ClientID %>').val()
                + "&SubTopic="+ $('#<%=txtSubTopic.ClientID %>').val() +  "&PriorityID="+ $('#<%=ddlPriority.ClientID %>').val()
                + "&dtReport="+ $('#<%=txtDateReport.ClientID %>').val()+ "&dtTaskEnd="+ $('#<%=txtDateFinish.ClientID %>').val()+ "&ConditionID="+ ConditionID + "&TaskNotes="+ $('#<%=txtNote.ClientID %>').val()
                + "&TaskStatusID=4"//+ $('#<%=ddlStatuses.ClientID %>').val()
                + "&dtStatus=0"//+ $('#<%=txtStatusDate.ClientID %>').val()
                + "&DateFrom="+ $('#<%=txtFromDate.ClientID %>').val()
                + "&DateTo="+ $('#<%=txtToDate.ClientID %>').val()
                + "&AlarmDate="+ $('#<%=txtAlarmDate.ClientID %>').val()
                + "&IsToDelete="+ isToDelete + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                type: "post",
                data: "ParentsPopulation=" + ($('#<%=ctlPopulationsR.hdnParentsPopulationID %>').val())
                +"&ItemsPopulation="+ ($('#<%=ctlPopulationsR.hdnItemsPopulationID %>').val()) + "&UnCheckedPopulation="+ ($('#<%=ctlPopulationsR.hdnUnCheckedPopulationID %>').val())
                +"&Task="+ escape($('#<%=txtTask.ClientID %>').val())
            });
            request.done(function (response, textStatus, jqXHR) {
                 CloseEditWinTaskItemBox();
                 RefreshMD();

                 ridmd="0";
            });
            request.fail(function (jqXHR, textStatus, errorThrown) {
                if (jqXHR.status == 200) {
                    if(jqXHR.responseText=="True")                    
                    {
                        CloseEditWinTaskItemBox();
                        RefreshMD();

                        ridmd="0";
                    }
                    else
                    {
                    //debugger;
                        alert("אראה שגיאה בשמירת הנתונים - " + jqXHR.responseText);
                    }
                }
                else {
                    alert("אראה שגיאה בשמירת הנתונים, "+ jqXHR.responseText);
                    //alert("Error");
                }
            });

//            
        }
    function SavePops()
        {        
            $('#aPop').text($('#<%=ctlPopulationsR.hdnPopsID %>').val());
            if($('#aPop').text() == "")
            {
                $('#aPop').text("אוכלוסיות");
            }
        }
   function ShowCtlPopulations() {

    

            $('.ctlPopulations').css("display", "block");
            var top = "1%";
            var left="10%";
            $(".ctlPopulations")
                        .animate({ "top": top ,"left":left,"display": "block"}, "high");
            //$('#dBodyr').block({ message: '' });
        }
    function initwData(data, objMain) {
            $(".ui-pg-div").click(doNone);

            //$("#edit_jQGrid")[0].children[0].onclick = ShowEditFormMD;

            $("#add_jQGrid")[0].children[0].onclick = ShowAddFormMD;

            $("#del_jQGrid")[0].children[0].onclick = ShowDeleteFormMD;

            $("#search_jQGrid")[0].children[0].onclick = ShowSearchFormMD;

           $("#refresh_jQGrid")[0].children[0].onclick = RefreshMD;
        }
        function RefreshMD() {
            $('#jQGrid').setGridParam({ page: 1, datatype: "json" }).trigger('reloadGrid');
        }

        function ShowEditFormMD() {
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר משימה מן הגריד תחילה.");
                return;
            }
            if (ridmd != "") {
               $('#<%=ddlTopics.ClientID %>').val(Row["TopicID"]);
               $('#<%=txtSubTopic.ClientID %>').val(Row["SubTopic"]);
               $('#<%=ddlReportUser.ClientID %>').val(Row["ReportUser"]);
               $('#<%=ddlClassifications.ClientID %>').val(Row["ClassificationID"]);
               $('#<%=ddlPriority.ClientID %>').val(Row["PriorityID"]);
               //$('#<%=txtTask.ClientID %>').val(Row["Task"].replace('<div style="font-weight:700;">','').replace('<div style="font-weight: 700;">','').replace('</div>',''));
               $('#<%=txtTask.ClientID %>').val(Row["Task"].substr(Row["Task"].indexOf('>')+1,Row["Task"].length - Row["Task"].indexOf('>')-1).replace('</div>',''));
               $('#<%=txtDateReport.ClientID %>').val(Row["dtReport"]);
               $('#<%=txtDateFinish.ClientID %>').val(Row["dtTaskEnd"]);
               if(Row["ConditionID"]=="3")
                    $('#<%=cbClosed.ClientID %>').val("on");
                else
                    $('#<%=cbClosed.ClientID %>').val("off");
               $('#<%=ddlStatuses.ClientID %>').val(Row["TaskStatusID"]);
               $('#<%=txtStatusDate.ClientID %>').val(Row["dtStatus"]);

               $('#<%=txtFromDate.ClientID %>').val(Row["DateFrom"]);
               $('#<%=txtToDate.ClientID %>').val(Row["DateTo"]);
               $('#<%=txtAlarmDate.ClientID %>').val(Row["AlarmDate"]);
                //$('#aPop').text(Row["Populations"]);
                
                $('#<%=ctlPopulationsR.hdnTskID_ID %>').val(ridmd);
                
                SetInit();//on user control
               

                IsAddMD = false;
                $('.EditWinTaskItemBox').css("display", "block");
                var top = 500;
                $(".EditWinTaskItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");

                $('#dBodyr').block({ message: '' });
            }
            else {
                alert("אנא בחר משימה");
            }
            return false;
        }
        var IsAddMD = true;
        function ShowAddFormMD() {
           
            $('#<%=ddlTopics.ClientID %>').val("");
            $('#<%=txtSubTopic.ClientID %>').val("");
            $('#<%=ddlReportUser.ClientID %>').val("");
            $('#<%=ddlClassifications.ClientID %>').val("");
            $('#<%=ddlPriority.ClientID %>').val("");
            $('#<%=txtTask.ClientID %>').val("");
            $('#<%=txtDateReport.ClientID %>').val("");
            $('#<%=txtDateFinish.ClientID %>').val("");
            $('#<%=cbClosed.ClientID %>').val("off");
            $('#<%=ddlStatuses.ClientID %>').val("");
            
            $('#<%=txtFromDate.ClientID %>').val("");
            $('#<%=txtToDate.ClientID %>').val("");
            $('#<%=txtAlarmDate.ClientID %>').val("");

            

            $('#aPop').text("אוכלוסיות");

            $('#<%=ctlPopulationsR.hdnTskID_ID %>').val("0");
            SetInit();

            ridmd="0";
            IsAddMD = true;
            $('.EditWinTaskItemBox').css("display", "block");
            var top = 500;
            $(".EditWinTaskItemBox").css({ top: top })
                        .animate({ "top": "100px" }, "high");
            $('#dBodyr').block({ message: '' });
        }
       
        function ShowDeleteFormMD() {
            
            if(ridmd=="0" || ridmd =="") {
                alert("אנא בחר משימה מן הגריד תחילה.");
                return;
            }
            if (confirm("האם אתה בטוח ברצונך למחוק את המשימה המסומנת מן הגריד?")) {
                SetTaskData('1');
            }
        }

        function ShowSearchFormMD() {
            $("#jQGrid").searchGrid({ closeAfterSearch: false });
        }
        function doNone() {
            return false;
        }
        var Row="";
        function OpenTask(ID)
        {
            var row = $('#jQGrid').jqGrid('getRowData', ID);
            Row = row;
            ridmd = row["TaskID"];
            ShowEditFormMD();
        }

        function getWidth(widthHD)
        {
            var newWidthPer = (widthHD/1667)*100;
            return $(document).width() * newWidthPer/100;
        }
        function ImageFormatter(cellValue, options, rowObject) {
            if (cellValue == '')
                return '';
            return "<div style='text-align:center;'><img src='../../Handlers/ShowImage.ashx?ImageName=" + cellValue + "' width='16px' /></div>";
        }
    var Row;
    var ridmd="0";
    function SetGrid() {
   
            $("#jQGrid").jqGrid({
                url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_Tasks_GetAllTasks&TaskUserID=<%= SessionUserID%>&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
                datatype: "json",
                direction: "rtl",
                colNames: ['#','משימה', 'סוג','קוד', 'שם','הערה','מסמכים מצורפים','תאריך סטטוס','סטטוס','*','TopicID','SubTopic','ReportUser','ClassificationID','PriorityID','dtReport','dtTaskEnd','ConditionID','TaskStatusID','dtStatus','DateFrom','DateTo','AlarmDate','Condition','Name'],
                colModel: [ { name: 'TaskID', index: 'TaskID', width: getWidth(170), sorttype: 'int', align: 'right', editable: true ,summaryType:mysum,hidden:true},
                            { name: 'Task', index: 'Task', width: 0, sorttype: 'text', align: 'right', editable: true,formatter: BoldFormatter,summaryType:summaryType},
                            { name: 'PopulationType', index: 'PopulationType', width: getWidth(200), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType},
                            { name: 'UserID', index: 'UserID', width: getWidth(200), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType,hidden:true},
                            { name: 'TaskUser', index: 'TaskUser', width: getWidth(240), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType},
                            
                            { name: 'UserNotes', index: 'UserNotes', width: getWidth(400), sorttype: 'text', align: 'right', editable: true },
                            { name: 'TaskUserBlobExtension', index: 'TaskUserBlobExtension', width: getWidth(130), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType},
                            { name: 'TaskUpdateDate', index: 'TaskUpdateDate', width: getWidth(340), sorttype: 'date', align: 'right', editable: true,formatter: 'date',formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null} ,summaryType:summaryType},
                            
                            { name: 'TaskStatusName', index: 'TaskStatusName', width: getWidth(270), sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType},
                            { name: 'imgStatus', index: 'imgStatus', width: getWidth(40), formatter: ImageFormatter, stype: 'text',sorttype: 'text',summaryType:summaryType},

                            { name: 'TopicID', index: 'TopicID', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true },
                            { name: 'SubTopic', index: 'SubTopic', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true },
                            { name: 'ReportUser', index: 'ReportUser', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true },
                            { name: 'ClassificationID', index: 'ClassificationID', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true },
                            { name: 'PriorityID', index: 'PriorityID', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true },
                            { name: 'dtReport', index: 'dtReport', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true},
                            { name: 'dtTaskEnd', index: 'dtTaskEnd', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true},
                            { name: 'ConditionID', index: 'ConditionID', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true },
                            { name: 'TaskStatusID', index: 'TaskStatusID', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true },
                            { name: 'dtStatus', index: 'dtStatus', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true},

                            { name: 'DateFrom', index: 'DateFrom', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true,formatter: 'date',formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null} ,summaryType:summaryType },
                            { name: 'DateTo', index: 'DateTo', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true,formatter: 'date',formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null} ,summaryType:summaryType },
                            { name: 'AlarmDate', index: 'AlarmDate', width: 0, sorttype: 'text', align: 'right', editable: true, hidden:true,formatter: 'date',formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y H:i', defaultValue: null} ,summaryType:summaryType },
                            { name: 'Condition', index: 'Condition', width: 70, sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType,hidden:true},
                            { name: 'Name', index: 'Name', width: 100, sorttype: 'text', align: 'right', editable: true ,summaryType:summaryType,hidden:true}

                        ],
                rowNum: 1070,
                mtype: 'POST',
                loadonce: true,
                rowList: [10, 20, 30],
                pager: '#jQGridPager',
                sortname: '_id',
                viewrecords: true,
                sortorder: 'asc',
                caption: " ",
                toppager: false,
                grouping: true, 
                groupingView : { 
                     groupField : ['Task'],
                    // groupOrder : ['desc'] ,
                     //groupDataSorted : true,
                     groupSummary:true,
                     groupColumnShow: [false],
                     groupCollapse: true
                  }, 
                loadComplete: function (data) {
                    $('.ui-pg-input')[0].parentElement.childNodes[0].data = " דף ";
                    $('.ui-pg-input')[0].parentElement.childNodes[2].data = " מ ";
                    $('.ui-pg-input')[0].parentElement.childNodes[1].style.textAlign = "center";

                    var grid = $("#jQGrid"),
                    ids = grid.getDataIDs();

//                    for (var i = 0; i < ids.length; i++) {
//                        grid.setRowData(ids[i], false, { height : 20 + (i * 2) });
//                    }
                   
                    initwData(data, $("#jQGrid"));

                    var $this = $(this),
                            sum = $this.jqGrid("getCol", "UserID", false, "sum"),
                            $footerRow = $(this.grid.sDiv).find("tr.footrow"),
                            localData = $this.jqGrid("getGridParam", "data"),
                            totalRows = localData.length,
                            totalSum = 0,
                            $newFooterRow,
                            i;

                    var counter =1;
                    var OldTadkID="";
                    for (var i = 0; i < localData.length; i++) {
                                
                        if(localData[i]["TaskID"] != OldTadkID)
                        {
                            if(OldTadkID=="")
                                OldTadkID = localData[i]["TaskID"];

                            $('#div'+OldTadkID).text("סה''כ: "+counter.toString());
                            OldTadkID = localData[i]["TaskID"];
                            counter=0;
                        }
                        counter++;
                    }

                    $('#div'+OldTadkID).text("סה''כ: "+counter.toString());
            },

                onSelectRow: function (id) {

                    //ridmd = id;
                    var row = $('#jQGrid').jqGrid('getRowData', id);
                    Row = row;
                    ridmd = row["TaskID"];                    
                    
                },
                ondblClickRow: function (id) {

//                    var row = $('#jQGrid').jqGrid('getRowData', id);
//                    Row = row;
//                   ridmd = row["TaskID"];
//                   
//                    ShowEditFormMD();
                },
                
            });

            $('#jQGrid').jqGrid('navGrid', '#jQGridPager',
                       {
                           edit: false,
                           add: true,
                           del: true,
                           search: true,
                           searchtext: "",
                           addtext: "",
                           edittext: "",
                           deltext: "",
                           refreshtext: "",
                           viewtext: "צפה"
                           
                       },
            //                       { width:700,reloadAfterSubmit:false, top:100,left:300, 
            //                        afterShowForm : hookDatePicker },
                       {   //EDIT
                       //                       height: 300,
                       //                       width: 400,
                       //                       top: 50,
                       //                       left: 100,
                       //                       dataheight: 280,
                       closeOnEscape: true, //Closes the popup on pressing escape key
                       reloadAfterSubmit: true,
                       closeAfterEdit: true,
                       clearAfterAdd: true,
                       drag: true,
                       afterSubmit: function (response, postdata) {

                           if (response.responseText.indexOf('בהצלחה') > -1)
                               ShowTaskT();
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid'); //Reloads the grid after edit
                               return [false, response.responseText]//Captures and displays the response text on th Edit window
                           }
                           $("#sData")[0].style.display = "block";

                       },

                       editData: {
                           id: function () {
                               $("#cData")[0].innerText = "Close";
                               $("#sData")[0].style.display = "none";

                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'id');

                               return value;
                           },
                           GraphID: function () {

                               $("#cData")[0].innerText = "Close";
                               $("#sData")[0].style.display = "none";

                               var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                               var value = $('#jQGrid').jqGrid('getCell', sel_id, 'GraphID');

                               return value;
                           },
                           GroupID: function () {

                               return getCellGroupNameValue();
                           },
                           Grids: function () {
                               return getCellGridsValue();
                           }
                       }
                   },
            //                       { width:700,reloadAfterSubmit:false, top:100,left:300, 
            //                        afterShowForm : hookDatePicker },
                       {
                       closeAfterAdd: true, //Closes the add window after add

                       afterSubmit: function (response, postdata) {
                           if (response.responseText.indexOf('בהצלחה') > -1)
                               ShowTaskT();
                           $("#cData")[0].innerText = "Close";
                           $("#sData")[0].style.display = "none";
                           if (response.responseText == "") {

                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [true, '']
                           }
                           else {
                               $(this).jqGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')//Reloads the grid after Add
                               return [false, response.responseText]
                           }
                       }
                   },
                       {   //DELETE
                           closeOnEscape: true,
                           closeAfterDelete: true,
                           reloadAfterSubmit: true,
                           closeOnEscape: true,
                           drag: true,
                           afterSubmit: function (response, postdata) {
                               if (response.responseText == "") {

                                   $("#jQGrid").trigger("reloadGrid", [{ current: true}]);
                                   return [false, response.responseText]
                               }
                               else {
                                   $(this).jQGrid('setGridParam', { datatype: 'json' }).trigger('reloadGrid')
                                   return [true, response.responseText]
                               }
                           },
                           delData: {
                               GraphID: function () {

                                   var sel_id = $('#jQGrid').jqGrid('getGridParam', 'selrow');
                                   var value = $('#jQGrid').jqGrid('getCell', sel_id, 'GraphID');
                                   alert(value);
                                   return value;

                                   return value;
                               }
                           }
                       },
                       {//SEARCH
                           closeOnEscape: true

                       }
                );
        }
        SetGrid();

        function OnLoadMain()
        {
            $(".dtp").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yymmdd'
                });
                
                 $(".dtpN").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy'
                });

                var d = new Date();

                var month = d.getMonth()+1;
                var day = d.getDate();

                var output =  (day<10 ? '0' : '') + day + '/' +
                    (month<10 ? '0' : '') + month + '/' +
                    d.getFullYear();
                
                $('.dtp1').val(output);
                $('.dtp2').val(output);

                setDt('<%= txtAlarmDate.ClientID%>');//datetime

                $('.dtp3').val(output + " " + "09:00");

                $('.txtPartsGridContainer').width($(document).width()-20);
                $('.txtPartsGridContainer').height($(document).height()-5);
                $('.ui-jqgrid').height($(document).height()-5);
                $('.ui-jqgrid-bdiv').height($(document).height()-61);

                
                
        }
    var counterr = 0;
    function SetInit() {
        var request;
        request = $.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_Tasks_GetTsakPopulationJSON&TaskID=" + $('#<%=ctlPopulationsR.hdnTskID_ID %>').val()
                 + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
            type: "get",
            data: ''
        });
        request.done(function (response, textStatus, jqXHR) {
            //cbItem.ID = "cb_" + dt.Rows[t]["value"].ToString() + "_" + dtAgentsPops.Rows[i]["PopulationTypeID"].ToString() + "*" + dtAgentsPops.Rows[i]["PopulationID"].ToString(); 
            //alert(response);
            //debugger;
            counterr = 0;

            for (var i = 0; i < $('.cbtree').length; i++) {
                $('.cbtree')[i].checked = false;
            }
            for (var i = 0; i < response.length; i++) {
                var UserID = response[i].UserID;
                //if (response[i].PopulationTypeID * 1.0 < 4) {
                for (var t = UserID.length; t < 4; t++) {
                    UserID = '0' + UserID;
                }
                //}
                if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID)) {
                    document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).checked = true;

                    counterr++;

                    try {
                        document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.children[2].style.color = "orange";
                        if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                            document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";

                        if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                            document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";

                        if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                            document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";

                        if (document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2])
                            document.getElementById('ctlPopulationsR_cb_' + UserID + '_' + response[i].PopulationTypeID + '*' + response[i].PopulationID).parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].style.color = "orange";
                    }
                    catch (e) {

                    }
                }
            }
            SaveData();
        });


        var request2;
        request2 = $.ajax({
            url: "../../Handlers/MainHandler.ashx?MethodName=MPLayout_Tasks_GetTsakPopulationParentsJSON&TaskID=" + $('#<%=ctlPopulationsR.hdnTskID_ID %>').val()
                 + "&Tiks=<%= DateTime.Now.Ticks.ToString()%>",
            type: "get",
            data: ''
        });
        request2.done(function (response, textStatus, jqXHR) {
            //cbItem.ID = "cb_" + dt.Rows[t]["value"].ToString() + "_" + dtAgentsPops.Rows[i]["PopulationTypeID"].ToString() + "*" + dtAgentsPops.Rows[i]["PopulationID"].ToString(); 
            //alert(response);
            // debugger;
            for (var i = 0; i < response.length; i++) {
                if (document.getElementById('ctlPopulationsR_cb_' + response[i].ParentPopulation))
                    document.getElementById('ctlPopulationsR_cb_' + response[i].ParentPopulation).checked = true;
            }

           

            $('#tabAgents').tree('collapseAll');
            $('#tabCustomers').tree('collapseAll');
            $('#tabItems').tree('collapseAll');
            $('#tabCategories').tree('collapseAll');
        });

        request2.fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 200) {
            }
            else {
                alert("אראה שגיאה בשליפת הנתונים");
                //alert("Error");
            }
        });
    }
        OnLoadMain();
    </script>
</body>
</html>
