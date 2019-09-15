<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    ValidateRequest="false" CodeBehind="ItemDetails.aspx.cs" Inherits="PQ.Admin.Presentation.AssetMng.ItemDetails" %>

<%@ Register Src="UC_ItemDetails/MaintenanceTask.ascx" TagName="MaintenanceTask"
    TagPrefix="uc1" %>
<%@ Register Src="UC_ItemDetails/FaultHistory.ascx" TagName="FaultHistory" TagPrefix="uc2" %>
<%@ Register Src="UC_ItemDetails/PhotoUpload.ascx" TagName="PhotoUpload" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetManagement.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.tmpl.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.maskedinput-1.3.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.waitforimages.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMng/itemDetails.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMng/maintTask.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMng/faultHistory.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <asp:HiddenField ID="hidItem_ID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField runat="server" ID="hidItemCategory_ID" ClientIDMode="Static" />
    <div id="content">
        <div id="tabAssetMngProfile" class="jquery_tab_title">
            <ul>
                <li><a href="#tabMainScreen">
                    <asp:Label runat="server" Text="<%$ Resources:AssetMng, ItemDetails_headerMainScreen %>" />
                </a></li>
                <li><a href="#tabMaintenanceTask">
                    <asp:Label runat="server" Text="<%$ Resources:AssetMng, ItemDetails_headerMaintenanceTask %>" />
                </a></li>
                <li><a href="#tabFaultHistory">
                    <asp:Label runat="server" Text="<%$ Resources:AssetMng, ItemDetails_headerFaultHistory %>" />
                </a></li>
            </ul>
            <div id="tabMainScreen">
                <div>
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 145px; vertical-align: top" rowspan="3">
                                <div class="div_wrapper">
                                    <div id="loader" class="loading">
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="div_wrapper">
                                    <p>
                                        <label class="label">
                                            <asp:Label runat="server" ID="lblAssetMngID" Text="<%$ Resources:AssetMng, GeneralInfo_lblItemCategory %>" /></label>
                                        <select class="select-hyper" id="ddlItemCategory" datatextfield="ItemCategory_Name" datavaluefield="ItemCategory_ID"
                                            runat="server" clientidmode="Static" />
                                    </p>
                                </div>
                                <div class="div_wrapper">
                                    <p>
                                        <label class="label">
                                            <asp:Label runat="server" ID="Label1" Text="<%$ Resources:AssetMng, GeneralInfo_lblItemType %>" /></label>
                                        <asp:DropDownList CssClass="select-hyper" ClientIDMode="Static" DataTextField="ItemType_Name"
                                            DataValueField="ItemType_ID" ID="ddlItemType" runat="server" AppendDataBoundItems="true">
                                            <asp:ListItem Text="<%$ Resources:AssetMngSettings, ItemTypes_grtItemType %>">0</asp:ListItem>
                                        </asp:DropDownList>
                                    </p>
                                </div>
                                <div class="div_wrapper treeUnitsEdit">
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
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblItemName %>" /></label>
                                            <%-- <asp:DropDownList CssClass="select" ClientIDMode="Static" DataTextField="Item_Name"
                                            DataValueField="Item_ID" ID="txtItemName" runat="server" >
                                        </asp:DropDownList>--%>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtItemName" runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblSerialNumber %>" /></label>
                                            <input class="input-largeDialog" type="text" clientidmode="Static" id="txtSerialNumber"
                                                runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblItemLocation %>" /></label>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtItemLocation"
                                                runat="server" />
                                        </p>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblModelName %>" /></label>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtItemModel" runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblItemStatus %>" /></label>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtItemStatus"
                                                runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblCheckIn %>" />
                                            </label>
                                            <input class="input-largeDialog" type="text" clientidmode="Static" id="txtCheckIn" runat="server" />
                                        </p>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblCheckOut %>" /></label>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtCheckOut" runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblCounter %>" /></label>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtCounter" readonly="readonly" runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblCounterDate %>" /></label>
                                            <input class="input-largeDialog" type="text" clientidmode="Static" id="txtCounterDate" readonly="readonly"
                                                runat="server" />
                                        </p>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_txtServiceProviderName %>" /></label>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtServiceProviderName"
                                                runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_txtServiceProviderDetails %>" /></label>
                                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtServiceProviderDetails"
                                                runat="server" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_txtEndServiceDate %>" /></label>
                                            <input class="input-largeDialog" type="text" clientidmode="Static" id="txtEndServiceDate"
                                                runat="server" />
                                        </p>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <label class="label">
                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_txtRemarks %>" /></label>
                                            <asp:TextBox clientidmode="Static" ID="txtRemarks" Width="770" Height="70" Rows="3" runat="server" TextMode="MultiLine"></asp:TextBox>
                                        </p>
                                    </div>
                                    
                                </div>
                            </td>
                        </tr>
                        <tr id="tdMaintAlert" style="display: none">
                            <td>
                            </td>
                            <td>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <img src="../../Resources/images/24_alert.png" alt="" />
                                    </div>
                                    <div class="div_wrapper">
                                        <label>
                                            <asp:Label ID="lblMaintAlertDesc" Style="display: none" class="maintAlertDesc" runat="server"
                                                ClientIDMode="Static" Text="<%$ Resources:AssetMng, GeneralInfo_lblMaintTaskNotCompile %>" />
                                        </label>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <input class="button" id="btnUpdate" clientidmode="Static" type="button" runat="server"
                                                value="<%$ Resources:AssetMng, GeneralInfo_btnUpdate %>" />
                                        </p>
                                    </div>
                                    <div class="div_wrapper">
                                        <p>
                                            <input class="button" id="btnDeleteItem" clientidmode="Static" type="button" runat="server"
                                                style="display: none" value="<%$ Resources:AssetMng, GeneralInfo_btnDelete %>" />
                                        </p>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                   
                </div>
            </div>
            <!--end content_block-->
            <div id="tabMaintenanceTask" class="jquery_tab">
                <div class="content_block">
                    <uc1:MaintenanceTask ID="MaintenanceTask1" runat="server" />
                </div>
            </div>
            <!--end content_block-->
            <div id="tabFaultHistory" class="jquery_tab">
                <div class="content_block">
                    <uc2:FaultHistory ID="FaultHistory1" runat="server" />
                </div>
            </div>
        </div>
    </div>
    <div id="divMaintPlanning" style="display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <table id="tblMaintPlanning" width="100%">
                </table>
                <div id="pgrMaintPlanning">
                </div>
            </div>
        </div>
    </div>
    <div id="ucPhotoUploader" style="display: none">
        <uc3:PhotoUpload ID="PhotoUpload1" runat="server" />
    </div>
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label runat="server" ClientIDMode="Static" ID="hidAddNewItemDetail" Text="<%$ Resources:AssetMng, GeneralInfo_lblAddNewItemDetail %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidUpdateItemDetail" Text="<%$ Resources:AssetMng, GeneralInfo_lblUpdateItemDetail %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidMaintPlanning_Grid_MaintType"
            Text="<%$ Resources:AssetMng, MaintPlanning_Grid_MaintType %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidMaintPlanning_Grid_NextTask"
            Text="<%$ Resources:AssetMng, MaintPlanning_Grid_NextTask %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidMaintPlanning_Grid_LastTask"
            Text="<%$ Resources:AssetMng, MaintPlanning_Grid_LastTask %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidMaintPlanning_HeaderTitle"
            Text="<%$ Resources:AssetMng, MaintPlanning_HeaderTitle %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
    </div>
    <script type="text/javascript">
        var dateFormats;
        $(function () {
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);

            $("#txtCheckIn, #txtCheckOut, #txtEndServiceDate").datepicker({
                changeYear: true, changeMonth: true, dateFormat: dateFormats
            });
            itemDetail.Init();
            //$("#txtItemName").combobox();
        });
        $(function () {
            var pid = getArgs();
            var tabCount = $('#tabAssetMngProfile').tabs('length');
            if (!pid.iid) {
                $("#tabAssetMngProfile").tabs().tabs("option", "disabled", [1, 2, 3]);
                $("#btnUpdate").val($("#hidAddNewItemDetail").text());
            }
            else {
                $("#tabAssetMngProfile").tabs();
                $("#btnDeleteItem").show();
                $("#btnUpdate").val($("#hidUpdateItemDetail").text());
                itemDetail.PopulationItemDetailsData(pid.iid);
            }
            itemDetail.LoadPhoto();
            $("#tabAssetMngProfile").bind("tabsselect", function (event, ui) {
                if (ui.index == 1)
                    itemDetail.PopulateMaintTypesCombo($("#ddlItemCategory").val());
                if (ui.index == 2)
                    itemDetail.PopulateFaultTypeCombo($("#ddlItemCategory").val());
            });
        });


        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });

        $("#ddlItemCategory").change(function () {
            if ($(this).val() != "0") {
                $(this).removeClass('ui-state-error', 200);
                itemDetail.PopulateItemTypesCombo($(this).val());
            }
        });

        $("#ddlItemType").change(function () {
            if ($(this).val() != "0") {
                $(this).removeClass('ui-state-error', 200);
            }
        });
        $("#ddlUnit").change(function () {
            if ($(this).val() != "") {
                $(this).removeClass('ui-state-error', 200);
            }
        });
        $("#txtItemName").change(function () {
            if ($(this).val() != "") {
                $(this).removeClass('ui-state-error', 200);
            }
        });
        $("#txtSerialNumber").change(function () {
            if ($(this).val() != "") {
                $(this).removeClass('ui-state-error', 200);
            }
        });
        $("#txtCheckIn").change(function () {
            if ($(this).val() != "") {
                $(this).removeClass('ui-state-error', 200);
            }
        });
    </script>
</asp:Content>
