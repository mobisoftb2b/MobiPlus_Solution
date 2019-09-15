<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
EnableViewState="false" CodeBehind="AdministrativeTask.aspx.cs" Inherits="PQ.Admin.Presentation.EmployeeSettings.AdministrativeTask" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EmployeeSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/EmployeeSettings/adminTasksSettings.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:EmployeeSettings, AdminTask_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divAdminTask">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblAdminTask" width="100%">
                        </table>
                        <div id="pgrAdminTask">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divAdminTaskDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblAdminTaskType_Name" Text="<%$ Resources:EmployeeSettings, AdminTask_lblAdministrativeRequirements_Name %>" /></label>
                    <input type="text" class="input-hyper" id="txtAdministrativeRequirementsName" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddAdminTaskType" runat="server" clientidmode="Static"
                        value="<%$ Resources:EmployeeSettings, AdminTask_btnAdministrativeRequirements %>"
                        class="button" onclick="btnAddAdminTaskType_Click();" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:EmployeeSettings, AdminTask_btnClose %>"
                        onclick="$('#divAdminTaskDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidAdminTask_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, AdminTask_MainGreeting %>" />
        <asp:Label ID="hidAdminTask_Grid_AdministrativeRequirements_Name" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:EmployeeSettings, AdminTask_Grid_AdministrativeRequirements_Name %>"></asp:Label>
        <asp:Label ID="hidAdminTask_btnAddNewAdministrativeRequirements" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:EmployeeSettings, AdminTask_btnAddNewAdministrativeRequirements %>"></asp:Label>
        <asp:Label ID="hidAdminTask_btnUpdateSetting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, AdminTask_btnUpdateSetting %>"></asp:Label>
        <asp:Label ID="hidAdminTask_btnAddAdminTask" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, AdminTask_btnAddAdminTask %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidSubQualificationTypeID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            adminTask.CreateAdministrativeRequirementsGrid();
        });

        function divAdministrativeRequirements_Open() {
            $("#divAdminTaskDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '300px', modal: true, zIndex: 50,
                title: $('#hidAdminTask_MainGreeting').text(),
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
                    $("#txtAdministrativeRequirementsName").removeClass('ui-state-error');
                }
            });
            return false;
        };

        $("#txtAdministrativeRequirementsName").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 500);
        });

        function btnAddAdminTaskType_Click() {
            if ($("#txtAdministrativeRequirementsName").val() == "") {
                $("#txtAdministrativeRequirementsName").addClass('ui-state-error');
                return false;
            }
            $("#waitplease").css({ 'display': 'block' });
            var subQualificationType = {
                SubQualificationType_ID: $("#hidSubQualificationTypeID").val() == "" ? 0 : $("#hidSubQualificationTypeID").val(),
                SubQualificationType_Name: $("#txtAdministrativeRequirementsName").val()
            };
            adminTask.AdministrativeTasksEdit_Save(subQualificationType);
        };
    </script>
</asp:Content>
