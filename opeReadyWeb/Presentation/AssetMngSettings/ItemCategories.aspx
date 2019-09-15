<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ItemCategories.aspx.cs" Inherits="PQ.Admin.Presentation.AssetMngSettings.ItemCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetMngSettingsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMngSettings/itemCategory.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:AssetMngSettings, AMS_ItemCategory_MainGreeting %>" /></h2>
        <div class="emplSearch" id="divItemCategoriesMain">
            <div class="div_wrapper">
                <table cellpadding="0" cellspacing="0" id="tblItemCategoriesMain" width="100%">
                </table>
                <div id="pgrItemCategoriesMain">
                </div>
            </div>
        </div>
        <div id="divItemCategoriesMainDetails" style="overflow-x: hidden; display: none">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblAdminTaskType_Name" Text="<%$ Resources:AssetMngSettings, AMS_ItemCategory_Name %>" /></label>
                        <input type="text" class="input-hyper" id="txtItemCategoryName" maxlength="100" />
                    </p>
                </div>
            </div>
           
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnAddItemCategory" runat="server" clientidmode="Static"
                            value="<%$ Resources:AssetMngSettings, AMS_ItemCategory_btnAdd %>" class="button" />
                    </p>
                </div>

                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnClose" runat="server" value="<%$ Resources:AssetMngSettings, AMS_ItemCategory_btnClose %>"
                            onclick="$('#divItemCategoriesMainDetails').dialog('destroy');" class="button" />
                    </p>
                </div>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidAMS_ItemCategory_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, AMS_ItemCategory_MainGreeting %>" />
        <asp:Label ID="hidAMS_Grid_ItemCategory_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, AMS_Grid_ItemCategory_Name %>"></asp:Label>
        <asp:Label ID="hidAMS_ItemCategory_btnUpdate" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, AMS_ItemCategory_btnUpdate %>"></asp:Label>
        <asp:Label ID="hidAMS_ItemCategory_btnAdd" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, AMS_ItemCategory_btnAdd %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidItemCategory_ID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            itemCategory.PopulationItemCategoryGrid(null);
        });

        $("#btnAddItemCategory").live("click", function () {
            if ($("#txtItemCategoryName").val() == "") {
                $("#txtItemCategoryName").addClass('ui-state-error');
                return false;
            }
            $("#waitplease").css({ 'display': 'block' });
            var itemCat = {
                ItemCategory_ID: $("#hidItemCategory_ID").val() == "" ? 0 : $("#hidItemCategory_ID").val(),
                ItemCategory_Name: $("#txtItemCategoryName").val()
            };
            itemCategory.ItemCategories_Save(itemCat);
        });
        
    </script>
</asp:Content>
