<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintenanceTypes.aspx.cs"
 Inherits="PQ.Admin.Presentation.AssetMngSettings.MaintenanceTypes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetMngSettingsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMngSettings/maintTypes.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:AssetMngSettings, MaintTypes_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AssetMngSettings, MaintTypes_lblItemCategory %>" /></label>
                    <asp:DropDownList ID="ddlItemCategories" runat="server" ClientIDMode="Static" CssClass="select-hyper"
                        DataTextField="ItemCategory_Name" DataValueField="ItemCategory_ID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMngSettings, MaintTypes_btnItemCatFilter %>" />
                </p>
            </div>
        </div>
        <div class="emplSearch" id="divDefineMaintTypes">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <table id="tblMaintTypes" width="100%">
                        </table>
                        <div id="pgrMaintTypes">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divDefineMaintTypesDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:AssetMngSettings, MaintTypes_lblItemCategoriesDetails  %>" /></label>
                    <asp:DropDownList ID="ddlItemCategoriesDetails" runat="server" ClientIDMode="Static"
                        CssClass="select-hyper" DataTextField="ItemCategory_Name" DataValueField="ItemCategory_ID">
                    </asp:DropDownList>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label4" Text="<%$ Resources:AssetMngSettings, MaintTypes_lblMaintTypes %>" /></label>
                    <input type="text" id="txtMaintTypes" class="input-largeDialog" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddNewMaintTypes" runat="server" value="<%$ Resources:AssetMngSettings, MaintTypes_btnAddNewMaintTypes %>"
                        class="button" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:AssetMngSettings, MaintTypes_btnClose %>"
                        onclick="$('#divDefineMaintTypesDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidMaintTypes_MainGreeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, MaintTypes_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidMaintTypes_btnAddEventType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintTypes_btnAddMaintType %>"></asp:Label>
        <asp:Label ID="hidMaintTypes_Grid_ItemCategory_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintTypes_Grid_ItemCategory_Name %>"></asp:Label>
        <asp:Label ID="hidMaintTypes_Grid_MaintType_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintTypes_Grid_MaintType_Name %>"></asp:Label>
        <asp:Label ID="lblMaintTypes_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, MaintTypes_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblMaintTypes_btnAddNewMaintTypes" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, MaintTypes_btnAddNewMaintTypes %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidMaintTypes_ID" runat="server" ClientIDMode="Static" />
    <script type="text/javascript">
        $(function () {
            maintType.PopulationMaintTypeGrid(null);
        });
        $("#ddlItemCategoriesDetails").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 200);
        });
        $("#txtMaintTypes").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 200);
        });
       
    </script>
</asp:Content>
