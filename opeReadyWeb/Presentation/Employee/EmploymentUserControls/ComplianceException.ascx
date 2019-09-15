<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ComplianceException.ascx.cs"
    Inherits="PQ.Admin.Presentation.Employee.EmploymentUserControls.ComplianceException" %>
<div>
    <fieldset>
        <legend>
            <asp:Label runat="server" Text="<%$ Resources:Employee, ComplException_grbComplianceException %>"></asp:Label></legend>
        <div class="emplSearch">
            <div id="divComplianceExceptions">
                <table id="tlbComplianceExceptions">
                </table>
                <div id="pgrComplianceExceptions">
                </div>
            </div>
        </div>
    </fieldset>
</div>
<div id="divComplianceExceptionDialog" style="display: none">
    <fieldset>
        <legend>
            <asp:Label ID="lblComplException_grbComplianceException" runat="server" Text="<%$ Resources:Employee, ComplException_grbComplianceException %>"></asp:Label></legend>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <asp:Label runat="server" CssClass="label" ID="lblComplException_ddlTrainingEventTypeException"
                        Text="<%$ Resources:Employee, ComplException_ddlTrainingEventTypeException %>" />
                    <select id="ddlTrainingEventTypeException" class="select">
                    </select>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblComplException_ddlTrainingEventCategoryException"
                            Text="<%$ Resources:Employee, ComplException_ddlTrainingEventCategoryException %>" /></label>
                    <select id="ddlTrainingEventCategoryException" class="select-big">
                        <option>
                            <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Employee, ComplException_Greeting_ddlTrainingEventCategoryException %>" /></option>
                    </select>
                </p>
            </div>
        </div>
    </fieldset>
</div>
<div style="display: none">
</div>
<script type="text/javascript">
    $("#ddlTrainingEventTypeException").change(function () {
        compEx.PopulateTrainingEventCategoryExceptionSelect($(this).val());
    });
    $("#ddlTrainingEventTypeException").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 100);
    });
    $("#ddlTrainingEventCategoryException").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 100);
    });
</script>
