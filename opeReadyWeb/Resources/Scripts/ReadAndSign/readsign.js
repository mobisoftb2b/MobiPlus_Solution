/// <reference path="../Common/_references.js" />
/// <reference path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
var rowCount;


$(function () {
    if ($.cookie("lang"))
        $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
    else
        $.datepicker.setDefaults($.datepicker.regional['']);
    readsign.CreateReadSignCollectionGrid();

});

$(document).bind('click', function (e) {
    var $clicked = $(e.target); if (!$clicked.parents().hasClass("treeUnitsEdit"))
        $("#treeUnits, #treeUnitsSec,#divPerson2Unit").hide();
});

$("#ddlUnit").live("click", function () {
    if ($('#treeUnits').is(':visible')) {
        $('#treeUnits').fadeOut('slide');
    }
    else {
        $('#treeUnits').fadeIn('slide');
        readsign.CreateUnitTree();
    }
    return false;
});
$("#txtUnit").live("click", function () {
    if ($('#treeUnitsSec').is(':visible')) {
        $('#treeUnitsSec').fadeOut('slide');
    }
    else {
        $('#treeUnitsSec').fadeIn('slide');
        readsign.CreateUnitTreeDetails();
    }
    return false;
});
$("#btnFilter").live("click", function () {
    $("#tblReadSign").GridUnload();
    readsign.CreateReadSignCollectionGrid();
});
$("#btnAddNewReadSign").live("click", function () {
    if (readsign.RequaredFeilds())
        readsign.UpdateReadSignDetails();
    return false;
});
$("#btnSearch").live("click", function () {
    RaiseLoader(true);
    var person = {
        Person_FirstName: $('#txtFirstName').val(),
        Person_LastName: $('#txtLastName').val(),
        Job_ID: $('#ddlJob').val(),
        UnitID: $('#hidReadAndUnitID').val(),
        IsActive: true,
        IsReadiness: true
    };
    $("#tlbEmlpoyee").GridUnload();
    readsign.GetEmlpoyeeGrid(person);
});
$("#txtPerson2Unit").live("click", function () {
    if ($('#divPerson2Unit').is(':visible')) {
        $('#divPerson2Unit').fadeOut('slide');
    }
    else {
        $('#divPerson2Unit').fadeIn('slide');
        readsign.CreatePersonUnitTree();
    }
    return false;
});
$("#btnAddEmployee").live("click", function () {
    readsign.GetSelectedEmployeeIDs();
});
$("#txtInitDate").change(function () {
    if ($(this).val() != "")
        $(this).removeClass('ui-state-error', 100);
});
$("#txtExpireDate").change(function () {
    if ($(this).val() != "")
        $(this).removeClass('ui-state-error', 100);
});
$("#txtTitle").change(function () {
    if ($(this).val() != "")
        $(this).removeClass('ui-state-error', 100);
});
var readsign = {
    availableTags: null,
    rowObject: null,
    selectedID: null,
    CreateUnitTree: function () {
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
                    $('#treeUnits').jstree(
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
                        $('#hidUnitID').val(data.rslt.obj.get(0).id);
                        $('#ddlUnit').val($(data.rslt.obj.find("a").get(0)).text());
                        $('#treeUnits').fadeOut('slow');
                        $('#ddlUnit').removeClass('ui-state-error', 100);
                        return false;
                    });
                } catch (e) {
                }
            }
        }, function () {
        });
    },
    CreateUnitTreeDetails: function () {
        window.PQ.Admin.WebService.PQWebService.GetUserMenu(null,
        function (result) {
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
                    $('#treeUnitsSec').jstree(
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
                        $('#hidUnitIDSec').val(data.rslt.obj.get(0).id);
                        $('#txtUnit').val($(data.rslt.obj.find("a").get(0)).text());
                        $('#treeUnitsSec').fadeOut('slow');
                        $('#txtUnit').removeClass('ui-state-error', 100);
                        return false;
                    });
                } catch (e) {
                }
            }
        }, function () {
        });
    },
    CreateReadSignCollectionGrid: function (result) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divResultPanel').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var readSignGrid = $("#tblReadSign").jqGrid({
            direction: langDir,
            datatype: function () { readsign.GetReadSignCollectionData(result); },
            height: 400,
            autowidth: false,
            colNames: [
                $('#hidReadSign_Grid_lblInitDate').text(), $('#hidReadSign_Grid_lblExpirationDate').text(), $('#hidReadSign_Grid_Title').text(),
                $('#hidReadSign_Grid_lblAssignedEmployees').text(), $('#hidReadSign_Grid_lblSignedEmployees').text(), $('#hidReadSign_btnEdit').text(),
                $('#hidReadSign_btnDelete').text(), ''],
            colModel: [
                { name: 'InitDate', index: 'InitDate', sortable: true, width: 200, align: 'center', formatter: utcDateFormatter },
                { name: 'ExpireDate', index: 'ExpireDate', sortable: true, width: 200, align: 'center', formatter: utcDateFormatter },
                { name: 'Title', index: 'Title', sortable: true, width: 200, align: 'center' },
                { name: 'AssinedEmployees', index: 'AssinedEmployees', sortable: true, width: 150, align: 'center' },
                { name: 'SignedEmployees', index: 'SignedEmployees', sortable: true, width: 150, align: 'center' },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteRSFormatter, width: 32, align: 'center' },
                { name: 'ReadAndSignID', hidden: 'true', key: true }
            ],
            gridview: true,
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            hoverrows: false,
            toolbar: [true, "top"],
            pager: '#pgrReadSign',
            pgbuttons: false,
            rowNum: 20000,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divResultPanel').unblock();
                }
            },
            onCellSelect: function (rowid, iCol) {
                switch (iCol) {
                    case 5:
                        readsign.GetReadSignDetails($(this).getRowData(rowid).ReadAndSignID);
                        break;
                    case 6:
                        if ($(this).getRowData(rowid).AssinedEmployees > 0 || $(this).getRowData(rowid).SignedEmployees > 0 || $(this).getRowData(rowid).RDS_AttachedItems > 0) {
                            return false;
                        } else {
                            readsign.ReadSign_Delete($(this).getRowData(rowid).ReadAndSignID);
                        }
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid) {
                readsign.GetReadSignDetails($(this).getRowData(rowid).ReadAndSignID);
            }
        });
        readSignGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        readSignGrid
          .toolbarButtonAdd("#t_tblReadSign",
		{
		    caption: $('#hidReadSign_btnAdd').text(),
		    position: "first",
		    align: (langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function () {
		        $("#btnAddNewReadSign").val($("#hidReadSign_btnAddReadSign").text());
		        $("#hidReadAndSignID").val("");
		        $("#txtUnit").val("");
		        $("#hidUnitIDSec").val("");
		        $("#txtInitDate").val("");
		        $("#txtExpireDate").val("");
		        $("#txtTitle").val("");
		        $("#txtRemarks").val("");
		        $("#lblUseName").text("");
		        $("#tblPersons, #tblRSAttachment").GridUnload();
		        readsign.CreateReadSign2PersonGrid(null);
		        readsign.CreateReadSignAttachmentGrid(null);
		        readsign.OpenReadSignAssignment();
		    }
		});
    },
    GetReadSignCollectionData: function (result) {
        if (!result) {
            var uid = $("#hidUnitID").val() == "" ? null : parseInt($("#hidUnitID").val());
            try {
                ReadSignsService.ReadSign_Select(uid, $("#chkIsActive").attr("checked"),
                function (data) {
                    readsign.ReceivedReadSignCollectionData(JSON.parse(getMain(data)).rows);
                }, function () {
                    return false;
                }, null);
            } catch (e) {
                return false;
            }
        } else {
            readsign.ReceivedReadSignCollectionData(result);
        }
        return false;
    },
    ReceivedReadSignCollectionData: function (data) {
        var thegrid = $("#tblReadSign");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) { $('#divResultPanel').unblock(); $("#waitplease").css({ 'display': 'none' }); }
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    GetReadSignDetails: function (readAndSignId) {
        if (readAndSignId) {
            $("#btnAddNewReadSign").val($("#hidReadSign_btnUpdateReadSign").text());
            ReadSignsService.ReadAndSign_SelectDetails(readAndSignId,
                function (data) {
                    if (data) {
                        $("#hidReadAndSignID").val(data.ReadAndSignID);
                        $("#txtUnit").val(data.UnitName);
                        $("#hidUnitIDSec").val(data.UnitID);
                        $("#txtInitDate").val(utcDateFormatter(data.InitDate));
                        $("#txtExpireDate").val(utcDateFormatter(data.ExpireDate));
                        $("#txtTitle").val(data.Title);
                        $("#txtRemarks").val(data.Remarks);
                        $("#lblUseName").text(data.UserName);
                        $("#tblPersons, #tblRSAttachment").GridUnload();
                        readsign.CreateReadSign2PersonGrid(data.ReadSign2Persons);
                        readsign.CreateReadSignAttachmentGrid(data.ReadSignAttachmentses);
                    }
                    readsign.OpenReadSignAssignment();
                },
                function (ex) {
                    return false;
                });

        }
    },
    UpdateReadSignDetails: function () {
        RaiseLoader(true);
        var paramm = {
            ReadAndSignID: $("#hidReadAndSignID").val() == "" ? null : parseInt($("#hidReadAndSignID").val()),
            UnitID: $("#hidUnitIDSec").val() == "" ? null : parseInt($("#hidUnitIDSec").val()),
            InitDateStr: $("#txtInitDate").val(),
            ExpireDateStr: $("#txtExpireDate").val(),
            Remarks: $("#txtRemarks").val(),
            Title: $("#txtTitle").val()
        };
        ReadSignsService.ReadAndSign_UpdateDetails(paramm,
            function (result) {
                $("#hidReadAndSignID").val(result[0].ReadAndSignID);
                $("#tblReadSign").GridUnload();
                readsign.CreateReadSignCollectionGrid(null);
                readsign.GetReadSignDetails(result[0].ReadAndSignID);
            },
            function (ex) {
                return false;
            },
         null);
    },
    OpenReadSignAssignment: function () {
        $("#divReadSignDetails").dialog({ autoOpen: true, bgiframe: true, resizable: true, closeOnEscape: true, width: '800px', modal: true, zIndex: 50,
            title: $('#hidReadSign_HeaderDefine').text(),
            create: function (event, ui) {
                $(this).block({
                    css: { border: '0px' },
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
            },
            open: function (type, data) {
                $(this).parent().appendTo("form");
                $(this).unblock();
            }
        });
    },
    ReadSign_Delete: function (readAndSignId) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    RaiseLoader(true);
                    try {
                        var readAndSign = {
                            ReadAndSignID: parseInt(readAndSignId),
                            UnitID: $("#hidUnitID").val() == "" ? null : parseInt($("#hidUnitID").val()),
                            IsActive: $("#chkIsActive").attr("checked")
                        };
                        ReadSignsService.ReadAndSign_Delete(readAndSign,
                                function (result) {
                                    $("#tblReadSign").GridUnload();
                                    readsign.CreateReadSignCollectionGrid(JSON.parse(getMain(result)).rows);
                                    RaiseLoader(false);
                                    $("#ConfirmDeleteAttachment").dialog('destroy');
                                },
                                function (ex) {
                                    return false;
                                }, null);
                    } catch (e) {
                        return false;
                    }
                    return false;
                },
                Cancel: function (e) {
                    e.preventDefault();
                    $(this).dialog('destroy');
                    return false;
                }
            }
        });
        return false;
    },
    //------------------------------------------------------Read & Sign 2 Person --------------------------------------------------
    CreateReadSign2PersonGrid: function (value) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divPersons').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var readSignGrid = $("#tblPersons").jqGrid({
            direction: langDir,
            datatype: function () { readsign.GetReadSign2PersonData(value); },
            height: 200,
            width: 750,
            colNames: [
                $('#hidReadSign_Grid_PersonID').text(), $('#hidReadSign_Grid_FirstsName').text(),
                $('#hidReadSign_Grid_LastName').text(), $('#hidReadSign_Grid_SignatureDate').text(),
                $('#hidReadSign_btnDelete').text(), ''],
            colModel: [
                { name: 'Person_ID', index: 'Person_ID', key: true, sortable: true, width: 50, align: 'center', formatter: coloredFontFormatter },
                { name: 'Person_FirstName', index: 'Person_FirstName', sortable: true, width: 100, align: 'center', formatter: coloredFontFormatter },
                { name: 'Person_LastName', index: 'Person_LastName', sortable: true, width: 100, align: 'center', formatter: coloredFontFormatter },
                { name: 'SignatureDate', index: 'SignatureDate', sortable: true, width: 50, align: 'center', formatter: utcDateFormatter },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 32, align: 'center' },
                { name: 'Person_ID', hidden: 'true', key: true }
            ],
            gridview: true,
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            hoverrows: false,
            toolbar: [$('#hidReadAndSignID').val() == "" ? false : true, "top"],
            pager: '#pgrPersons',
            pgbuttons: false,
            rowNum: 20000,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divPersons').unblock();
                }
            },
            onCellSelect: function (rowid, iCol) {
                switch (iCol) {
                    case 4:
                        readsign.ReadSign2Person_Delete($(this).getRowData(rowid).Person_ID);
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid) {

            }
        });
        readSignGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        readSignGrid
          .toolbarButtonAdd("#t_tblPersons",
		{
		    caption: $('#hidReadSign_btnAdd').text(),
		    position: "first",
		    align: (langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function () {
		        readsign.AddingPersons2ReadSign();
		    }
		});
    },
    GetReadSign2PersonData: function (data) {
        try {
            var thegrid = $("#tblPersons");
            thegrid.clearGridData();
            rowCount = data.length;
            if (!rowCount) {
                $('#divPersons').unblock();
                $("#waitplease").css({ 'display': 'none' });
            }
            for (var i = 0; i < data.length; i++)
                thegrid.addRowData(i + 1, data[i]);
        } catch (e) {
            $('#divPersons').unblock();
            return false;
        }
        return false;
    },
    AddingPersons2ReadSign: function () {
        $("#divEmployeeForReadSign").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, width: '1024px', modal: true, zIndex: 50,
            open: function (event, ui) {
                $(this).parent().appendTo("form");
                $("#tlbEmlpoyee").GridUnload();
            }
        });
    },
    GetSelectedEmployeeIDs: function () {
        var arrIDs = new Array();
        var persons = new Array();
        RaiseLoader(true);
        arrIDs = $("#tlbEmlpoyee").getGridParam("selarrrow");
        if (arrIDs[0] == undefined) arrIDs[0] = "0";
        try {
            $(arrIDs).each(function () {
                var tempPerson = $("#tlbEmlpoyee").getRowData(this);
                try {
                    if (tempPerson.Person_ID != undefined) {
                        persons.push({
                            Person_FirstName: tempPerson.Person_FirstName,
                            Person_LastName: tempPerson.Person_LastName,
                            Person_ID: tempPerson.Person_ID,
                            ReadAndSignID: $("#hidReadAndSignID").val()
                        });
                    }
                } catch (ex) { }

            });
            try {
                ReadSignsService.ReadAndSign2Person_Save(persons,
				function (result) {
				    if (result) {
				        $("#tblPersons").GridUnload();
				        readsign.CreateReadSign2PersonGrid(JSON.parse(getMain(result)).rows);
				        $('#divEmployeeForReadSign').dialog('destroy');
				    }
				    $("#waitplease").css({ 'display': 'none' });
				}, function (er) {
				    $("#waitplease").css({ 'display': 'none' });
				    $('#divEmployeeForEvent').dialog('destroy');
				});
            } catch (e) { }
        } catch (e) { }
    },
    GetEmlpoyeeGrid: function (persons) {
        var langDir = "ltr";
        var lastsel;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $("#tlbEmlpoyee").jqGrid({
            direction: langDir,
            datatype: function (pdata) { readsign.GetEmlpoyeeListData(persons); },
            height: 375,
            width: 950,
            colNames: [
                $('#hidReadSign_Search_Grid_PersonID').text(), $('#hidReadSign_Search_Grid_FirstsName').text(),
				$('#hidReadSign_Search_Grid_LastName').text(), $('#hidReadSign_Search_Grid_Job_Name').text(), $('#hidReadSign_Search_Grid_Unit_Name').text()
			],
            colModel: [
				{ name: 'Person_ID', index: 'Person_ID', key: true, sortable: true, sorttype: 'int', width: 100 },
				{ name: 'Person_FirstName', index: 'Person_FirstName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Person_LastName', index: 'Person_LastName', sortable: true, sorttype: 'text', width: 100 },
                { name: 'Job_Name', index: 'Job_Name', sortable: true, sorttype: 'text', width: 100 },
                { name: 'Unit_Name', index: 'Unit_Name', sortable: true, sorttype: 'text', width: 100 }
			],
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: true,
            recordpos: 'left',
            rowNum: 10000,
            pager: '#pgrEmployee',
            pgbuttons: false,
            pginput: false,
            multiselect: true,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local' });
                var ids = $(this).jqGrid('getDataIDs');
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $(this).trigger('reloadGrid');
                    $(this).jqGrid('sortGrid', "Person_ID", true);
                    rowCount = 0;
                }
            },
            onSelectAll: function (rowid, e) {
                if (e) readsign.selctedID = rowid;
                else readsign.selctedID = null;
                return false;
            },
            onSelectRow: function (id) {
                if (id && id !== lastsel) {
                    $(this).jqGrid('restoreRow', lastsel);
                    $(this).jqGrid('editRow', id, true);
                    lastsel = id;
                }
            }
        });
        $("#tlbEmlpoyee").jqGrid('gridResize', { minWidth: 900, minHeight: 300 });

    },
    GetEmlpoyeeListData: function (person) {
        if (person) {
            var man = new Array();
            try {
                var temp = $("#tblPersons").getDataIDs();
                $(temp).each(function () {
                    var tempPerson = $("#tblPersons").getRowData(this);
                    man.push(tempPerson.Person_ID);
                });

                PQ.Admin.WebService.EmployeeSearchWS.EmployeeSearching(person, man,
			function (data) {
			    readsign.ReceivedEmployeeListData(JSON.parse(getMain(data)).rows);
			}, function (data, textStatus) {
			    RaiseWarningAlert('An error has occured retrieving data!');
			});
            } catch (e) { }
        }
    },
    ReceivedEmployeeListData: function (data) {
        var thegrid = $("#tlbEmlpoyee");
        thegrid.clearGridData();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    CreatePersonUnitTree: function () {
        window.PQ.Admin.WebService.PQWebService.GetUserMenu(null,
        function (result) {
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
                    $('#divPerson2Unit').jstree(
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
                        $('#hidReadAndUnitID').val(data.rslt.obj.get(0).id);
                        $('#txtPerson2Unit').val($(data.rslt.obj.find("a").get(0)).text());
                        $('#divPerson2Unit').fadeOut('slow');
                        $('#txtPerson2Unit').removeClass('ui-state-error', 100);
                        readsign.PopulateJobsListCombo(data.rslt.obj.get(0).id);
                        return false;
                    });
                } catch (e) {
                }
            }
        }, function () {
        });
    },
    PopulateJobsListCombo: function (unitId) {
        $("#ddlJob").addClass("ui-autocomplete-loading");
        $("#ddlJob>option").remove();
        unitId = unitId == "" ? 0 : unitId;
        try {
            PQ.Admin.WebService.PQWebService.GetJobByUnitID(unitId, $("#hidReadSign_grtSelectJobs").text(),
			function (result) {
			    $(result).each(function () {
			        $("#ddlJob").append($("<option></option>").val(this['Job_ID']).html(this['Job_Name']));
			    });
			    $("#ddlJob").removeClass("ui-autocomplete-loading");
			},
			function (e) { });
        } catch (ex) { }
        RaiseLoader(false);

        return false;
    },
    //------------------------------------------------------Read & Sign Attachment --------------------------------------------------
    CreateReadSignAttachmentGrid: function (value) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divRSAttachment').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var readSignGrid = $("#tblRSAttachment").jqGrid({
            direction: langDir,
            datatype: function () { readsign.GetReadSignAttachmentData(value); },
            height: 120,
            width: 750,
            colNames: [
                $('#hidReadSign_Grid_AttachmentsName').text(), $('#hidReadSign_btnEdit').text(), $('#hidReadSign_btnDelete').text(), ''],
            colModel: [
                { name: 'AttachmentsName', index: 'AttachmentsName', sortable: true, width: 80, align: 'center', formatter: 'date' },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 32, align: 'center' },
                { name: 'AttachmentsID', hidden: 'true', key: true }
            ],
            gridview: true,
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            hoverrows: false,
            toolbar: [$('#hidReadAndSignID').val() == "" ? false : true, "top"],
            pager: '#pgrRSAttachment',
            pgbuttons: false,
            rowNum: 20000,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divRSAttachment').unblock();
                }
            },
            onCellSelect: function (rowid, iCol) {
                switch (iCol) {
                    case 1:
                        readsign.ReadSignAttach_Download($(this).getRowData(rowid).AttachmentsID);
                        break;
                    case 2:
                        readsign.DeleteAttacment($(this).getRowData(rowid).AttachmentsID);
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid) {
                // add handler
            }
        });
        readSignGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        readSignGrid
          .toolbarButtonAdd("#t_tblRSAttachment",
		{
		    caption: $('#hidReadSign_btnAdd').text(),
		    position: "first",
		    align: (langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function () {
		        readsign.FileUpload_Open();
		    }
		});
    },
    GetReadSignAttachmentData: function (data) {
        try {
            var thegrid = $("#tblRSAttachment");
            thegrid.clearGridData();
            rowCount = data.length;
            if (!rowCount) {
                $('#divRSAttachment').unblock();
                $("#waitplease").css({ 'display': 'none' });
            }
            for (var i = 0; i < data.length; i++)
                thegrid.addRowData(i + 1, data[i]);
        } catch (e) {
            $('#divRSAttachment').unblock();
            return false;
        }
        return false;
    },
    FileUpload_Open: function () {
        var attachmentsFileName;
        $("#divFileUpload").dialog({ autoOpen: true, closeOnEscape: true, width: '400px', modal: true, zIndex: 20,
            title: $('#hidReadSign_Header_Attachment').text(),
            open: function (type, data) {
                $("#txtReadSignAttachName").val("");
                $(this).parent().appendTo("form");
                $(this).block({
                    css: { border: '0px' },
                    timeout: 100,
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
                $("#btnRSUpload").removeAttr("disabled", 100);
                // clearContents();
                var button = $('#btnBrowse');
                var upload = new AjaxUpload(button, {
                    action: '/opeReady/Handlers/ReadSign/ReadSignFileUpload.ashx',
                    name: 'myfile',
                    autoSubmit: false,
                    onChange: function (file, ext) {
                        if (!checkNotAllowedFileExtension(null, ext)) {
                            $("#btnRSUpload").attr("disabled", true);
                        }
                        else { $("#btnRSUpload").removeAttr("disabled", 100); }
                        attachmentsFileName = file;
                        $("#lblPhotoFileName").block({
                            css: { border: '0px' },
                            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                            message: ''
                        });
                        setTimeout(function () { $("#lblFileName").unblock().text(file); }, 500);
                    },
                    onSubmit: function () {
                        RaiseLoader(true);
                        this.disable();
                    },
                    onComplete: function () {
                        this.enable();
                        readsign.UploadComplete();
                        $("#waitplease").css({ 'display': 'none' });
                    }
                });


                $("#btnRSUpload").live("click", function () {
                    if (readsign.RequaredReadSignAttachFields()) {
                        upload.setData({ "AttachmentsName": $("#txtReadSignAttachName").val(), "ReadAndSignID": $("#hidReadAndSignID").val(), "AttachmentsFileName": attachmentsFileName });
                        upload.submit();
                    }
                });
            }
        });
        return false;
    },
    UploadComplete: function (sender, args) {
        ReadSignsService.ReadAndSign_SelectAttachments($("#hidReadAndSignID").val(),
            function (result) {
                $("#tblRSAttachment").GridUnload();
                readsign.CreateReadSignAttachmentGrid(JSON.parse(getMain(result)).rows);
                RaiseLoader(false);
            },
            function (ex) {
                return false;
            },
         null);
        $('#divFileUpload').dialog('destroy');
    },
    StartUpload: function (sender, args) {
        RaiseLoader(true);
        $('#btnRSUpload').attr("disabled", true);
        return false;
    },
    RequaredReadSignAttachFields: function () {
        if ($('#txtReadSignAttachName').val() == '')
            $('#txtReadSignAttachName').addClass('ui-state-error').focus();
        else {
            $('#txtReadSignAttachName').removeClass('ui-state-error', 500);
            return true;
        }
        return false;
    },
    DeleteAttacment: function (attachmentId) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    RaiseLoader(true);
                    try {
                        ReadSignsService.ReadAndSign_DeleteAttachments(attachmentId, $("#hidReadAndSignID").val(),
                                function (result) {
                                    $("#tblRSAttachment").GridUnload();
                                    readsign.CreateReadSignAttachmentGrid(JSON.parse(getMain(result)).rows);
                                    RaiseLoader(false);
                                    $("#ConfirmDeleteAttachment").dialog('destroy');
                                },
                                function (ex) {
                                    return false;
                                }, null);
                    } catch (e) {
                        return false;
                    }
                    return false;
                },
                Cancel: function (e) {
                    e.preventDefault();
                    $(this).dialog('destroy');
                    return false;
                }
            }
        });
        return false;
    },
    ReadSignAttach_Download: function (args) {
        RaiseLoader(true);
        window.location.href = '/opeReady/Handlers/ReadSign/ReadSignAttachDownload.ashx?attachid=' + args;
        $("#waitplease").css({ 'display': 'none' });
    },
    ReadSign2Person_Delete: function (personId) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    RaiseLoader(true);
                    try {
                        var params = {
                            ReadAndSignID: $("#hidReadAndSignID").val(),
                            Person_ID: personId
                        };
                        ReadSignsService.ReadAndSign2Person_DeletePerson(params,
                                function (result) {
                                    $("#tblPersons").GridUnload();
                                    readsign.CreateReadSign2PersonGrid(JSON.parse(getMain(result)).rows);
                                    RaiseLoader(false);
                                    $("#ConfirmDeleteAttachment").dialog('destroy');
                                },
                                function (ex) {
                                    return false;
                                }, null);
                    } catch (e) {
                        return false;
                    }
                    return false;
                },
                Cancel: function (e) {
                    e.preventDefault();
                    $(this).dialog('destroy');
                    return false;
                }
            }
        });
        return false;
    },
    RequaredFeilds: function () {
        var result = new Boolean(true);
        if ($("#txtUnit").val() == "") {
            $('#txtUnit').addClass('ui-state-error').focus();
            return false;
        }
        else {
            $('#txtUnit').removeClass('ui-state-error', 500);
        }
        if ($("#txtInitDate").val() == "") {
            $('#txtInitDate').addClass('ui-state-error').focus();
            return false;
        }
        else {
            $('#txtInitDate').removeClass('ui-state-error', 500);
        }
        if ($("#txtExpireDate").val() == "") {
            $('#txtExpireDate').addClass('ui-state-error').focus();
            return false;
        }
        else {
            $('#txtExpireDate').removeClass('ui-state-error', 500);
        }
        if ($("#txtTitle").val() == "") {
            $('#txtTitle').addClass('ui-state-error').focus();
            return false;
        }
        else {
            $('#txtTitle').removeClass('ui-state-error', 500);
        }
        return result;
    }
};
function deleteRSFormatter(ellvalue, options, rowObject) {
    var img;
    try {
        img = new Image(32, 32);
        if (rowObject.AssinedEmployees > 0 || rowObject.SignedEmployees > 0 || rowObject.AttachedItems > 0) {
            $(img).attr("src", "/opeReady/Resources/images/empty.png");
        }
        else {
            $(img).attr("src", "/opeReady/Resources/icons/trash.png");
            $(img).attr("style", "cursor:pointer");
        }
    } catch (e) { }
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}
function coloredFontFormatter(cellvalue, options, rowObject) {
    if (rowObject.SignatureDate != null) {
        return '<span style="color:green">' + cellvalue + '</span>';
    } else {
        return '<span style="color:red">' + cellvalue + '</span>';
    }
}
function pickdates(id) {
    jQuery("#" + id + "_SignatureDate", "#tblPersons").datepicker({ dateFormat: "dd/mm/yy" });
}
