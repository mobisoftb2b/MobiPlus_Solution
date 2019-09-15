<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    EnableEventValidation="false" ValidateRequest="false" CodeBehind="Reports.aspx.cs"
    Inherits="PQ.Admin.Reports.Reports" %>

<%@ OutputCache NoStore="true" VaryByParam="none" Duration="1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/ReportsWebService.asmx" />
            <asp:ServiceReference Path="~/WebService/EventRecords.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.common.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Reports/reports.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div id="divMainScreen">
            <h2 class="jquery_tab_title">
                <asp:Label runat="server" ID="lblHeaderGeneralInfo" Text="<%$ Resources:Reports, headerReportParameters %>" /></h2>
            <div id="divParameterPanel">
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblReportGroup" Text="<%$ Resources:Reports, ReportsParam_lblReportGroup %>" /></label>
                            <select id="ddlReportGroup" class="select-hyper" tabindex="1" runat="server" clientidmode="Static"
                                datatextfield="ReportMainCategories_ORGName" datavaluefield="ReportMainCategories_ID">
                            </select>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblReportName" TabIndex="2" Text="<%$ Resources:Reports, ReportsParam_lblReportName %>" /></label>
                            <asp:DropDownList ID="ddlReportName" CssClass="select-hyper" runat="server" ClientIDMode="Static">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Reports, ReportsParam_lblReportDescription %>" /></label>
                            <input type="text" tabindex="3" runat="server" readonly="readonly" class="input-big inputContent"
                                id="txtReportDesc" clientidmode="Static" />
                        </p>
                    </div>
                </div>
            </div>
            <div class="emplSearch mainContent" id="divMainContent">
                <%--Date Area--%>
                <div class="emplSearch noDisplay" id="divDateArea">
                    <div class="div_wrapper noDisplay" id="divDateFrom">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Reports, ReportsParam_lblDateFrom %>" /></label>
                            <input type="text" runat="server" class="input-medium PQ_datepicker_input inputContent"
                                style="width: 250px" id="txtDateFrom" clientidmode="Static" />
                        </p>
                    </div>
                    <div class="div_wrapper noDisplay" id="divDateTo">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Reports, ReportsParam_lblDateTo %>" /></label>
                            <input type="text" runat="server" class="input-medium PQ_datepicker_input inputContent"
                                style="width: 250px" id="txtDateTo" clientidmode="Static" />
                        </p>
                    </div>
                </div>
                <%--Unit & Job Area--%>
                <div class="emplSearch noDisplay" id="divUnitJobArea">
                    <div class="div_wrapper noDisplay treeUnitsEdit" id="divUnitArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label4" Text="<%$ Resources:Reports, ReportsParam_lblUnit %>" /></label>
                            <input class="combobox-big" type="text" id="ddlUnit" runat="server" clientidmode="Static"
                                onclick="OnClientPopup_Click();" />
                            <div id="treeUnits">
                            </div>
                        </p>
                    </div>
                    <div class="div_wrapper noDisplay" id="divJobArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label5" Text="<%$ Resources:Reports, ReportsParam_lblJob %>" /></label>
                            <asp:DropDownList ID="ddlJobs" class="select-hyper ddlContent" runat="server" ClientIDMode="Static">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <%--Event type & event subject area--%>
                <div class="emplSearch noDisplay" id="divEventTypeArea">
                    <div class="div_wrapper noDisplay" id="divTrainingEventTypeArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label6" Text="<%$ Resources:Reports, ReportsParam_lblEventType %>" /></label>
                            <asp:DropDownList ID="ddlTrainingEventType" CssClass="select-hyper ddlContent" runat="server"
                                ClientIDMode="Static" DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID">
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper noDisplay" id="divEventCategoryArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label7" Text="<%$ Resources:Reports, ReportsParam_lblEventCategory %>" /></label>
                            <asp:DropDownList ID="ddlEventCategory" CssClass="select-hyper ddlContent" runat="server"
                                ClientIDMode="Static" DataTextField="TrainingEventCategory_Name" DataValueField="TrainingEventCategory_ID">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <%--Administrative task & Readiness level--%>
                <div class="emplSearch">
                    <div class="div_wrapper noDisplay" id="divSubjectEvaluationArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label8" Text="<%$ Resources:Reports, ReportsParam_lblSubjectEvaluation %>" /></label>
                            <asp:DropDownList ID="ddlSubQualification" CssClass="select-hyper ddlContent" runat="server"
                                ClientIDMode="Static" DataTextField="ReportMainCategories_ORGName" DataValueField="ReportMainCategories_ID">
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper noDisplay" id="divReadinessLevelArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label9" TabIndex="2" Text="<%$ Resources:Reports, ReportsParam_lblReadinessLevel %>" /></label>
                            <asp:DropDownList ID="ddlReadinessLevel" class="select-hyper ddlContent" runat="server"
                                ClientIDMode="Static" DataTextField="ORGName" DataValueField="ReadinessLevelID">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <%--Employee status & Employee name area--%>
                <div class="emplSearch">
                    <div class="div_wrapper noDisplay" id="divEmploymentStatusArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label10" Text="<%$ Resources:Reports, ReportsParam_lblEmploymentStatus %>" /></label>
                            <asp:DropDownList ID="ddlEmploymentHistory" CssClass="select-hyper ddlContent" runat="server"
                                ClientIDMode="Static">
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper noDisplay" id="divEmployerNameArea">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label11" TabIndex="2" Text="<%$ Resources:Reports, ReportsParam_lblEmployerName %>" /></label>
                            <asp:DropDownList ID="dllEmployerName" class="select-hyper ddlContent" runat="server"
                                ClientIDMode="Static" DataValueField="PersonCategory_ID" DataTextField="PersonCategory_Name">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper noDisplay" id="divJobStatus">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label12" Text="<%$ Resources:Reports, ReportsParam_lblJobStatus %>" /></label>
                            <asp:DropDownList ID="ddlJobStatus" class="select-hyper ddlContent" runat="server"
                                ClientIDMode="Static">
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper noDisplay" id="divEmployeeNumber">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label13" Text="<%$ Resources:Reports, ReportsParam_lblEmployeeNumber %>" /></label>
                            <asp:TextBox runat="server" ID="txtEmployeeNumber" CssClass="input-medium inputContent"
                                Style="width: 250px" ClientIDMode="Static"></asp:TextBox>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <asp:Button CssClass="button" ID="btnGenerateReport" runat="server" Text="<%$ Resources:Reports, ReportsParam_btnGenerateReport %>"
                                ClientIDMode="Static" OnClientClick="return RequaredFieldCheck();" OnClick="btnGenerateReport_Click" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="button" class="button" id="btnClearance" runat="server" value="<%$ Resources:Reports, ReportsParam_btnClearance %>"
                                clientidmode="Static" onclick="ClearAllFields();" />
                        </p>
                    </div>
                    <div class="div_wrapper" style="display: none" id="divSimfoxGear">
                        <p>
                            <asp:Button CssClass="button" ID="btnSimfoxGear" runat="server" Text="<%$ Resources:Reports, ReportsParam_btnSimfoxGear %>"
                                ClientIDMode="Static" OnClientClick="return btnSimfoxGear_ClientClick();" onclick="btnSimfoxGear_Click" />
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="emplSearch" id="divReportViewer" style="direction: ltr;">
        <asp:UpdatePanel ID="updShowReport" runat="server">
            <ContentTemplate>
                <rsweb:ReportViewer ID="ReportViewer1" runat="server" ShowToolBar="true" Width="100%"
                    Height="100%">
                    <LocalReport EnableExternalImages="True" EnableHyperlinks="True">
                    </LocalReport>
                </rsweb:ReportViewer>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnGenerateReport" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <div style="display: none">
        <asp:Label ID="hidReportName_Greeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:Reports, ddlReportName_Greeting %>" />
        <asp:Label ID="hidReportName_grtSelectJobs" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Reports, ReportsParam_grtSelectJobs %>" />
        <asp:Label ID="hidGrtTrainingEventType" ClientIDMode="Static" runat="server" Text="<%$ Resources:Reports, hidReportsParam_GrtTrainingEventType %>" />
        <asp:Label ID="hidGrtTrainingEventCategory" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Reports, ReportsParam_GrtTrainingEventCategory %>" />
        <asp:Label ID="hidGrtSubQualificationType" ClientIDMode="Static" runat="server" Text="<%$ Resources:Reports, ReportsParam_GrtSubQualificationType %>" />
        <asp:Label ID="hidGrtEmploymentHistory" ClientIDMode="Static" runat="server" Text="<%$ Resources:Reports, ReportsParam_GrtEmploymentHistory %>" />
        <asp:Label ID="hidJobStatus_Greeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:Reports, ddlJobStatus_Greeting %>" />
        <asp:Label ID="hidUnit_Greeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:Reports, ReportsParam_ddlUnit_Greeting %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
    </div>
    <div id="divHiddenFields">
        <asp:HiddenField ID="hidUnitID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidReport_ID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidReport_Name" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidReportURL" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidJobsDDL" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidJobsID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidTrainingEventType" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidTrainingEventTypeID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidEventCategory" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidEventCategoryID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidSubQualification" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidSubQualificationID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidEmploymentHistory" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidEmploymentHistoryID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidJobStatus" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidJobStatusID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidEmployerName" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidReadinessLevel" runat="server" ClientIDMode="Static" />
    </div>
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
            $("#waitplease").css({ 'display': 'block' });
        });
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
            if (args.get_error()) {
                args.set_errorHandled(true);
            };
            $("#waitplease").css({ 'display': 'none' });
        });
        var reportObj, dateFormats;
        $(document).ready(function (e) {
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }
            $('#txtDateFrom, #txtDateTo').datepicker({
                beforeShow: customRange,
                firstDay: 1,
                changeFirstDay: false,
                changeYear: true,
                changeMonth: true,
                dateFormat: dateFormats
            });

            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);
            report.PopulationReportNameDropDown({ Report_ID: 0, Report_ORGName: $('#hidReportName_Greeting').text() });

        });

        function customRange(input) {
            if (input.id == 'txtDateTo') {
                return {
                    minDate: $('#txtDateFrom').datepicker("getDate")
                };
            } else if (input.id == 'txtDateFrom') {
                return {
                    maxDate: $('#txtDateTo').datepicker("getDate")
                };
            }
        }

        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });
        $("#txtDateFrom").change(function () {
            if ($(this).val().trim() != "") {
                $(this).removeClass('ui-state-error', 100);
            }
            return false;
        });
        $("#txtDateTo").change(function () {
            if ($(this).val().trim() != "") {
                $(this).removeClass('ui-state-error', 100);
            }
            return false;
        });
        $("#txtEmployeeNumber").change(function () {
            if ($(this).val().trim() != "") {
                $(this).removeClass('ui-state-error', 100);
            }
            return false;
        });
        $("#ddlEventCategory").change(function () {
            if ($(this).val() != "0") {
                $("#hidEventCategory").val($("#ddlEventCategory option:selected").text());
                $("#hidEventCategoryID").val($("#ddlEventCategory").val());
                $(this).removeClass('ui-state-error', 100);
            }
            else {
                $("#hidEventCategory").val(''); $("#hidEventCategoryID").val('');
            }
        });
        $("#ddlJobs").change(function () {
            if ($(this).val() != "0") {
                $("#hidJobsDDL").val($("#ddlJobs option:selected").text());
                $("#hidJobsID").val($("#ddlJobs").val());
                $(this).removeClass('ui-state-error', 100);
            }
            else {
                $("#hidJobsDDL").val('');
                $("#hidJobsID").val('');
            }
        });

        $("#ddlTrainingEventType").change(function () {
            $("#ddlEventCategory").addClass("ui-autocomplete-ddl-loading");
            report.PopulateTrainingEventCategoryCombo($(this).val());
            if ($(this).val() != "0") {
                $("#hidTrainingEventType").val($("#ddlTrainingEventType option:selected").text());
                $("#hidTrainingEventTypeID").val($("#ddlTrainingEventType").val());
                $(this).removeClass('ui-state-error', 100);
                $("#hidEventCategoryID,#hidEventCategory").val('');
            }
            else {
                $("#hidTrainingEventType").val('');
                $("#hidTrainingEventTypeID").val('');
            }
        });

        $("#ddlReportGroup").change(function (i) {
            $(this).removeClass('ui-state-error', 100);
            $("#ddlReportName").addClass("ui-autocomplete-ddl-loading");
            ClearFields();
            PQ.Admin.WebService.ReportsWebService.GetReportsDataList($(this).val(), $("#hidReportName_Greeting").text(),
            function (data) {
                report.PopulationReportNameDropDown(data);
            },
            function (e) { });
        });
        $("#ddlSubQualification").change(function () {
            if ($(this).val() != "0") {
                $("#hidSubQualificationID").val($("#ddlSubQualification").val());
                $("#hidSubQualification").val($("#ddlSubQualification option:selected").text());
                $(this).removeClass('ui-state-error', 100);
            }
            else {
                $("#hidSubQualification").val('');
                $("#hidSubQualificationID").val('');
            }
        });
        $("#ddlEmploymentHistory").change(function () {
            if ($(this).val() != "0") {
                $("#hidEmploymentHistory").val($("#ddlEmploymentHistory option:selected").text());
                $("#hidEmploymentHistoryID").val($("#ddlEmploymentHistory").val());
                $(this).removeClass('ui-state-error', 100);
            }
            else {
                $("#hidEmploymentHistory").val('');
                $("#hidEmploymentHistoryID").val('');
            }
        });
        $("#ddlJobStatus").change(function () {
            if ($(this).val() != "0") {
                $("#hidJobStatusID").val($("#ddlJobStatus").val());
                $("#hidJobStatus").val($("#ddlJobStatus option:selected").text());
                $(this).removeClass('ui-state-error', 100);
            }
            else {
                $("#hidJobStatus").val('');
                $("#hidJobStatusID").val('');
            }
        });
        $("#dllEmployerName").change(function () {
            if ($(this).val() != "0") {
                $("#hidEmployerName").val($("#dllEmployerName option:selected").text());
                $(this).removeClass('ui-state-error', 100);
            }
            else
                $("#hidEmployerName").val('');
        });
        $("#ddlReadinessLevel").change(function () {
            if ($(this).val() != "0") {
                $("#hidReadinessLevel").val($("#ddlReadinessLevel option:selected").text());
                $(this).removeClass('ui-state-error', 100);
            }
            else
                $("#hidReadinessLevel").val('');
        });

        $("#ddlReportName").change(function () {
            $("#waitplease").css({ 'display': 'block' });
            $("#txtReportDesc").addClass("ui-autocomplete-ddl-loading");
            ClearFields();
            $("#hidReport_Name").val($("#ddlReportName option:selected").text());
            report.GetReportDesc($(this).val());
            $(this).removeClass('ui-state-error', 100);
            if ($(this).val() == "510") {
                $("#divSimfoxGear").show("slow");
            } else {
                $("#divSimfoxGear").hide("slow");
            }
        });

        function OnClientPopup_Click() {
            if ($('#treeUnits').is(':visible')) {
                $('#treeUnits').fadeOut('slide');
            }
            else {
                $('#treeUnits').fadeIn('slide');
                report.CreateUnitTree();
            }
            return false;
        };

        function RequaredFieldCheck() {
            var result = new Boolean(true);
            if ($("#ddlReportGroup").val() == "0") {
                $("#ddlReportGroup").addClass('ui-state-error');
                return false;
            }
            else {
                $("#ddlReportGroup").removeClass('ui-state-error', 100);
                result = true;
            }
            if ($("#ddlReportName").val() == "0") {
                $("#ddlReportName").addClass('ui-state-error');
                return false;
            }
            else {
                $("#ddlReportName").removeClass('ui-state-error', 100);
                result = true;
            }
            $("#divMainContent").each(function () {
                if ($(this).find("select").hasClass("ui-state-error")) {
                    result = false;
                    return false;
                }
                if ($(this).find("input:text").hasClass("ui-state-error")) {
                    result = false;
                    return false;
                }
            })
            return result;
        }

        function OpenReportViewerPopup() {
            $("#divReportViewer").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, width: '830px', height: 700, modal: true, zIndex: 50,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                    $(this).block({
                        css: { border: '0px' },
                        timeout: 100,
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                }
            });
            return false;
        }

        function ClearAllFields() {
            ClearFields();
            report.HideAll();
            report.PopulationReportNameDropDown({ Report_ID: 0, Report_ORGName: $('#hidReportName_Greeting').text() });
            $("#ddlReportGroup, #ddlReportName").val("0");
        }

        function ClearFields() {
            $(".ddlContent").each(function () {
                $(this).val('0');
            });
            $(".inputContent").each(function () {
                $(this).val('');
            });
            $(this).find("input:hidden").val('');
            $("#ddlUnit").val($("#hidUnit_Greeting").text()).removeClass("ui-state-error");
            $("#divHiddenFields").each(function () {
                $(this).find(":hidden").val('');
            });
        }

        function btnSimfoxGear_ClientClick () {
            if ($("#txtDateFrom").val() == "") {
                $("#txtDateFrom").addClass("ui-state-error");
                return false;
            }
            if ($("#txtDateFrom").val() == "") {
                $("#txtDateTo").addClass("ui-state-error");
                return false;
            }
            return true;
        };


    

    </script>
</asp:Content>
