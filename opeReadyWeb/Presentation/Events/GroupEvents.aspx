<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="GroupEvents.aspx.cs" Inherits="PQ.Admin.Presentation.Events.GroupEvents"
    ValidateRequest="false" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EmployeeSearchWS.asmx" />
            <asp:ServiceReference Path="~/WebService/EventRecords.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.hotkeys.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/employee.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/GroupEvents/groupEvents.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.xslt.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div id="tabGroupEvents" class="jquery_tab_title">
            <ul>
                <li><a href="#divEventsRecords">
                    <asp:Label runat="server" ID="Label4" Text="<%$ Resources:Employee, headerEventsRecord %>" />
                </a></li>
                <li><a href="#divAdminTask">
                    <asp:Label runat="server" ID="Label5" Text="<%$ Resources:Employee, headerAdminTask %>" />
                </a></li>
            </ul>
            <%--<h2 class="jquery_tab_title">
                <asp:Label runat="server" ID="lblHeaderGeneralInfo" Text="<%$ Resources:Employee, headerGroupEvent %>" /></h2>--%>
            <div id="divEventsRecords" class="jquery_tab">
                <div class="content_block">
                    <div class="emplSearch">
                        <fieldset style="max-width: 800px">
                            <legend id="lgdGeneralInfo">
                                <asp:Label runat="server" ID="headerGeneralInfo" Text="<%$ Resources:Employee, headerGeneralInfo %>" /></legend>
                            <div id="divGeneralInfo" class="emplSearch">
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="lblEventDate" Text="<%$ Resources:Employee, lblEventDate %>" /></label>
                                            <input class="input-medium PQ_datepicker_input" type="text" id="txtGroupEventDate"
                                                runat="server" clientidmode="Static" onkeypress="event.keyCode = 0;" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="lblEventType" Text="<%$ Resources:Employee, lblEventType %>" /></label>
                                            <asp:DropDownList ID="ddlTrainingEventType" ClientIDMode="Static" runat="server"
                                                CssClass="select" DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper" id="divEmployeeEvaluationTotal">
                                        <fieldset>
                                            <legend>
                                                <asp:Label runat="server" ID="lblEventSubjects" Text="<%$ Resources:Employee, lblEventSubjects %>" /></legend>
                                            <div class="div_wrapper">
                                                <div class="wrapMessages" id="divEmployeeEvaluation">
                                                </div>
                                                <input type="button" style="margin-top: 5px;" class="button" runat="server" value="<%$ Resources:Employee, btnAddSubject %>"
                                                    onclick="divAddEventSubject_Open();" />
                                            </div>
                                        </fieldset>
                                    </div>
                                    <div class="div_wrapper" id="divTaskAttachment">
                                        <fieldset>
                                            <legend>
                                                <asp:Label runat="server" ID="Label15" Text="<%$ Resources:Employee, lblTaskAttachment %>" /></legend>
                                            <div class="div_wrapper">
                                                <label class="inline">
                                                    <asp:Label runat="server" ID="lblAttachedFileName" ClientIDMode="Static" /></label>
                                            </div>
                                            <div class="div_wrapper">
                                                <input id="btmAddTaskAttachment" type="button" style="margin-top: 5px;" class="button"
                                                    clientidmode="Static" runat="server" value="<%$ Resources:Employee, btnAddTaskAttachment %>" />
                                            </div>
                                        </fieldset>
                                    </div>
                                </div>
                                <div class="emplSearch">
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblRemarks" Text="<%$ Resources:Employee, lblPersonEmploymentHistoryRemarks %>" /></label>
                                    <asp:TextBox TextMode="MultiLine" ID="editRemarks" ClientIDMode="Static" runat="server"
                                        Width="770" Height="80px"></asp:TextBox>
                                </div>
                                <div class="emplSearch">
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label7" Text="<%$ Resources:Employee, lblPersonEmploymentHistory_ManagerName %>" /></label>
                                    <asp:TextBox ID="txtManagerName" CssClass="input-medium" ClientIDMode="Static" runat="server"
                                        Width="770"></asp:TextBox>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                    <div class="emplSearch">
                        <fieldset>
                            <legend>
                                <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Employee, lblEmployeeEvaluation %>" /></legend>
                            <div class="div_wrapper">
                                <table cellpadding="0" cellspacing="0" id="tblEmlpoymentEvaluation">
                                </table>
                                <div id="pgrEmlpoymentEvaluation">
                                </div>
                            </div>
                        </fieldset>
                        <div class="div_wrapper">
                            <p>
                                <input id="btnSaveGroupEvent" type="button" clientidmode="Static" class="button"
                                    runat="server" value="<%$ Resources:Employee, GroupEvent_btnSaveGroupEvent %>"
                                    onclick="btnSaveGroupEvent_Click();" />
                            </p>
                        </div>
                    </div>
                </div>
                <%--List of employee--%>
                <div id="divEmployeeForEvent" style="display: none">
                    <div>
                        <h2 id="h2Empl">
                            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:Employee, lblEventRecords_EmployeeSearch %>" /></h2>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblFirstName" Text="<%$ Resources:Employee, lblEventRecords_FirstName %>" /></label>
                                    <input class="input-medium" clientidmode="Static" type="text" id="txtFirstName" runat="server" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblLastName" Text="<%$ Resources:Employee, lblEventRecords_LastName %>" /></label>
                                    <input class="input-medium" type="text" clientidmode="Static" id="txtLastName" runat="server" />
                                </p>
                            </div>
                            <div class="div_wrapper treeUnitsEdit">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblUnit" Text="<%$ Resources:Employee, lblUnit %>" /></label>
                                    <div>
                                        <asp:TextBox CssClass="combobox-big" ID="ddlUnit" runat="server" ClientIDMode="Static"
                                            onclick="OnClientPopup_Click(treeUnits);" validate="required:true" />
                                        <div id="treeUnits">
                                        </div>
                                    </div>
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="lblJob" Text="<%$ Resources:Employee, lblJob %>" /></label>
                                    <asp:DropDownList ID="ddlJob" AppendDataBoundItems="true" CssClass="select-hyper"
                                        Width="200px" ClientIDMode="Static" runat="server" DataTextField="Job_Name" DataValueField="Job_ID">
                                        <asp:ListItem Value="0" Text="<%$ Resources:Employee, GroupEvent_grtSelectJobs %>"></asp:ListItem>
                                    </asp:DropDownList>
                                </p>
                            </div>
                            <div class="div_wrapper" style="margin-top: 23px">
                                <p>
                                    <input type="button" class="button" id="btnSearch" runat="server" value="<%$ Resources:Employee, btnSearch %>"
                                        onclick="OpenEmployeeList()" />
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch" id="divEmployee2Event" style="height: 450px; overflow: auto">
                            <div class="div_wrapper" id="divEmployee">
                                <table id="tlbEmlpoyee" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="pgrEmployee">
                                </div>
                            </div>
                        </div>
                        <asp:HiddenField ID="hidPersonID" ClientIDMode="Static" runat="server" />
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <input type="button" class="button" id="btnEmployee" onclick="btnEmployeeAdd_Click();"
                                        runat="server" value="<%$ Resources:Employee, btnAdd %>" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <input type="button" class="button" id="btnCancel" runat="server" onclick="$('#divEmployeeForEvent').dialog('close');"
                                        value="<%$ Resources:Employee, btnCloseUpload %>" />
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!---------------  Tab Admin Task ------------------------------------------------------------------>
            <div id="divAdminTask" class="jquery_tab">
                <div class="content_block">
                    <div class="emplSearch">
                        <fieldset style="max-width: 800px">
                            <legend id="Legend1">
                                <asp:Label runat="server" ID="Label6" Text="<%$ Resources:Employee, headerGeneralInfo %>" /></legend>
                            <div id="div1" class="emplSearch">
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="lblFromDateAdminTask" Text="<%$ Resources:Employee, AT_lblFromDate %>" /></label>
                                            <input class="input-medium PQ_datepicker_input" type="text" id="txtAdminTaskDate"
                                                runat="server" clientidmode="Static" onkeypress="event.keyCode = 0;" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" ID="lblSubQualificationType_Names" Text="<%$ Resources:Employee, lblSubQualificationType_Names %>" /></label>
                                            <asp:DropDownList ID="ddlAdminTaskTrainingEventType" ClientIDMode="Static" runat="server"
                                                CssClass="select" DataTextField="SubQualificationType_Name" DataValueField="SubQualificationType_ID" />
                                        </p>
                                    </div>
                                </div>
                                <div class="emplSearch">
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label30" Text="<%$ Resources:Employee, AT_lblRemarks %>" /></label>
                                    <asp:TextBox TextMode="MultiLine" ID="txtAdminTaskRemarks" ClientIDMode="Static"
                                        runat="server" Width="770" Height="80px"></asp:TextBox>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                    <div class="emplSearch">
                        <fieldset>
                            <legend>
                                <asp:Label runat="server" ID="Label18" Text="<%$ Resources:Employee, lblEmployeeEvaluation %>" /></legend>
                            <div class="div_wrapper">
                                <table cellpadding="0" cellspacing="0" id="tblAdminTaskEmployee">
                                </table>
                                <div id="Div3">
                                </div>
                            </div>
                        </fieldset>
                        <div class="div_wrapper">
                            <p>
                                <input id="btnSaveAdminTaskGroupEvent" clientidmode="Static" type="button" class="button"
                                    runat="server" value="<%$ Resources:Employee, AdminTask_btnSaveGroupEvent %>" />
                            </p>
                        </div>
                    </div>
                </div>
                <%--List of employee--%>
                <div id="divAdminTaskEmployeeList" style="display: none">
                    <div>
                        <h2 id="h1">
                            <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Employee, lblEventRecords_EmployeeSearch %>" /></h2>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label20" Text="<%$ Resources:Employee, lblEventRecords_FirstName %>" /></label>
                                    <input class="input-medium" clientidmode="Static" type="text" id="txtAT_FirstName"
                                        runat="server" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label21" Text="<%$ Resources:Employee, lblEventRecords_LastName %>" /></label>
                                    <input class="input-medium" type="text" clientidmode="Static" id="txtAT_LastName"
                                        runat="server" />
                                </p>
                            </div>
                            <div class="div_wrapper treeUnitsEdit">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label22" Text="<%$ Resources:Employee, lblUnit %>" /></label>
                                    <span>
                                        <asp:TextBox CssClass="combobox-big" ID="txtAT_Unit" runat="server" ClientIDMode="Static"
                                            onclick="OnClientPopup_Click(treeAT_Units);" validate="required:true" />
                                        <div id="treeAT_Units">
                                        </div>
                                    </span>
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <label class="label">
                                        <asp:Label runat="server" ID="Label23" Text="<%$ Resources:Employee, lblJob %>" /></label>
                                    <asp:DropDownList ID="ddlJobAT" AppendDataBoundItems="true" CssClass="select-hyper"
                                        Width="200px" ClientIDMode="Static" runat="server" DataTextField="Job_Name" DataValueField="Job_ID">
                                        <asp:ListItem Value="0" Text="<%$ Resources:Employee, GroupEvent_grtSelectJobs %>"></asp:ListItem>
                                    </asp:DropDownList>
                                </p>
                            </div>
                            <div class="div_wrapper" style="margin-top: 23px">
                                <p>
                                    <asp:Button CssClass="button" ID="btnAT_SerchEmployee" ClientIDMode="Static" runat="server"
                                        Text="<%$ Resources:Employee, btnSearch %>" />
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch" id="div6" style="height: 450px; overflow: auto">
                            <div class="div_wrapper" id="div7">
                                <table id="tlbEmlpoyeeAdminTaskGrid" cellpadding="0" cellspacing="0">
                                </table>
                                <div id="pgrEmlpoyeeAdminTask">
                                </div>
                            </div>
                        </div>
                        <asp:HiddenField ID="HiddenField1" ClientIDMode="Static" runat="server" />
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <input type="button" clientidmode="Static" class="button" id="btnAT_EmployeeAdd"
                                        runat="server" value="<%$ Resources:Employee, btnAdd %>" />
                                </p>
                            </div>
                            <div class="div_wrapper">
                                <p>
                                    <input type="button" class="button" id="btnATClose" runat="server" onclick="$('#divAdminTaskEmployeeList').dialog('close');"
                                        value="<%$ Resources:Employee, btnCloseUpload %>" />
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--Add Event Subject Area--%>
    <div id="divAddEventSubject" style="display: none;">
        <h2 id="h2">
            <asp:Label ID="lblEventsSubject" runat="server" Text="<%$ Resources:Employee, lblEventSubjects %>" /></h2>
        <div class="emplSearch" style="max-height: 250px;">
            <table id="tblEventSubjects" width="100%" cellpadding="0" cellspacing="0">
            </table>
            <div id="pgrEventSubjects">
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="Button1" onclick="groupEvent.getSelectedIDs();"
                        runat="server" value="<%$ Resources:Employee, btnAdd %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="Button3" runat="server" onclick="$('#divAddEventSubject').dialog('destroy');"
                        value="<%$ Resources:Employee, btnCloseUpload %>" />
                </p>
            </div>
        </div>
    </div>
    <%-- End Add Event Subject Area--%>
    <div id="ConfirmDeleteAttachment" style="display: none">
        <p>
            <label class="label">
                <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Employee, lblConfirmDelete %>" /></label></p>
    </div>
    <div id="divPersonDetails" style="display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Employee, lblEventRecords_EmployeeID %>" /></label>
                    <input class="input-medium" type="text" id="txtEmployeeIDUpd" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label8" Text="<%$ Resources:Employee, lblEventRecords_FirstName %>" /></label>
                    <input class="input-medium" type="text" id="txtFirstNameUpd" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label9" Text="<%$ Resources:Employee, lblEventRecords_LastName %>" /></label>
                    <input class="input-medium" type="text" id="txtLastNameUpd" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label10" Text="<%$ Resources:Employee, lblUnit %>" /></label>
                    <input class="input-medium" type="text" id="txtUnitUpd" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label11" Text="<%$ Resources:Employee, lblJob %>" /></label>
                    <input class="input-medium" type="text" id="txtJobUpd" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper" id="divPerfomanceLevel">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label12" Text="<%$ Resources:Employee, lblPerfomanceLabel %>" /></label>
                    <select class="select" id="ddlPerfomanceLevelUpdate" datatextfield="ExecutionLevel_ORGName"
                        clientidmode="Static" runat="server" datavaluefield="ExecutionLevel_ID">
                    </select>
                </p>
            </div>
            <div class="div_wrapper" id="divTotalScore">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label13" Text="<%$ Resources:Employee, lblEventScore %>" /></label>
                    <input class="input-medium" type="text" id="txtEventScoreUpd" />
                </p>
            </div>
            <div class="div_wrapper" id="divQuality">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label14" Text="<%$ Resources:Employee, lblQuantity %>" /></label>
                    <input class="input-medium" type="text" id="txtQuantityUpd" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="btnUpdatePerson" onclick="btnUpdatePerson_Click();"
                        runat="server" value="<%$ Resources:Employee, btnUpdate %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="Button4" runat="server" onclick="$('#divPersonDetails').dialog('destroy');"
                        value="<%$ Resources:Employee, btnCloseUpload %>" />
                </p>
            </div>
        </div>
    </div>
    
    <div id="waitplease">
        <img src="<%= this.ResolveClientUrl("~/Resources/images/waitPlease.gif") %>" alt="" />
        <asp:Label ID="lblWaitPls" Style="vertical-align: super;" runat="server" Text="<%$ Resources:Employee, lblWaitPls %>"></asp:Label>
    </div>
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEmployeeID" Text="<%$ Resources:Employee, lblEventRecords_EmployeeID %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidFirstName" Text="<%$ Resources:Employee, lblEventRecords_FirstName %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidLastName" Text="<%$ Resources:Employee, lblEventRecords_LastName %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidJob" Text="<%$ Resources:Employee, lblJob %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidUnit" Text="<%$ Resources:Employee, lblUnit %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidReadinessLabel" Text="<%$ Resources:Employee, lblPerfomanceLabel %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventScore" Text="<%$ Resources:Employee, lblEventScore %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidQuantity" Text="<%$ Resources:Employee, lblQuantity %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventRecordsDelete" Text="<%$ Resources:Employee, lblEventRecords_btnDelete %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEventType" Text="<%$ Resources:Employee, lblEventType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidRemarks" Text="<%$ Resources:Employee, lblPersonEmploymentHistoryRemarks %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupEvent_grtSelectJobs"
            Text="<%$ Resources:Employee, GroupEvent_grtSelectJobs %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupEvent_btnAddEmployee"
            Text="<%$ Resources:Employee, GroupEvent_btnAddEmployee %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupEvent_GrtPerfomanceLabel"
            Text="<%$ Resources:Employee, GroupEvent_GrtPerfomanceLabel %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidSaveSuccessMessage" Text="<%$ Resources:Employee, GroupEvent_SaveSuccessMessage %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidNoPersonInEvent" Text="<%$ Resources:Employee, GroupEvent_NoPersonInEvent %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
    </div>
    <asp:HiddenField ID="xmlTreeDoc" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidEventTypeID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidATUnitID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript" language="javascript">
        var dateFormats;
        var optionsArray = null;
        var optionReadiness = null;
        var upload;

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
            $("#waitplease").css({ 'display': 'block' });
        });
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
            $("#waitplease").css({ 'display': 'none' });
            if (args.get_error()) {
                args.set_errorHandled(true);
            };
        });

        $(document).ready(function () {
            $("#tabGroupEvents").tabs({
                selected: 0,
                select: function (event, ui) {
                    var selected = ui.tab.hash;
                    if (selected) {
                        switch (selected) {
                            case "#divAdminTask":
                                $("#tblAdminTaskEmployee").GridUnload();
                                groupEvent.AdminTaskEmployeesGrid(null, 0);
                                break;
                        }
                        $('#hidUnitID,#hidATUnitID,#ddlUnit,#txtAT_Unit').val("");
                    }
                }

            });
            var param = getArgs();

            groupEvent.EmlpoymentEvaluationsGrid(null, 0);
            groupEvent.GetPerfomanceLevelArray();


            //            $("#btmAddTaskAttachment").live("click", function () {
            //                if (RequaredPersonAttachFields()) {
            //                    upload.setData({ "PersonAttachName": $("#txtPersonAttachName").val() });
            //                    upload.submit();
            //                }
            //            });

            $('#lgdGeneralInfo').click(function () {
                $('#divGeneralInfo').toggle('slow');
            });
            deleteEventSubjects(".closeable");
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }
            $(".PQ_datepicker, .PQ_datepicker_input").datepicker({
                dateFormat: dateFormats, changeYear: true, changeMonth: true,
                beforeShow: function (i, e) {
                    var z = jQuery(i).closest(".ui-dialog").css("z-index") + 15;
                    e.dpDiv.css('z-index', (isNaN(z) ? 1 : z));
                }
            });
            if ($.cookie("lang")) $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else $.datepicker.setDefaults($.datepicker.regional['']);

            groupEvent.SetFirstNameArray();
            groupEvent.SetLastNameArray();
        });


        $(document).ready(function () {
            var button = $('#btmAddTaskAttachment');
            var param = getArgs();           
            upload = new AjaxUpload(button, {
                action: '<%=ResolveUrl("~/Handlers/TaskAttachUpload.ashx") %>',
                name: 'myfile',
                autoSubmit: false,
                onChange: function (file, ext) {
                    if (!checkNotAllowedFileExtension(null, ext)) {
                        $("#btnEventAttachmentUpload").attr("disabled", true);
                    }
                    else { $("#btnEventAttachmentUpload").removeAttr("disabled", 100); }
                    $("#lblAttachedFileName").block({
                        css: { border: '0px' },
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                    setTimeout(function () { $("#lblAttachedFileName").unblock().text(file); }, 500);
                },
                onSubmit: function () {
                    $("#waitplease").css({ 'display': 'block' });
                    this.disable();
                },
                onComplete: function () {
                    this.enable();
                    $("#waitplease").css({ 'display': 'none' });
                }
            });
            return false;
        });

        function btnClosePopUp_Click() {
            $('#txtPersonAttachName').val("");
            if ($('#txtPersonAttachName').hasClass("ui-state-error"))
                $('#txtPersonAttachName').removeClass('ui-state-error', 500);
            $('#divGroupEventAttachment').dialog('destroy');
        }



        function UploadComplete(sender, args) {
            //            $("#tlbPersonAttachments").GridUnload();
            //            attachment.CreateAttachmentGrid();
            //            $("#waitplease").css({ 'display': 'none' });
            //            $('#txtPersonAttachName').val("");
            //            $('#divFileUpload').dialog('destroy');
        }
        function StartUpload(sender, args) {
            //            $("#waitplease").css({ 'display': 'block' });
            //            $('#btnUploadFile').attr("disabled", true);
            return false;
        }

        $("#btnSaveAdminTaskGroupEvent").live("click", function () {
            var mydata = $("#tblAdminTaskEmployee").jqGrid('getGridParam', 'data');
            groupEvent.AdminTaskEmploeeGroup_Save(mydata);
        });

        $("#btnAT_EmployeeAdd").live("click", function () {
            groupEvent.AdminTaskSelectedEmployeeIDs();
        });

        $("#ddlTrainingEventType").change(function () {
            if ($("#ddlTrainingEventType").val() != "0") $("#ddlTrainingEventType").removeClass('ui-state-error', 100);
            //$(divEmployeeEvaluation).empty();
            $('.click_to_close').click();
            PQ.Admin.WebService.EventRecords.TrainingEventType_SelectRequiredField($(this).val(),
                function (result) {
                    if (!isNaN(result)) {
                        $("#hidEventTypeID").val(result);
                        $("#tblEmlpoymentEvaluation").GridUnload();
                        groupEvent.EmlpoymentEvaluationsGrid(null, result);
                        $("#ddlTrainingEventType").removeClass('ui-state-error', 100);
                    }
                },
                function (e) {
                    $("#waitplease").css({ 'display': 'none' });
                    return false;
                });

        });

        $('#txtGroupEventDate').change(function () {
            if ($(this).val() != "") $(this).removeClass('ui-state-error', 100);
        });

        function divEmployeeForEvent_Open() {
            $("#divEmployeeForEvent").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, width: '1024px', modal: true, zIndex: 50,
                open: function (event, ui) {
                    $(this).parent().appendTo("form");
                }
            });
        };

        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits,#treeAT_Units").hide();
        });


        function divAddEventSubject_Open() {

            $("#divAddEventSubject").dialog({ autoOpen: true, bgiframe: true, resizable: true, closeOnEscape: true, position: ['center', 200], width: '430px', modal: true, zIndex: 50,
                title: $('h2 span[id*=lblEventsSubject]').text(),
                open: function (event, ui) {
                    $(this).block({
                        css: { border: '0px' },
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                    $(this).parent().appendTo("form");
                    $('#tblEventSubjects').GridUnload();
                    groupEvent.AddEventSubjectsGrid($('#ddlTrainingEventType').val());
                }
            });
            return false;
        };

        function divPersonDetails_Open() {
            $("#divPersonDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, position: 'center', width: '600px', modal: true, zIndex: 50,
                open: function (event, ui) {
                    $(this).parent().appendTo("form");
                }
            });
            return false;
        };

        function SetDeleteEventSubjects() {
            deleteEventSubjects(".closeable");
            $('#divAddEventSubject').dialog('destroy');
        }



        function AddEmployeeForEvent() {
            $('#divEmployeeForEvent input:text').each(function () {
                $(this).val('');
            });
            $('#hidUnitID').val('');
            $("#ddlJob>option").remove();
            $("#ddlJob").append($("<option></option>").val(0).html($("#hidGroupEvent_grtSelectJobs").text()));
            $("#tlbEmlpoyee").GridUnload();
            divEmployeeForEvent_Open();
        }

        function OnClientPopup_Click(sender) {
            $('#' + sender.id).toggle(100);
            try {
                groupEvent.CreateUnitTree(null, sender);
            } catch (e) {
                return false;
            }
            return false;
        };

        function OpenEmployeeList() {
            $("#waitplease").css({ 'display': 'block' });
            var _person = {
                Person_FirstName: $('#txtFirstName').val(),
                Person_LastName: $('#txtLastName').val(),
                Job_ID: $('#ddlJob').val(),
                UnitID: $('#hidUnitID').val(),
                IsActive: true,
                IsReadiness: true
            };
            $("#tlbEmlpoyee").GridUnload();
            groupEvent.GetEmlpoyeeGrid(_person, $("#hidEventTypeID").val());
        };

        function btnEmployeeAdd_Click() {
            groupEvent.getSelectedEmployeeIDs();
        }


        function btnSaveGroupEvent_Click() {
            if (groupEvent.RequaredFields()) {
                $("#waitplease").css({ 'display': 'block' });
                var eventSubjects = new Array();
                $($("#divEmployeeEvaluation").find('.message')).each(function () {
                    eventSubjects.push($(this).attr("tecat"));
                });
                var mydata = $("#tblEmlpoymentEvaluation").jqGrid('getGridParam', 'data');
                groupEvent.TrainingEventGroup_Save(eventSubjects, mydata, upload);
              
            }
        };

        function btnUpdatePerson_Click() {
            $("#waitplease").css({ 'display': 'block' });
            var personData = {
                Person_ID: $('#txtEmployeeIDUpd').val(),
                ExecutionLevel_ID: $('#ddlPerfomanceLevelUpdate').val(),
                TrainingEvent2Person_Quantity: $('#txtQuantityUpd').val(),
                TrainingEvent2Person_Score: $('#txtEventScoreUpd').val(),
                Person_FirstName: $('#txtFirstNameUpd').val(),
                Person_LastName: $('#txtLastNameUpd').val(),
                Unit_Name: $('#txtUnitUpd').val(),
                Job_Name: $('#txtJobUpd').val(),
                ExecutionLevel_ORGName: $('#ddlPerfomanceLevelUpdate option:selected').text()
            };
            PQ.Admin.WebService.EventRecords.TrainingGroupEvent2Person_Update(personData,
            function (data) {
                $("#tblEmlpoymentEvaluation").GridUnload();
                groupEvent.EmlpoymentEvaluationsGrid(data, $("#hidEventTypeID").val());
                $('#divPersonDetails').dialog('destroy');
            },
            function (e) { return false; });
        }

       
    </script>
</asp:Content>
