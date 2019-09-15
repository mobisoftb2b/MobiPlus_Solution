<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    EnableEventValidation="false" EnableViewState="false" CodeBehind="PerfomanceAnalysis.aspx.cs"
    Inherits="PQ.Admin.Presentation.Readiness.PerfomanceAnalysis" %>

<%@ OutputCache NoStore="true" VaryByParam="none" Duration="1" Location="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AlertSettingService.asmx" />
            <asp:ServiceReference Path="~/WebService/EventRecords.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/perfomanceAnalisys.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div>
            <h2 class="jquery_tab_title">
                <asp:Label runat="server" ID="lblHeaderGeneralInfo" Text="<%$ Resources:Readiness, headerPerformanceAnalysis %>" /></h2>
            <div class="emplSearch">
                <fieldset>
                    <legend></legend>
                    <div class="emplSearch">
                        <div class="div_wrapper treeUnitsEdit">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Employee, lblUnit %>" /></label>
                                <span>
                                    <input class="combobox-big" type="text" id="ddlUnit" runat="server" clientidmode="Static"
                                        onclick="OnClientPopup_Click();" />
                                    <div id="treeUnits">
                                    </div>
                                </span>
                            </p>
                        </div>
                        <div class="wrapper" style="margin-top: 4px">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="Label4" Text="<%$ Resources:Employee, lblJob %>" /></label>
                                <asp:DropDownList ID="ddlJobsList" runat="server" DataTextField="Job_Name" CssClass="select-big"
                                    ClientIDMode="Static" DataValueField="Job_ID" onchange="ddlJobsList_OnChange();">
                                </asp:DropDownList>
                            </p>
                        </div>
                        <div class="div_wrapper">
                            <br />
                            <input type="checkbox" id="chkExecTimeIsVisible" />
                            <asp:Label runat="server" ID="Label5" Text="<%$ Resources:Employee, PerfomanceAnalisys_chkExecTimeIsVisible %>" />
                        </div>
                    </div>
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Readiness, grbEventRecordFilter %>" /></label>
                                <asp:DropDownList ID="ddlTrainingEventTypePerfomance" ClientIDMode="Static" runat="server"
                                    ViewStateMode="Enabled" CssClass="select-hyper" DataTextField="TrainingEventType_Name"
                                    DataValueField="TrainingEventType_ID" />
                            </p>
                        </div>
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="lblTrainingEventCategory" Text="<%$ Resources:Readiness, PerfomanceAnalisys_lblTrainingEventCategory %>" /></label>
                                <asp:DropDownList ID="ddlTrainingEventCategory" ClientIDMode="Static" runat="server"
                                    ViewStateMode="Enabled" CssClass="select-big" DataTextField="TrainingEventCategory_Name"
                                    DataValueField="TrainingEventCategory_ID" />
                            </p>
                        </div>
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Readiness, PerfomanceAnalisys_lblSubEvaluation %>" /></label>
                                <asp:DropDownList ID="ddlSubEvaluationType" ClientIDMode="Static" runat="server"
                                    ViewStateMode="Enabled" CssClass="select-big" DataTextField="SubEvaluationType_Name"
                                    DataValueField="SubEvaluationType_ID" />
                                <input type="button" id="btnTrainingEventTypeFilterPerfomance" runat="server" class="button"
                                    onclick="btnTrainingEventTypeFilterPerfomance_Click();" value="<%$ Resources:Readiness, PerfomanceAnalisys_lblFilter %>" />
                            </p>
                        </div>
                    </div>
                </fieldset>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper" style="width: 675px">
                    <fieldset>
                        <legend></legend>
                        <div class="emplSearch">
                            <table cellpadding="0" cellspacing="0" width="650px" style="direction: ltr">
                                <tr>
                                    <td style="width: 50%;">
                                        <div class="wrapperLeft">
                                            <p>
                                                <label id="startDate">
                                                </label>
                                            </p>
                                        </div>
                                    </td>
                                    <td style="width: 50%;">
                                        <div class="wrapperRight">
                                            <p>
                                                <label id="endDate">
                                                </label>
                                            </p>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="div_wrapper" style="margin-left: 15px; margin-right: 15px">
                            <div id="slider" style="width: 600px">
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
            <div class="emplSearch">
                <div id="rightChartsPanel" style="display: none" class="div_wrapper">
                    <fieldset>
                        <legend>
                            <asp:Label runat="server" ID="lblHeaderFieldset" ClientIDMode="Static" /></legend>
                        <div class="emplSearch">
                            <div id="divLowerChart" class="div_wrapper loading charts">
                            </div>
                            <div class="div_wrapper loading charts" id="divChrtSubEvaluations">
                            </div>
                            <div class="div_wrapper loading charts" id="divChartExecutionTime">
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hidUnitID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidJobID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidStartDate" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidEndDate" ClientIDMode="Static" runat="server" />
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtTrainingEventType" Text="<%$ Resources:Readiness, grtTrainingEventType %>" />
        <asp:Label ID="hidReadinessStatus_grtSelectJobs" runat="server" Text="<%$ Resources:Readiness, ReadinessStatus_grtSelectJobs %>"
            ClientIDMode="Static" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtTrainingEventCategory"
            Text="<%$ Resources:Readiness, ReadinessStatus_GrtTrainingEventCategory %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtSubjectEvaluation" Text="<%$ Resources:Readiness, PerfomanseAnalysis_GrtSubjectEvaluation %>" />
         <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
    </div>
    <script type="text/javascript" language="javascript">
        $("#MySplitter").css({ "opacity": "0" }).fadeIn("slow");
        var _unitRoot = "<%= UnitRoot %>";
        var _user = new PQ.BE.User();
        $(function () {
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);

            var maxDate = new Date();
            var newdate = new Date(maxDate);
            newdate.setYear(newdate.getFullYear() - 3);

            var minDate = new Date(newdate);

            var tempdate = new Date(minDate);
            tempdate.setYear(tempdate.getFullYear() - 2);
            var firstDate = new Date(tempdate);

            /* Set date for the textbox*/
            var dateStart = new Date(firstDate.getTime());
            dateStart.setDate(dateStart.getDate());
            $('#startDate').text($.datepicker.formatDate('M-yy', dateStart));
            $('#hidStartDate').val($.datepicker.formatDate('dd/mm/yy', dateStart));

            var endDate = new Date(maxDate);
            endDate.setYear(endDate.getFullYear());
            $('#endDate').text($.datepicker.formatDate('M-yy', endDate));
            $('#hidEndDate').val($.datepicker.formatDate('dd/mm/yy', endDate));
            /* End areaSet date for the textbox*/


            var slider = $('#slider').slider({
                animate: true,
                values: [minDate, maxDate],
                range: true,
                max: Math.floor((maxDate.getTime() - minDate.getTime()) / 86400000),
                slide: function (event, ui) {
                    var date = new Date(minDate.getTime());
                    date.setDate(date.getDate() + ui.values[0]);
                    $('#startDate').text($.datepicker.formatDate('M-yy', date));
                    $('#hidStartDate').val($.datepicker.formatDate('dd/mm/yy', date));
                    date = new Date(minDate.getTime());
                    date.setDate(date.getDate() + ui.values[1]);
                    $('#endDate').text($.datepicker.formatDate('M-yy', date));
                    $('#hidEndDate').val($.datepicker.formatDate('dd/mm/yy', date));
                },
                stop: function (event, ui) {
                    $("#waitplease").css({ 'display': 'block' });
                    $('#divPerfomance').fadeIn("slow");
                    btnTrainingEventTypeFilterPerfomance_Click();
                    if ($("#chkExecTimeIsVisible").attr("checked"))
                        perfomance.ChartPerfomanceAnalysis_ExecutionTimeFormatter('', $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#hidStartDate').val(), $('#hidEndDate').val());
                    else
                        $("#divChartExecutionTime").empty();
                }
            });

            slider.slider('values', 0, Math.floor((dateStart.getTime() - endDate.getTime()) / 90000000));

        });
        $(document).ready(function () {
            perfomance.PopulateJobsListCombo($("#hidUnitID").val());
            perfomance.PopulateTrainingEventCategorySelect();
            perfomance.PopulateSubEvaluationTypeCombo();
            $("#MySplitter").css({ "opacity": "1" });

        });
        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });


        $("#ddlTrainingEventCategory").change(function () {
            perfomance.PopulateSubEvaluationTypeCombo();
        });
        function OnClientPopup_Click() {
            var _user = new PQ.BE.User();
            if ($('#treeUnits').is(':visible')) {
                $('#treeUnits').fadeOut('slide');
            }
            else {
                $('#treeUnits').fadeIn('slide');
                perfomance.CreateUnitTree(_user);
            }
            return false;
        };

        function ddlJobsList_OnChange() {
            $("#waitplease").css({ 'display': 'block' });
            var dataID = $("#ddlJobsList").val();
            var dataText = $("#ddlJobsList option:selected").text();
            perfomance.DisplayJobReadinessInfo($("#hidUnitID").val(), dataID, dataText, $('#hidStartDate').val(), $('#hidEndDate').val());
        }

        $("#ddlTrainingEventTypePerfomance").change(function () {
            perfomance.PopulateTrainingEventCategorySelect();
            $("#ddlTrainingEventCategory").trigger("change");
        });

        function btnTrainingEventTypeFilterPerfomance_Click() {
            $("#divChrtSubEvaluations, #divLowerChart").empty();
            if ($("#hidUnitID").val() != "")
                perfomance.DisplayUnitReadinessInfo($("#hidUnitID").val(), $("#ddlUnit").val(), $('#hidStartDate').val(), $('#hidEndDate').val());
            if ($("#ddlJobsList").val() != "0")
                perfomance.DisplayJobReadinessInfo($("#hidUnitID").val(), $("#ddlJobsList").val(), $("#ddlJobsList option:selected").text(), $('#hidStartDate').val(), $('#hidEndDate').val());
            if ($("#ddlTrainingEventTypePerfomance").val() != "0" && $("#hidUnitID").val() == "" && $("#ddlJobsList").val() == "0") {
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }) }, 500);
                perfomance.DisplayUnitReadinessInfo(2, '', $('#hidStartDate').val(), $('#hidEndDate').val());
            }
            else {
                if ($("#hidUnitID").val() == "" && $("#ddlJobsList").val() == "0") {
                    setTimeout(function () { $("#waitplease").css({ 'display': 'none' }) }, 500);
                    perfomance.DisplayAllEventTypeGraphInfo($("#hidUnitID").val(), $('#hidStartDate').val(), $('#hidEndDate').val());
                }
            }
            if ($("#chkExecTimeIsVisible").attr("checked"))
                perfomance.ChartPerfomanceAnalysis_ExecutionTimeFormatter('', $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#hidStartDate').val(), $('#hidEndDate').val());
            else
                $("#divChartExecutionTime").empty();

            $("#divChrtSubEvaluations,#divLowerChart").removeClass("loading");
        }

    </script>
</asp:Content>
