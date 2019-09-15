<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="FileImport.aspx.cs" Inherits="PQ.Admin.Presentation.SystemSettings.FileImport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/SystemSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/SystemSettings/fileImport.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:SystemSettings, FileImport_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label" for="Label1">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:SystemSettings, FileImport_lblExternalSourceType %>" /></label>
                    <asp:DropDownList ID="ddlExternalSourceType" runat="server" ClientIDMode="Static"
                        CssClass="select" DataTextField="ExternalSourceType_Name" DataValueField="ExternalSourceTypeID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" runat="server" clientidmode="Static"
                        value="<%$ Resources:SystemSettings, FileImport_btnExternalSourceTypeFilter %>" />
                </p>
            </div>
        </div>
        <div id="divExternalSourceTypeDetails" style="display: none">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="Label2" Text="<%$ Resources:SystemSettings, FileImport_lblEventType %>" /></label>
                                <asp:DropDownList ID="ddlEventType" runat="server" ClientIDMode="Static" CssClass="select"
                                    DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID" />
                            </p>
                        </div>
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="lblExternalSourcePersonMatch" Text="<%$ Resources:SystemSettings, FileImport_lblExternalSourcePersonMatch %>" /></label>
                                <asp:DropDownList ID="ddlExternalSourcePersonMatch" runat="server" ClientIDMode="Static"
                                    CssClass="select" DataTextField="ExternalSourcePersonMatch_Name" DataValueField="ExternalSourcePersonMatch_ID" />
                            </p>
                        </div>
                    </div>
                    <div class="emplSearch">
                        <input type="checkbox" runat="server" class="checkbox" id="chkSyncEmployeesFromSource"
                            clientidmode="Static" />
                        <asp:Label runat="server" CssClass="inline checkboxinline" ID="Label3" Text="<%$ Resources:SystemSettings, FileImport_lblSyncEmployeesFromSource %>" />
                    </div>
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="lblFileInputDirection" Text="<%$ Resources:SystemSettings, FileImport_lblFileInputDirection %>" /></label>
                                <asp:TextBox ID="txtFileInputDirection" Style="direction: ltr" runat="server" ClientIDMode="Static"
                                    CssClass="input-big" />
                            </p>
                        </div>
                    </div>
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="lblFileOutputDirection" Text="<%$ Resources:SystemSettings, FileImport_lblFileOutputDirection %>" /></label>
                                <asp:TextBox ID="txtFileOutputDirection" Style="direction: ltr" runat="server" ClientIDMode="Static"
                                    CssClass="input-big" />
                            </p>
                        </div>
                    </div>
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="lblFileErrorDirection" Text="<%$ Resources:SystemSettings, FileImport_lblFileErrorDirection %>" /></label>
                                <asp:TextBox ID="txtFileErrorDirection" Style="direction: ltr" runat="server" ClientIDMode="Static"
                                    CssClass="input-big" />
                            </p>
                        </div>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <input type="button" id="btnUpdate" class="button" value="<%$ Resources:SystemSettings, FileImport_btnUpdate %>"
                                onclick="btnUpdate_Click();" runat="server" />
                        </p>
                    </div>
                </div>
            </fieldset>
            <br />
            <fieldset id="frmExtSrcSubData">
                <legend>
                    <asp:Label runat="server" ID="Label4" Text="<%$ Resources:SystemSettings, FileImport_lblExternalSourceSubDataRef %>" />
                </legend>
                <table id="tblExtSrcSubData">
                </table>
                <div id="pgrExtSrcSubData">
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divFileBrowsing" style="display: none">
    </div>
    <div class="no-display">
        <asp:Label ID="hidFileImport_lblSubCatName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, FileImport_lblSubCatName %>"></asp:Label>
        <asp:Label ID="hidFileImport_lblIsValidForCalc" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, FileImport_lblIsValidForCalc %>"></asp:Label>
    </div>
    <script type="text/javascript">
        $("#ddlExternalSourceType").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 100);
        });

        $("#btnFilter").live("click", function () {
            if ($("#ddlExternalSourceType").val() != "0") {
                $("#waitplease").css({ 'display': 'block' });
                PQ.Admin.WebService.SystemSettingsService.ExternalSourceType_Select($("#ddlExternalSourceType").val(),
                    function (data) {
                        $("#ddlExternalSourceType").removeClass('ui-state-error');
                        $("#ddlEventType").val(data.TrainingEventType_ID);
                        $("#txtFileInputDirection").val(data.InputDirectory);
                        $("#txtFileOutputDirection").val(data.OutputDirectory);
                        $("#txtFileErrorDirection").val(data.ErrorDirectory);
                        $("#ddlExternalSourcePersonMatch").val(data.ExternalSourcePersonMatch_ID);
                        $("#chkSyncEmployeesFromSource").attr('checked', data.SyncEmployeesFromSource);
                        $('#tblExtSrcSubData').GridUnload();
                        fileImport.PopulateExtSrcSubDataGrid(data.ExternalSourceTypeID);
                        setTimeout(function () {
                            $("#waitplease").css({ 'display': 'none' });
                            if (!$("#divExternalSourceTypeDetails").is(':visible'))
                                $("#divExternalSourceTypeDetails").fadeIn('slide');

                        }, 500);
                    }, function (ex) { });
            }
            else {
                $("#ddlExternalSourceType").addClass('ui-state-error').focus();
                $("#divExternalSourceTypeDetails").fadeOut('slide');
                return false;
            }
        });
    </script>
</asp:Content>
