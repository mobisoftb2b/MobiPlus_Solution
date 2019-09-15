<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="EventSubjectSettings.aspx.cs" Inherits="PQ.Admin.Presentation.EventSettings.EventSubjectSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EventTypeSettingsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/EventSettings/eventSubjectSettings.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:EventSettings, EventSubject_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:EventSettings, EventSubject_lblEventType %>" /></label>
                    <asp:DropDownList ID="ddlEventType" runat="server" ClientIDMode="Static" CssClass="select"
                        DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID" />
                </p>
            </div>
            <div class="div_wrapper" style="margin-top: 24px">
                <p>
                    <input type="button" class="button" id="btnFilter" runat="server" value="<%$ Resources:EventSettings, EventSubject_btnEventTypeFilter %>"
                        onclick="btnFilter_Click()" />
                </p>
            </div>
        </div>
        <div class="emplSearch" id="divDefineEventSubject">
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <table cellpadding="0" cellspacing="0" id="tblEventSubjects" width="100%">
                        </table>
                        <div id="pgrEventSubjects">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div id="divDefineEventSubjectsDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblEventSettings_lblEventType" Text="<%$ Resources:EventSettings, EventSubject_lblEventType  %>" /></label>
                    <asp:DropDownList ID="ddlEventTypeDetails" runat="server" ClientIDMode="Static" CssClass="select"
                        DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID">
                    </asp:DropDownList>
                    <input type="text" class="input-medium" id="txtEventTypeDetails" readonly="readonly" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:EventSettings, EventSubject_lblEventSubjects %>" /></label>
                    <input type="text" id="txtEventSubject" class="input-medium" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddNewEventSubjects" runat="server" value="<%$ Resources:EventSettings, EventSubject_btnAddNewEventSubjects %>"
                        class="button" onclick="btnAddNewEventSubjects_Click();" clientidmode="Static" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:EventSettings, EventSubject_btnClose %>"
                        onclick="$('#divDefineEventSubjectsDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidEventSubject_MainGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSubject_MainGreeting %>"></asp:Label>
        <asp:Label ID="hidEventSubjects_btnAddEventType" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSubjects_btnAddEventType %>"></asp:Label>
        <asp:Label ID="hidEventSubject_Grid_TrainingEventType_Name" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:EventSettings, EventSubject_Grid_TrainingEventType_Name %>"></asp:Label>
        <asp:Label ID="hidEventSubject_Grid_TrainingEventCategory_Name" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:EventSettings, EventSubject_Grid_TrainingEventCategory_Name %>"></asp:Label>
        <asp:Label ID="lblEventSettings_btnUpdate" ClientIDMode="Static" runat="server" Text="<%$ Resources:EventSettings, EventSettings_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblEventSubject_btnAddNewEventSubjects" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:EventSettings, EventSubject_btnAddNewEventSubjects %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidTrainingEventCategory_ID" runat="server" ClientIDMode="Static" />
    <script type="text/javascript">
        $(function () {
            eventSubject.CreateEventSubjectsGrid(null);
        });

        function btnFilter_Click() {
            $('#divDefineEventSubject').block({
                css: { border: '0px' },
                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                message: ''
            });
            $("#tblEventSubjects").GridUnload();
            eventSubject.CreateEventSubjectsGrid($("#ddlEventType").val());
        };

        function divDefineEventSubjectsDetails_Open() {
            $("#divDefineEventSubjectsDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '400px', modal: true, zIndex: 50,
                title: $('#hidEventSubject_MainGreeting').text(),
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

        function btnAddNewEventSubjects_Click() {
            if (RequaredFields()) {
                $("#waitplease").css({ 'display': 'block' });
                var trainingEventCategory = {
                    TrainingEventCategory_ID: ($("#hidTrainingEventCategory_ID").val() == "" ? 0 : $("#hidTrainingEventCategory_ID").val()),
                    TrainingEventType_ID: $("#ddlEventTypeDetails").val(),
                    TrainingEventCategory_Name: $("#txtEventSubject").val()
                };
                eventSubject.SaveEventSubjectSettingData(trainingEventCategory);
            }
        };

        function RequaredFields() {
            var result = new Boolean(true);

            if ($("#ddlEventTypeDetails").val() == "0") {
                $("#ddlEventTypeDetails").addClass('ui-state-error').focus();
                return false;
            }
            else {
                $("#ddlEventTypeDetails").removeClass('ui-state-error', 500);
                result = true;
            }

            if ($("#txtEventSubject").val() == "") {
                $("#txtEventSubject").addClass('ui-state-error').focus();
                return false;
            }
            else {
                $("#txtEventSubject").removeClass('ui-state-error', 500);
                result = true;
            }
            return result;
        };

        $("#ddlEventTypeDetails").change(function () {
            $(this).removeClass('ui-state-error', 500);
        });
        $("#txtEventSubject").change(function () {
            $(this).removeClass('ui-state-error', 500);
        });

    </script>
</asp:Content>
