var dashboard = {
    OpenDashboardConfigPanel: function () {
        $("#divParamPanel").dialog({ autoOpen: true, bgiframe: true, resizable: true, closeOnEscape: true, width: '850px', modal: true, zIndex: 50,
            title: $('#hidDialogTitleHeaderDefine').text(),
            create: function () {
                $(this).block({
                    css: { border: '0px' },
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
            },
            open: function () {
                $(this).parent().appendTo("form");
                $(this).unblock();
                dashboard.DashboardLoadData();
            }
            //            ,buttons:
            //            [{ id: "btnClose", text: $("#hidDB_Config_btnClose").text(), click: function () { $(this).dialog('destroy'); } }]
        });
        return false;
    },
    DashboardLoadData: function () {
        this.ClearFields();
        DashboardService.DashboardLoadData({ DashboardItemID: null },
            function (result) {
                var inHtml = "";
                $.each(result, function (i, ob) {
                    inHtml += '<option value="' + ob.DashboardItemID + '">' + ob.DashboardItemName + '</option>';
                });
                $("#lsbReportList").empty().append(inHtml);
                RaiseLoader(false);
            },
            function (ex) {

            });
        RaiseLoader(false);
        return false;
    },
    DashboardGetSelectedData: function () {
        var selected = $("#lsbReportList").val();
        DashboardService.DashboardLoadData({ DashboardItemID: selected },
            function (result) {
                dashboard.PopulateReportDetailForm(result[0]);
            },
            function (ex) {

            });
        return false;
    },
    PopulateReportDetailForm: function (result) {
        $("#hidDashboardItemID").val(result.DashboardItemID);
        $("#txtOrder").val(result.DashboardItemOrder);
        $("#txtViewName").val(result.DashboardItemName);
        $("#ddlViewSource").val(result.DashboardItemSourceType);
        $("#ddlChartType").val(result.DashboardItemChartType);
        dashboard.ChartTypeImage(result.DashboardItemChartType);
        $("#ddlTaskName").val(result.TrainingEventTypeID);
        switch (result.DashboardItemSourceType) {
            case 1:
                $("#divComplianceTaskParam,#divMaintenanceItems").hide("fast"); $("#divDefaultTime,#divChartType").show();
                break;
            case 2:
                $("#divMaintenanceItems").hide(); $("#divComplianceTaskParam, #divChartType,#divDefaultTime").show();
                break;
            case 3:
                $("#divChartType, #divDefaultTime").hide();
                break;
            case 4:
                $("#divComplianceTaskParam").hide();
                $("#divMaintenanceItems, #divChartType,#divDefaultTime").show();
                break;
        }
        dashboard.PopulateTaskSubjectList(result.TrainingEventTypeID, result.TrainingEventCategory_ID);
        $("#rdbDataLevel").find("input[value='" + result.ComplianceDataLevel + "']").attr("checked", "checked");
        $("#rdbCompAdggregation").find("input[value='" + result.ComplianceAggregation + "']").attr("checked", "checked");
        $("#rdbDisplayLevel").find("input[value='" + result.ItemLevel + "']").attr("checked", "checked");
        if ($("#rdbDisplayLevel input:checked").val() == "2") $("#ddlItemCategory").attr("disabled", false);
        $("#ddlItemCategory").val(result.ItemCategoryID);
        $("#rdbAggregation").find("input[value='" + result.ItemAggregation + "']").attr("checked", "checked");
        $("#hidDefaultUnitID").val(result.UnitID);
        $("#rdbDefaultTime").find("input[value='" + result.DefualtTime + "']").attr("checked", "checked");
        $("#chkDashboardItemEnabled").attr("checked", result.DashboardItemEnabled);
        $("#ddlCopyFromUser").val(result.UserID);
        $("#hidDefaultUnitID").val(result.UnitData.Unit_ID);
        $("#ddlDefaultUnit").val(result.UnitData.Unit_Name);
        if (!$("#divMainConfig").is(":visible")) setTimeout(function () { $("#divMainConfig").show("slide"); }, 100);
    },
    PopulateTaskSubjectList: function (trainingEventTypeID, trainingEventCategoryID) {
        $("#ddlTaskSubject>option").remove();
        window.PQ.Admin.WebService.AlertSettingService.TrainingEventCategory_Select(trainingEventTypeID, $("#hidDB_Config_TaskSubject_optGreeting").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlTaskSubject").append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $("#ddlTaskSubject").removeClass("ui-autocomplete-ddl-loading");
            if (trainingEventCategoryID) $("#ddlTaskSubject").val(trainingEventCategoryID);
            if ($("#rdbDataLevel input:checked").val() == "2") $("#ddlTaskSubject").attr("disabled", false);
        },
        function () {
            return false;
        });
    },
    CreateUnitTree: function () {
        try {
            window.PQ.Admin.WebService.PQWebService.GetUserMenu(null, function (result) {
                if (result) {
                    var theme = "default", rtl = false;
                    if ($.cookie("lang")) {
                        var lang = $.cookie("lang");
                        if (lang == 'he-IL' || lang == 'ar') {
                            theme = "default-rtl";
                            rtl = true;
                        }
                    }
                    try {
                        var level = $("#lblTreeLebel").text() == "" ? 0 : parseInt($("#lblTreeLebel").text());
                        var arrayIDs = GetArrayTreeIDs(result, level);

                        $('#txtDefaultUnit').jstree(
				        { "xml_data": { "data": result },
				            "plugins": ["themes", "xml_data", "ui", "types"],
				            "core": { "rtl": rtl, "initially_open": arrayIDs, "animation": "100" },
				            "themes": { "theme": theme },
				            "types": { "types":
						        { "file": {
						            "valid_children": ["default"],
						            "icon": { "image": "/opeReady/Resources/images/active.png" }
						        },
						            "folder": {
						                "valid_children": "all",
						                "icon": { "image": "/opeReady/Resources/images/close.png" },
						                "hover_node": false,
						                "select_node": function () { return false; }
						            }
						        }
				            }
				        }).bind("select_node.jstree", function (event, data) {
				            $('#hidDefaultUnitID').val(data.rslt.obj.get(0).id);
				            $('#ddlDefaultUnit').val($(data.rslt.obj.find("a").get(0)).text()).removeClass('ui-state-error', 100);
				            $('#txtDefaultUnit').fadeOut('slow');
				            return false;
				        });
                    } catch (ex) {
                    }
                }
            }, function () {

            });
        } catch (e) {
            alert(e.Description);
        }
    },
    ApplyReportParameters: function () {
        if (this.RequaredFieldsCheck()) {
            RaiseLoader(true);
            var param = {
                DashboardItemID: $("#hidDashboardItemID").val() == "" ? 0 : parseInt($("#hidDashboardItemID").val()),
                DashboardItemOrder: $("#txtOrder").val() == "" ? 0 : parseInt($("#txtOrder").val()),
                DashboardItemName: $("#txtViewName").val(),
                DashboardItemSourceType: $("#ddlViewSource").val(),
                DashboardItemChartType: $("#ddlChartType").val(),
                TrainingEventTypeID: $("#ddlTaskName").val(),
                TrainingEventCategory_ID: $("#ddlTaskSubject").val(),
                ComplianceDataLevel: $("#rdbDataLevel input:checked").val(),
                ComplianceAggregation: $("#rdbCompAdggregation input:checked").val(),
                ItemLevel: $("#rdbDisplayLevel input:checked").val(),
                ItemCategoryID: $("#ddlItemCategory").val(),
                ItemAggregation: $("#rdbAggregation input:checked").val(),
                UnitData: { Unit_ID: $("#hidDefaultUnitID").val() },
                DefualtTime: $("#rdbDefaultTime input:checked").val(),
                DashboardItemEnabled: $("#chkDashboardItemEnabled").attr("checked"),
                UserID: $("#hidUserID").val()
            };

            DashboardService.DashboardItemSave(param,
                function (result) {
                    var temp = isNaN($("#hidDashboardItemID").val()) ? 0 : parseInt($("#hidDashboardItemID").val());
                    if (result) {
                        if (temp != result.DashboardItemID) {
                            $('#lsbReportList').append('<option value="' + result.DashboardItemID + '">' + result.DashboardItemName + '</option>');
                        } else {
                            $("#lsbReportList option[value='" + result.DashboardItemID + "']").attr("selected", true);
                        }
                        dashboard.PopulateReportDetailForm(result);
                    }
                    setTimeout(function () {
                        $("#btnRefresh").click(); RaiseLoader(false);
                    }, 500);
                },
                function (ex) {
                });
        }
    },
    MoveUp: function () {
        $("#lsbReportList option:selected").each(function () {
            var listItem = $(this);
            var listItemPosition = $("#lsbReportList option").index(listItem) + 1;
            if (listItemPosition == 1) return false;
            var prev = listItem.prev();
            listItem.insertBefore(prev);
            $("#txtOrder").val(listItemPosition - 1);
            return false;
        });
        this.SaveCurrentIndex();
    },
    MoveDown: function () {
        var itemsCount = $("#lsbReportList option").length;
        $($("#lsbReportList option:selected").get().reverse()).each(function () {
            var listItem = $(this);
            var listItemPosition = $("#lsbReportList option").index(listItem) + 1;
            if (listItemPosition == itemsCount) return false;
            var next = listItem.next();
            listItem.insertAfter(next);
            $("#txtOrder").val(listItemPosition + 1);
            return false;
        });
        this.SaveCurrentIndex();
    },
    SaveCurrentIndex: function () {
        var reportIndex = new Array();
        RaiseLoader(true);
        $("#lsbReportList option").each(function (index, option) {
            reportIndex.push({ DashboardItemID: $(option).val(), DashboardItemOrder: ++index });
        });
        DashboardService.SaveCurrentIndex(reportIndex,
            function () {
                setTimeout(function () { RaiseLoader(false); }, 500);
            },
            function () {

            });
    },
    ClearFields: function () {
        $("#hidDashboardItemID").val(0);
        $("#txtOrder").val("");
        $("#txtViewName").val("");
        $("#ddlViewSource").val("0");
        $("#ddlChartType").val("0");
        $("#ddlTaskName").val("0");
        $("#rdbDataLevel").find("input[value='1']").attr("checked", "checked");
        $("#rdbCompAdggregation").find("input[value='1']").attr("checked", "checked");
        $("#rdbDisplayLevel").find("input[value='1']").attr("checked", "checked");
        $("#ddlItemCategory").val("0");
        $("#rdbAggregation").find("input[value='1']").attr("checked", "checked");
        //        $("#hidDefaultUnitID").val("0");
        //        $("#rdbDefaultTime").find("input[value='1']").attr("checked", "checked");
        //        $("#chkDashboardItemEnabled").attr("checked", false);
        $("#ddlCopyFromUser").val();
    },
    DeleteSelectedItem: function () {
        var selected = $("#lsbReportList option:selected").val();
        if (selected) {
            $("#ConfirmDeleteAttachment").dialog({
                title: $("#hidDialogTitleHeaderDefine").text(),
                autoOpen: true,
                modal: true,
                resizable: false,
                closeOnEscape: true,
                height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        DashboardService.DashboardItemDelete(parseInt(selected),
                            function (result) {
                                var inHtml = "";
                                $.each(result, function (i, ob) {
                                    inHtml += '<option value="' + ob.DashboardItemID + '">' + ob.DashboardItemName + '</option>';
                                });
                                $("#lsbReportList").empty().append(inHtml);
                                dashboard.ClearFields();
                                $("#ConfirmDeleteAttachment").dialog('destroy');
                            }, function (ex) {

                            });
                    }
                    , Cancel: function (e) {
                        $(this).dialog('destroy');
                        result = false;
                    }
                }
            });
        }
    },
    RequaredFieldsCheck: function () {
        if ($("#txtViewName").val() == "") {
            $("#txtViewName").addClass('ui-state-error');
            return false;
        } else {
            $("#txtViewName").removeClass('ui-state-error', 200);
        }
        if ($("#rdbDataLevel input:checked").val() == "2") {
            if ($("#ddlTaskSubject").val() == "0") {
                $("#ddlTaskSubject").addClass('ui-state-error');
                return false;
            } else {
                $("#ddlTaskSubject").removeClass('ui-state-error', 200);
            }
        }
        if ($("#rdbDisplayLevel input:checked").val() == "2") {
            if ($("#ddlItemCategory").val() == "0") {
                $("#ddlItemCategory").addClass('ui-state-error');
                return false;
            } else {
                $("#ddlItemCategory").removeClass('ui-state-error', 200);
            }
        }

        return true;
    },
    DefaultChartDashboard: function (unitID, year, month, isRefresh) {
        RaiseLoader(true);
        $("#divChrtCommonUpper").empty();
        $("#divReportImages").fadeIn("slow");
        var currdate = new Date();
        currdate = encodeURI(currdate.toString());
        DashboardService.DashboardSelectList(
            function (result) {
                if (result) {
                    for (var i = 0; i < result.length; i++) {
                        var uid = result[i].UnitData.Unit_ID;
                        if (result[i].DashboardItemSourceType == 3) {
                            var jsonText = JSON.stringify({ unitID: uid }, null, 2);
                            $.ajax({
                                type: "POST",
                                url: "/opeReady/WebService/ReadinessWebService.asmx/UnitReadiness_SelectByUnitID",
                                data: jsonText,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: false,
                                processdata: true,
                                success: function (msg) {
                                    var data = getMain(msg);
                                    var uname =  result[i].UnitData.Unit_Name;
                                    var $div = $('<div id="divGauge' + i + '" class="div_wrapper loading rounded-corners" style="width:450px;height:380px;box-shadow: 10px 10px 5px #888888;"></div>').appendTo("#divChrtCommonUpper");
                                    $("<div class='gaugeTitleTop'>" + uname + "</div>").appendTo("#divGauge" + i);
                                    $("<div class='gaugeTitle'>" + $("#hidDB_Config_GaugeHeader").text() + "</div>").appendTo("#divGauge" + i);
                                    $div.append("<iframe class='gaugeParams' src='/opeReady/Presentation/Gauge/Gauge.aspx?gg=" + (data == undefined ? 0 : data.UnitReadiness_Score) + "&ars=20' scrolling='no' frameborder='0'></iframe>");

                                },
                                error: function (ex) {
                                    alert(ex.responseText);
                                }
                            });
                        } else {
                            $('<div id="divImg' + i + '" class="div_wrapper loading"></div>').appendTo("#divChrtCommonUpper");
                            $("#divImg" + i).load("/opeReady/Handlers/Dashboard/UCDashboardHandler.ashx?did=" + result[i].DashboardItemID + "&UnitID=" + uid + "&Year=" + year + "&Month=" + month + "&ref=" + isRefresh + "&d=" + currdate,
                                function () {
                                    $(this).removeClass("loading");
                                    RaiseLoader(false);
                                });
                        }
                    }
                    setTimeout(function () {
                        RaiseLoader(false);
                    }, 500);
                } else {
                    setTimeout(function () {
                        RaiseLoader(false);
                    }, 500);
                }

            });
        return false;
    },
    ChartTypeImage: function (parameters) {
        parameters = parseInt(parameters);
        var imagePath = '/opeReady/Resources/images/';
        var image = $("#imgChatType");
        image.fadeOut('fast', function () {
            switch (parameters) {
                case 1:
                    imagePath = imagePath + 'columnchart.png';
                    break;
                case 2:
                    imagePath = imagePath + 'barchat.png';
                    break;
                default:
                    return false;
            }
            image.attr('src', imagePath);
            image.fadeIn('fast');
            return false;
        });
    },
    CopyDataToAnotherUser: function (fromUser, toUser) {
        RaiseLoader(true);
        DashboardService.CopyDataToAnotherUser(fromUser, toUser,
            function () {
                setTimeout(function () {
                    RaiseLoader(false);
                }, 500);
            },
            function (ex) {

            });
        return false;

    }


};

