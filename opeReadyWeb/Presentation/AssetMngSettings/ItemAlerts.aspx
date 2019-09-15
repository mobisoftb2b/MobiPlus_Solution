<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ItemAlerts.aspx.cs" Inherits="PQ.Admin.Presentation.AssetMngSettings.ItemAlerts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetMngSettingsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMngSettings/itemAlert.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_MainGreeting %>" /></h2>
        <div class="emplSearch" id="divDefineMaintCycle">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <table id="tblMaintCycle" width="100%">
                        </table>
                        <div id="pgrMaintCycle">
                        </div>
                    </div>
                </div>
            </fieldset>
            <br />
            <input type="button" id="btnCalculateAssetsMaint" class="button" runat="server"
                clientidmode="Static" value="<%$ Resources:AssetMngSettings, MaintCycle_btnCalculateAssetsMaints  %>" />
        </div>
    </div>
    <div id="divDefineMaintCycleDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_lblItemCategoriesDetails  %>" /></label>
                    <asp:DropDownList ID="ddlItemCategoriesDetails" runat="server" ClientIDMode="Static"
                        CssClass="select-hyper" DataTextField="ItemCategory_Name" DataValueField="ItemCategory_ID">
                    </asp:DropDownList>
                    <input type="text" id="txtItemCategoriesDetails" readonly="readonly" class="input-largeDialog no-display" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_lblItemTypesDetails  %>" /></label>
                    <asp:DropDownList ID="ddlItemTypes" runat="server" ClientIDMode="Static" CssClass="select-hyper"
                        DataTextField="ItemType_Name" DataValueField="ItemType_ID">
                    </asp:DropDownList>
                    <input type="text" id="txtItemTypes" readonly="readonly" class="input-largeDialog no-display" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_lblMaintTypes  %>" /></label>
                    <asp:DropDownList ID="ddlMaintTypes" runat="server" ClientIDMode="Static" CssClass="select-hyper"
                        DataTextField="MaintType_Name" DataValueField="MaintType_ID">
                    </asp:DropDownList>
                    <input type="text" id="txtMaintTypes" readonly="readonly" class="input-largeDialog no-display" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_lblMaintCycle_Days  %>" /></label>
                    <input type="text" id="txtMaintCycle_Days" class="input-largeDialog" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_Counter  %>" /></label>
                    <input type="text" id="txtCounter" class="input-largeDialog" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddNewMaintCycle" runat="server" value="<%$ Resources:AssetMngSettings, MaintCycle_btnAddNewMaintCycle %>"
                        class="button" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:AssetMngSettings, MaintCycle_btnClose %>"
                        onclick="$('#divDefineMaintCycleDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidMaintCycle_MainGreeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidMaintCycle_btnAddMaintCycle" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintCycle_btnAddMaintCycle %>"></asp:Label>
        <asp:Label ID="hidMaintCycle_Grid_ItemCategory_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintCycle_Grid_ItemCategory_Name %>"></asp:Label>
        <asp:Label ID="hidMaintCycle_Grid_ItemType_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintCycle_Grid_ItemType_Name %>"></asp:Label>
        <asp:Label ID="hidMaintCycle_Grid_MaintType_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintCycle_Grid_MaintType_Name %>"></asp:Label>
        <asp:Label ID="hidMaintCycle_Grid_MaintCycle_Days" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintCycle_Grid_MaintCycle_Days %>"></asp:Label>
            <asp:Label ID="hidMaintCycle_Grid_MaintCycle_Counter" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintCycle_Grid_MaintCycle_Counter %>"></asp:Label>
        <asp:Label ID="lblMaintCycle_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, MaintCycle_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblMaintCycle_btnAddNewMaintCycle" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintCycle_btnAddNewMaintCycle %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidItemCategory_ID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidItemType_ID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidMaintType_ID" runat="server" ClientIDMode="Static" />
    <script type="text/javascript">

        $(function () {
            itemAlert.PopulationMaintCycleGrid(null);
        });

        $("#ddlItemCategoriesDetails").change(function () {
            if ($(this).val() != "0") {
                $(this).removeClass('ui-state-error', 200);
                itemAlert.PopulateItemTypesCombo($(this).val());
                itemAlert.PopulateMaintTypesCombo($(this).val());
            }
        });
        $("#ddlItemTypes").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 200);
        });
        $("#ddlMaintTypes").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 200);
        });
        $("#txtMaintCycle_Days").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 200);
        });

        $("#btnCalculateAssetsMaint").live("click", function () {
            $("#waitplease").css({ 'display': 'block' });
            AssetMngSettingsService.MaintCycles_CalculateAssetsMaint(function (result) {
                if (result) {

                }
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
            },
            function (ex) {
                return false;
            }, null);
        });
    </script>
</asp:Content>
