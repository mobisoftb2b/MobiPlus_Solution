<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="EventTypeSettings.aspx.cs" EnableViewState="false" Inherits="PQ.Admin.Presentation.EventSettings.EventTypeSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EventTypeSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/EventSettings/eventSettings.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:EventSettings, EventSettings_MainGreeting %>" /></h2>
        <div class="emplSearch" id="divDefineEventSettings">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblEventTypeSettings" width="100%">
                        </table>
                        <div id="pgrEventTypeSettings">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divDefineEventSettingsDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblEventSettings_lblEventType" Text="<%$ Resources:EventSettings, EventSettings_lblEventType %>" /></label>
                    <input type="text" class="input-large" id="txtEventType" />
                </p>
            </div>
        </div>
        <div class="emplSearch" id="divRadiobuttons">
            <fieldset>
                <legend>
                    <asp:Label runat="server" ID="Label4" Text="<%$ Resources:EventSettings, EventSettings_Header_PerfomanceAssessment %>" /></legend>
                <div class="div_wrapper">
                    <p>
                        <input type="radio" id="rdExecutionLevel" class="jquery_improved" name="radiobutton" />
                        <label for="rdExecutionLevel" class="inline">
                            <asp:Label runat="server" ID="lblExecutionLebel" Text="<%$ Resources:EventSettings, EventSettings_lblExecutionLebel %>" /></label>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="radio" id="rdScore" class="jquery_improved" name="radiobutton" />
                        <label for="rdScore" class="inline">
                            <asp:Label runat="server" ID="lblScore" Text="<%$ Resources:EventSettings, EventSettings_lblScore %>" /></label>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="radio" id="rdQuantity" class="jquery_improved" name="radiobutton" />
                        <label for="rdQuantity" class="inline">
                            <asp:Label runat="server" ID="lblQuantity" Text="<%$ Resources:EventSettings, EventSettings_lblQuantity %>" /></label>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="radio" id="rbNone" class="jquery_improved" name="radiobutton" />
                        <label for="rbNone" class="inline">
                            <asp:Label runat="server" ID="Label2" Text="<%$ Resources:EventSettings, EventSettings_lblNone %>" /></label>
                    </p>
                </div>
            </fieldset>
        </div>
        <div class="emplSearch">
            <fieldset>
                <legend>
                    <asp:Label runat="server" ID="Label1" Text="<%$ Resources:EventSettings, EventSettings_Header_BestPerformance %>" /></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <input type="radio" id="rdoHightLevel" class="jquery_improved" value="1" checked="checked"
                                name="bestprefomance" />
                            <label for="lblBestPerformanceHightLevel" class="inline">
                                <asp:Label runat="server" ID="lblBestPerformanceHightLevel" Text="<%$ Resources:EventSettings, EventSettings_Header_BestPerformanceHightLevel %>" />&nbsp;(&nbsp;<font
                                    color="red">0</font>....<font color="green">100</font>&nbsp;)</label>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <input type="radio" id="rdoLowLevel" class="jquery_improved" value="0" name="bestprefomance" />
                            <label for="lblBestPerformanceLowLevel" class="inline">
                                <asp:Label runat="server" ID="lblBestPerformanceLowLevel" Text="<%$ Resources:EventSettings, EventSettings_Header_BestPerformanceLowLevel %>" />&nbsp;(&nbsp;<font
                                    color="red">100</font>....<font color="green">0</font>&nbsp;)</label>
                        </p>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label for="rdFailureRecovery" class="inline">
                        <asp:Label runat="server" ID="lblFailureRecovery" Text="<%$ Resources:EventSettings, EventSettings_lblFailureRecovery %>" /></label>
                    <input type="text" id="txtFailureRecovery" class="input-short" maxlength="5" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="checkbox" class="checkbox" id="chkOverridelStatus" />
                    <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblActivateComplStatus"
                        Text="<%$ Resources:SystemSettings, ReadinessLevel_OverrideStatus %>" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddNewEventType" runat="server" value="<%$ Resources:EventSettings, EventSettings_btnAddNewEventType %>"
                        class="button" clientidmode="Static" onclick="btnAddNewEventType_Click();" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:EventSettings, EventSettings_btnClose %>"
                        onclick="$('#divDefineEventSettingsDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidEventSettings_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidEventSettings_btnAddEventType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_btnAddEventType %>"></asp:Label>
        <asp:Label ID="hidEventSettings_Grid_EventType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_Grid_EventType %>"></asp:Label>
        <asp:Label ID="hidEventSettings_Grid_Score" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_Grid_Score %>"></asp:Label>
        <asp:Label ID="hidEventSettings_Grid_Quantity" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_Grid_Quantity %>"></asp:Label>
        <asp:Label ID="hidEventSettings_Grid_ExecutionLebel" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_Grid_ExecutionLebel %>"></asp:Label>
        <asp:Label ID="lblEventSettings_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:EventSettings, EventSettings_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblEventSubject_btnAddNewEventSubjects" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_btnAddNewEventType %>"></asp:Label>
        <asp:Label ID="hidEventSettings_DeleteEventSubjectError" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSettings_DeleteEventSubjectError %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidTrainingEventType_ID" runat="server" ClientIDMode="Static" />
    <script type="text/javascript">
        $(document).ready(function () {
            eventSetting.CreateEventSettingsGrid(null);
            $('input:checkbox').change(function () {
                $('input:checkbox').not(this).each(function (idx, el) {
                    el.checked = false;
                });
            });
        });

        function divDefineEventSettingsDetails_Open() {
            $("#divDefineEventSettingsDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '400px', modal: true, zIndex: 50,
                title: $('#hidEventSettings_MainGreeting').text(),
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

        $("#txtEventType").change(function () {
            $(this).removeClass("ui-state-error", 500);
        });

        $("#rdExecutionLevel, #rdQuantity, #rdScore").change(function () {
            $("#divRadiobuttons").removeClass('ui-state-error', 500);
        });

        function btnAddNewEventType_Click() {
            if (eventSetting.DefineEventTypeSettingRequaredFields()) {
                $("#waitplease").css({ 'display': 'block' });
                var _trainingEventType = {
                    TrainingEventType_Name: $("#txtEventType").val(),
                    isScoreRequiredField: $("#rdScore").attr('checked'),
                    isQuantityRequiredField: $("#rdQuantity").attr('checked'),
                    isExecutionLevelRequiredField: $("#rdExecutionLevel").attr('checked'),
                    RecoverFromFailureInDays: $("#txtFailureRecovery").val(),
                    TrainingEventType_ID: $("#hidTrainingEventType_ID").val(),
                    BestPerformance: $("#rdoHightLevel").attr('checked'),
                    OverrideStatus: $("#chkOverridelStatus").attr('checked'),
                    isNoneField: $("#rbNone").attr('checked')
                };
                eventSetting.SaveEventTypeSettingData(_trainingEventType);
            }
        };

      
      
    </script>
</asp:Content>
