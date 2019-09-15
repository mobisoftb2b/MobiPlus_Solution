<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ReadinessValues.aspx.cs" Inherits="PQ.Admin.Presentation.SystemSettings.ReadinessValues" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/SystemSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/SystemSettings/readinessLevel.min.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:SystemSettings, ReadinessLevel_MainGreeting %>" /></h2>
        <div class="emplSearch" id="divDefineEventSettings">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divReadinessLevel">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblReadinessLevel" width="100%">
                        </table>
                        <div id="pgrReadinessLevel">
                        </div>
                    </div>
                </div>                
            </fieldset>
        </div>
    </div>
    <div id="divReadinessLevelDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:SystemSettings, ReadinessLevel_lblORGName %>" /></label>
                    <input type="text" class="input-large" id="txtORGName" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblMultiplierFactor" Text="<%$ Resources:SystemSettings, ReadinessLevel_lblMultiplierFactor %>" /></label>
                    <input type="text" class="input-large" id="txtMultiplierFactor" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblThresholdScore" Text="<%$ Resources:SystemSettings, ReadinessLevel_lblThresholdScore %>" /></label>
                    <input type="text" class="input-large" id="txtThresholdScore" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnUpdateReadinessLevel" runat="server" value="<%$ Resources:SystemSettings, ReadinessLevel_btnUpdateReadinessLevel %>"
                        class="button" clientidmode="Static" onclick="btnUpdateReadinessLevel_Click();" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:SystemSettings, ReadinessLevel_btnClose %>"
                        onclick="$('#divReadinessLevelDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidReadinessLevel_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, ReadinessLevel_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidReadinessLevels_Grid_ReadinessLevel_ORGName" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:SystemSettings, ReadinessLevels_Grid_ReadinessLevel_ORGName %>"></asp:Label>
        <asp:Label ID="hidReadinessLevels_Grid_MultiplierFactor" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, ReadinessLevels_Grid_MultiplierFactor %>"></asp:Label>
        <asp:Label ID="hidReadinessLevels_Grid_ThresholdScore" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, ReadinessLevels_Grid_ThresholdScore %>"></asp:Label>
    </div>
    <asp:HiddenField runat="server" ID="hidReadinessLevel_ID" ClientIDMode="Static" />
    <script type="text/javascript">
        $(function () {
            readiness.CreateReadinessLevelGrid();
            $("#txtThresholdScore, #txtMultiplierFactor").ForceNumericOnly();
        });

        function divReadinessLevelDetails_Open() {
            $("#divReadinessLevelDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '380px', modal: true, zIndex: 50,
                title: $('#hidReadinessLevel_MainGreeting').text(),
                create: function (event, ui) {
                    $(this).block({
                        css: { border: '0px' },
                        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                        message: ''
                    });
                },
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                    $(this).unblock();
                }
            });
            return false;
        };
        function btnUpdateReadinessLevel_Click() {
            var editdata = {
                ORGName: $("#txtORGName").val(),
                ReadinessLevelID: $("#hidReadinessLevel_ID").val(),
                ThresholdScore: $("#txtThresholdScore").val(),
                MultiplierFactor: $("#txtMultiplierFactor").val()
            };
            readiness.SaveReadinessLevelData(editdata);
        };
    </script>
</asp:Content>
