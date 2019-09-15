<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" EnableViewState="false"
    CodeBehind="Employers.aspx.cs" Inherits="PQ.Admin.Presentation.EmployeeSettings.Employers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EmployeeSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/EmployeeSettings/employeeSettings.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:EmployeeSettings, Employers_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divEmployers">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblEmployers" width="100%">
                        </table>
                        <div id="pgrEmployers">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divPersonCategoryDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblEmployer_lblPersonCategory_Name" Text="<%$ Resources:EmployeeSettings, Employer_lblPersonCategory_Name %>" /></label>
                    <input type="text" class="input-hyper" id="txtPersonCategoryName" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddEmployerSetting" runat="server" clientidmode="Static"
                        value="<%$ Resources:EmployeeSettings, Employer_btnAddEmployerSetting %>" class="button"
                        onclick="btnAddEmployerSetting_Click();" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:EmployeeSettings, Employer_btnClose %>"
                        onclick="$('#divPersonCategoryDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidEmployers_MainGreeting" runat="server" Text="<%$ Resources:EmployeeSettings, Employers_MainGreeting %>" ClientIDMode="Static" />
        <asp:Label ID="hidEmployer_Grid_PersonCategory_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, Employer_Grid_PersonCategory_Name %>"></asp:Label>
        <asp:Label ID="hidEmployers_btnAddNewCompany" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, Employers_btnAddNewCompany %>"></asp:Label>
        <asp:Label ID="hidEmployer_btnUpdateSetting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, Employer_btnUpdateSetting %>"></asp:Label>
        <asp:Label ID="hodEmployer_btnAddEmployerSetting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EmployeeSettings, Employer_btnAddEmployerSetting %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidPersonCategoryID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            eSettings.CreateEmployerSettingsGrid();
        });

        function divPersonCategoryDetails_Open() {
            $("#divPersonCategoryDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '300px', modal: true, zIndex: 50,
                title: $('#hidEmployers_MainGreeting').text(),
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
                    $("#txtPersonCategoryName").removeClass('ui-state-error');
                }
            });
            return false;
        };

        $("#txtPersonCategoryName").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 500);
        });

        function btnAddEmployerSetting_Click() {
            if ($("#txtPersonCategoryName").val() == "") {
                $("#txtPersonCategoryName").addClass('ui-state-error');
                return false;
            }
            $("#waitplease").css({ 'display': 'block' });
            var empSetting = {
                PersonCategory_ID: $("#hidPersonCategoryID").val() == "" ? null : $("#hidPersonCategoryID").val(),
                PersonCategory_Name: $("#txtPersonCategoryName").val()
            };
            eSettings.EmployerSettings_Save(empSetting);
        };
    </script>
</asp:Content>
