<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Attachments.ascx.cs"
    Inherits="PQ.Admin.Presentation.Employee.EmploymentUserControls.Attachments" %>
<div>
    <fieldset>
        <legend>
            <asp:Label runat="server" ID="pnEmploymentHistory" Text="<%$ Resources:Employee, grbAttachments %>"></asp:Label></legend>
        <div class="emplSearch">
            <div id="divPersonAttachments">
                <table cellpadding="0" cellspacing="0" id="tlbPersonAttachments">
                </table>
                <div id="pgrPersonAttachments">
                </div>
            </div>
            <%--<div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="btnFileUploadDB" onclick="btnFileUploadDB_Click(this.event);"
                        runat="server" value="<%$ Resources:Employee, btnUpload %>" />
                </p>
            </div>--%>
        </div>
    </fieldset>
</div>
<div id="divFileUpload" class="modalPopup" style="overflow-x: hidden; display: none">
    <div class="div_wrapper">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblDateAttachment" Text="<%$ Resources:Employee, lblPersonAttachName %>" /></label>
                    <span>
                        <asp:TextBox CssClass="input-large" ID="txtPersonAttachName" runat="server" ClientIDMode="Static" />
                    </span>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <label class="inline">
                    <asp:Label runat="server" ID="lblChooseFile" Text="<%$ Resources:Employee, lblEventAttachmet %>" /></label>
            </div>
            <div class="div_wrapper">
                <label class="inline">
                    <asp:Label runat="server" ID="lblFileName" ClientIDMode="Static" /></label>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnBrowse" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:Employee, Attachment_btnBrowse %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <div style="width: 40px">
                        &nbsp;</div>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnUpload" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:Employee, btnUpload %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="btnClosePopUp" onclick="attachment.btnClosePopUp_Click();"
                        runat="server" value="<%$ Resources:Employee, btnCloseUpload %>" />
                </p>
            </div>
        </div>
    </div>
</div>
<asp:Button runat="server" ID="btnSearchPersonAttachments" CssClass="no-display" />
<div id="hiddAdminTaskFuildCaptions" style="display: none">
    <asp:Label runat="server" ClientIDMode="Static" ID="hiddit" Text="<%$ Resources:Employee, Attach_btnEdit %>" />
    <asp:Label runat="server" ClientIDMode="Static" ID="hidbtnDelete" Text="<%$ Resources:Employee, Attach_btnDelete %>" />
    <asp:Label runat="server" ClientIDMode="Static" ID="hidAttach_btnUpload" Text="<%$ Resources:Employee, Attach_btnUpload %>" />
    <asp:Label runat="server" ClientIDMode="Static" ID="hidUpload" Text="<%$ Resources:Employee, btnUpload %>" />
    <asp:Label runat="server" ClientIDMode="Static" ID="hidGrbAttachments" Text="<%$ Resources:Employee, grbAttachments %>" />
</div>
<asp:Button runat="server" ID="btnReviewFile" ClientIDMode="Static" OnClick="btnReviewFile_Click"
    CssClass="no-display" />
<asp:HiddenField ID="hidPersonAttachmentsID" ClientIDMode="Static" runat="server" />
<script type="text/javascript" language="javascript">

    function fileUpload_Open() {
        $("#divFileUpload").dialog({ autoOpen: true, closeOnEscape: true, width: '400px', modal: true, zIndex: 20,
            title: $('#hidGrbAttachments').text(),
            open: function (type, data) {
                $(this).parent().appendTo("form");
                $(this).block({
                    css: { border: '0px' },
                    timeout: 100,
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
                $("#btnUpload").removeAttr("disabled", 100);
                clearContents();
                var param = getArgs();
                var button = $('#btnBrowse');
                var upload = new AjaxUpload(button, {
                    action: '<%=ResolveUrl("~/Handlers/fileUpload.ashx?eid=' + param.eid + '") %>',
                    name: 'myfile',
                    autoSubmit: false,
                    onChange: function (file, ext) {
                        if (!checkNotAllowedFileExtension(null, ext)) {
                            $("#btnUpload").attr("disabled", true);
                        }
                        else { $("#btnUpload").removeAttr("disabled", 100); }
                        $("#lblFileName").block({
                            css: { border: '0px' },
                            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                            message: ''
                        });
                        setTimeout(function () { $("#lblFileName").unblock().text(file); }, 500);
                    },
                    onSubmit: function (file, ext) {
                        $("#waitplease").css({ 'display': 'block' });
                        this.disable();
                    },
                    onComplete: function (file, response) {
                        this.enable();
                        UploadComplete();
                        $("#waitplease").css({ 'display': 'none' });
                    }
                });

                $("#btnUpload").live("click", function () {
                    if (RequaredPersonAttachFields()) {
                        upload.setData({ "PersonAttachName": $("#txtPersonAttachName").val() });
                        upload.submit();
                    }
                });
            }
        });
        return false;
    };

    function UploadComplete(sender, args) {
        $("#tlbPersonAttachments").GridUnload();
        attachment.CreateAttachmentGrid();
        $("#waitplease").css({ 'display': 'none' });
        $('#txtPersonAttachName').val("");
        $('#divFileUpload').dialog('destroy');
    }
    function StartUpload(sender, args) {
        $("#waitplease").css({ 'display': 'block' });
        $('#btnUploadFile').attr("disabled", true);
        return false;
    }
    function ClientUploadError(sender, args) {
    }
    function RequaredPersonAttachFields() {
        if ($('#txtPersonAttachName').val() == '')
            $('#txtPersonAttachName').addClass('ui-state-error').focus();
        else {
            $('#txtPersonAttachName').removeClass('ui-state-error', 500);
            return true;
        }
        return false;
    }

    function btnFileUploadDB_Click(event) {
        $('#txtPersonAttachName').val("");
        $('#txtPersonAttachName').removeClass('ui-state-error', 500);
        fileUpload_Open();
    };

    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
        if (args.get_error()) {
            args.set_errorHandled(true);
        };
        $("#waitplease").css({ 'display': 'none' });
    });
    Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function (sender, args) {
        $("#waitplease").css({ 'display': 'block' });
    });

  
</script>
