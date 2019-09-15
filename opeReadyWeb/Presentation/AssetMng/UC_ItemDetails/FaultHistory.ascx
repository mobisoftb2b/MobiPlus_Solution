<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FaultHistory.ascx.cs"
    Inherits="PQ.Admin.Presentation.AssetMng.UC_ItemDetails.FaultHistory" %>
<div>
 <h2>
        <asp:Label ID="Label11" runat="server" Text="<%$ Resources:AssetMng, ItemDetails_headerFaultHistory %>" /></h2>
    <fieldset>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AssetMng, FaultHistory_lblFaultType %>" /></label>
                    <asp:DropDownList ID="ddlFaultType" runat="server" ClientIDMode="Static" CssClass="select"
                        Style="width: 250px" DataTextField="FaultType_Name" DataValueField="FaultType_ID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMng, FaultHistory_btnFaultTypeFilter %>" />
                </p>
            </div>
        </div>
    </fieldset>
    <div class="emplSearch" id="divFaultHistory">
        <fieldset>
            <legend>
                <asp:Label runat="server" ID="Label7" Text="<%$ Resources:AssetMng, FaultHistory_MainHeaderFaultHistory %>"></asp:Label></legend>
            <table id="tblFaultHistory" width="100%">
            </table>
            <div id="pgrFaultHistory" style="width: 100%">
            </div>
        </fieldset>
    </div>
</div>
<div id="divDefineFaultHistoryDetails" style="display: none">
    <div id="tabsFaultInfoProfile">
        <ul>
            <li><a href="#tabFaultInformation">
                <asp:Label ID="Label1" runat="server" Text="<%$ Resources:AssetMng, FaultHistory_FaultInformation %>" />
            </a></li>
            <li><a href="#tabFaultAttachment">
                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:AssetMng, FaultHistory_FaultAttachment %>" />
            </a></li>
        </ul>
        <div id="tabFaultInformation">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:AssetMng, FaultHistory_FI_FaultDate %>" /></label>
                        <input type="text" id="txtFaultDate" class="input-largeDialog" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label ID="Label5" runat="server" Text="<%$ Resources:AssetMng, FaultHistory_FI_FaultType  %>" /></label>
                        <asp:DropDownList ID="ddlFaultTypeDetails" runat="server" ClientIDMode="Static" CssClass="select-hyper"
                            DataTextField="FaultType_Name" DataValueField="FaultType_ID">
                        </asp:DropDownList>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:AssetMng, FaultHistory_FI_ReportName %>" /></label>
                        <input type="text" id="txtReportName" class="input-largeDialog" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label8" Text="<%$ Resources:AssetMng, FaultHistory_FI_RepairDate %>" /></label>
                        <input type="text" id="txtRepairDate" class="input-largeDialog" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label9" Text="<%$ Resources:AssetMng, FaultHistory_FI_FixName %>" /></label>
                        <input type="text" id="txtFixName" class="input-largeDialog" />
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="Label10" Text="<%$ Resources:AssetMng, FaultHistory_FI_Remarks %>" /></label>
                        <textarea rows="15" cols="60" style="width: 520px" id="txtFaultInfoRemarks"></textarea>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnAddNewFaultHistory" runat="server" value="<%$ Resources:AssetMng, FaultHistory_btnAddNewFaultHistory %>"
                            class="button" clientidmode="Static" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnClose" runat="server" value="<%$ Resources:AssetMng, FaultHistory_btnClose %>"
                            onclick="$('#divDefineFaultHistoryDetails').dialog('destroy');" class="button" />
                    </p>
                </div>
            </div>
        </div>
        <div id="tabFaultAttachment">
            <fieldset>
                <div class="emplSearch" id="divFaultAttachment">
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <table id="tlbFaultAttachment" width="100%">
                            </table>
                            <div id="pgrFaultAttachment">
                            </div>
                        </div>
                    </div>
                </div>               
            </fieldset>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="Button1" runat="server" value="<%$ Resources:AssetMng, FaultHistory_btnClose %>"
                            onclick="$('#divDefineFaultHistoryDetails').dialog('destroy');" class="button" />
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="divFileFaultUpload" class="modalPopup" style="overflow-x: hidden; display: none">
    <div class="div_wrapper">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" Text="<%$ Resources:AssetMng, FaultHistoryAttach_AttachName %>" /></label>
                    <span>
                        <asp:TextBox CssClass="input-large" ID="txtFaultAttachments_Name" runat="server"
                            ClientIDMode="Static" />
                    </span>
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <label class="inline">
                    <asp:Label runat="server" ID="lblFaultChooseFile" Text="<%$ Resources:AssetMng, FaultHistoryAttach_ChosedAttachmet %>" /></label>
            </div>
            <div class="div_wrapper">
                <label class="inline">
                    <asp:Label runat="server" ID="lblFaultFileName" ClientIDMode="Static" /></label>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnBrowseFault" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMng, FaultHistoryAttach_btnBrowse %>" />
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
                    <input type="button" id="btnUploadFault" class="button" clientidmode="Static" runat="server"
                        value="<%$ Resources:AssetMng, FaultHistoryAttach_btnUpload %>" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" class="button" id="btnClosePopUpFault" onclick="$('#divFileFaultUpload').dialog('destroy');"
                        runat="server" value="<%$ Resources:AssetMng, FaultHistoryAttach_btnCloseUpload %>" />
                </p>
            </div>
        </div>
    </div>
</div>
<asp:HiddenField ID="hidItemFaults_ID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hidAttachmentID" runat="server" ClientIDMode="Static" />
<div class="no-display">
    <asp:Label ID="hidFaultHistory_MainGreeting" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_MainGreeting %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_btnAddFaultHistory" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_btnAddFaultHistory %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_Grid_ReportDate" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_Grid_ReportDate %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_Grid_FaultType_Name" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_Grid_FaultType_Name %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_Grid_ReportBy" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_Grid_ReportBy %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_Grid_RepairDate" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_Grid_RepairDate %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_Grid_RepairBy" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_Grid_RepairBy %>"></asp:Label>
    <asp:Label ID="lblFaultHistory_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:AssetMng, FaultHistory_btnUpdate %>"></asp:Label>
    <asp:Label ID="lblFaultHistory_btnAddNewFaultHistory" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_btnAddNewFaultHistory %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_Grid_FaultAttach_Date" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistory_Grid_FaultAttach_Date %>"></asp:Label>
    <asp:Label ID="hidFaultHistory_Grid_FaultAttach_Description" ClientIDMode="Static"
        runat="server" Text="<%$ Resources:AssetMng, FaultHistory_Grid_FaultAttach_Description %>"></asp:Label>
    <asp:Label ID="lblFaultHistoryAtach_btnUpload" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistoryAtach_btnUpload %>"></asp:Label>
    <asp:Label ID="hidFaultHistoryAtach_grbAttachments" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistoryAtach_grbAttachments %>"></asp:Label>
         <asp:Label ID="hidFaultHistoryAtach_Grid_AttachmentCount" ClientIDMode="Static" runat="server"
        Text="<%$ Resources:AssetMng, FaultHistoryAtach_Grid_AttachmentCount %>"></asp:Label>
</div>
<script type="text/javascript">
    $(function () {
        faultHist.Init();
        faultHist.PopulationFaultHistoryGrid(null);
        if ($.cookie("dateFormat"))
            if ($.cookie("dateFormat") === "103") dateFormats = "dd/mm/yy";
            else dateFormats = "mm/dd/yy";
        if ($.cookie("lang")) $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
        else $.datepicker.setDefaults($.datepicker.regional['']);
        $("#txtFaultDate, #txtRepairDate").datepicker({
            changeYear: true, changeMonth: true, dateFormat: dateFormats
        });
    });
    $("#txtFaultDate").change(function () {
        if ($(this).val() != "")
            $(this).removeClass('ui-state-error', 200);
    });
    $("#ddlFaultTypeDetails").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 200);
    });
    $("#txtReportName").change(function () {
        if ($(this).val() != "")
            $(this).removeClass('ui-state-error', 200);
    });

</script>
