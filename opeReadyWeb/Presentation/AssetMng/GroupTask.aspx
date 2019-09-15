<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="GroupTask.aspx.cs" Inherits="PQ.Admin.Presentation.AssetMng.GroupTask" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/AssetManagement.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.maskedinput-1.3.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.waitforimages.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AssetMng/groupTask.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2 id="h2Empl">
            <asp:Label ID="lblGroupTask" runat="server" Text="<%$ Resources:AssetMng, GroupTask_lblGroupTask %>" /></h2>
        <div class="content_block">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblGroupTaskEventDate" Text="<%$ Resources:AssetMng, GroupTask_lblGroupTaskEventDate %>" /></label>
                        <input class="input-hyper PQ_datepicker_input" type="text" id="txtGroupTaskDate"
                            runat="server" clientidmode="Static" onkeypress="event.keyCode = 0;" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:AssetMng, AssetMng_lblItemCategoryID %>" /></label>
                        <select id="ddlItemCategories" class="select-hyper" runat="server" clientidmode="Static"
                            datatextfield="ItemCategory_Name" datavaluefield="ItemCategory_ID">
                        </select>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblGroupTaskType" Text="<%$ Resources:AssetMng, GroupTask_lblGroupTaskType %>" /></label>
                        <asp:DropDownList ID="ddlTaskType" ClientIDMode="Static" runat="server" AppendDataBoundItems="True"
                            CssClass="select-hyper" DataTextField="MaintType_Name" DataValueField="MaintType_ID">
                            <asp:ListItem Text="<%$ Resources:AssetMng, GroupTask_grtItemType %>" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AssetMng, GroupTask_txtResponsibleName %>" /></label>
                        <input class="input-hyper" type="text" id="txtResponsibleName" runat="server" clientidmode="Static" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label10" Text="<%$ Resources:AssetMng, GroupTask_txtCounter %>" /></label>
                        <input class="input-hyper" type="text" id="txtCounter" runat="server" clientidmode="Static" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label3" Text="<%$ Resources:AssetMng, GroupTask_txtRemarks %>" /></label>
                        <textarea rows="10" cols="60" style="width: 520px" id="txtRemarks" class="textarea-middle"></textarea>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <fieldset>
                    <legend>
                        <asp:Label runat="server" ID="Label4" Text="<%$ Resources:AssetMng, GroupTask_flsItem %>" /></legend>
                    <div id="divItemsList">
                        <table id="tblItemsList" width="100%">
                        </table>
                        <div id="pgrItemsList">
                        </div>
                    </div>
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <p>
                                <input type="button" runat="server" id="btnSaveGroupMaintTask" class="button" style="margin-top: 22px;"
                                    clientidmode="Static" value="<%$ Resources:AssetMng, GroupTask_btnSaveGroupMaintTask %>" />
                            </p>
                        </div>
                    </div>
                </fieldset>
            </div>
            <div id="divTaskSearch" style="display: none">
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:AssetMng, GroupTask_lblItemCategoryID %>" /></label>
                            <select id="ddlItemCategorySearch" class="select-hyper" runat="server" clientidmode="Static"
                                datatextfield="ItemCategory_Name" datavaluefield="ItemCategory_ID">
                            </select>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label6" Text="<%$ Resources:AssetMng, GroupTask_lblGroupItemType %>" /></label>
                            <asp:DropDownList ID="ddlTaskTypeSearch" ClientIDMode="Static" runat="server" AppendDataBoundItems="True"
                                CssClass="select" DataTextField="ItemType_Name" DataValueField="ItemType_ID">
                                <asp:ListItem Text="<%$ Resources:AssetMng, GroupTask_grtItemType %>" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper treeUnitsEdit">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblUnit" Text="<%$ Resources:AssetMng, GroupTask_lblUnit %>" /></label>
                            <div>
                                <input class="combobox-big" type="text" id="ddlUnit" runat="server" clientidmode="Static" />
                                <div id="treeUnits">
                                </div>
                            </div>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:AssetMng, GeneralInfo_lblItemName %>" /></label>
                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtItemName"
                                runat="server" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:AssetMng, GroupTask_lblItemLocation %>" /></label>
                            <input class="input-largeDialog" clientidmode="Static" type="text" id="txtItemLocation"
                                runat="server" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="button" runat="server" id="btnTaskSearch" class="button" style="margin-top: 22px"
                                clientidmode="Static" value="<%$ Resources:AssetMng, GroupTask_btnTaskSearch %>" />
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <fieldset>
                        <legend>
                            <asp:Label runat="server" ID="Label9" Text="<%$ Resources:AssetMng, GroupTask_flsTaskResult %>" /></legend>
                        <div id="divTaskResult">
                            <table id="tblTaskResult" width="100%">
                            </table>
                            <div id="pgrTaskResult">
                            </div>
                        </div>
                        <div class="emplSearch">
                            <p>
                                <input type="button" runat="server" id="btnAddSelectedTasks" class="button" style="margin-top: 22px;
                                    display: none" clientidmode="Static" value="<%$ Resources:AssetMng, GroupTask_btnAddSelectedTasks %>" />
                            </p>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_HeaderTitle" Text="<%$ Resources:AssetMng, GroupTask_HeaderTitle %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_btnAddTask" Text="<%$ Resources:AssetMng, GroupTask_btnAddTask %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_ItemCategory"
            Text="<%$ Resources:AssetMng, GroupTask_Grid_ItemCategory %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_ItemTask" Text="<%$ Resources:AssetMng, GroupTask_Grid_ItemTask %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_ManufacturerName"
            Text="<%$ Resources:AssetMng, GroupTask_Grid_ManufacturerName %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_SerialNumber"
            Text="<%$ Resources:AssetMng, GroupTask_Grid_SerialNumber %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_ItemModel"
            Text="<%$ Resources:AssetMng, GroupTask_Grid_ItemModel %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_Location" Text="<%$ Resources:AssetMng, GroupTask_Grid_Location %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_Counter" Text="<%$ Resources:AssetMng, GroupTask_Grid_Counter %>" />
<asp:Label runat="server" ClientIDMode="Static" ID="hidGroupTask_Grid_Delete" Text="<%$ Resources:AssetMng, GroupTask_Grid_Delete %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidSaveSuccessMessage" Text="<%$ Resources:AssetMng, GroupTask_SaveSuccessMessage %>" />
    </div>
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            groupTask.Init();
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);
        });
        $("#ddlItemCategories").change(function () {
            groupTask.TaskTypePopulation($(this).val());
        });
        $("#ddlItemCategorySearch").change(function () {
            groupTask.TaskTypeSearchPopulation($(this).val());
        });
        $("#ddlUnit").change(function () {
            if ($(this).val() != "") {
                $(this).removeClass('ui-state-error', 200);
            }
        });
        $("#txtGroupTaskDate").change(function () {
            if ($(this).val() != "") {
                $(this).removeClass('ui-state-error', 200);
            }
        });
        $("#ddlTaskType").change(function () {
            if ($(this).val() != "") {
                $(this).removeClass('ui-state-error', 200);
            }
        });

        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });
    </script>
</asp:Content>
