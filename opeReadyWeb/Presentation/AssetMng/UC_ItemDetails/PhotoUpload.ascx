<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PhotoUpload.ascx.cs"
    Inherits="PQ.Admin.Presentation.Employee.EmploymentUserControls.PhotoUpload" %>
<div>
    <div class="emplSearch">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Employee, lblChoosePhoto %>" /></label>
                </p>
            </div>
            <div class="div_wrapper">
                <label class="inline">
                    <asp:Label runat="server" ID="lblPhotoFileName" ClientIDMode="Static" /></label>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnPhotoBrowse" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:Employee, Attachment_btnBrowse %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <span style="width: 40px">&nbsp;</span>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddPhoto" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:Employee, PU_btnUpload %>" /></p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="btnCloseUpload" clientidmode="Static" runat="server" value="<%$ Resources:Employee, PU_btnCloseUpload %>" /></p>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $("#btnCloseUpload").live("click", function () {
        $("#ucPhotoUploader").dialog("destroy");
    });
</script> 