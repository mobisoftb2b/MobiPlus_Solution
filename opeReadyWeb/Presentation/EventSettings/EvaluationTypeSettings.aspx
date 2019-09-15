<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="EvaluationTypeSettings.aspx.cs" Inherits="PQ.Admin.Presentation.EventSettings.EvaluationTypeSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EventTypeSettingsService.asmx" />
            <asp:ServiceReference Path="~/WebService/AlertSettingService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/EventSettings/evaluationTypeSettings.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:EventSettings, EvaluationType_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:EventSettings, EvaluationType_lblEventType %>" /></label>
                    <asp:DropDownList ID="ddlEventType" runat="server" ClientIDMode="Static" CssClass="select"
                        DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:EventSettings, EvaluationType_lblEventSubject %>" /></label>
                    <asp:DropDownList ID="ddlEventSubject" runat="server" ClientIDMode="Static" CssClass="select"
                        DataTextField="TrainingEventCategory_Name" DataValueField="TrainingEventCategory_ID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" runat="server" value="<%$ Resources:EventSettings, EvaluationType_btnEvaluationTypeFilter %>"
                        onclick="btnFilter_Click()" />
                </p>
            </div>
        </div>
        <div class="emplSearch" id="divDefineEvaluationType">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblEvaluationType" width="100%">
                        </table>
                        <div id="pgrEvaluationType">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divDefineEvaluationTypeDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblEvaluationType_lblEventType" Text="<%$ Resources:EventSettings, EvaluationType_lblEventType  %>" /></label>
                    <asp:DropDownList ID="ddlEventTypeDetails" runat="server" ClientIDMode="Static" CssClass="select"
                        DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID">
                    </asp:DropDownList>
                    <input type="text" class="input-medium" id="txtEventTypeDetails" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <label class="label">
                    <asp:Label runat="server" ID="lblEvaluationType_lblEventSubject" Text="<%$ Resources:EventSettings, EvaluationType_lblEventSubject  %>" /></label>
                <asp:DropDownList ID="ddlEventSubjectDetails" runat="server" ClientIDMode="Static"
                    CssClass="select" DataTextField="TrainingEventCategory_Name" DataValueField="TrainingEventCategory_ID">
                </asp:DropDownList>
                <input type="text" class="input-medium" id="txtEventSubjectDetails" readonly="readonly" />
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label3" Text="<%$ Resources:EventSettings, EvaluationType_lblSubEvaluationType  %>" /></label>
                    <input type="text" class="input-medium" id="txtSubEvaluationType" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddNewEvaluationType" runat="server" value="<%$ Resources:EventSettings, EvaluationType_btnAddEvaluationType %>"
                        class="button" onclick="btnAddNewEvaluationType_Click();" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:EventSettings, EventSettings_btnClose %>"
                        onclick="$('#divDefineEvaluationTypeDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidEvaluationType_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EvaluationType_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidEvaluationType_btnAddEvaluationType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EvaluationType_btnAddEvaluationType %>"></asp:Label>
        <asp:Label ID="hidEvaluationType_Grid_EventType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EvaluationType_Grid_EventType %>"></asp:Label>
        <asp:Label ID="hidEvaluationType_Grid_EventSubject" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EvaluationType_Grid_EventSubject %>"></asp:Label>
        <asp:Label ID="hidEvaluationType_Grid_SubEvaluationType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EvaluationType_Grid_SubEvaluationType %>"></asp:Label>
        <asp:Label ID="hidEvaluationTpe_GrtTrainingEventCategory" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EvaluationTpe_GrtTrainingEventCategory %>"></asp:Label>
        <asp:Label ID="lblEventSettings_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:EventSettings, EventSettings_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblEvaluationType_btnAddEvaluationType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EvaluationType_btnAddEvaluationType %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidSubEvaluationTypeID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            $("#waitplease").css({ 'display': 'block' });
            evaluationType.CreateEvaluationTypeGrid("ddlEventSubject");
        });

        function divDefineEvaluationTypeDetails_Open() {
            $("#divDefineEvaluationTypeDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '580px', modal: true, zIndex: 50,
                title: $('#hidEvaluationType_MainGreeting').text(),
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

        function btnFilter_Click() {
            $("#waitplease").css({ 'display': 'block' });
            $("#tblEvaluationType").GridUnload();
            evaluationType.CreateEvaluationTypeGrid("ddlEventSubject");
        }

        $("#ddlEventType").change(function () {
            $("#ddlEventSubject").addClass("ui-autocomplete-ddl-loading");
            evaluationType.PopulateTrainingEventCategoryCombo($(this).val());
        });
        $("#ddlEventTypeDetails").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass("ui-state-error", 100);
            $("#ddlEventSubjectDetails").addClass("ui-autocomplete-ddl-loading");
            evaluationType.PopulateTrainingEventCategoryDetailsCombo($(this).val());
        });
        $("#ddlEventSubjectDetails").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass("ui-state-error", 100);
        });

        function btnAddNewEvaluationType_Click() {
            if (evaluationType.DefineEvaluationTypeRequaredFields()) {
                $("#waitplease").css({ 'display': 'block' });
                var evaltype = {
                    TrainingEventType_ID: $("#ddlEventTypeDetails").val(),
                    TrainingEventCategory_ID: $("#ddlEventSubjectDetails").val(),
                    SubEvaluationType_Name: $("#txtSubEvaluationType").val(),
                    SubEvaluationType_ID: $("#hidSubEvaluationTypeID").val()
                };
                evaluationType.SaveEvaluationTypeData(evaltype);
            }
        };

    </script>
</asp:Content>
