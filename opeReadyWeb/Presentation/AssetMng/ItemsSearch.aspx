<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
	CodeBehind="ItemsSearch.aspx.cs" Inherits="PQ.Admin.Presentation.AssetMng.ItemsSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetManagement.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.qtip-1.0.0-rc3.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMng/itemsSearch.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2 id="h2Empl">
            <asp:Label ID="lblItemSearch" runat="server" Text="<%$ Resources:AssetMng, AssetMng_lblItemSearch %>" /><img
                alt="Show" id="imgShowParams" style="margin-bottom: -5px; display: none" src="../../Resources/images/down_alt.png" /></h2>
        <div id="divSearchPanel">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:AssetMng, AssetMng_lblItemCategoryID %>" /></label>
                        <select id="ddlItemCategories" class="select-hyper" runat="server" clientidmode="Static"
                            datatextfield="ItemCategory_Name" datavaluefield="ItemCategory_ID">
                        </select>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblClassification" Text="<%$ Resources:AssetMng, AssetMng_lblItemType %>" /></label>
                        <select id="ddlItemType" class="select-hyper" runat="server" clientidmode="Static"
                            datatextfield="ItemType_Name" datavaluefield="ItemType_ID">
                        </select>
                    </p>
                </div>
                <%-- ReSharper disable UnknownCssClass --%>
                <div class="div_wrapper treeUnitsEdit">
                    <%-- ReSharper restore UnknownCssClass --%>
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblUnit" Text="<%$ Resources:AssetMng, AssetMng_lblUnit %>" /></label>
                        <span>
                            <input class="combobox-big" type="text" id="ddlUnit" runat="server" clientidmode="Static" />
                            <div id="treeUnits">
                            </div>
                        </span>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblFirstName" Text="<%$ Resources:AssetMng, AssetMng_lblItemName %>" /></label>
                        <input class="input-largeDialog" clientidmode="Static" type="text" id="txtItemName"
                            runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblLastName" Text="<%$ Resources:AssetMng, AssetMng_lblSerialNumber %>" /></label>
                        <input class="input-largeDialog" type="text" clientidmode="Static" id="txtSerialNumber"
                            runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label1" Text="<%$ Resources:AssetMng, AssetMng_lblModelName %>" /></label>
                        <input class="input-largeDialog" clientidmode="Static" type="text" id="txtModelName"
                            runat="server" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblReadinessLabel" Text="<%$ Resources:AssetMng, AssetMng_lblItemLocation %>" /></label>
                        <input class="input-largeDialog" type="text" clientidmode="Static" id="txtItemLocation"
                            runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AssetMng, AssetMng_lblItemStatus %>" /></label>
                        <input class="input-largeDialog" type="text" clientidmode="Static" id="txtItemStatus"
                            runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="checkbox" runat="server" class="checkbox" id="chkIsActive" clientidmode="Static"
                            style="margin-top: 25px" />
                        <label class="inline checkboxinline" for="chkIsActive">
                            <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblIsActive" Text="<%$ Resources:AssetMng, AssetMng_chkIsActive %>" /></label>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="checkbox" runat="server" class="checkbox" id="chkMaintAlert" clientidmode="Static"
                            style="margin-top: 25px" />
                        <label class="inline checkboxinline" for="chkMaintAlert">
                            <asp:Label runat="server" CssClass="inline checkboxinline" ID="Label3" Text="<%$ Resources:AssetMng, AssetMng_chkMaintAlert %>" /></label>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:AssetMng, AssetMng_ServiceProviderName %>" /></label>
                        <input class="input-largeDialog" clientidmode="Static" type="text" id="txtServiceProviderName"
                            runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <div style="width: 355px">
                        </div>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="checkbox" runat="server" class="checkbox" id="chkFaultAlert" clientidmode="Static"
                            style="margin-top: 25px" />
                        <label class="inline checkboxinline" for="chkFaultAlert">
                            <asp:Label runat="server" CssClass="inline checkboxinline" ID="Label5" Text="<%$ Resources:AssetMng, AssetMng_chkFaultAlert %>" /></label>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input class="button" id="btnSearch" type="button" runat="server" value="<%$ Resources:AssetMng, AssetMng_btnSearch %>"
                            clientidmode="Static" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input class="button" id="btnClear" type="button" clientidmode="Static" runat="server"
                            value="<%$ Resources:AssetMng, AssetMng_btnClear %>" />
                    </p>
                </div>
                <div class="div_wrapper demo" style="width: 380px">
                    <div id="slider-range-max">
                    </div>
                    <input type="text" id="amount" style="border: 0; color: #f6931f; font-weight: bold;" />
                </div>
            </div>
        </div>
        <h2>
            <asp:Label ID="lblResult" runat="server" Text="<%$ Resources:AssetMng, AssetMng_lblResult %>" /></h2>
        <div id="divResultPanel" class="grid">
            <table id="tblItems">
            </table>
            <div id="pgrItems">
            </div>
        </div>
    </div>
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label ID="hidAssetMng_Grid_lblItemName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AssetMng, AssetMng_Grid_lblItemName  %>" />
        <asp:Label ID="hidAssetMng_Grid_lblSerialNumber" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_lblSerialNumber %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_Grid_lblItemModel" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_lblItemModel %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_Grid_lblLocation" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_lblLocation %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_Grid_lblStatus" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_lblStatus %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_Grid_lblMaintAlert" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_lblMaintAlert %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_btnEdit" runat="server" Text="<%$ Resources:AssetMng, AssetMng_btnEdit %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_AllItems" runat="server" Text="<%$ Resources:AssetMng, AssetMng_AllItems %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_Grid_lblItemType" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_lblItemType %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_Grid_lblItemCategory" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_lblItemCategory %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidAssetMng_Grid_FaultAlert" runat="server" Text="<%$ Resources:AssetMng, AssetMng_Grid_FaultAlert %>"
            ClientIDMode="Static" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
    </div>
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            $("#chkIsActive").attr("checked", true); $("#slider-range-max").slider({
                animate: true, range: "max", min: 100, max: 1000, step: 100, value: 100, slide: function (event, ui) {
                    if (ui.value == 1000) {
                        $("#amount").val($("#hidAssetMng_AllItems").text());
                    } else { $("#amount").val(ui.value); }
                }
            });
            $("#amount").val($("#slider-range-max").slider("value"));
            itemSearch.Init();
        });
        $(function () {
            $('#h2Empl').hover(function () {
                $(this).css({
                    cursor: 'pointer'
                });
            }, function () { $(this).css({ cursor: 'default' }); }).click(function () { itemSearch.ShowIconParamsArea(); });
        });

        $("#frmScoutForm").keypress(function (e) {
            var code = (e.keyCode ? e.keyCode : e.which); if (code == 13) $("#btnSearch").click();
        });
        $(document).bind('click', function (e) {
            var $clicked = $(e.target); if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });
        $("#ddlItemCategories").change(function () {
            itemSearch.PopulateItemTypesCombo($(this).val());
        });
        $("#imgShowParams").live("click", function () {
            $("#divSearchPanel").toggle();
        }); 
    </script>
</asp:Content>
