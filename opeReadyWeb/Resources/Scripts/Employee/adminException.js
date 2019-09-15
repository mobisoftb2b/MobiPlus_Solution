/// <reference path="../Common/_references.js" />

var rowCount;
var adminEx = {
    CreateAdminExceptionsGrid: function (subQualificationBarException) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divAdminExceptions').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var complExceptionsGrid = $("#tlbAdminExceptions").jqGrid({
            direction: langDir,
            datatype: function (pdata) {
                if (subQualificationBarException) adminEx.ReceivedAdminExceptionsData(JSON.parse(getMain(subQualificationBarException)).rows);
                else adminEx.GetAdminExceptionsData();
            },
            height: 375,
            autowidth: true,
            colNames: [
                $('#hidAdminException_Grid_SubQualificationType_Name').text(),
                $('#hidAdminException_Grid_Delete').text(), '', ""],
            colModel: [
           		{ name: 'SubQualificationTypeName', index: 'SubQualificationTypeName', sortable: true, width: 220 },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'SubQualificationTypeID', hidden: 'true' },
                { name: 'PersonID', hidden: 'true' }
           	],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            altRows: true,
            hoverrows: false,
            toolbar: [true, "top"],
            pager: $('#pgrAdminExceptions'),
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divAdminExceptions').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, e) {
                switch (iCol) {
                    case 1:
                        return adminEx.DeleteAdminException($(this).getRowData(rowid));
                }
                return false;
            }
        });
        complExceptionsGrid.jqGrid('sortGrid', "SubQualificationTypeName", true);
        complExceptionsGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        complExceptionsGrid.toolbarButtonAdd("#t_tlbAdminExceptions",
        {
            caption: $('#hidAdminException_Grid_AddException').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                adminEx.AddAdminException();
            }
        });
    },
    GetAdminExceptionsData: function () {
        var pid = getArgs();
        if (pid.eid) {
            PQ.Admin.WebService.PQWebService.SubQualificationBarException_SelectAll(pid.eid,
            function (data) {
                adminEx.ReceivedAdminExceptionsData(JSON.parse(getMain(data)).rows);
            }, function () {
                alert('An error has occured retrieving data!');
            });
        }
    },
    ReceivedAdminExceptionsData: function (data) {
        var thegrid = $("#tlbAdminExceptions");
        thegrid.clearGridData();
        rowCount = data.length;
        if (rowCount == 0) $('#divAdminExceptions').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    PopulationSubQualificationTypeSelect: function () {
        $("#ddlSubQualificationType>option").remove();
        PQ.Admin.WebService.PQWebService.SubQualificationType_SelectAll(0, $("#hidAdminException_ddlSubQualificationType").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlSubQualificationType").append($("<option></option>").val(this['SubQualificationType_ID']).html(this['SubQualificationType_Name']));
            });
        },
        function (e) { });
        $("#waitplease").css({ 'display': 'none' });
        return false;
    },
    AddAdminException: function () {
        $("#ddlSubQualificationType").val("0");
        $("#divAdminExceptionDialog").dialog({
            title: $("#hidGrbComplianceException").text(),
            autoOpen: true,
            modal: true,
            resizable: false,
            closeOnEscape: true,
            height: 200,
            width: 300,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: [
                {
                    text: $("#hidAdminException_btnAddException").text(),
                    click: function () {
                        if (adminEx.RequaredFieldsCheck()) {
                            adminEx.SaveComplianceException();
                        }
                    }
                },
                {
                    text: $("#hidAdminException_btnCancel").text(),
                    click: function () { $(this).dialog("close"); }
                }]
        });
    },
    RequaredFieldsCheck: function () {
        if ($("#ddlSubQualificationType").val() == "0") {
            $('#ddlSubQualificationType').addClass('ui-state-error').focus();
            return false;
        }
        else {
            $('#ddlSubQualificationType').removeClass('ui-state-error', 500);
        }
        return true;
    },
    SaveComplianceException: function() {
        var pid = getArgs();
        var paramException = {
            PersonID: pid.eid,
            SubQualificationTypeID: $("#ddlSubQualificationType").val()
        };

        PQ.Admin.WebService.PQWebService.SubQualificationType_Save(paramException,
            function (data, textStatus) {
                $("#tlbAdminExceptions").GridUnload();
                adminEx.CreateAdminExceptionsGrid(data);
                $("#divAdminExceptionDialog").dialog("close");
            }, function (data, textStatus) {
                alert('An error has occured retrieving data!');
            });
    },
        DeleteAdminException: function (rowObj) {
        if (rowObj != undefined) {
            var pid = getArgs();
            var paramException = {
                PersonID: pid.eid,
                SubQualificationTypeID: rowObj.SubQualificationTypeID
            };
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function () {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        try {
                            PQ.Admin.WebService.PQWebService.SubQualificationType_Delete(paramException,
                                function (data, textStatus) {
                                    $("#tlbAdminExceptions").GridUnload();
                                    adminEx.CreateAdminExceptionsGrid(data);
                                    //compEx.ReceivedComplianceExceptionsData(JSON.parse(getMain(data)).rows);
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
    }
}
