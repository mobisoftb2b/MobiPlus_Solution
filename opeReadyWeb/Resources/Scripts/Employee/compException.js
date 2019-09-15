/// <reference path="../Common/_references.js" />
var rowCount;
var compEx = {
    CreateComplianceExceptionsGrid: function (trainingEventsBarExceptions) {
        var langDir = "ltr";
        var pid = getArgs();
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divComplianceExceptions').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var complExceptionsGrid = $("#tlbComplianceExceptions").jqGrid({
            direction: langDir,
            datatype: function (pdata) {
                if (trainingEventsBarExceptions) compEx.ReceivedComplianceExceptionsData(JSON.parse(getMain(trainingEventsBarExceptions)).rows);
                else compEx.GetComplianceExceptionsData(pdata);
            },
            height: 375,
            autowidth: true,
            colNames: [
                $('#hidComplException_Grid_TrainingEventType_Name').text(),
                $('#hidComplException_Grid_TrainingEventCategory_Name').text(),
                $('#hidComplException_Grid_Delete').text(), '', ""],
            colModel: [
           		{ name: 'TrainingEventTypeName', index: 'TrainingEventTypeName', sortable: true, width: 125 },
           		{ name: 'TrainingEventCategoryName', index: 'TrainingEventCategoryName', sortable: true, width: 180 },                                                                       //1
                {name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'TrainingEventTypeID', hidden: 'true' },
                { name: 'TrainingEventCategory_ID', hidden: 'true' }
           	],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            altRows: true,
            hoverrows: false,
            toolbar: [true, "top"],
            pager: $('#pgrComplianceExceptions'),
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divComplianceExceptions').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, e) {
                switch (iCol) {
                    case 2:
                        return compEx.DeleteComplianceException($(this).getRowData(rowid));
                }
                return false;
            }
        });
        complExceptionsGrid.jqGrid('sortGrid', "TrainingEventTypeName", true);
        complExceptionsGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        complExceptionsGrid.toolbarButtonAdd("#t_tlbComplianceExceptions",
        {
            caption: $('#hidComplException_Grid_AddException').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                compEx.AddComplianceException();
            }
        });
    },
    DeleteComplianceException: function (rowObj) {
        if (rowObj != undefined) {
            var pid = getArgs();
            var paramException = {
                PersonID: pid.eid,
                TrainingEventTypeID: rowObj.TrainingEventTypeID,
                TrainingEventCategory_ID: rowObj.TrainingEventCategory_ID
            };
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function () {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        try {
                            PQ.Admin.WebService.EventRecords.TrainingEventsBarExceptions_Delete(paramException,
                                function (data, textStatus) {
                                    compEx.ReceivedComplianceExceptionsData(JSON.parse(getMain(data)).rows);
                                    $('#ConfirmDeleteAttachment').dialog('destroy');
                                }, function (data, textStatus) {
                                    alert('An error has occured retrieving data!');
                                });

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
        }
        return false;
    },
    AddComplianceException: function () {
        //$("#ddlTrainingEventTypeException").val("0").trigger("change");
        $("#divComplianceExceptionDialog").dialog({
            title: $("#hidGrbComplianceException").text(),
            autoOpen: true,
            modal: true,
            resizable: false,
            closeOnEscape: true,
            height: 230,
            width: 450,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: [
                {
                    text: $("#hidComplException_btnAddException").text(),
                    click: function () {
                        if (compEx.RequaredFieldsCheck()) {
                            compEx.SaveComplianceException();
                        }
                    }
                },
                {
                    text: "Cancel",
                    click: function () { $(this).dialog("close"); }
                }]
        });
    },
    GetComplianceExceptionsData: function () {
        var pid = getArgs();
        if (pid.eid) {
            PQ.Admin.WebService.EventRecords.TrainingEventsBarExceptions_SelectAll(pid.eid,
            function (data, textStatus) {
                compEx.ReceivedComplianceExceptionsData(JSON.parse(getMain(data)).rows);
            }, function () {
                alert('An error has occured retrieving data!');
            });
        }
    },
    ReceivedComplianceExceptionsData: function (data) {
        var thegrid = $("#tlbComplianceExceptions");
        thegrid.clearGridData();
        rowCount = data.length;
        if (rowCount == 0) $('#divComplianceExceptions').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    SaveComplianceException: function () {
        var pid = getArgs();
        var paramException = {
            PersonID: pid.eid,
            TrainingEventTypeID: $("#ddlTrainingEventTypeException").val(),
            TrainingEventCategory_ID: $("#ddlTrainingEventCategoryException").val()
        };

        PQ.Admin.WebService.EventRecords.TrainingEventsBarExceptions_Save(paramException,
            function (data, textStatus) {
                $("#tlbComplianceExceptions").GridUnload();
                compEx.CreateComplianceExceptionsGrid(data);
                $("#divComplianceExceptionDialog").dialog("close");
            }, function (data, textStatus) {
                alert('An error has occured retrieving data!');
            });
    },
    PopulationTrainingEventTypeExceptionSelect: function () {
        $("#ddlTrainingEventTypeException>option").remove();
        PQ.Admin.WebService.EventRecords.TrainingEventType_SelectAll($("#hidComplException_Greeting_ddlTrainingEventTypeException").text(), false,
     function (result) {
         $(result).each(function () {
             $("#ddlTrainingEventTypeException").append($("<option></option>").val(this['TrainingEventType_ID']).html(this['TrainingEventType_Name']));
         });
         $("#waitplease").css({ 'display': 'none' });
     },
    function (e) {
        return false;
    });
    },
    PopulateTrainingEventCategoryExceptionSelect: function (trainingEventTypeId) {
        ClearOptionsFast('ddlTrainingEventCategoryException');
        var $ddlControl = $("#ddlTrainingEventCategoryException");
        //$("#ddlTrainingEventCategoryException>option").remove();
        $("#ddlTrainingEventCategoryException").addClass("ui-autocomplete-ddl-loading");

        PQ.Admin.WebService.AlertSettingService.TrainingEventCategory_Select(trainingEventTypeId, $("#hidComplException_Greeting_ddlTrainingEventCategoryException").text(),
        function (result) {
            $(result).each(function () {
                $ddlControl.append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $ddlControl.removeClass("ui-autocomplete-ddl-loading");
        },
        function (e) {
            return false;
        });
        $("#waitplease").css({ 'display': 'none' });
        return false;
    },
    RequaredFieldsCheck: function () {
        if ($("#ddlTrainingEventTypeException").val() == "0") {
            $('#ddlTrainingEventTypeException').addClass('ui-state-error').focus();
            return false;
        }
        else {
            $('#ddlTrainingEventTypeException').removeClass('ui-state-error', 500);
        }
        if ($("#ddlTrainingEventCategoryException").val() == "0") {
            $('#ddlTrainingEventCategoryException').addClass('ui-state-error').focus();
            return false;
        }
        else {
            $('#ddlTrainingEventCategoryException').removeClass('ui-state-error', 500);
        }
        return true;

    }
};

function ClearOptionsFast(id) {
    var selectObj = document.getElementById(id);
    var selectParentNode = selectObj.parentNode;
    var newSelectObj = selectObj.cloneNode(false); // Make a shallow copy
    selectParentNode.replaceChild(newSelectObj, selectObj);
    return newSelectObj;
}