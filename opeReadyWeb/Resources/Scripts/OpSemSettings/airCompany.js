/// <reference path="../Common/jquery-1.6.4.min.js" />
/// <reference path="../Common/jquery-ui-1.8.12.custom.min.js" />


var airplane = {
    rowCount: 0,
    CreateAirplaneCompanyGrid: function (companyData) {
        var _langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divAirplaneCompanys').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        $("#tblAirplaneCompanies").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { airplane.getAirplaneCompanyData(companyData); },
            height: 375,
            colNames: [
                    $('#hidAPC_Grid_AirlineCompany_ShortName').text(),
                    $('#hidAPC_Grid_AirlineCompany_IATACode').text(),
                    $('#hidAPC_Grid_AirlineCompany_ICAOCode').text(),
                    $('#hidAPC_Grid_AirlineCompany_isDisplayed').text(),
                    '', '', 'AirplaneCompany_ID'],
            colModel: [
       		        { name: 'AirlineCompany_ShortName', index: 'AirlineCompany_ShortName', sortable: true, sorttype: 'text', width: 320 },
               		{ name: 'IATACode', index: 'IATACode', sortable: true, sorttype: 'text', width: 100, align: 'center' },
                    { name: 'ICAOCode', index: 'ICAOCode', sortable: true, sorttype: 'int', align: 'center', width: 100 },
                    { name: 'isDisplayed', index: 'isDisplayed', sortable: false, formatter: checkboxPic, align: 'center', width: 100 },
                    { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'AirlineCompany_ID', hidden: 'true' }
               	],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            pginput: true,
            altRows: true,
            hoverrows: false,
            toolbar: [true, "top"],
            recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
            pager: '#pgrAirplaneCompanies',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (airplane.rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divAirplaneCompanys').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 4:
                        airplane.DefineAirplaneCompany_Open($(this).getRowData(rowid));
                        break;
                    case 5:
                        return airplane.DefinAirplaneCompany_Delete($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                airplane.DefineAirplaneCompany_Open($(this).getRowData(rowid));
            }
        });
        $("#tblAirplaneCompanies")
            .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
            .toolbarButtonAdd("#t_tblAirplaneCompanies",
            {
                caption: $('#hidAPC_btnAddAirlineCompanyUpper').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    airplane.DefineAirplaneCompany_New();
                }
            })
    },
    getAirplaneCompanyData: function (companyData) {
        if (companyData) {
            airplane.ReceivedAirplaneCompanyData(JSON.parse(getMain(companyData)).rows);
        }
        else {
            OpSemsService.AirplaneCompany_SelectALL(null,
            function (data, textStatus) {
                airplane.ReceivedAirplaneCompanyData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                $('#divAirplaneCompanys').unblock();
                return false;
            }, null);
        }
    },
    ReceivedAirplaneCompanyData: function (data) {
        var thegrid = $("#tblAirplaneCompanies");
        thegrid.clearGridData();
        this.rowCount = data.length;
        if (!this.rowCount) $('#divAirplaneCompanys').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    DefineAirplaneCompany_Open: function (rowData) {
        if (rowData) {
            var currdate = new Date();
            currdate = encodeURI(currdate.toString());
            $('#loader').empty().addClass("loading");
            $("#btnAddAirlineCompany").val($("#hidAPC_btnAirlineCompanyUpdate").text());
            OpSemsService.AirplaneCompany_Select(rowData.AirlineCompany_ID,
            function (data) {
                if (data) {
                    $("#txtAirlineCompanyName").val(data.AirlineCompany_ShortName);
                    $("#txtAirlineCompanyLongName").val(data.AirlineCompany_LongName);
                    $("#txtIATACode").val(data.IATACode);
                    $("#txtICAOCode").val(data.ICAOCode);
                    $("#chkIsDisplay").attr("checked", data.isDisplayed);
                    $("#hidAirlineCompany_ID").val(data.AirlineCompany_ID);
                    $("#uploadLogo").fadeToggle(500);
                    var img = new Image(80, 70);
                    $(img)
                        .load(function () {
                            $(this).hide();
                            $('#loader').removeClass('loading').append(this);
                            $(this).fadeIn();
                        }).error(function () {
                        }).attr('src', '/opeReady/Handlers/opeSems/AirlineLogoHandler.ashx?ailcomid=' + data.AirlineCompany_ID + "&d=" + currdate);
                }
                airplane.InitializeUploadModule();
                airplane.divAirplaneCompanyDetails_Open();
            },
        function (ex) {
            return false;
        });
        }
    },
    divAirplaneCompanyDetails_Open: function () {
        $("#divAirlineCompanyDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '600px', modal: true, zIndex: 50,
            title: $('#hidAPC_HeaderDefine').text(),
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
                $("#btnUpload").attr("disabled", true);
            },
            beforeClose: function (event, ui) {
                $("#hidAirplaneCompany_ID").val("");
                upload = null;
            }
        });
        return false;
    },
    DefineAirplaneCompany_New: function () {
        $("#btnAddAirlineCompany").val($("#hidAPC_btnAddAirlineCompany").text());
        $("input:text").val("");
        $("#hidAirlineCompany_ID").val("");
        $("#loader").empty().addClass('loading');
        $("#uploadLogo").hide();
        airplane.divAirplaneCompanyDetails_Open();
    },
    DefineAirplaneCompany_Save: function () {
        if (airplane.RequaredAirplaneCompanyFields()) {
            $("#waitplease").css({ 'display': 'block' });
            var _station = {
                AirlineCompany_ShortName: $("#txtAirlineCompanyName").val(),
                AirlineCompany_LongName: $("#txtAirlineCompanyLongName").val(),
                IATACode: $("#txtIATACode").val(),
                ICAOCode: $("#txtICAOCode").val(),
                AirlineCompany_ID: $("#hidAirlineCompany_ID").val() == "" ? 0 : parseInt($("#hidAirlineCompany_ID").val()),
                isDisplayed: $("#chkIsDisplay").attr("checked")
            };
            OpSemsService.AirplaneCompany_Save(_station,
              function (data) {
                  if (data) {
                      $("#tblAirplaneCompanies").GridUnload();
                      airplane.CreateAirplaneCompanyGrid(null);
                      $("#waitplease").css({ 'display': 'none' });
                      $("#hidAirlineCompany_ID").val(data.AirlineCompany_ID);
                      $("#btnBrowse").removeAttr("disabled", 100);
                      $("#uploadLogo").show(500);
                      if (data.AirlineCompany_Logo == null) {
                          $("#loader").empty().removeClass("loading");
                          airplane.InitializeUploadModule();
                      }
                  }
              },
          function (ex) {
              $("#waitplease").css({ 'display': 'none' });
              return false;
          });
        }
    },
    DefinAirplaneCompany_Delete: function (rowData) {
        if (rowData) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            OpSemsService.AirlineCompany_Delete(rowData.AirlineCompany_ID,
                        function (result) {
                            if (result) {
                                $("#tblAirplaneCompanies").GridUnload();
                                airplane.CreateAirplaneCompanyGrid(result);
                                $("#waitplease").css({ 'display': 'none' });
                                $('#ConfirmDeleteAttachment').dialog('destroy');
                            }
                        },
                        function (ex) {
                            $("#waitplease").css({ 'display': 'none' });
                            $('#ConfirmDeleteAttachment').dialog('destroy');
                            return false;
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
    RequaredAirplaneCompanyFields: function () {
        var result = new Boolean(true);
        if ($("#txtAirplaneCompanysName").val() == "") {
            $("#txtAirplaneCompanysName").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#txtAirplaneCompanysName").removeClass('ui-state-error', 200);
            result = true;
        }
        if ($("#ddlThreatCategory").val() == "0") {
            $("#ddlThreatCategory").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#ddlThreatCategory").removeClass('ui-state-error', 200);
            result = true;
        }
        if ($("#txtColor").val() == "") {
            $("#txtColor").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#txtColor").removeClass('ui-state-error', 200);
            result = true;
        }
        return result;
    },
    InitializeUploadModule: function () {
        var button = $('#btnBrowse');
        var upload = new AjaxUpload(button, {
            action: '/opeReady/Handlers/opeSems/AirlineCompanyFileUploader.ashx',
            name: 'myfile',
            autoSubmit: false,
            onChange: function (file, ext) {
                if (!checkNotAllowedFileExtension(null, ext)) {
                    $("#btnUpload").attr("disabled", true);
                }
                else { $("#btnUpload").removeAttr("disabled", 100); }
                setTimeout(function () { $("#txtLogo").val(file); }, 100);
            },
            onSubmit: function (file, ext) {
                this.disable();
            },
            onComplete: function (file, response) {
                this.enable();
                airplane.UploadComplete();
            }
        });
        $("#divAirlineCompanyDetails").delegate("#btnUpload", "click", function () {
            if ($("#txtLogo").val() != "") {
                $("#waitplease").css({ 'display': 'block' });
                upload.setData({ "AirlineCompany_ID": $("#hidAirlineCompany_ID").val() });
                upload.submit();
            }
        });
    },
    UploadComplete: function (sender, args) {
        var currdate = new Date();
        currdate = encodeURI(currdate.toString());
        $("#loader").empty().addClass('loading');
        var img = new Image(80, 70);
        $(img)
            .load(function () {
                $(this).hide();
                $('#loader').removeClass('loading').append(this);
                $(this).fadeIn();
            }).error(function () {

            }).attr('src', '/opeReady/Handlers/opeSems/AirlineLogoHandler.ashx?ailcomid=' + $("#hidAirlineCompany_ID").val() + "&d=" + currdate);
        $("#txtLogo").val("");
        $("#waitplease").css({ 'display': 'none' });
    }
};