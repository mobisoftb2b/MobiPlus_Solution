var rowCount;
var arrayIDs;

var readinessInfo = {
    availableTags: null,
    rowObject: null,
    pathSrc: null,
    speedGauge: null,
    grades: null,
    rowCount: 0
};

readinessInfo.CreateUnitTree = function (userData) {
    if (userData) {
        PQ.Admin.WebService.PQWebService.GetUnitTree(null,
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
		        if (!arrayIDs) arrayIDs = GetArrayTreeIDs(result, level);

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
								        "select_node": function (event, data) { return false; }
								    }
								}
						    }
						}).bind("loaded.jstree", function (event, data) {
						    var persent = _rtl == true ? '1%' : '99%';
						    $("li.jstree-checked[color='green']").css({ background: "transparent url('/opeReady/Resources/images/greenRing.png') " + persent + " top no-repeat", "margin-rigth": "15px" });
						    $("li.jstree-checked[color='yellow']").css({ background: "transparent url('/opeReady/Resources/images/yellowRing.png') " + persent + " top no-repeat", "margin-rigth": "15px" });
						    $("li.jstree-checked[color='red']").css({ background: "transparent url('/opeReady/Resources/images/redRing.png') " + persent + "top no-repeat", "margin-rigth": "15px" });
						}).bind("select_node.jstree", function (event, data) {
						    $("#waitplease").css({ 'display': 'block' });
						    $('#hidUnitID').val(data.rslt.obj.get(0).id);
						    $('#ddlUnit').val(readinessInfo.DisplayUnitReadinessText(data.rslt.obj.get(0).id, result));
						    $('#treeUnits').fadeOut('slow');
						    $("#ddlJobsList").val("0");
						    readinessInfo.DisplayUnitReadinessInfo(data.rslt.obj.get(0).id, readinessInfo.DisplayUnitReadinessText(data.rslt.obj.get(0).id, result));
						    readinessInfo.PopulateJobsListCombo(data.rslt.obj.get(0).id);
						    readinessInfo.DisplayUserReadinessDetals(data.rslt.obj.get(0).id, readinessInfo.DisplayUnitReadinessText(data.rslt.obj.get(0).id, result));
						    return false;
						});
		    } catch (e) {
		    }

		    $("#tblGaugesArea").css({ "opacity": "1" });
		}, function (e) {
		    return false;
		});
    }
};

readinessInfo.DisplayUnitReadinessInfo = function (unitID, unitText) {
    if (unitText) $("#lblHeaderFieldset").text(unitText);
    if (unitID) {
        $("#hidUnitID").val(unitID);
        $("#lblHeaderGraph").text(unitText);
        $('#rightChartsPanel').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.9 },
            message: ''
        });
        readinessInfo.ChartUnitReadinessInfoPie(unitID);
        readinessInfo.ChartUnitReadinessInfoLower(unitID);
        PQ.Admin.WebService.ReadinessWebService.UnitReadiness_SelectByUnitID(parseInt(unitID),
			function (result) {
			    if (result) {
			        $("#frmGaugesMain").attr("src", pathSrcMain + "?gg=" + result.UnitReadiness_Score + "&ars=" + ColorAreaSelector(result.ReadinessLevelID));
			        $("#waitplease").css({ 'display': 'none' });
			        $("#divChartArea").css({ 'display': 'block' });
			        $('#rightChartsPanel').unblock();
			    }
			    return false;
			},
			function (e) {
			    return false;
			});
    }
};

readinessInfo.DisplayUnitReadinessText = function (id, xml) {
    var _result;
    var _xml = $.parseXML(xml);
    $(_xml).find("item").filter(function () {
        return $(this).attr("id") === id;
    }).each(function () {
        _result = $(this).find("details").attr("unitName");
    });
    return _result;
};
readinessInfo.ChartUnitReadinessInfoPie = function (unitID) {
    $("#divPieChart").empty().addClass("loading");
    var img = new Image(280, 250);
    $(img).attr("id", unitID);
    $(img).attr("src", "/opeReady/Handlers/ReadinessStatusHandlers/UnitChartReadinessStatus.ashx?uid=" + unitID);
    $("#divPieChart").fadeIn('1000').append(img).removeClass("loading");
    return false;
}

readinessInfo.ChartUnitReadinessInfoLower = function (unitID) {
    $("#chrtUnitReadinessLower").empty();
    var img = new Image();
    $(img).attr("id", unitID);
    $(img).attr("src", "/opeReady/Handlers/ReadinessStatusHandlers/LowerUnitReadinessStatusChart.ashx?uid=" + unitID);
    $("#chrtUnitReadinessLower").fadeIn('1000').append(img).removeClass("loading");
    return false;
}

readinessInfo.DisplayJobReadinessInfo = function (unitID, jobID, JobText) {
    if (jobID) {
        $("#hidJobID").val(jobID);
        if (jobID > 0) {
            $("#lblHeaderGraph").text(JobText);
            if (JobText) $("#lblHeaderFieldset").text(JobText);
        }
        $('#rightChartsPanel').block({
            css: { border: '0px' },
            timeout: 500,
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.9 },
            message: ''
        });
        readinessInfo.ChartJobReadinessInfoPie(unitID, jobID);
        readinessInfo.ChartJobReadinessInfoLower(unitID, jobID);
        PQ.Admin.WebService.ReadinessWebService.JobReadiness_SelectByID(parseInt(unitID), parseInt(jobID),
			function (result) {
			    if (result) {
			        $("#frmGaugesMain").attr("src", pathSrcMain + "?gg=" + result.JobReadiness_Score + "&ars=" + ColorAreaSelector(result.ReadinessLevelID));
			    }
			    return false;
			},
			function (e) {
			    return false;
			});
    }
};

readinessInfo.GetReadinessDetails = function () {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.ReadinessWebService.PersonReadiness_Select(pid.eid,
		function (result) {
		    if (result) {
		        $("#txtReadinessAcception").text(result.PersonReadiness_Remarks);
		        $("#txtAdminAlert").text(result.AdministrativeAlert);
		        $("#frmGauges").attr("src", employeePages.pathSrc + "?gg=" + ColorAreaSelector(result.ReadinessLevel_ID));
		    } else {
		        $("#frmGauges").attr("src", employeePages.pathSrc + "?gg=" + 5);
		    }

		},
		function (e) { },
		null);
    }
    return false;
}

readinessInfo.ChartJobReadinessInfoPie = function (unitID, jobID) {
    $("#divPieChart").empty().addClass("loading");
    var img = new Image(280, 250);
    $(img).attr("id", jobID);
    $(img).attr("src", "/opeReady/Handlers/ReadinessStatusHandlers/JobPieReadinessStatus.ashx?jid=" + jobID + "&uid=" + unitID);
    $("#divPieChart").fadeIn('1000').append(img).removeClass("loading");
    return false;
};

readinessInfo.ChartJobReadinessInfoLower = function (unitID, jobID) {
    $("#chrtUnitReadinessLower").empty();
    var img = new Image(670, 350);
    $(img).attr("id", jobID);
    $(img).attr("src", "/opeReady/Handlers/ReadinessStatusHandlers/JobLowerChartReadinessStatus.ashx?jid=" + jobID + "&uid=" + unitID);
    $("#chrtUnitReadinessLower").append(img).fadeIn('slow').removeClass("loading");
    return false;
};

readinessInfo.ChrtReadinessStatusHistory = function (personID) {
    $("#divChrtReadinessHistory").empty();
    var img = new Image(715, 350);
    $(img).attr("id", personID);
    $(img).attr("src", "/opeReady/Handlers/ChrtReadinessStatusHistory.ashx?eid=" + personID);
    $("#divChrtReadinessHistory").fadeIn('slow').append(img).removeClass("loading");
    return false;
};

readinessInfo.DisplayUserReadinessDetals = function (unitID, headerText) {
    if (unitID) {
        $('#divUserDetails').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.9 },
            message: '<img src="/opeReady/Resources/images/ajax-loader.gif" />'
        });
        $("#lblHeaderUserDetails").text(headerText);
        $("#divHeaderUserInfo").removeClass("readinessRed");
        $("#lblUserGreen, #lblUserYellow, #lblUserRed").empty();
        PQ.Admin.WebService.ReadinessWebService.UnitReadiness_SelectByUnitIDForUpperPie(unitID,
		function (result) {
		    $('#divUserDetails').unblock();
		    if ($(result).length > 0) {
		        $("#divUserDetails").fadeIn(500)
		        $(result).each(function () {
		            switch (this.ReadinessLevel_ID) {
		                case 1:
		                    $("#lblUserGreen").text(this.Person_Count);
		                    break;
		                case 2:
		                    $("#lblUserYellow").text(this.Person_Count);
		                    break;
		                case 3:
		                    $("#lblUserRed").text(this.Person_Count);
		                    break;
		            }
		        });
		        readinessInfo.ShowHideHeads();
		    }
		    else {
		        $("#divUserDetails").fadeOut("slow");
		        $("#lblUserGreen, #lblUserYellow, #lblUserRed").empty();
		    }

		},
		function (ex) {
		    return false;
		});

    }
};

readinessInfo.DisplayUserReadinessDetalsPerJob = function (jobID, headerText) {
    if (jobID) {
        $('#divUserDetails').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.9 },
            message: '<img src="/opeReady/Resources/images/ajax-loader.gif" />'
        });
        if (jobID > 0)
            $("#lblHeaderUserDetails").text(headerText);
        $("#lblUserGreen, #lblUserYellow, #lblUserRed").empty();
        PQ.Admin.WebService.ReadinessWebService.JobReadiness_SelectPie($("#hidUnitID").val(), jobID,
		function (result) {
		    $('#divUserDetails').unblock();
		    if ($(result).length > 0) {
		        $("#divUserDetails").fadeIn(500);
		        $(result).each(function () {
		            switch (this.ReadinessLevel_ID) {
		                case 1:
		                    $("#lblUserGreen").text(this.Person_Count);
		                    break;
		                case 2:
		                    $("#lblUserYellow").text(this.Person_Count);
		                    break;
		                case 3:
		                    $("#lblUserRed").text(this.Person_Count);
		                    break;
		            }
		        });
		        readinessInfo.ShowHideHeads();
		    }
		    else {
		        $("#divUserDetails").fadeOut("slow");
		        $("#lblUserGreen, #lblUserYellow, #lblUserRed").empty();
		    }
		},
		function (ex) {
		    return false;
		});

    }
};

readinessInfo.UserDetailReadinessInfoPerUnit = function (readinessLevelID) {
    var jobID, jobText;
    $("#waitplease").css({ 'display': 'block' });
    $("#tblHeadsEmlpoyee").GridUnload();
    var unitID = $('#hidUnitID').val();
    var unitText = $('#ddlUnit').val();
    try {
        jobID = $('#ddlJobsList').val();
        jobText = $('#ddlJobsList option:selected').text();
    } catch (e) { }
    $("#divHeaderUserInfo").removeClass("readinessGreen readinessYellow readinessRed");
    switch (readinessLevelID) {
        case 1:
            $("#divHeaderUserInfo").addClass("readinessGreen");
            break;
        case 2:
            $("#divHeaderUserInfo").addClass("readinessYellow");
            break;
        case 3:
            $("#divHeaderUserInfo").addClass("readinessRed");
            break;
    }
    $("#divUsersDetailsInfo").dialog({ autoOpen: true, resizable: true, position: ["50%", 100], closeOnEscape: true, width: '1000px', modal: true, zIndex: 50,
        open: function (type, data) {
            $(this).parent().appendTo("form");
            $(this).block({
                css: { border: '0px' },
                timeout: 200,
                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                message: ''
            });
            $("#divHeaderUserInfo").text("");
            if (jobID == "0") {
                readinessInfo.UserDetailsReadinessStatusGrid(unitID, readinessLevelID);
                $("#divHeaderUserInfo").text(unitText);
            }
            else {
                readinessInfo.UserDetailsReadinessStatusGridPerJob(jobID, readinessLevelID);
                if (jobID > 0)
                    $("#divHeaderUserInfo").text(jobText);
            }
        }
    }).dialog("open");
    return false;
};

readinessInfo.UserDetailsReadinessStatusGrid = function (unitID, readinessLevelID) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $("#tblHeadsEmlpoyee").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { readinessInfo.getEmployeeSearchData(unitID, readinessLevelID) },
        height: 400,
        autowidth: true,
        gridview: true,
        colNames: [
				"",
				$('#hidEmpSearch_Grid_lblEmployeeID').text(),
				$('#hidEmpSearch_Grid_lblFirstName').text(),
				$('#hidEmpSearch_Grid_lblLastName').text(),
				$('#hidEmpSearch_Grid_PersonReadiness_Remarks').text()],
        colModel: [
				{ name: 'Photo', index: 'Photo', formatter: imageFormatter, width: 35, align: 'center', classes: 'headsEmlpoyee', sortable: false },
				{ name: 'Person_ID', index: 'Person_ID', sortable: true, key: true, classes: 'headsEmlpoyee', sorttype: 'number', width: 50 },
				{ name: 'Person_FirstName', index: 'Person_FirstName', classes: 'headsEmlpoyee', sortable: true, sorttype: 'text', width: 80 },                                                                       //1
				{name: 'Person_LastName', index: 'Person_LastName', sortable: true, classes: 'headsEmlpoyee', sorttype: 'text', width: 80 },
				{ name: 'PersonReadiness_Jobs_Remarks', index: 'PersonReadiness_Jobs_Remarks', title: false, formatter: backgroundFormatter, sortable: true, sorttype: 'text', width: 300 }
			],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
        viewrecords: true,
        rowNum: 10000,
        loadonce: true,
        altRows: true,
        hoverrows: false,
        pager: '#pgrEmlpoyee',
        recordpos: 'left',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' }); //   
            if (rowCount == $(this).getGridParam('records')) {
                readinessInfo.imagePreview();
                $("#waitplease").css({ 'display': 'none' });
            }
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            window.open("/opeReady/Presentation/Employee/EmployeeDetails.aspx?eid=" + $(this).getRowData(rowid).Person_ID, "_blank");
        }
    });
    $("#tblHeadsEmlpoyee").jqGrid('gridResize', { minWidth: 555, minHeight: 300 });
};

function imageFormatter(cellvalue, options, rowObject) {
    var img = new Image(40, 50);
    $(img).attr("id", rowObject.Person_ID);
    $(img).attr("src", "/opeReady/Handlers/PhotoHandler.ashx?eid=" + rowObject.Person_ID);
    $(img).attr("class", "tooltip");
    return img.outerHTML || new XMLSerializer().serializeToString(img);
};

readinessInfo.imagePreview = function () {
    /* CONFIG */
    xOffset = 200;
    yOffset = 30;
    /* END CONFIG */
    $(".tooltip").hover(function (e) {
        this.t = this.title;
        this.title = "";
        var c = (this.t != "") ? "<br/>" + this.t : "";
        $("body").append("<p id='preview'><img src='" + this.src + "' width='145px' />" + c + "</p>");
        $("#preview")
			.css("top", (e.pageY - xOffset) + "px")
			.css("left", (e.pageX + yOffset) + "px")
			.css("z-index", 10000)
			.fadeIn("fast");
    },
	function () {
	    this.title = this.t;
	    $("#preview").remove();
	});
    $(".tooltip").mousemove(function (e) {
        $("#preview")
			.css("top", (e.pageY - xOffset) + "px")
			.css("left", (e.pageX + yOffset) + "px");
    });
};

readinessInfo.UserDetailsReadinessStatusGridPerJob = function (jobID, readinessLevelID) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $("#tblHeadsEmlpoyee").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { readinessInfo.getEmployeeSearchDataPerJob(jobID, readinessLevelID) },
        height: 400,
        autowidth: true,
        gridview: true,
        colNames: [
				"",
				$('#hidEmpSearch_Grid_lblEmployeeID').text(),
				$('#hidEmpSearch_Grid_lblFirstName').text(),
				$('#hidEmpSearch_Grid_lblLastName').text(),
				$('#hidEmpSearch_Grid_PersonReadiness_Remarks').text()],
        colModel: [
				{ name: 'Photo', index: 'Photo', formatter: imageFormatter, width: 35, align: 'center', classes: 'personPopup rowup', sortable: false },
				{ name: 'Person_ID', index: 'Person_ID', sortable: true, key: true, sorttype: 'number', classes: 'rowup', width: 50 },
				{ name: 'Person_FirstName', index: 'Person_FirstName', sortable: true, sorttype: 'text', classes: 'rowup', width: 80 },                                                                       //1
				{name: 'Person_LastName', index: 'Person_LastName', sortable: true, sorttype: 'text', classes: 'rowup', width: 80 },
				{ name: 'PersonReadiness_Jobs_Remarks', index: 'PersonReadiness_Jobs_Remarks', title: false, classes: 'rowup', sortable: true, sorttype: 'text', formatter: backgroundFormatter, width: 300 }
			],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
        viewrecords: true,
        rowNum: 10000,
        loadonce: true,
        altRows: true,
        hoverrows: false,
        pager: '#pgrEmlpoyee',
        recordpos: 'left',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' }); //   
            if (rowCount == $(this).getGridParam('records')) {
                readinessInfo.imagePreview();
                $("#waitplease").css({ 'display': 'none' });
                rowCount = 0;
            }
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            window.open("/opeReady/Presentation/Employee/EmployeeDetails.aspx?eid=" + $(this).getRowData(rowid).Person_ID, "_blank");
        }
    });
    $("#tblHeadsEmlpoyee").jqGrid('gridResize', { minWidth: 555, minHeight: 300 });
}
readinessInfo.getEmployeeSearchData = function (unitID, readinessLevelID) {
    var personInfo = {
        ReadinessLevel_ID: readinessLevelID,
        UnitID: unitID,
        IsActive: true
    };
    PQ.Admin.WebService.EmployeeSearchWS.EmployeeSearch(personInfo,
			function (data, textStatus) {
			    readinessInfo.ReceivedEmployeeSearchData(JSON.parse(readinessInfo.getMain(data)).rows);
			}, function (data, textStatus) {

			});
};

readinessInfo.getEmployeeSearchDataPerJob = function (jobID, readinessLevelID) {
    var personInfo = {
        ReadinessLevel_ID: readinessLevelID,
        Job_ID: jobID,
        IsActive: true
    };
    PQ.Admin.WebService.EmployeeSearchWS.EmployeeSearch(personInfo,
			function (data, textStatus) {
			    readinessInfo.ReceivedEmployeeSearchData(JSON.parse(readinessInfo.getMain(data)).rows);
			}, function (data, textStatus) {
			    alert('An error has occured retrieving data!');
			});
};

readinessInfo.ReceivedEmployeeSearchData = function (data) {
    var thegrid = $("#tblHeadsEmlpoyee");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

readinessInfo.getMain = function (dObj) {
    if (dObj.hasOwnProperty('d'))
        return dObj.d;
    else
        return dObj;
};

function backgroundFormatter(cellvalue, options, rowObject) {
    var tempValue = cellvalue == null ? "" : cellvalue.trim();
    if (tempValue.length > 200)
        return "<div>" + tempValue + "</div>";
    else
        return tempValue;
};

readinessInfo.ShowHideHeads = function () {
    if ($("#lblUserGreen").text() == "")
        $("#trDefaultUserGreen").fadeOut();
    else
        $("#trDefaultUserGreen").fadeIn();

    if ($("#lblUserYellow").text() == "")
        $("#trDefaultUserYellow").fadeOut();
    else
        $("#trDefaultUserYellow").fadeIn();

    if ($("#lblUserRed").text() == "")
        $("#trDefaultUserRed").fadeOut();
    else
        $("#trDefaultUserRed").fadeIn();
};

readinessInfo.PopulateJobsListCombo = function (unitID) {
    $("#ddlJobsList").addClass("ui-autocomplete-loading");
    $("#ddlJobsList>option").remove();
    unitID = unitID == "" ? 0 : unitID;
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
}

