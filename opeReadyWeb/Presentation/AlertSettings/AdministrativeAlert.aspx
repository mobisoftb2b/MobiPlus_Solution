<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdministrativeAlert.aspx.cs" Inherits="PQ.Admin.Presentation.AlertSettings.WebAdministrativeAlert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AlertSettingService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AlertSettings/administrativeAlert.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:AlertSettings, AdminAlert_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblEmployeeID" Text="<%$ Resources:AlertSettings, AdminAlert_lblJob %>" /></label>
                        <asp:DropDownList ID="ddlJobsList" runat="server" AppendDataBoundItems="true" DataTextField="Job_Name"
                            ClientIDMode="Static" DataValueField="Job_ID">
                            <asp:ListItem Value="0" Text="<%$ Resources:AlertSettings, AdminAlert_ddlJobGreeting %>"></asp:ListItem>
                        </asp:DropDownList>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" value="<%$ Resources:AlertSettings, AdminAlert_btnSearch %>"
                            class="button" style="margin-top: 23px" id="btnSearch" runat="server" clientidmode="Static" />
                    </p>
                </div>
            </fieldset>
        </div>
        <div class="emplSearch" id="divAdministrativeAlert">
            <div class="div_wrapper">
                <table cellpadding="0" cellspacing="0" id="tblAdministrativeAlert" width="100%">
                </table>
                <div id="pgrAdministrativeAlert">
                </div>
            </div>
        </div>
    </div>
    <div id="divAdminAlertDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblAdminAlert_lblJob" Text="<%$ Resources:AlertSettings, AdminAlert_lblJob %>" /></label>
                    <asp:DropDownList ID="ddlJobs" runat="server" AppendDataBoundItems="true" DataTextField="Job_Name"
                        CssClass="select-hyper" ClientIDMode="Static" DataValueField="Job_ID">
                        <asp:ListItem Value="0" Text="<%$ Resources:AlertSettings, AdminAlert_ddlJobGreeting %>"></asp:ListItem>
                    </asp:DropDownList>
                    <input type="text" class="input-hyper" readonly="readonly" id="txtJobs" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblReadinessAlert_lblEventCategory" Text="<%$ Resources:AlertSettings, AdminAlert_lblSubQualification %>" /></label>
                    <asp:DropDownList ID="ddlSubQualification" ClientIDMode="Static" runat="server" CssClass="select-hyper"
                        DataTextField="SubQualificationType_Name" DataValueField="SubQualificationType_ID">
                    </asp:DropDownList>
                    <input type="text" class="input-hyper" readonly="readonly" id="txtSubQualification" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label3" Text="<%$ Resources:AlertSettings, AdminAlert_lblThresholdLevelInDays %>" /></label>
                    <input type="text" class="input-hyper" id="txtThresholdLevelInDays" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label4" Text="<%$ Resources:AlertSettings, AdminAlert_lblGraceInDay %>" /></label>
                    <input type="text" class="input-hyper" id="txtGraceInDay" />
                </p>
            </div>
            <div class="div_wrapper noDisplay">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label5" Text="<%$ Resources:AlertSettings, AdminAlert_lblAlertInDay %>" /></label>
                    <input type="text" class="input-hyper" id="txtAlertInDay" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label6" CssClass="select-hyper" Text="<%$ Resources:AlertSettings, AdminAlert_lblInitialEntryAlert %>" /></label>
                    <asp:DropDownList ID="chkInitialEntryAlert" ClientIDMode="Static" runat="server"
                        CssClass="select-hyper">
                        <asp:ListItem Value="-1" Selected="True" Text="<%$ Resources:AlertSettings, AdminAlert_ddlInitialEntryAlert %>"></asp:ListItem>
                        <asp:ListItem Value="1" Text="YES"></asp:ListItem>
                        <asp:ListItem Value="0" Text="NO"></asp:ListItem>
                    </asp:DropDownList>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddReadinessAlert" runat="server" value="<%$ Resources:AlertSettings, AdminAlert_btnAddAlert %>"
                        class="button" onclick="btnAddAdminAlert_Click();" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:AlertSettings, AdminAlert_btnClose %>"
                        onclick="$('#divAdminAlertDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidAdminAlert_HeaderDefine" ClientIDMode="Static" runat="server" Text="<%$ Resources:AlertSettings, AdminAlert_HeaderDefine %>"></asp:Label>
        <asp:Label ID="hidAdminAlert_btnAddAdminAlert" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AdminAlert_btnAddAdminAlert %>"></asp:Label>
        <asp:Label ID="hidAdminAlert_Grid_SubQualificationName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AdminAlert_Grid_SubualificationName %>"></asp:Label>
        <asp:Label ID="hidAdminAlert_Grid_ThresholdLevelInDays" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AdminAlert_Grid_ThresholdLevelInDays %>"></asp:Label>
        <asp:Label ID="hidAdminAlert_Grid_GraceInDays" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AdminAlert_Grid_GraceInDays %>"></asp:Label>
        <asp:Label ID="hidAdminAlert_Grid_AlertInDays" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AdminAlert_Grid_AlertInDays %>"></asp:Label>
        <asp:Label ID="hidAdminAlert_Grid_Job_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AdminAlert_Grid_Job_Name %>"></asp:Label>
        <asp:Label ID="lblReadinessAlert_btnUpdate" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AlertSettings_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblReadinessAlert_btnAddAlert" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AdminAlert_btnAddAlert %>"></asp:Label>
    </div>
    <script type="text/javascript">
        $(function () {
            var _adminAlert = {
                Job_ID: $("#ddlJobsList").val()
            };
            adminAlert.CreateAdministrativeAlertGrid(_adminAlert);
        });
        $('#txtGraceInDay').keypress(
            function (event) {
                //Allow only backspace and delete
                if (event.keyCode != 48 && event.keyCode != 8 && event.keyCode != 46) {
                    if (!parseInt(String.fromCharCode(event.which))) {
                        event.preventDefault();
                    }
                }
            }
        );
        $('#txtThresholdLevelInDays').keypress(
            function (event) {
                //Allow only backspace and delete
                if (event.keyCode != 48 && event.keyCode != 8 && event.keyCode != 46) {
                    if (!parseInt(String.fromCharCode(event.which))) {
                        event.preventDefault();
                    }
                }
            }
        );
        $("#btnSearch").click(function () {
            var _adminAlert = {
                Job_ID: $("#ddlJobsList").val()
            };
            $('#tblAdministrativeAlert').GridUnload();
            adminAlert.CreateAdministrativeAlertGrid(_adminAlert);
        });

        function divAdminAlertDetails_Open() {
            $("#divAdminAlertDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '600px', modal: true, zIndex: 50,
                title: $('#hidAdminAlert_HeaderDefine').text(),
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
                }
            });
            return false;
        };

        function btnAddAdminAlert_Click() {
            adminAlert.DefineAdministrativeAlert_Save();
        };

        $("#ddlJobs").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 200);
        });
        $("#ddlSubQualification").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 200);
        });
        $("#txtThresholdLevelInDays").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 200);
        });
    </script>
</asp:Content>
