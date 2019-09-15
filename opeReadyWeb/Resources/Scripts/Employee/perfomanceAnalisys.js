var perfomance = {

};

perfomance.Init = function () {

};

perfomance.CreateUnitTree = function (userData) {
    if (userData) {
        PQ.Admin.WebService.PQWebService.GetUserMenu(userData,
        function (result) {
            var _theme, _rtl;
            if ($.cookie("lang")) {
                var _lang = $.cookie("lang");
                if (_lang == 'he-IL' || _lang == 'ar') {
                    _theme = "default-rtl";
                    _rtl = true;
                }
                else {
                    _theme = "default";
                    _rtl = false;
                }
            }
            try {
                var level = $("#lblTreeLebel").text() == "" ? 0 : parseInt($("#lblTreeLebel").text());
                var arrayIDs = GetArrayTreeIDs(result, level);

                $('#treeUnits').jstree(
                        { "xml_data": { "data": result },
                            "plugins": ["themes", "xml_data", "ui", "types"],
                            "core": { "rtl": _rtl, "initially_open": [arrayIDs], "animation": "100" },
                            "themes": { "theme": _theme },
                            "types": { "types":
                                { "file": {
                                    "valid_children": ["default"],
                                    "icon": { "image": "/opeReady/Resources/images/active.png" }
                                },
                                    "folder": {
                                        "valid_children": "all",
                                        "icon": { "image": "/opeReady/Resources/images/close.png" },
                                        "select_node": function () { return false; }
                                    }
                                }
                            }
                        }).bind("select_node.jstree", function (event, data) {
                            $("#waitplease").css({ 'display': 'block' });
                            $('#hidUnitID').val(data.rslt.obj.get(0).id);
                            $('#ddlUnit').val($(data.rslt.obj.find("a").get(0)).text());
                            $('#treeUnits').fadeOut('slow');
                            $("#ddlJobsList").val("0");
                            if ($("#ddlTrainingEventTypePerfomance").val() == "0")
                                perfomance.DisplayAllEventTypeGraphInfo(data.rslt.obj.get(0).id, $('#hidStartDate').val(), $('#hidEndDate').val());
                            else
                                perfomance.DisplayUnitReadinessInfo(data.rslt.obj.get(0).id, data.args[0].innerText, $('#hidStartDate').val(), $('#hidEndDate').val());
                            perfomance.PopulateJobsListCombo(data.rslt.obj.get(0).id);
                            return false;
                        });
            } catch (e) { }
            $("#tblGaugesArea").css({ "opacity": "1" });
        }, function (e) {
            return false;
        });
    }
};


perfomance.CreateJobTree = function (userData, unitID) {
    if (unitID) {
        PQ.Admin.WebService.PQWebService.GetUnitJobTree(parseInt(unitID),
        function (result) {
            var nodes = false;
            if ($(XmlParser(result)).find("item").length > 0)
                nodes = true;
            if (nodes) {
                var _theme, _rtl;
                if ($.cookie("lang")) {
                    var _lang = $.cookie("lang");
                    if (_lang == 'he-IL' || _lang == 'ar') {
                        _theme = "default-rtl";
                        _rtl = true;
                    }
                    else {
                        _theme = "default";
                        _rtl = false;
                    }
                }
                try {
                    $('#divJobs').bind("loaded.jstree", function (e, data) {
                        $(this).jstree("open_all");
                        $('#divWrapperJob').fadeIn('slow');
                        $('#rightChartsPanel').fadeIn('slow');
                    }).jstree(
                        { "xml_data": { "data": result },
                            "plugins": ["themes", "xml_data", "ui", "types"],
                            "core": { "rtl": _rtl, "initially_open": ["2"], "animation": "100" },
                            "themes": { "theme": _theme }
                        }).bind("select_node.jstree", function (event, data) {
                            $("#waitplease").css({ 'display': 'block' });
                            perfomance.DisplayJobReadinessInfo(data.rslt.obj.get(0).id, data.args[0].innerText);
                            return false;
                        }).jstree("refresh");
                } catch (e) {
                }
            }
            else {
                $('#divWrapperJob').fadeOut('slow');
                $('#divLowerChart').fadeOut('slow');
            }
        },
        function (e) {
            return false;
        });
    }
};


perfomance.PopulateTrainingEventTypeCombo = function () {
    $("#ddlTrainingEventTypePerfomance>option").remove();
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectAll($("#hidGrtTrainingEventType").text(), false,
     function (result) {
         $(result).each(function () {
             $("#ddlTrainingEventTypePerfomance").append($("<option></option>").val(this['TrainingEventType_ID']).html(this['TrainingEventType_Name']));
         });
         $("#waitplease").css({ 'display': 'none' });
     },
    function (e) {
        return false;
    });

};
perfomance.PopulateddlTrainingEventTypeExceptionCombo = function () {
    $("#ddlTrainingEventTypeException>option").remove();
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectAll($("#hidGrtTrainingEventType").text(), false,
     function (result) {
         $(result).each(function () {
             $("#ddlTrainingEventTypeException").append($("<option></option>").val(this['TrainingEventType_ID']).html(this['TrainingEventType_Name']));
         });
         $("#waitplease").css({ 'display': 'none' });
     },
    function (e) {
        return false;
    });

};
perfomance.DisplayAllEventTypeGraphInfo = function (unitID, dateFrom, dateTo) {
    var currdate = new Date();
    currdate = encodeURI(currdate.toString());
    $('#rightChartsPanel').fadeIn('slow');
    $(".charts").block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#divLowerChart").empty();
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectAll($("#hidGrtTrainingEventType").text(), false,
     function (data) {
         $(data).each(function (i) {
             if (data[i].TrainingEventType_ID != 0) {
                 var img = new Image();
                 $(img).attr("id", data[i]);
                 $(img).attr("src", "/opeReady/Handlers/ReadinessAnalisysHandlers/UnitChartReadinessAnalisys.ashx?uid=" + unitID + "&tetid=" + data[i].TrainingEventType_ID + "&from=" + dateFrom + "&to=" + dateTo + "&d=" + currdate);
                 $("#divLowerChart").fadeIn('slow').append(img).removeClass("loading");
             }
         });
         $(".charts").unblock();
         $("#waitplease").css({ 'display': 'none' });
     },
    function (e) {
        return false;
    });
    return false;
};

///------------------------------------------ Perfomance Analisys Unit Charts -------------------------------------------------------------
perfomance.DisplayUnitReadinessInfo = function (unitID, unitText, dateFrom, dateTo) {
    if (unitText) $("#lblHeaderFieldset").text(unitText);
    $('#rightChartsPanel').fadeIn('slow');
    $(".charts").block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    perfomance.ChartPerfomanceAnalysis(unitID, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), dateFrom, dateTo);
    perfomance.ChartSubEvaluationsFormatter(unitID, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#ddlSubEvaluationType').val(), dateFrom, dateTo)
    $('#ddlTrainingEventTypePerfomance').removeClass('ui-state-error', 500);
    return false;
};


perfomance.ChartPerfomanceAnalysis = function (unitID, traningEventTypeID, trainingEventCategoryID, dateFrom, dateTo) {
    var currdate = new Date();
    currdate = encodeURI(currdate.toString());
    trainingEventCategoryID = trainingEventCategoryID == null ? 0 : trainingEventCategoryID;
    $("#divLowerChart").empty();
    var img = new Image();
    $(img).attr("id", traningEventTypeID);
    $(img).attr("src", "/opeReady/Handlers/ReadinessAnalisysHandlers/UnitChartReadinessAnalisys.ashx?uid=" + unitID + "&tetid=" + traningEventTypeID + "&tecatid=" + trainingEventCategoryID + "&from=" + dateFrom + "&to=" + dateTo + "&d=" + currdate);
    $("#divLowerChart").fadeIn('slow').append(img).removeClass("loading");
    return false;
}

perfomance.ChartSubEvaluationsFormatter = function (unitID, traningEventTypeID, trainingEventCategoryID, subevaluationID, dateFrom, dateTo) {
    var currdate = new Date();
    currdate = encodeURI(currdate.toString());
    var _trainingEventCategoryID = trainingEventCategoryID == undefined ? 0 : parseInt(trainingEventCategoryID);
    $("#divChrtSubEvaluations").empty();
    if (_trainingEventCategoryID === 0) {
        PQ.Admin.WebService.ReadinessWebService.PerfomanceAnalysisSubEvaluations_SelectPerUnits(unitID, traningEventTypeID,
        function (data) {
            $(data).each(function (i) {
                var img = new Image();
                $(img).attr("id", data[i]);
                $(img).attr("src", "/opeReady/Handlers/ReadinessAnalisysHandlers/ReadinessAnalisys_UnitSubEvaluation.ashx?uid=" + unitID + "&tetid=" + traningEventTypeID + "&tecatid=" + data[i] + "&from=" + dateFrom + "&to=" + dateTo + "&seid=" + subevaluationID + "&d=" + currdate);
                $("#divChrtSubEvaluations").fadeIn('slow').append(img);
            });
            $(".charts").unblock();
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) { }, null);
    }
    else {
        var img = new Image();
        $(img).attr("id", _trainingEventCategoryID);
        $(img).attr("src", "/opeReady/Handlers/ReadinessAnalisysHandlers/ReadinessAnalisys_UnitSubEvaluation.ashx?uid=" + unitID + "&tetid=" + traningEventTypeID + "&tecatid=" + _trainingEventCategoryID + "&from=" + dateFrom + "&to=" + dateTo + "&seid=" + subevaluationID + "&d=" + currdate);
        $("#divChrtSubEvaluations").fadeIn('slow').append(img);
        $(".charts").unblock();
        $("#waitplease").css({ 'display': 'none' });
    }
    return false;
};

///------------------------------------------ End Perfomance Analisys Unit Charts -------------------------------------------------------------

///---------------------------  Perfomance Analisys Job Charts -----------------------------------------------------------------------------
perfomance.DisplayJobReadinessInfo = function (unitID, jobID, JobText, dateFrom, dateTo) {
    if (!isNaN(jobID)) jobID = parseInt(jobID);
    var _traningEventTypeID = $('#ddlTrainingEventTypePerfomance').val();
    if (jobID > 0) {
        if (JobText) $("#lblHeaderFieldset").text(JobText);
    }
    if (jobID) {
        $("#hidJobID").val(jobID);
        $('#rightChartsPanel').fadeIn('slow');
        $('.charts').block({
            css: { border: '0px' },
            timeout: 500,
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.9 },
            message: ''
        });
        perfomance.ChartJobPerfomanceAnalysis(jobID, _traningEventTypeID, dateFrom, dateTo);
        perfomance.ChartJobSubEvaluationPerfomanceAnalysis(jobID, _traningEventTypeID, $('#ddlTrainingEventCategory').val(), $('#ddlSubEvaluationType').val(), dateFrom, dateTo);
        $('#ddlTrainingEventTypePerfomance').removeClass('ui-state-error', 500);
    }
    else {
        perfomance.ChartPerfomanceAnalysis(unitID, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), dateFrom, dateTo);
        perfomance.ChartSubEvaluationsFormatter(unitID, $('#ddlTrainingEventTypePerfomance').val(), $('#ddlTrainingEventCategory').val(), $('#ddlSubEvaluationType').val(), dateFrom, dateTo)

    }
    return false;
};

perfomance.ChartJobPerfomanceAnalysis = function (jobID, traningEventTypeID, fromDate, toDate) {
    var currdate = new Date();
    currdate = encodeURI(currdate.toString());
    $("#divLowerChart").empty();
    var img = new Image();
    $(img).attr("id", traningEventTypeID);
    $(img).attr("src", "/opeReady/Handlers/ReadinessAnalisysHandlers/PerfomanseAnalisys_JobCharts.ashx?jid=" + jobID + "&tetid=" + traningEventTypeID + "&from=" + fromDate + "&to=" + toDate + "&d=" + currdate);
    $("#divLowerChart").fadeIn('slow').append(img).removeClass("loading");
    return false;
};

perfomance.ChartJobSubEvaluationPerfomanceAnalysis = function (jobID, traningEventTypeID, trainingEventCategoryID, subevaluationID, fromDate, toDate) {
    var currdate = new Date();
    currdate = encodeURI(currdate.toString());
    var _trainingEventCategoryID = trainingEventCategoryID == undefined ? 0 : parseInt(trainingEventCategoryID);
    $("#divChrtSubEvaluations").empty();
    if (_trainingEventCategoryID === 0) {
        PQ.Admin.WebService.ReadinessWebService.PerfomanceAnalysisSubEvaluations_SelectPerJobs(jobID, traningEventTypeID,
        function (data) {
            $(data).each(function (i) {
                var img = new Image();
                $(img).attr("id", data[i]);
                $(img).attr("src", "/opeReady/Handlers/ReadinessAnalisysHandlers/ReadinessAnalisys_JobsSubEvaluation.ashx?jid=" + jobID + "&tetid=" + traningEventTypeID + "&tecatid=" + data[i] + "&from=" + fromDate + "&to=" + toDate + "&seid=" + subevaluationID + "&d=" + currdate);
                $("#divChrtSubEvaluations").fadeIn('slow').append(img);
            });
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) { }, null);
    }
    else {
        var img = new Image();
        $(img).attr("id", _trainingEventCategoryID);
        $(img).attr("src", "/opeReady/Handlers/ReadinessAnalisysHandlers/ReadinessAnalisys_JobsSubEvaluation.ashx?jid=" + jobID + "&tetid=" + traningEventTypeID + "&tecatid=" + _trainingEventCategoryID + "&from=" + fromDate + "&to=" + toDate + "&seid=" + subevaluationID + "&d=" + currdate);
        $("#divChrtSubEvaluations").fadeIn('slow').append(img);
        $("#waitplease").css({ 'display': 'none' });
    }
    return false;
};

///--------------------------- End Perfomance Analisys Job Charts -----------------------------------------------------------------------------


perfomance.ChartPerfomanceAnalysis_ExecutionTimeFormatter = function (personID, traningEventTypeID, traningEventCategoryID, fromDate, toDate) {
    var currdate = new Date();
    currdate = encodeURI(currdate.toString());
    $("#divChartExecutionTime").empty();
    var img = new Image();
    $(img).attr("id", personID);
    $(img).attr("src", "/opeReady/Handlers/PerfomanceAnalysis_ExecutionTimeChart.ashx?eid=" + personID + "&tetid=" + traningEventTypeID + "&tecatid=" + traningEventCategoryID + "&from=" + fromDate + "&to=" + toDate + "&d=" + currdate);
    $("#divChartExecutionTime").fadeIn('slow').append(img).removeClass("loading");
    $(".charts").unblock();
    return false;
};


perfomance.PopulateJobsListCombo = function (unitID) {
    $("#ddlJobsList").addClass("ui-autocomplete-loading");
    $("#ddlJobsList>option").remove();
    unitID = unitID == "" ? 0 : parseInt(unitID);
    PQ.Admin.WebService.PQWebService.GetJobByUnitID(unitID, $("#hidReadinessStatus_grtSelectJobs").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlJobsList").append($("<option></option>").val(this['Job_ID']).html(this['Job_Name']));
        });
        $("#ddlJobsList").removeClass("ui-autocomplete-loading");
    },
    function (e) { });
    $("#waitplease").css({ 'display': 'none' });
    return false;
};


perfomance.PopulateTrainingEventCategorySelect = function () {
    $("#ddlTrainingEventCategory>option").remove();
    $("#ddlTrainingEventCategory").addClass("ui-autocomplete-ddl-loading");
    var $ddlControl = $("#ddlTrainingEventCategory");
    var trainingEventTypeID = $("#ddlTrainingEventTypePerfomance").val();
    PQ.Admin.WebService.AlertSettingService.TrainingEventCategory_Select(trainingEventTypeID, $("#hidGrtTrainingEventCategory").text(),
        function (result) {
            $(result).each(function () {
                $ddlControl.append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $ddlControl.removeClass("ui-autocomplete-ddl-loading");
            $("#ddlSubEvaluationType").trigger("change");
        },
    function (e) {
        return false;
    });
    $("#waitplease").css({ 'display': 'none' });
    return false;
}
perfomance.PopulateSubEvaluationTypeCombo = function () {
    $("#ddlSubEvaluationType>option").remove();
    $("#ddlSubEvaluationType").addClass("ui-autocomplete-ddl-loading");
    var trainingEventCategoryID = $("#ddlTrainingEventCategory").val();
    PQ.Admin.WebService.AlertSettingService.SubEvaluationType2TrainingEventCategory_Select(trainingEventCategoryID, $("#hidGrtSubjectEvaluation").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlSubEvaluationType").append($("<option></option>").val(this['SubEvaluationType_ID']).html(this['SubEvaluationType_Name']));
            });
            $("#ddlSubEvaluationType").removeClass("ui-autocomplete-ddl-loading");
        },
    function (e) {
        return false;
    });
    $("#waitplease").css({ 'display': 'none' });
    return false;
};

perfomance.PopulateSubEvaluationTypePACombo = function () {
    $("#ddlSubEvaluationTypePA>option").remove();
    $("#ddlSubEvaluationTypePA").addClass("ui-autocomplete-ddl-loading");
    var trainingEventCategoryID = $("#ddlTrainingEventCategory").val();
    PQ.Admin.WebService.AlertSettingService.SubEvaluationType2TrainingEventCategory_Select(trainingEventCategoryID, $("#hidGrtSubjectEvaluation").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlSubEvaluationTypePA").append($("<option></option>").val(this['SubEvaluationType_ID']).html(this['SubEvaluationType_Name']));
            });
            $("#ddlSubEvaluationTypePA").removeClass("ui-autocomplete-ddl-loading");
        },
    function (e) {
        return false;
    });
    $("#waitplease").css({ 'display': 'none' });
    return false;
}
