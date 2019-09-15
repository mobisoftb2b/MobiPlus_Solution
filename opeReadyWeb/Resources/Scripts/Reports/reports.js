var report = {
};

report.PopulationReportNameDropDown = function (data) {
    if (data) {
        $("#ddlReportName>option").remove();
        $(data).each(function () {
            $("#ddlReportName").append($("<option></option>").val(this['Report_ID']).html(this['Report_ORGName']));
        });
        $("#ddlReportName").removeClass("ui-autocomplete-ddl-loading");
    }

};
report.GetReportDesc = function (value) {
    //    ClearFields();
    PQ.Admin.WebService.ReportsWebService.GetReportsData(value,
    function (data) {
        $("#hidReport_ID").val(value);
        report.HideAll();
        $("#txtReportDesc").val('').removeClass("ui-autocomplete-ddl-loading");
        $('#txtDateFrom, #txtDateTo').val('');
        $('#content').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.9 },
            message: ''
        });
        if (data) {
            $("#hidReportURL").val(data.ReportURL);
            $("#txtReportDesc").val(data.Report_ORGDescription);
            if (data.isFromDateParam || data.isToDateParam)
                report.ShowDateBlock(data);
            if (data.isUnitParam || data.isJobParam)
                report.ShowUnitJobBlock(data);
            if (data.isTrainingEventType || data.isTrainingEventCategory)
                report.ShowEventTypeEventCategoryBlock(data);
            if (data.isSubQualification)
                report.ShowSubQualificationBlock(data);
            if (data.isRedinessLevel)
                report.ShowRedinessLevelBlock(data);
            if (data.isEmploymentHistory)
                report.ShowEmploymentHistoryBlock(data);
            if (data.isPersonCategory)
                report.ShowPersonCategoryBlock(data);
            if (data.isJobStatus)
                report.ShowJobStatusBlock(data);
            if (data.isEmployeeNumber)
                report.ShowEmployeeNumberBlock(data);
        }
        $('#content').unblock();
        $("#waitplease").css({ 'display': 'none' });
    },
    function (e) { });
};

report.ShowUnitJobBlock = function (data) {
    $("#divUnitJobArea").removeClass("noDisplay", 500).fadeIn(1000);
    report.PopulateJobsListCombo($("#hidUnitID").val());
    if (data.isUnitParam) $("#divUnitArea").removeClass("noDisplay", 500).fadeIn(1000);
    if (data.isJobParam) $("#divJobArea").removeClass("noDisplay", 500).fadeIn(1000);
    if (data.isUnitParamRequired) $("#ddlUnit").addClass("ui-state-error");
    if (data.isJobParamRequired) $("#ddlJobs").addClass("ui-state-error");
};

report.ShowDateBlock = function (data) {
    $("#divDateArea").removeClass("noDisplay", 500).fadeIn(1000);
    if (data.isFromDateParam) $("#divDateFrom").removeClass("noDisplay", 500).fadeIn(1000);
    else $("#divDateFrom").addClass("noDisplay");
    if (data.isToDateParam) $("#divDateTo").removeClass("noDisplay", 500).fadeIn(1000);
    else $("#divDateTo").addClass("noDisplay");
    if (data.isFromDateParamRequired && $("#txtDateFrom").val() == "") $("#txtDateFrom").addClass("ui-state-error");
    if (data.isToDateParamRequired && $("#txtDateFrom").val() == "") $("#txtDateTo").addClass("ui-state-error");
};
report.ShowEventTypeEventCategoryBlock = function (data) {
    $("#divEventTypeArea").removeClass("noDisplay", 500).fadeIn(1000);
    report.PopulateTrainingEventTypeCombo();
    if (data.isTrainingEventType) $("#divTrainingEventTypeArea").removeClass("noDisplay", 500).fadeIn(1000);
    else $("#divTrainingEventTypeArea").addClass("noDisplay");
    if (data.isTrainingEventCategory) $("#divEventCategoryArea").removeClass("noDisplay", 500).fadeIn(1000);
    else $("#divEventCategoryArea").addClass("noDisplay");
    if (data.isTrainingEventTypeRequired)
        $("#ddlTrainingEventType").addClass("ui-state-error");
    if (data.isTrainingEventCategoryRequired)
        $("#ddlEventCategory").addClass("ui-state-error");
};

report.ShowSubQualificationBlock = function (data) {
    $("#divSubjectEvaluationArea").removeClass("noDisplay", 500).fadeIn(1000);
    report.PopulateAdminTasksCombo();
    if (data.isSubQualificationRequired)
        $("#ddlSubQualification").addClass("ui-state-error");
};
report.ShowRedinessLevelBlock = function (data) {
    $("#divReadinessLevelArea").removeClass("noDisplay", 500).fadeIn(1000);
    $("#ddlReadinessLevel").val("0");
    if (data.isRedinessLevelRequired)
        $("#ddlReadinessLevel").addClass("ui-state-error");
};
report.ShowEmploymentHistoryBlock = function (data) {
    $("#divEmploymentStatusArea").removeClass("noDisplay", 500).fadeIn(1000);
    report.PopulateEmploymentHistoryCombo();
    if (data.isEmploymentHistoryRequired)
        $("#ddlEmploymentHistory").addClass("ui-state-error");
};
report.ShowPersonCategoryBlock = function (data) {
    $("#divEmployerNameArea").removeClass("noDisplay", 500).fadeIn(1000);
    $("#dllEmployerName").val("0");
    if (data.isPersonCategoryRequired)
        $("#dllEmployerName").addClass("ui-state-error");
};

report.ShowJobStatusBlock = function (data) {
    $("#divJobStatus").removeClass("noDisplay", 500).fadeIn(1000);
    this.PopulateJobStatusCombo();
    if (data.isJobStatusRequired)
        $("#ddlJobStatus").addClass("ui-state-error");
};

report.ShowEmployeeNumberBlock = function (data) {
    $("#divEmployeeNumber").removeClass("noDisplay", 500).fadeIn(1000);
    if (data.isEmployeeNumberRequired)
        $("#txtEmployeeNumber").addClass("ui-state-error");
};

report.HideAll = function () {
    $("#divDateArea, #divEventTypeArea, #divSubjectEvaluationArea, #divReadinessLevelArea, #divEmploymentStatusArea, #divEmployerNameArea, #divJobStatus, #divEmployeeNumber, #divUnitArea,#divJobArea").addClass("noDisplay");
    $("#divMainContent select").each(function () {
        $(this).removeClass("ui-state-error");
    });
    $("#divMainContent input").each(function () {
        $(this).removeClass("ui-state-error");
    });
};

report.CreateUnitTree = function () {
    PQ.Admin.WebService.PQWebService.GetUserMenu(null,
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
                            $('#ddlUnit').val($(data.rslt.obj.find("a").get(0)).text()).removeClass('ui-state-error', 1000);
                            $('#treeUnits').fadeOut('slow');
                            $("#ddlJobs").val("0");
                            report.PopulateJobsListCombo(data.rslt.obj.get(0).id);
                            return false;
                        });
            } catch (e) {
            }

            $("#tblGaugesArea").css({ "opacity": "1" });
        }, function (e) {
            return false;
        });
};

report.PopulateJobsListCombo = function (unitID) {
    $("#ddlJobs").addClass("ui-autocomplete-ddl-loading");
    $("#ddlJobs>option").remove();
    if (unitID) {
        PQ.Admin.WebService.PQWebService.GetJobByUnitID(unitID, $("#hidReportName_grtSelectJobs").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlJobs").append($("<option></option>").val(this['Job_ID']).html(this['Job_Name']));
        });
        $("#ddlJobs").removeClass("ui-autocomplete-ddl-loading");
    },
    function (e) { });
    }
    else {
        $("#ddlJobs").append($("<option></option>").val(0).html($("#hidReportName_grtSelectJobs").text()));
        $("#ddlJobs").removeClass("ui-autocomplete-ddl-loading");
    }

    $("#waitplease").css({ 'display': 'none' });
    return false;
};

//-------------------------------------- Population Event Records Comboes  ----------------------------------------------------

report.PopulateTrainingEventTypeCombo = function () {
    $("#ddlTrainingEventType>option").remove();
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectAll($("#hidGrtTrainingEventType").text(),false,
        function (result) {
            $(result).each(function () {
                $("#ddlTrainingEventType").append($("<option></option>").val(this['TrainingEventType_ID']).html(this['TrainingEventType_Name']));
            });
            $("#ddlTrainingEventType").removeClass("ui-autocomplete-ddl-loading");
        },
    function (e) {
        return false;
    });

};

report.PopulateTrainingEventCategoryCombo = function (trainingEventTypeID) {
    $("#ddlEventCategory>option").remove();
    PQ.Admin.WebService.ReportsWebService.TrainingEventCategory_Select(trainingEventTypeID, $("#hidGrtTrainingEventCategory").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlEventCategory").append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $("#ddlEventCategory").removeClass("ui-autocomplete-ddl-loading");
        },
    function (e) {
        return false;
    });
};
//-------------------------------------------------------------------------------------------------------------------------------

report.PopulateAdminTasksCombo = function () {
    $("#ddlSubQualification>option").remove();
    PQ.Admin.WebService.PQWebService.SubQualificationType_SelectAll(0, $("#hidGrtSubQualificationType").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlSubQualification").append($("<option></option>").val(this['SubQualificationType_ID']).html(this['SubQualificationType_Name']));
        });

    },
    function (e) { });
    $("#waitplease").css({ 'display': 'none' });
    return false;
};

report.PopulateEmploymentHistoryCombo = function () {
    $("#ddlEmploymentHistory>option").remove();
    PQ.Admin.WebService.PQWebService.GetEmploymentHistoryType($("#hidGrtEmploymentHistory").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlEmploymentHistory").append($("<option></option>").val(this['EmploymentHistoryType_ID']).html(this['EmploymentHistoryType_Name']));
        });
    },
    function (e) { });
    $("#waitplease").css({ 'display': 'none' });
    return false;
};

report.PopulateJobStatusCombo = function () {
    $("#ddlJobStatus>option").remove();
    PQ.Admin.WebService.PQWebService.JobStatus_SelectAll(0, $("#hidJobStatus_Greeting").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlJobStatus").append($("<option></option>").val(this['JobStatus_ID']).html(this['JobStatus_ORGName']));
        });
    },
    function (e) { });
    return false;
};
