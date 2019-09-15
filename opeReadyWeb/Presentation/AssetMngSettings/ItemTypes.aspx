<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ItemTypes.aspx.cs" Inherits="PQ.Admin.Presentation.AssetMngSettings.ItemTypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetMngSettingsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMngSettings/itemTypes.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label runat="server" Text="<%$ Resources:AssetMngSettings, ItemTypes_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:AssetMngSettings, ItemTypes_lblItemCategory %>" /></label>
                    <asp:DropDownList ID="ddlItemCategories" runat="server" ClientIDMode="Static" CssClass="select-hyper"
                        DataTextField="ItemCategory_Name" DataValueField="ItemCategory_ID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMngSettings, ItemTypes_btnItemCatFilter %>" />
                </p>
            </div>
        </div>
        <div class="emplSearch" id="divDefineItemTypes">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <table id="tblItemTypes" width="100%">
                        </table>
                        <div id="pgrItemTypes">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divDefineItemTypesDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" Text="<%$ Resources:AssetMngSettings, ItemTypes_lblItemCategoriesDetails  %>" /></label>
                    <asp:DropDownList ID="ddlItemCategoriesDetails" runat="server" ClientIDMode="Static"
                        CssClass="select-hyper" DataTextField="ItemCategory_Name" DataValueField="ItemCategory_ID">
                    </asp:DropDownList>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AssetMngSettings, ItemTypes_lblItemTypes %>" /></label>
                    <input type="text" id="txtItemTypes" class="input-largeDialog" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label3" Text="<%$ Resources:AssetMngSettings, ItemTypes_EndServiceDateAlertInDays %>" /></label>
                    <input type="text" class="input-hyper" id="txtEndServiceDateAlertInDays" maxlength="10" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddNewItemTypes" runat="server" value="<%$ Resources:AssetMngSettings, ItemTypes_btnAddNewItemTypes %>"
                        class="button" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:AssetMngSettings, ItemTypes_btnClose %>"
                        onclick="$('#divDefineItemTypesDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidItemTypes_MainGreeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, ItemTypes_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidItemTypes_btnAddEventType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, ItemTypes_btnAddItemType %>"></asp:Label>
        <asp:Label ID="hidItemTypes_Grid_ItemCategory_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, ItemTypes_Grid_ItemCategory_Name %>"></asp:Label>
        <asp:Label ID="hidItemTypes_Grid_ItemType_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, ItemTypes_Grid_ItemType_Name %>"></asp:Label>
        <asp:Label ID="lblItemTypes_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, ItemTypes_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblItemTypes_btnAddNewItemTypes" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, ItemTypes_btnAddNewItemTypes %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidItemTypes_ID" runat="server" ClientIDMode="Static" />
    <script type="text/javascript">
        $(function () {
            itemType.PopulationItemTypeGrid(null);
            $("#txtEndServiceDateAlertInDays").ForceNumericOnly();
        });
        $("#ddlItemCategoriesDetails").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 200);
        });
        $("#txtItemTypes").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 200);
        });
       
    </script>
</asp:Content>
