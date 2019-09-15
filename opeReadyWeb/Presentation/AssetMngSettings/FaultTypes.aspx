<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FaultTypes.aspx.cs"
 Inherits="PQ.Admin.Presentation.AssetMngSettings.FaultTypes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetMngSettingsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMngSettings/faultTypes.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:AssetMngSettings, FaultTypes_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AssetMngSettings, FaultTypes_lblItemCategory %>" /></label>
                    <asp:DropDownList ID="ddlItemCategories" runat="server" ClientIDMode="Static" CssClass="select"
                        DataTextField="ItemCategory_Name" DataValueField="ItemCategory_ID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMngSettings, FaultTypes_btnItemCatFilter %>" />
                </p>
            </div>
        </div>
        <div class="emplSearch" id="divDefineFaultTypes">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <table id="tblFaultTypes" width="100%">
                        </table>
                        <div id="pgrFaultTypes">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divDefineFaultTypesDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:AssetMngSettings, FaultTypes_lblItemCategoriesDetails  %>" /></label>
                    <asp:DropDownList ID="ddlItemCategoriesDetails" runat="server" ClientIDMode="Static"
                        CssClass="select" DataTextField="ItemCategory_Name" DataValueField="ItemCategory_ID">
                    </asp:DropDownList>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label4" Text="<%$ Resources:AssetMngSettings, FaultTypes_lblFaultTypes %>" /></label>
                    <input type="text" id="txtFaultTypes" class="input-medium" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddNewFaultTypes" runat="server" value="<%$ Resources:AssetMngSettings, FaultTypes_btnAddNewFaultTypes %>"
                        class="button" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:AssetMngSettings, FaultTypes_btnClose %>"
                        onclick="$('#divDefineFaultTypesDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidFaultTypes_MainGreeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, FaultTypes_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidFaultTypes_btnAddFaulttType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, FaultTypes_btnAddFaultType %>"></asp:Label>
        <asp:Label ID="hidFaultTypes_Grid_ItemCategory_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, FaultTypes_Grid_ItemCategory_Name %>"></asp:Label>
        <asp:Label ID="hidFaultTypes_Grid_FaultType_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, FaultTypes_Grid_FaultType_Name %>"></asp:Label>
        <asp:Label ID="lblFaultTypes_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMngSettings, FaultTypes_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblFaultTypes_btnAddNewFaultTypes" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMngSettings, FaultTypes_btnAddNewFaultTypes %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidFaultType_ID" runat="server" ClientIDMode="Static" />
    <script type="text/javascript">
        $(function () {
            faultType.PopulationFaultTypeGrid(null);
        });
        $("#ddlItemCategoriesDetails").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 200);
        });
        $("#txtFaultTypes").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 200);
        });
    </script>
</asp:Content>
