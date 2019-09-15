<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ExecutionLevel.aspx.cs" Inherits="PQ.Admin.Presentation.SystemSettings.ExecutionLevel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/SystemSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/SystemSettings/executionLevel.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:SystemSettings, ExecutionLevel_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divExecutionLevel">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblExecutionLevel" width="100%">
                        </table>
                        <div id="pgrExecutionLevel">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divExecutionLevelDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblExecutionLevelName" Text="<%$ Resources:SystemSettings, ExecutionLevel_lblExecutionLevelName %>" /></label>
                    <input type="text" class="input-big" id="txtExLevelName" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblMatchScore" Text="<%$ Resources:SystemSettings, ExecutionLevel_lblMatchScore %>" /></label>
                    <input type="text" class="input-big" id="txtMatchScore" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblTipFormula" Text="<%$ Resources:SystemSettings, ExecutionLevel_lblTipFormula %>" /></label>
                    <input type="text" class="input-big" id="txtTipFormula" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblSemsFormula" Text="<%$ Resources:SystemSettings, ExecutionLevel_lblSemsFormula %>" /></label>
                    <input type="text" class="input-big" id="txtSemsFormula" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnUpdateExecutionLevel" runat="server" value="<%$ Resources:SystemSettings, ExecutionLevel_btnUpdateExecutionLevel %>"
                        class="button" clientidmode="Static" onclick="btnUpdateExecutionLevel_Click();" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:SystemSettings, ExecutionLevel_btnClose %>"
                        onclick="$('#divExecutionLevelDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidExecutionLevel_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, ExecutionLevel_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidExecutionLevel_Grid_ExecutionLevelName" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, ExecutionLevel_Grid_ExecutionLevelName %>"></asp:Label>
        <asp:Label ID="hidExecutionLevel_Grid_MatchScore" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:SystemSettings, ExecutionLevel_Grid_MatchScore %>"></asp:Label>
    </div>
    <asp:HiddenField runat="server" ID="hidExecutionLevelID" ClientIDMode="Static" />
    <script type="text/javascript">
        $(function () {
            executionLevel.CreateExecutionLevelGrid();
            $("#txtMatchScore").ForceNumericOnly();
        });

        function divExecutionLevelDetails_Open() {
            $("#divExecutionLevelDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '580px', modal: true, zIndex: 50,
                title: $('#hidExecutionLevel_MainGreeting').text(),
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


        function btnUpdateExecutionLevel_Click() {
            $("#waitplease").css({ 'display': 'block' });
            var editdata = {
                ExecutionLevel_ORGName: $("#txtExLevelName").val(),
                ExecutionLevel_ID: $("#hidExecutionLevelID").val(),
                MatchScore: $("#txtMatchScore").val(),
                TipFormula: $("#txtTipFormula").val(),
                SemsFormula: $("#txtSemsFormula").val()
            };
            executionLevel.SaveExecutionLevelData(editdata);
        };
    </script>
</asp:Content>
