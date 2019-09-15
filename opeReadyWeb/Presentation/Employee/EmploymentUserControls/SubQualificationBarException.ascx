<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SubQualificationBarException.ascx.cs"
    Inherits="PQ.Admin.Presentation.Employee.EmploymentUserControls.SubQualificationBarException" %>
<div>
    <fieldset>
        <legend>
            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Employee, grbAdminException %>"></asp:Label></legend>
        <div class="emplSearch">
            <div id="divAdminExceptions">
                <table id="tlbAdminExceptions">
                </table>
                <div id="pgrAdminExceptions">
                </div>
            </div>
        </div>
    </fieldset>
</div>
<div id="divAdminExceptionDialog" style="display: none">
    <div class="emplSearch">
        <div class="div_wrapper">
            <p>
                <label class="label">
                    <asp:Label runat="server" ID="lblDateAttachment" Text="<%$ Resources:Employee, AdminException_GrtSubQualificationType %>" /></label>
                <select id="ddlSubQualificationType" class="select">
                </select>
            </p>
        </div>
    </div>
</div>
<div style="display: none">
   
</div>
<script type="text/javascript">
    $("#ddlSubQualificationType").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 100);
    });
</script>
