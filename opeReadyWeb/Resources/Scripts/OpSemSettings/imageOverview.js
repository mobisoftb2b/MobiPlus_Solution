var imageOver = {
    rowCount: 0,
    dataRow: null,
    CreateImageOverviewGrid: function (imageData) {
        var _langDir, lastsel;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divImageOverviews').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var grid = $("#tblImageOverviews").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { imageOver.getImageOverviewData(imageData); },
            height: 375,
            width: 800,
            colNames: [
                    $('#hidIO_Grid_ImageID').text(),
                    $('#hidIO_Grid_ImageDate').text(),
                    $('#hidIO_Grid_EmployeeID').text(),
                    $('#hidIO_Grid_EmployeeName').text(),
                    $('#hidIO_Grid_ThreatType').text(),
                    $('#hidIO_Grid_ViewImage').text()
                    ],

            colModel: [
                    { name: 'ThreatLog_ID', key: true, sortable: true, sorttype: 'int', width: 100 },
       		        { name: 'ScreenerDateStr', index: 'ScreenerDateStr', sortable: true, sorttype: 'text', width: 150 },
                    { name: 'ScreenerPerson_ID', index: 'ScreenerPerson_ID', sortable: true, sorttype: 'int', width: 120, align: 'center' },
               		{ name: 'ScreenerPerson_Name', index: 'ScreenerPerson_Name', sortable: true, sorttype: 'text', width: 200, align: 'center' },
                    { name: 'ThreatTypeList', index: 'ThreatTypeList', sortable: true, sorttype: 'text', align: 'center', width: 300 },
                    { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: attachFormatter, width: 65, align: 'center' }
               	],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            pginput: true,
            altRows: true,
            multiselect: true,
            loadonce: true,
            hoverrows: false,
            rowNum: 20000,
            toolbar: [true, "top"],
            recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
            pager: '#pgrImageOverviews',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (imageOver.rowCount == $(this).getGridParam('records')) {
                    $(this).trigger('reloadGrid');
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divImageOverviews').unblock();
                }
            },
            onSelectRow: function (rowid, status, e) {
                return false;
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 6:
                        imageOver.DefineImageOverview_Open($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                imageOver.DefineImageOverview_Open($(this).getRowData(rowid));
            }
        });
        $("#tblImageOverviews")
            .jqGrid('gridResize', { minWidth: 650, minHeight: 300 })
            .toolbarButtonAdd("#t_tblImageOverviews",
            {
                caption: $('#hidIO_DownloadImages').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-image',
                onClickButton: function () {
                    imageOver.DownloadImages();
                }
            })
            .toolbarButtonAdd("#t_tblImageOverviews",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (imageOver.rowCount == 0) return false;
                    var threatLog = {
                        ThreatDateFromStr: $("#txtDateFrom").val(),
                        ThreatTypeID: imageOver.GetMultiselectThreatTypeData(),
                        VerifiedThreats: $("#chkVerifiedThreats").attr("checked"),
                        ThreatDateToStr: $("#txtDateTo").val(),
                        EmployeeIDList: imageOver.GetMultiselectData(),
                        StationType_ID: $("#chkMissedThreats").attr("checked") ? 2 : null
                    };
                    var urlHandlers = "/opeReady/Handlers/ExcelExport/ImageOverviewExcel.ashx";
                    var paramHandlers = "?ttype=" + JSON.stringify(threatLog, null, 2);
                    $("#tblImageOverviews").jqGrid('excelExport', { url: urlHandlers + paramHandlers });
                }
            });
    },
    getImageOverviewData: function (imageData) {
        if (imageData) {
            imageOver.ReceivedImageOverviewData(JSON.parse(getMain(imageData)).rows);
        }
        else {
            var threatLog = {
                ThreatDateFromStr: $("#txtDateFrom").val(),
                ThreatTypeID: imageOver.GetMultiselectThreatTypeData(),
                VerifiedThreats: $("#chkVerifiedThreats").attr("checked"),
                ThreatDateToStr: $("#txtDateTo").val(),
                EmployeeIDList: imageOver.GetMultiselectData(),
                StationType_ID: $("#chkMissedThreats").attr("checked") ? 2 : null
            };

            OpSemsService.ImageOverview_SelectALL(threatLog,
            function (data, textStatus) {
                imageOver.ReceivedImageOverviewData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                $('#divImageOverviews').unblock();
                return false;
            }, null);
        }
    },
    ReceivedImageOverviewData: function (data) {
        var thegrid = $("#tblImageOverviews");
        thegrid.clearGridData();
        this.rowCount = data.length;
        if (!this.rowCount) {
            $('#divImageOverviews').unblock();
            $("#waitplease").css({ 'display': 'none' });
        }
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    GetMultiselectData: function () {
        return $("#ddlEmployeeName").multiselect("getChecked").map(function () {
            return this.value;
        }).get();
    },
    GetMultiselectThreatTypeData: function () {
        return $("#ddlThreatType").multiselect("getChecked").map(function () {
            return this.value;
        }).get();
    },
    divImageDetails_Open: function () {
        //        $("#divImageDetails").dialog({
        //            autoOpen: true,
        //            bgiframe: true,
        //            resizable: false,
        //            closeOnEscape: true,
        //            width: 1150,
        //            height: 850,
        //            modal: true,
        //            zIndex: 50,
        //            title: $('#lblHeaderGeneralInfo').text(),
        //            position: 'top',
        //            create: function (event, ui) {
        //                $(this).block({
        //                    css: { border: '0px' },
        //                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        //                    message: ''
        //                });
        //            },
        //            open: function (type, data) {
        //                $(this).parent().appendTo("form");
        //                $(this).unblock(); $('#tabImageDetails').tabs("option", "selected", 0);
        //            },
        //            close: function () {
        //                imageOver.dataRow = null;
        //                $("#waitplease").css({ 'display': 'none' });
        //            }
        //        });        

        htmlResizablePopUp("/opeReady/Presentation/Readiness/ImageViewer.aspx", imageOver.dataRow, null, $(document).height(), $(document).width());
        return false;
    },

    DefineImageOverview_Open: function (rowData) {
        if (rowData) {
            imageOver.dataRow = rowData;
            imageOver.ImageReview(rowData, 0);
            imageOver.divImageDetails_Open();
        }
    },
    ImageReview: function (rowData, index) {
        $("#waitplease").css({ 'display': 'block' });
        $("#tabImageDetails").css({ 'height': $(window).height(), 'overflow-y': 'scroll' });
        var currdate = new Date();
        var scale = $("#ddlScaleImage").val() == undefined ? "100%" : $("#ddlScaleImage").val();
        switch (index) {
            case 0:
                $('#imgOriginalScreen').empty().removeClass('loading');
                var img = new Image();
                $(img).attr("id", "imgOrgScreen");
                $(img).css({ 'width': scale, 'height': scale });
                currdate = encodeURI(currdate.toString());
                $(img).load(function () {
                    $("#waitplease").css({ 'display': 'none' });
                    $(this).hide();
                    $('#imgOriginalScreen').empty().removeClass('loading').append(this);
                    $(this).fadeIn();
                }).error(function () {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#imgOriginalScreen').empty();
                }).attr('src', '/opeReady/Handlers/opeSems/ThreatsPicture.ashx?thlgid=' + rowData.ThreatLog_ID + "&type=b&d=" + currdate);
                break;
            case 1:
                OpSemsService.ImageOverview_Select(rowData.ThreatLog_ID, 1,
                function (data) {
                    var threatLog = JSON.parse(getMain(data)).rows;
                    $('#imgScreenerImage').empty().removeClass('loading');
                    currdate = encodeURI(currdate.toString());
                    var img = new Image();
                    $(img).attr("id", "imgScrImage");
                    $(img).css({ 'width': scale, 'height': scale });
                    $(img).load(function () {
                        $("#waitplease").css({ 'display': 'none' });
                        $('#imgScreenerImage').empty().removeClass('loading').append(this);
                        $(this).fadeIn();
                    }).error(function () {
                        $("#waitplease").css({ 'display': 'none' });
                        $('#imgScreenerImage').empty();
                    }).attr('src', '/opeReady/Handlers/opeSems/ThreatsPicture.ashx?thlgid=' + rowData.ThreatLog_ID + "&type=a&d=" + currdate);
                    imageOver.CreateToolbarA(threatLog);
                },
                function (ex) {
                }, null);
                break;
            case 2:
                OpSemsService.ImageOverview_Select(rowData.ThreatLog_ID, 2,
                function (data) {
                    var threatLog = JSON.parse(getMain(data)).rows;
                    $('#imgSearcherImage').empty().removeClass('loading');
                    currdate = encodeURI(currdate.toString());
                    var img = new Image();
                    $(img).attr("id", "imgScanImage");
                    $(img).css({ 'width': scale, 'height': scale });
                    $(img).load(function () {
                        $("#waitplease").css({ 'display': 'none' });
                        $('#imgSearcherImage').append(this);
                        $(this).fadeIn();
                    }).error(function () {
                        $("#waitplease").css({ 'display': 'none' });
                        $('#imgSearcherImage').empty();
                    }).attr('src', '/opeReady/Handlers/opeSems/ThreatsPicture.ashx?thlgid=' + rowData.ThreatLog_ID + "&type=c&d=" + currdate);
                    imageOver.CreateToolbarC(threatLog);
                },
                function (ex) {
                }, null);
                break;
        }

    },
    DownloadImages: function () {
        var arrIDs = $("#tblImageOverviews").getGridParam("selarrrow");
        if (arrIDs.length > 0) {
            OpSemsService.ThreatPictureDownload(arrIDs,
                function (data) {
                    window.location.href = '/opeReady/Handlers/opeSems/ThreatPictureDownload.ashx';
                },
                function (ex) {
                }, null);
        }
    },
    CreateToolbarA: function (threatTypes) {
        $("#divColoredButtonsA").empty();
        for (var i = 0; i < threatTypes.length; i++) {
            if (threatTypes[i].StationType_ID === 1) {
                if (threatTypes[i].IsFound) {
                    $("#divColoredButtonsA")
                        .append($("<div></div>&nbsp;")
                        .addClass("div_wrapper")
                        .append("<div class='checkedThreat' style='background-color:" + threatTypes[i].ThreatType.Color + "' >" + threatTypes[i].ThreatType.ThreatType_Name + "</div>"));
                }
                else {
                    $("#divColoredButtonsA")
                        .append($("<div></div>&nbsp;")
                        .addClass("div_wrapper")
                        .append("<div class='ColoredButtons' style='background-color:" + threatTypes[i].ThreatType.Color + "' >" + threatTypes[i].ThreatType.ThreatType_Name + "</div>"));
                }
            }

        }
    },
    CreateToolbarC: function (threatTypes) {
        $("#divColoredButtonsC").empty();
        for (var i = 0; i < threatTypes.length; i++) {
            $("#divColoredButtonsC")
                .append($("<div></div>&nbsp;")
                .addClass("div_wrapper")
                .append("<div class='ColoredButtons' style='background-color:" + threatTypes[i].ThreatType.Color + "' >" + threatTypes[i].ThreatType.ThreatType_Name + "</div>"));
        }
    },
    ScalingImages: function (tabSelected, scale) {
        switch (tabSelected) {
            case 0:
                $("#imgOrgScreen").animate({
                    width: scale,
                    height: scale
                }, 1000, function () { });
                break;
            case 1:
                $("#imgScrImage").animate({
                    width: scale,
                    height: scale
                }, 1000, function () { });
                break;
            case 2:
                $("#imgScanImage").animate({
                    width: scale,
                    height: scale
                }, 1000, function () { });
                break;
        }
        $("#imgOriginalScreen, #imgScreenerImage,#imgSearcherImage").unblock();
    },
    PopulateThreatTypeCombo: function (value) {
        $("#ddlThreatType>option").remove();
        OpSemsService.ThreatType_SelectByCategory(value,
    function (result) {
        $(result).each(function () {
            $("#ddlThreatType").append($("<option></option>").val(this['ThreatType_ID']).html(this['ThreatType_Name']));
        });
        $("#ddlThreatType").multiselect({
            multiple: true,
            minWidth: 260,
            selectedList: 5,
            height: 300,
            checkAllText: $("#hidIO_Multiselect_CheckAllText").text(),
            uncheckAllText: $("#hidIO_Multiselect_UncheckAllText").text(),
            noneSelectedText: $("#hidIO_Multiselect_NoneSelectedText").text(),
            selectedText: $("#hidIO_Multiselect_SelectedText").text()
        }).multiselect("checkAll").multiselectfilter({ label: $("#hidIO_Multiselectfilter_label").text() });
    },
    function (e) { });
        return false;
    },
    CreateUnitTree: function (userData) {
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
                            imageOver.PopulateJobsListCombo(data.rslt.obj.get(0).id);
                            imageOver.PopulationEmployeeData(data.rslt.obj.get(0).id);
                            return false;
                        });
            } catch (e) { }
        }, function (e) {
            return false;
        });
        }
    },
    PopulateJobsListCombo: function (unitID) {
        $("#ddlJobsList").addClass("ui-autocomplete-loading");
        $("#ddlJobsList>option").remove();
        unitID = unitID == "" ? 0 : parseInt(unitID);
        PQ.Admin.WebService.PQWebService.GetJobByUnitID(unitID, $("#hidIO_grtSelectJobs").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlJobsList").append($("<option></option>").val(this['Job_ID']).html(this['Job_Name']));
        });
        $("#ddlJobsList").removeClass("ui-autocomplete-loading");
    },
    function (e) { });
        $("#waitplease").css({ 'display': 'none' });
        return false;
    },

    PopulationEmployeeData: function (unitID, jobID) {
        $("#ddlEmployeeName>option").remove();
        OpSemsService.Person_SearchAll(unitID, jobID, function (data) {
            if (data) {
                $(data).each(function () {
                    $("#ddlEmployeeName").append($("<option></option>").val(this['Person_ID']).html(this['Person_FullName']));
                });
                $("#ddlEmployeeName").multiselect("refresh").multiselect("uncheckAll")
            }
            $("#waitplease").css({ 'display': 'none' });
        });
    }
};