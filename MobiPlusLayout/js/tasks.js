const task = {
    rowCount: 0,
    Init: () => {
        task.CreateGrid(null);
    },
    CreateGrid: (selected) => {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divTaskList').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var activityGrid = $("#grdTaskList").jqGrid({
            direction: langDir,
            datatype: function (pdata) { task.GetTasksData(selected); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 60,
            colNames: [
              $('#hidTaskID_Grid_Header').val(),
              $('#hidTaskType_Grid_Header').val(),
              $('#hidTaskDesc_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
              $('#hidCustomerCode_Grid_Header').val(),
              $('#hidDateFrom_Grid_Header').val(),
              $('#hidDateTo_Grid_Header').val(),                
              $('#hidCustAddress_Grid_Header').val(),
              $('#hidCustCity_Grid_Header').val(),
              '', '', '','',''
            ],
            colModel: [
                { name: 'TaskID', index: 'TaskID', sortable: true, sorttype: 'text', align: 'center', width: 40 },
                { name: 'TaskType', index: 'TaskType', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'Task', index: 'Task', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'CustomerCode', index: 'CustomerCode', sorttype: 'text', sortable: true, align: recordpos, width: 100 },
                { name: 'DateFrom', index: 'DateFrom', sortable: true, sorttype: 'text', align: 'center', width: 60, formatter: DateFormatteryyyymmdd },
                { name: 'DateTo', index: 'DateTo', sortable: true, sorttype: 'text', align: 'center', width: 60, formatter: DateFormatteryyyymmdd },                 
                { name: 'Address', index: 'Address', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'City', index: 'City', sortable: true, sorttype: 'text', align: recordpos, width: 60 },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center', search: false },
                { name: 'Del', index: 'Del', sortable: false, edittype: 'image', formatter: deleteSpecFormatter, width: 45, align: 'center', search: false },
                { name: 'TaskTypeID', hidden: 'true' }, { name: 'AgentId', hidden: 'true' }, { name: 'DateFrom', hidden: 'true', formatter: DateFormatteryyyymmdd }
            ],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: true,
            pginput: false,
            altRows: false,
            gridview: true,
            resizable: false,
            shrinkToFit: true,
            rowNum: 20000,
            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdTaskListPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (task.rowCount == $(this).getGridParam('records')) {
                    $('#divTaskList').unblock();
                }
            },
            jsonReader: {
                repeatitems: false,
                root: function (obj) { return obj; },
                page: function (obj) { return activityGrid.jqGrid('getGridParam', 'page'); },
                total: function (obj) { return Math.ceil(obj.length / activityGrid.jqGrid('getGridParam', 'rowNum')); },
                records: function (obj) { return obj.length; }
            },
            ondblClickRow: function (rowid) {
                task.DefineTaskData($(this).getRowData(rowid));
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 8:
                        task.DefineTaskData($(this).getRowData(rowid));
                        break;
                    case 9:
                        task.DeleteTask($(this).getRowData(rowid));
                        break;
                }
                return false;
            }            
        });
        activityGrid.toolbarButtonAdd("#t_grdTaskList",
            {
                caption: $("#hidSearchButtonCaption").val(),
                position: "last",
                align: 'left',
                buttonicon: "ui-icon-search",
                onClickButton: function () {
                    activityGrid[0].toggleToolbar();
                }
            });
        activityGrid.toolbarButtonAdd("#t_grdTaskList",
          {
              caption: $("#hidAddbuttonCaption").val(),
              buttonicon: "ui-icon-plus",
              cursor: 'pointer',
              onClickButton: function () {
                  task.Task2DriverNew();
              },
              position: "first"
          });
        $("#grdTaskList").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        activityGrid[0].toggleToolbar();
    },
    GetTasksData: function (selected) {
        window.parent.ShowLoading();
        let params = {
            CountryID: $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"],
            DistrID: $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"],
            AgentID: selected == undefined ? null : selected,
            FromDate: $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"],
            ToDate: $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"]
        };

        HardwareWebService.Layout_Tasks_GetAllTasksAsync(params,
            function (data, textStatus) {
                task.ReceivedTasksData(JSON.parse(data));
            }, function (data, textStatus) {
                console.log(data.message);
                return false;
            });

        return false;
    },
    ReceivedTasksData: function (data) {
        var thegrid = $("#grdTaskList")[0];
        task.rowCount = data.length;
        if (!task.rowCount) $('#divTaskList').unblock();
        thegrid.addJSONData(data);
        window.parent.CloseLoading();
    },
    DialogTaskOpen: function () {
        $("#divAddTask2Driver")
            .addClass("dialog")
            .dialog({
                autoOpen: true, bgiframe: false, resizable: false, closeOnEscape: true, height: 370, width: 700, modal: true,
                position: ["center", 100],
                title: $("#hidTitleAddD4D").val(),
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
                    $('input').removeClass('ui-state-error');

                },
                buttons: [{
                    text: $("#hidSaveButtonCaption").val(),
                    click: function () {
                        if (task.CheckInputValues()) {
                            task.SaveTask2Drivers();
                        }
                    }
                }, {
                    text: $("#hidCancelButtonCaption").val(),
                    click: function () {
                        $(this).dialog("close");

                    }
                }]
            });

        return false;
    },
    Task2DriverNew: function () {		
        $("#hidTask_ID").val('');
        $("#ddlDriversList").val(0);
        $("#txtCustomer").val('');
        $("#txtCustomerAddress").val('');
        $("#txtCustomerCity").val('');       
        $("#ddlTaskType").val(0);
        $("#txtTaskDesc").val('');		
		$("#txtFromDate").val('');
        $("#txtToDate").val('');
        task.DialogTaskOpen();
        isUpdate = true;
		
    },
    SaveTask2Drivers: () => {

        let dateFrom = $("#txtFromDate").val().substr(6, 4) + $("#txtFromDate").val().substr(3, 2) + $("#txtFromDate").val().substr(0, 2);
        let dateTo = $("#txtToDate").val().substr(6, 4) + $("#txtToDate").val().substr(3, 2) + $("#txtToDate").val().substr(0, 2);
        var params = {
            TaskID: $("#hidTask_ID").val(),
            AgentID: $("#ddlDriversList").val(),
            CustomerCode: $("#txtCustomer").val(),
            CustAddress: $("#txtCustomerAddress").val(),
            CustCity: $("#txtCustomerCity").val(),
            DateFrom: dateFrom,
            DateTo: dateTo,
            TaskTypeID: $("#ddlTaskType").val(),
            TaskDesc: $("#txtTaskDesc").val(),
            CountryID: $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"]
        };
        HardwareWebService.Layout_SaveTaskAsync(params,
            function (result) {
                $.jgrid.gridUnload("#grdTaskList");
                task.CreateGrid(null);
                setTimeout(function () { $("#divAddTask2Driver ").dialog("close"); }, 250);
            },
            function (ex) {

            });
        return false;
    },
    CheckInputValues: () => {
        var result = new Boolean(true);
        if ($("#ddlDriversList").val() == "0" || $("#ddlDriversList").val() == null) {
            $("#ddlDriversList").addClass('ui-state-error');
            return false;
        }
        else {
            $("#ddlDriversList").removeClass('ui-state-error', 500);
            result = true;
        }

        if ($("#txtCustomer").val() == "") {
            $("#txtCustomer").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#txtCustomer").removeClass('ui-state-error', 500);
            result = true;
        }
        if ($("#txtFromDate").val() == "") {
            $("#txtFromDate").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#txtFromDate").removeClass('ui-state-error', 500);
            result = true;
        }
        if ($("#txtToDate").val() == "") {
            $("#txtToDate").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#txtToDate").removeClass('ui-state-error', 500);
            result = true;
        }

        if ($("#ddlTaskType").val() == "0") {
            $("#ddlTaskType").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#ddlTaskType").removeClass('ui-state-error', 500);
            result = true;
        }
        return result;
    },
    DefineTaskData: (data) => {
        if (data) {
            $("#hidTask_ID").val(data.TaskID);
            $("#ddlDriversList").val(parseFloat(data.AgentId).toString());
            $("#txtCustomer").val(data.CustomerCode);
            $("#txtCustomerAddress").val(data.Address);
            $("#txtCustomerCity").val(data.City);
            $("#txtFromDate").val(data.DateFrom);
            $("#txtToDate").val(data.DateTo);
            $("#ddlTaskType").val(data.TaskTypeID);
            $("#txtTaskDesc").val(data.Task);
        }
        task.DialogTaskOpen();
    },
    DeleteTask: function (rowID) {
        if (rowID) {
            $("<div></div>").dialog({
                autoOpen: true,
                modal: true,
                resizable: false,
                closeOnEscape: true,
                height: 230,
                width: 400,
                title: 'מחיקה',
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                    $(this).html('<p><span class="ui-icon ui-icon-alert" style="float:right; margin:2px 12px 20px 10px;"></span>' + $("#hidConfirmMsg").val() + '</p>');
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            let param = {
                                TaskID: rowID.TaskID,
                                CountryID: rowID.CountryID,
                                AgentID: rowID.AgentId,
                                DateFrom: rowID.DateFrom
                            };
                            HardwareWebService.Layout_DeleteTaskAsync(param,
                               function (result) {
                                   $.jgrid.gridUnload("#grdTaskList");
                                   task.rowCount = 0;
                                   task.CreateGrid(null);
                               },
                               function (ex) {
                                   console.log(ex.message);
                               });
                        } catch (e) {
                            console.log(e.message);
                            return false;
                        }
                        $(this).dialog('destroy');
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
        }


    }

};


$(() => {
    task.Init();
    $("#lstAgents").on("change", (index) => {
        $('#lstAgents :selected').each(function (i, selected) {
            $.jgrid.gridUnload("#grdTaskList");
            task.CreateGrid($(selected).val());
        });
    });  
	
	$("#txtFromDate").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd/mm/yy',
		onSelect: (dateText) => {			
			var from = dateText.split("/")
            var f = new Date(from[2], from[1] - 1, from[0])
            $('#txtToDate').datepicker('option', "minDate", new Date(f));
		}
	});
	$("#txtToDate").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd/mm/yy',
	});

    $("#ddlDriversList").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#ddlTaskType").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#txtCustomer").change(function () {
        if ($(this).val() != "")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#txtFromDate").change(function () {
        if ($(this).val() != "")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#txtToDate").change(function () {
        if ($(this).val() != "")
            $(this).removeClass('ui-state-error', 500);
    });
});