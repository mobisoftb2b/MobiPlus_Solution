<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PerfomanceAnalysis.ascx.cs"
    Inherits="PQ.Admin.Presentation.Employee.EmploymentUserControls.PerfomanceAnalysisUC" %>
<div class="emplSearch">
    <div class="div_wrapper">
        <fieldset>
            <legend>
                <asp:Label runat="server" ID="Label17" Text="<%$ Resources:Employee, PerfomanceAnalisys_grtEventRecordFilter %>" /></legend>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Readiness, grbEventRecordFilter %>" /></label>
                        <asp:DropDownList ID="ddlTrainingEventTypePerfomance" ClientIDMode="Static" runat="server"
                            ViewStateMode="Enabled" CssClass="select" DataTextField="TrainingEventType_Name"
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
                            <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Employee, PerfomanceAnalisys_lblSubEvaluation %>" /></label>
                        <asp:DropDownList ID="ddlSubEvaluationTypePA" ClientIDMode="Static" runat="server"
                            ViewStateMode="Enabled" CssClass="select-big" DataTextField="SubEvaluationType_Name"
                            DataValueField="SubEvaluationType_ID" />
                        <input type="button" id="btnTrainingEventTypeFilterPerfomance" runat="server" class="button"
                            onclick="btnTrainingEventTypeFilterPerfomance_Click();" value="<%$ Resources:Employee, PerfomanceAnalisys_lblFilter %>" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <table width="650px" style="direction: ltr">
                        <tr>
                            <td style="width: 50%">
                                <div class="wrapperLeft">
                                    <p>
                                        <label id="startDate">
                                        </label>
                                    </p>
                                </div>
                            </td>
                            <td style="width: 50%">
                                <div class="wrapperRight">
                                    <p>
                                        <label id="endDate">
                                        </label>
                                    </p>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div class="emplSearch" style="width: 650px">
                        <div class="div_wrapper" style="margin-left: 15px; margin-right: 15px">
                            <div id="slider">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="div_wrapper">
                    <br />
                    <input type="checkbox" id="chkExecTimeIsVisible" />
                    <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Employee, PerfomanceAnalisys_chkExecTimeIsVisible %>" />
                </div>
            </div>
        </fieldset>
        <div id="divPerfomance" class="div_wrapper no-display">
            <fieldset>
                <legend>
                    <asp:Label runat="server" ID="lblUpperPerfomanceLabel" /></legend>
                <div class="emplSearch">
                    <div class="loading" id="divChrtCommonUpper">
                    </div>
                    <div class="loading" id="divChrtSubEvaluations">
                    </div>
                    <div class="loading" id="divChartExecutionTime">
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
</div>
<div id="hiddFuildCaptions" style="display: none">
    <asp:Label runat="server" ClientIDMode="Static" ID="hidGrtTrainingEventCategory"
        Text="<%$ Resources:Readiness, ReadinessStatus_GrtTrainingEventCategory %>" />
</div>
<asp:HiddenField ID="hidTrainingEventTypeID" runat="server" />
<asp:HiddenField ID="hidStartDate" ClientIDMode="Static" runat="server" />
<asp:HiddenField ID="hidEndDate" ClientIDMode="Static" runat="server" />
<script type="text/javascript">

    $(function () {
        if ($.cookie("lang"))
            $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
        else
            $.datepicker.setDefaults($.datepicker.regional['']);

        var maxDate = new Date();
        var newdate = new Date(maxDate);
        newdate.setYear(newdate.getFullYear() - 5);

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
                if ($('#ddlTrainingEventTypePerfomance').val() != "0") {
                    $("#waitplease").css({ 'display': 'block' });
                    $('#ddlTrainingEventTypePerfomance').removeClass('ui-state-error', 500);
                    $('#divPerfomance').fadeIn("slow");
                    var pid = getArgs();
                    if (pid.eid) {
                        ChartPerfomanceAnalysis(pid.eid, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#hidStartDate').val(), $('#hidEndDate').val());
                        ChartSubEvaluationsFormatter(pid.eid, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#ddlSubEvaluationTypePA').val(), $('#hidStartDate').val(), $('#hidEndDate').val());
                        
                        if ($("#chkExecTimeIsVisible").attr("checked"))
                            perfomance.ChartPerfomanceAnalysis_ExecutionTimeFormatter(pid.eid, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#hidStartDate').val(), $('#hidEndDate').val());
                        else
                            $("#divChartExecutionTime").empty();
                    }
                }
            }
        });
        slider.slider('values', 0, Math.floor((dateStart.getTime() - endDate.getTime()) / 90000000));
        perfomance.PopulateTrainingEventCategorySelect();
        perfomance.PopulateSubEvaluationTypePACombo();
    });

    $("#ddlTrainingEventCategory").change(function () {
        perfomance.PopulateSubEvaluationTypePACombo();
    });

    function btnTrainingEventTypeFilterPerfomance_Click() {
        var currdate = new Date();
        currdate = encodeURI(currdate.toString());
        var pid = getArgs();
        $("#divChrtCommonUpper").empty();
        $("#divChrtSubEvaluations").empty();
        if ($('#ddlTrainingEventTypePerfomance').val() != "0") {
            $("#waitplease").css({ 'display': 'block' });
            $(".charts").block({
                css: { border: '0px' },
                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                message: ''
            });
            $('#divPerfomance').fadeIn("slow");

            if (pid.eid) {
                ChartPerfomanceAnalysis(pid.eid, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#hidStartDate').val(), $('#hidEndDate').val());
                ChartSubEvaluationsFormatter(pid.eid, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#ddlSubEvaluationTypePA').val(), $('#hidStartDate').val(), $('#hidEndDate').val());

                if ($("#chkExecTimeIsVisible").attr("checked"))
                    perfomance.ChartPerfomanceAnalysis_ExecutionTimeFormatter(pid.eid, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#hidStartDate').val(), $('#hidEndDate').val());
                else
                    $("#divChartExecutionTime").empty();
            }
            $('#ddlTrainingEventTypePerfomance').removeClass('ui-state-error', 100);
        }
        else {
            $('#divPerfomance').fadeIn('slow');
            $(".charts").block({
                css: { border: '0px' },
                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                message: ''
            });
            $("#divChrtCommonUpper").empty();
            PQ.Admin.WebService.EventRecords.TrainingEventType_SelectAll($("#hidGrtTrainingEventType").text(),false,
             function (data) {
                 $(data).each(function (i) {
                     if (data[i].TrainingEventType_ID != 0) {
                         var img = new Image();
                         $(img).attr("src", "/opeReady/Handlers/PerfomanceAnalysisChart.ashx?eid=" + pid.eid + "&tetid=" + data[i].TrainingEventType_ID + "&tecatid=" + $('#ddlTrainingEventCategory').val() + "&from=" + $('#hidStartDate').val() + "&to=" + $('#hidEndDate').val() + "&d=" + currdate);
                         $("#divChrtCommonUpper").fadeIn('slow').append(img).removeClass("loading");
                     }
                 });
                 $(".charts").unblock();
                 $("#waitplease").css({ 'display': 'none' });
             },
            function (e) {
                return false;
            });
        }
        return false;
    };

    function ChartPerfomanceAnalysis(personID, traningEventTypeID, traningEventCategoryID, fromDate, toDate) {
        var currdate = new Date();
        currdate = encodeURI(currdate.toString());
        $("#divChrtCommonUpper").empty();
        var img = new Image();
        $(img).attr("id", personID);
        $(img).attr("src", "/opeReady/Handlers/PerfomanceAnalysisChart.ashx?eid=" + personID + "&tetid=" + traningEventTypeID + "&tecatid=" + traningEventCategoryID + "&from=" + fromDate + "&to=" + toDate + "&d=" + currdate);
        $("#divChrtCommonUpper").fadeIn('slow').append(img).removeClass("loading");
        $(".charts").unblock();
        return false;
    }
    function ChartSubEvaluationsFormatter(personID, traningEventTypeID, traningEventCategoryID, subevaluationID, fromDate, toDate) {
        var currdate = new Date(); 
        currdate = encodeURI(currdate.toString());
        var _traningEventCategoryID = traningEventCategoryID == undefined ? 0 : parseInt(traningEventCategoryID);
        $("#divChrtSubEvaluations").empty();
        if (_traningEventCategoryID === 0) {
            PQ.Admin.WebService.ReadinessWebService.PerfomanceAnalysisSubEvaluations_SubEvaluationsCount(personID, traningEventTypeID,
        function (data) {
            $(data).each(function (i) {
                var img = new Image();
                $(img).attr("id", personID);
                $(img).attr("src", "/opeReady/Handlers/multiSeriesChart.ashx?eid=" + personID + "&tetid=" + traningEventTypeID + "&tecatid=" + data[i] + "&from=" + fromDate + "&to=" + toDate + "&seid=" + subevaluationID + "&d=" + currdate);
                $("#divChrtSubEvaluations").fadeIn('slow').append(img).removeClass("loading");
            });
            $(".charts").unblock();
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) { }, null);
        } else {
            var img = new Image();
            $(img).attr("id", personID);
            $(img).attr("src", "/opeReady/Handlers/multiSeriesChart.ashx?eid=" + personID + "&tetid=" + traningEventTypeID + "&tecatid=" + _traningEventCategoryID + "&from=" + fromDate + "&to=" + toDate + "&seid=" + subevaluationID + "&d=" + currdate);
            $("#divChrtSubEvaluations").fadeIn('slow').append(img).removeClass("loading");
            $(".charts").unblock();
            $("#waitplease").css({ 'display': 'none' });
        }
        return false;
    };

    $("#ddlTrainingEventTypePerfomance").change(function () {
        perfomance.PopulateTrainingEventCategorySelect();
        $("#ddlTrainingEventCategory").trigger("change");
    });
</script>
