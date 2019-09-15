<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MaintenanceTask.ascx.cs"
    Inherits="PQ.Admin.Presentation.AssetMng.UC_ItemDetails.MaintenanceTask" %>
<div>
    <h2>
        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:AssetMng, MaintTask_MainGreeting %>" /></h2>
    <fieldset>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AssetMng, MaintTask_lblTaskType %>" /></label>
                    <asp:DropDownList ID="ddlTaskType" runat="server" ClientIDMode="Static" CssClass="select"
                        Style="width: 250px" DataTextField="MaintType_Name" DataValueField="MaintType_ID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMng, MaintTask_btnTaskTypeFilter %>" />
                </p>
            </div>
        </div>
    </fieldset>
    <fieldset>
        <div class="emplSearch" id="divDefineMaintTask">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <table id="tblMaintTask" width="100%">
                    </table>
                    <div id="pgrMaintTask">
                    </div>
                </div>
            </div>
        </div>
    </fieldset>
</div>
<div id="divDefineMaintTaskDetails" style="display: none">
    <div id="tabsAssetMngProfile">
        <ul>
            <li><a href="#tabTaskInformation">
                <asp:Label runat="server" Text="<%$ Resources:AssetMng, ItemDetails_TaskInformation %>" />
            </a></li>
            <li><a href="#tabTaskAttachment">
                <asp:Label runat="server" Text="<%$ Resources:AssetMng, ItemDetails_TaskAttachment %>" />
            </a></li>
        </ul>
        <div id="tabTaskInformation">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:AssetMng, MaintTask_TI_TaskDate %>" /></label>
                        <input type="text" id="txtTaskDate" class="input-largeDialog" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:AssetMng, MaintTask_TI_TaskType  %>" /></label>
                        <asp:DropDownList ID="ddlTaskTypeDetails" runat="server" ClientIDMode="Static" CssClass="select-hyper"
                            DataTextField="MaintType_Name" DataValueField="MaintType_ID">
                        </asp:DropDownList>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" Text="<%$ Resources:AssetMng, MaintTask_TI_NextScheduled %>" /></label>
                        <input type="text" id="txtNextScheduled" readonly="readonly" class="input-largeDialog" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label7" Text="<%$ Resources:AssetMng, MaintTask_TI_ResponsibleName %>" /></label>
                        <input type="text" id="txtMaintTask" class="input-largeDialog" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label4" Text="<%$ Resources:AssetMng, MaintTask_TI_Counter %>" /></label>
                        <input type="text" id="txtItemMaintCounter" class="input-largeDialog" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label8" Text="<%$ Resources:AssetMng, MaintTask_TI_Remarks %>" /></label>
                        <textarea rows="15" cols="60" style="width: 520px" id="txtTaskInfoRemarks"></textarea>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnAddNewMaintTask" runat="server" value="<%$ Resources:AssetMng, MaintTask_btnAddNewMaintTask %>"
                            class="button" clientidmode="Static" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnClose" runat="server" value="<%$ Resources:AssetMng, MaintTask_btnClose %>"
                            onclick="$('#divDefineMaintTaskDetails').dialog('destroy');" class="button" />
                    </p>
                </div>
            </div>
        </div>
        <div id="tabTaskAttachment">
            <fieldset>
                <div class="emplSearch" id="divTaskAttachment">
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <table id="tlbTaskAttachment" width="100%">
                            </table>
                            <div id="pgrTaskAttachment">
                            </div>
                        </div>
                    </div>
                </div>
            </fieldset>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="Button1" runat="server" value="<%$ Resources:AssetMng, FaultHistory_btnClose %>"
                            onclick="$('#divDefineMaintTaskDetails').dialog('destroy');" class="button" />
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="divFileUpload" class="modalPopup" style="overflow-x: hidden; display: none">
    <div class="div_wrapper">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblDateAttachment" Text="<%$ Resources:AssetMng, ItemMaintAttach_AttachName %>" /></label>
                    <span>
                        <asp:TextBox CssClass="input-large" ID="txtAttachments_Name" runat="server" ClientIDMode="Static" />
                    </span>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <label class="inline">
                    <asp:Label runat="server" ID="lblChooseFile" Text="<%$ Resources:AssetMng, ItemMaintAttach_ChosedAttachmet %>" /></label>
            </div>
            <div class="div_wrapper">
                <label class="inline">
                    <asp:Label runat="server" ID="lblFileName" ClientIDMode="Static" /></label>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnBrowse" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMng, ItemMaintAttach_btnBrowse %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <div style="width: 40px">
                        &nbsp;</div>
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnUpload" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMng, ItemMaintAttach_btnUpload %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="btnClosePopUp" onclick="$('#divFileUpload').dialog('destroy');"
                        runat="server" value="<%$ Resources:AssetMng, ItemMaintAttach_btnCloseUpload %>" />
                </p>
            </div>
        </div>
    </div>
</div>
<asp:HiddenField ID="hidItemMaint_ID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hidAttachmentID" runat="server" ClientIDMode="Static" />
<div class="no-display">
    <asp:Label ID="hidMaintTask_MainGreeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMng, MaintTask_MainGreeting %>"></asp:Label>
    <asp:Label ID="hidMaintTask_btnAddMaintTask" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTask_btnAddMaintTask %>"></asp:Label>
    <asp:Label ID="hidMaintTask_Grid_MaintTaskDate" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTask_Grid_MaintTaskDate %>"></asp:Label>
    <asp:Label ID="hidMaintTask_Grid_TaskType_Name" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, hidMaintTask_Grid_TaskType_Name %>"></asp:Label>
    <asp:Label ID="hidMaintTask_Grid_Counter" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMng, MaintTask_Grid_Counter %>"></asp:Label>
    <asp:Label ID="hidMaintTask_Grid_ResponsibleName" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTask_Grid_ResponsibleName %>"></asp:Label>
    <asp:Label ID="hidMaintTask_Grid_AttachmentsCount" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMng, MaintTask_Grid_AttachmentsCount %>"></asp:Label>
    <asp:Label ID="lblMaintTask_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMng, MaintTask_btnUpdate %>"></asp:Label>
    <asp:Label ID="lblMaintTask_btnAddNewMaintTask" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTask_btnAddNewMaintTask %>"></asp:Label>
    <asp:Label ID="hidMaintTask_Grid_TaskAttach_Date" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTask_Grid_TaskAttach_Date %>"></asp:Label>
    <asp:Label ID="hidMaintTask_Grid_TaskAttach_Description" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTask_Grid_TaskAttach_Description %>"></asp:Label>
    <asp:Label ID="lblMaintTaskAtach_btnUpload" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTaskAtach_btnUpload %>"></asp:Label>
    <asp:Label ID="hidMaintTaskAtach_grbAttachments" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, MaintTaskAtach_grbAttachments %>"></asp:Label>
</div>
<script type="text/javascript">
    var dateFormats;
    var pid = getArgs();
    $("#txtItemMaintCounter").ForceNumericOnly();
    $(function () {
        if ($.cookie("dateFormat"))
            if ($.cookie("dateFormat") === "103") dateFormats = "dd/mm/yy";
            else dateFormats = "mm/dd/yy";
        if ($.cookie("lang")) $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
        else $.datepicker.setDefaults($.datepicker.regional['']);
        $("#txtCheckIn, #txtCheckOut, #txtTaskDate").datepicker({
            changeYear: true, changeMonth: true, dateFormat: dateFormats
        });
        maintTask.PopulationMainTaskGrid(null);
    });
    $(document).bind('click',
        function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });
    $("#txtTaskDate").change(function () {
        if ($(this).val() != "")
            $(this).removeClass('ui-state-error', 200);
    });
    $("#ddlTaskTypeDetails").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 200);
    });   
    
</script>
