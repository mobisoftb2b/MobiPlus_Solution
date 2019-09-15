<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    EnableViewState="false" CodeBehind="EmploymentHistory.aspx.cs" Inherits="PQ.Admin.Presentation.EmployeeSettings.EmploymentHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EmployeeSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/EmployeeSettings/employmentHistoryType.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:EmployeeSettings, EmployeeHistory_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divEmploymentHistory">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblEmploymentHistory" width="100%">
                        </table>
                        <div id="pgrEmploymentHistory">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divEmploymentHistoryDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblEmploymentHistoryType_Name" Text="<%$ Resources:EmployeeSettings, EmployeeHistory_lblEmploymentHistoryType_Name %>" /></label>
                    <input type="text" class="input-hyper" id="txtEmploymentHistoryTypeName" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddEmployeeHistoryType" runat="server" clientidmode="Static"
                        value="<%$ Resources:EmployeeSettings, EmployeeHistory_btnAddEmployeeHistoryType %>"
                        class="button" onclick="btnAddEmployeeHistoryType_Click();" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:EmployeeSettings, EmployeeHistory_btnClose %>"
                        onclick="$('#divEmploymentHistoryDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidEmployeeHistory_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, EmployeeHistory_MainGreeting %>" />
        <asp:Label ID="hidEmployeeHistory_Grid_EmploymentHistoryType_Name" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:EmployeeSettings, EmployeeHistory_Grid_EmploymentHistoryType_Name %>"></asp:Label>
        <asp:Label ID="hidEmployeeHistory_btnAddNewCompany" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, EmployeeHistory_btnAddNewCompany %>"></asp:Label>
        <asp:Label ID="hidEmployeeHistory_btnUpdateSetting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, EmployeeHistory_btnUpdateSetting %>"></asp:Label>
        <asp:Label ID="hidEmployeeHistory_btnAddEmployeeHistory" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, EmployeeHistory_btnAddEmployeeHistory %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidEmploymentHistoryTypeID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            employmentHistory.CreateEmploymentHistoryTypeGrid();
        });

        function divEmploymentHistoryDetails_Open() {
            $("#divEmploymentHistoryDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '300px', modal: true, zIndex: 50,
                title: $('#hidEmployeeHistory_MainGreeting').text(),
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
                    $("#txtEmploymentHistoryTypeName").removeClass('ui-state-error');
                }
            });
            return false;
        };

        $("#txtEmploymentHistoryTypeName").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 500);
        });

        function btnAddEmployeeHistoryType_Click() {
            if ($("#txtEmploymentHistoryTypeName").val() == "") {
                $("#txtEmploymentHistoryTypeName").addClass('ui-state-error');
                return false;
            }
            $("#waitplease").css({ 'display': 'block' });
            var empHistory = {
                EmploymentHistoryType_ID: $("#hidEmploymentHistoryTypeID").val() == "" ? 0 : $("#hidEmploymentHistoryTypeID").val(),
                EmploymentHistoryType_Name: $("#txtEmploymentHistoryTypeName").val()
            };
            employmentHistory.EmployeeHistoryType_Save(empHistory);
        };
    </script>
</asp:Content>
