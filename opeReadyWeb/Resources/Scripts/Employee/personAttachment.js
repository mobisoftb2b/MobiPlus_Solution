var rowObject;
var attachment = {
    availableTags: null,
    rowObject: null
};


attachment.CreateAttachmentGrid = function () {
    var _langDir, editable = false;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divPersonAttachments').block({
        css: { border: '0px' },
        timeout: 500,
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = true;
    }
    var personAttachmentsGrid = $("#tlbPersonAttachments").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { attachment.getAdminTaskData(pdata); },
        height: 375,
        autowidth: false,
        colNames: [$('div span[id=hidEventRecordsFromDate]').text(),
                $('div span[id=hidRemarks]').text(),
                $('div span[id=hidEventRecordsEdit]').text(),
                $('div span[id=hidEventRecordsDelete]').text(),
                'PersonAttachments_ID', 'RDS_PersonAttachments_FileName'],
        colModel: [
           		{ name: 'PersonAttachments_Timestamp', index: 'PersonAttachments_Timestamp', formatter: 'date', sortable: true, sorttype: 'date', width: 125 },
           		{ name: 'PersonAttachments_Name', index: 'PersonAttachments_Name', sortable: true, sorttype: 'text', width: 490 },                                                                       //1
                {name: 'EditAttach', index: 'EditAdTask', sortable: false, edittype: 'image', formatter: attachFormatter, width: 32, align: 'center' },
                { name: 'DelAttach', index: 'DelAdTask', sortable: false, hidden: editable, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'PersonAttachments_ID', hidden: 'true', key: true },
                { name: 'RDS_PersonAttachments_FileName', hidden: 'true' }
           	],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
        datefmt: 'd/m/Y',
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: false,
        pginput: true,
        recordpos: 'left',
        toolbar: [true, "top"],
        hoverrows: false,
        altRows: true,
        pager: '#pgrPersonAttachments',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            $("#waitplease").css({ 'display': 'none' });
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 2:
                    attachment.ImgPreviewDocument_click($(this).getRowData(rowid));
                    break;
                case 3:
                    return attachment.DeleteAttachmentItem($(this).getRowData(rowid));
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            attachment.ImgPreviewDocument_click($(this).getRowData(rowid));
        }
    });
    personAttachmentsGrid.jqGrid('sortableRows');
    personAttachmentsGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
    if ($.cookie("userRole") != "6") {
        personAttachmentsGrid.toolbarButtonAdd("#t_tlbPersonAttachments",
        {
            caption: $('#hidAttach_btnUpload').text(),
            position: "first",
            align: (_langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                fileUpload_Open();
            }
        });
    }
    $("#waitplease").css({ 'display': 'none' });
};

attachment.getAdminTaskData = function (pData) {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.PQWebService.PersonAttachment_SelectAll(pid.eid,
            function (data, textStatus) {
                attachment.ReceivedAttachmentData(JSON.parse(attachment.getMain(data)).rows);
            }, function (data, textStatus) {
                alert('An error has occured retrieving data!');
            });
    }
};

attachment.ReceivedAttachmentData = function (data) {
    var thegrid = $("#tlbPersonAttachments");
    thegrid.clearGridData();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};


attachment.getMain = function (dObj) {
    if (dObj.hasOwnProperty('d'))
        return dObj.d;
    else
        return dObj;
};

attachment.DeleteAttachmentItem = function (attachmentsID) {
    if (attachmentsID) {
        var _personAttachmentsID = attachmentsID.PersonAttachments_ID;

        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.PQWebService.RDS_PersonAttachments_Delete(_personAttachmentsID,
                    function (result) {
                        $("#tlbPersonAttachments").GridUnload();
                        attachment.CreateAttachmentGrid();
                        $("#waitplease").css({ 'display': 'none' });
                        $('#ConfirmDeleteAttachment').dialog('destroy');
                    },
                    this.ExecuteFailResult);
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
};

attachment.ImgPreviewDocument_click = function (args) {
    $("#waitplease").css({ 'display': 'block' });
    var _imgID = args.PersonAttachments_ID;
    $('#hidPersonAttachmentsID').val(_imgID);
    $('#btnReviewFile').click();
    $("#waitplease").css({ 'display': 'none' });
}

///------------------------ Upload Files(attachments) -----------------------------------

attachment.btnClosePopUp_Click = function () {
    $('#txtPersonAttachName').val("");
    if ($('#txtPersonAttachName').hasClass("ui-state-error"))
        $('#txtPersonAttachName').removeClass('ui-state-error', 500);
    $('#divFileUpload').dialog('destroy');
};

