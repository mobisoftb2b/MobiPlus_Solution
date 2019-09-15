<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OrgJobs.aspx.cs" EnableViewState="false" Inherits="PQ.Admin.Presentation.OrganizationalStructure.OrgJobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content">
        <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/WebService/OrgUnitsService.asmx" />
            </Services>
            <Scripts>
                <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
                <asp:ScriptReference Path="~/Resources/Scripts/OrganizationalUnits/organizationalJobs.js" />
            </Scripts>
        </asp:ScriptManagerProxy>
        <div id="Div1">
            <h2>
                <asp:Label ID="lblOrgJobs_MainGreeting" runat="server" Text="<%$ Resources:OrgStructure, OrgJobs_MainGreeting %>" /></h2>
            <div class="emplSearch">
                <fieldset>
                    <legend></legend>
                    <div class="emplSearch" id="divJobSettings">
                        <div class="div_wrapper">
                            <table cellpadding="0" cellspacing="0" id="tblJobSettings" width="100%">
                            </table>
                            <div id="pgrJobSettings">
                            </div>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
        <div id="divJobSettingsDetails" style="overflow-x: hidden; display: none">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblOrgJob_lblJobName" Text="<%$ Resources:OrgStructure, OrgJob_lblJobName %>" /></label>
                        <input type="text" class="input-medium" id="txtJobName" tabindex="1" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblOrgJob_lblFromDate" Text="<%$ Resources:OrgStructure, OrgJob_lblFromDate %>" /></label>
                        <span>
                            <asp:TextBox CssClass="input-medium PQ_datepicker_input" TabIndex="2" ID="txtFromDateJob"
                                runat="server" ClientIDMode="Static" />
                        </span>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblOrgJob_lblToDate" Text="<%$ Resources:OrgStructure, OrgJob_lblToDate %>" /></label>
                        <span>
                            <asp:TextBox runat="server" ID="txtToDateJob" CssClass="input-medium PQ_datepicker_input"
                                ClientIDMode="Static" />
                        </span>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnAddOrgJobSetting" runat="server" clientidmode="Static"
                            value="<%$ Resources:OrgStructure, OrgJob_btnAddJobSetting %>" class="button"
                            onclick="btnAddOrgJobSetting_Click();" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" id="btnClose" runat="server" value="<%$ Resources:OrgStructure, OrgJob_btnClose %>"
                            onclick="$('#divJobSettingsDetails').dialog('destroy');" class="button" />
                    </p>
                </div>
            </div>
        </div>
        <div class="no-display">
            <asp:Label runat="server" ID="hidJob_Grid_Job_Name" ClientIDMode="Static" Text="<%$ Resources:OrgStructure, OrgJob_Grid_Job_Name %>"></asp:Label>
            <asp:Label runat="server" ID="hidJobSettings_btnAddNewJob" ClientIDMode="Static"
                Text="<%$ Resources:OrgStructure, OrgJob_btnAddNewJob %>"></asp:Label>
            <asp:Label ID="hidOrgJobs_MainGreeting" ClientIDMode="Static" runat="server" Text="<%$ Resources:OrgStructure, OrgJobs_MainGreeting %>" />
            <asp:Label ID="hidOrgJob_btnAddJobSetting" ClientIDMode="Static" runat="server" Text="<%$ Resources:OrgStructure, OrgJob_btnAddJobSetting %>" />
            <asp:Label ID="hidOrgJob_btnUpdateJobSetting" ClientIDMode="Static" runat="server"
                Text="<%$ Resources:OrgStructure, OrgJob_btnUpdateJobSetting %>" />
            <asp:Label ID="hidOrgJobs_DeleteJobError" ClientIDMode="Static" runat="server" Text="<%$ Resources:OrgStructure, OrgJobs_DeleteJobError %>" />
        </div>
    </div>
    <asp:HiddenField ID="hidJobID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            orgJob.CreateJobSettingsGrid();
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);
            $(".PQ_datepicker, .PQ_datepicker_input").datepicker({
                beforeShow: function (i, e) {
                    var z = jQuery(i).closest(".ui-dialog").css("z-index") + 15;
                    e.dpDiv.css('z-index', (isNaN(z) ? 1 : z));
                }, changeYear: true, changeMonth: true
            });
        });

        function divJobSettingsDetails_Open() {
            $("#divJobSettingsDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '600px', modal: true, zIndex: 50,
                title: $('#hidOrgJobs_MainGreeting').text(),
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
                    $("#txtJobName, #txtFromDateJob").removeClass('ui-state-error');
                }
            });
            return false;
        }


        function btnAddOrgJobSetting_Click() {
            if (JobRequaredFields()) {
                $("#waitplease").css({ 'display': 'block' });
                var jobvalue = {
                    Job_ID: $("#hidJobID").val() === "" ? 0 : $("#hidJobID").val(),
                    Job_Name: $("#txtJobName").val(),
                    Job_ValidFromDateStr: $("#txtFromDateJob").val(),
                    Job_ValidToDateStr: $("#txtToDateJob").val()
                };
                orgJob.JobSettings_Save(jobvalue);                
            }
        }

        function JobRequaredFields() {
            if ($("#txtJobName").val() == "") {
                $("#txtJobName").addClass('ui-state-error');
                return false;
            } else { $("#txtJobName").removeClass('ui-state-error'); }

            if ($("#txtFromDateJob").val() == "") {
                $("#txtFromDateJob").addClass('ui-state-error');
                return false;
            } else { $("#txtFromDateJob").removeClass('ui-state-error'); }
            return true;
        }

        $("#txtJobName").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 150);
        });
        $("#txtFromDateJob").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 150);
        });
    </script>
</asp:Content>
