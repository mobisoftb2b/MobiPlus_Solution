<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ReadinessAlert.aspx.cs" Inherits="PQ.Admin.Presentation.AlertSettings.WebReadinessAlert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/SystemSettingsService.asmx" />
            <asp:ServiceReference Path="~/WebService/AlertSettingService.asmx" />
            <asp:ServiceReference Path="~/WebService/EventRecords.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/AlertSettings/readinessAlert.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/SystemSettings/readinessLevel.min.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2>
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:AlertSettings, ReadinessAlert_MainGreeting %>" /></h2>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblEmployeeID" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblJob %>" /></label>
                        <asp:DropDownList ID="ddlJobsList" runat="server" AppendDataBoundItems="true" DataTextField="Job_Name"
                            ClientIDMode="Static" DataValueField="Job_ID">
                            <asp:ListItem Value="0" Text="<%$ Resources:AlertSettings, ReadinessAlert_ddlJobGreeting %>"></asp:ListItem>
                        </asp:DropDownList>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="button" value="<%$ Resources:AlertSettings, ReadinessAlert_btnSearch %>"
                            class="button" style="margin-top: 23px" id="btnSearch" runat="server" clientidmode="Static" />
                    </p>
                </div>
            </fieldset>
        </div>
        <div class="emplSearch" id="divReadinessAlert">
            <div class="div_wrapper">
                <table cellpadding="0" cellspacing="0" id="tblReadinessAlert" width="100%">
                </table>
                <div id="pgrReadinessAlert">
                </div>
            </div>
        </div>
        <div class="div_wrapper">
            <p>
                <span id="divReadinessCalculation">
                    <input type="button" value="<%$ Resources:AlertSettings, ReadinessAlert_btnReadinessCalculation %>"
                        class="button" style="margin-top: 23px" id="btnReadinessCalculation" runat="server"
                        clientidmode="Static" onclick="btnReadinessCalculation_Click();" />
                </span>
            </p>
        </div>
        <div class="div_wrapper">
            <p>
                <input type="checkbox" class="checkbox" id="chkMultiJobReadiness" style="margin-top: 25px" />
                <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblMultiJobReadiness"
                    Text="<%$ Resources:SystemSettings, ReadinessLevel_lblMultiJobReadiness %>" />
            </p>
        </div>
          <div class="div_wrapper">
            <p>
                <input type="checkbox" class="checkbox" id="chkActivateComplStatus" style="margin-top: 25px" />
                <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblActivateComplStatus"
                    Text="<%$ Resources:SystemSettings, ReadinessLevel_lblActivateComplStatus %>" />
            </p>
        </div>
    </div>
    <div class="emplSearch">
        <p>
            &nbsp;</p>
    </div>
    <div id="divReadinessAlertDetails" style="overflow-x: hidden; display: none">
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblReadinessAlert_lblJob" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblJob %>" /></label>
                    <asp:DropDownList ID="ddlJobs" runat="server" AppendDataBoundItems="true" DataTextField="Job_Name"
                        CssClass="select-hyper" ClientIDMode="Static" DataValueField="Job_ID">
                        <asp:ListItem Value="0" Text="<%$ Resources:AlertSettings, ReadinessAlert_ddlJobGreeting %>"></asp:ListItem>
                    </asp:DropDownList>
                    <input type="text" class="input-hyper" readonly="readonly" id="txtJobs" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblReadinessAlert_lblTrainingEventType" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblTrainingEventType %>" /></label>
                    <asp:DropDownList ID="ddlTrainingEventType" ClientIDMode="Static" runat="server"
                        AppendDataBoundItems="true" CssClass="select-hyper" DataTextField="TrainingEventType_Name"
                        DataValueField="TrainingEventType_ID">
                    </asp:DropDownList>
                    <input type="text" class="input-hyper" readonly="readonly" id="txtTrainingEventType" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="lblReadinessAlert_lblEventCategory" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblEventCategory %>" /></label>
                    <asp:DropDownList ID="ddlEventCategory" ClientIDMode="Static" runat="server" CssClass="select-hyper"
                        DataTextField="TrainingEventCategory_Name" DataValueField="TrainingEventCategory_ID">
                    </asp:DropDownList>
                    <input type="text" class="input-hyper" readonly="readonly" id="txtEventCategory" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblQuantity4Period %>" /></label>
                    <input type="text" class="input-hyper" id="txtQuantity4Period" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblMinQuantity4Period %>" /></label>
                    <input type="text" class="input-hyper" id="txtMinQuantuty4Period" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label3" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblThresholdLevelInDays %>" /></label>
                    <input type="text" class="input-hyper" id="txtThresholdLevelInDays" />
                </p>
            </div>
        </div>
        <div class="emplSearch" id="ScoreArea">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label4" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblGraceInDay %>" /></label>
                    <input type="text" class="input-hyper" id="txtGraceInDay" />
                </p>
            </div>
            <%-- <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label5" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblAlertInDay %>" /></label>
                    <input type="text" class="input-hyper" id="txtAlertInDay" />
                </p>
            </div>--%>
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label6" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblNumOfFailures4Alert %>" /></label>
                    <asp:DropDownList ID="txtNumOfFailures4Alert" ClientIDMode="Static" runat="server"
                        CssClass="select-hyper">
                        <asp:ListItem Value="-1" Selected="True" Text="<%$ Resources:AlertSettings, ReadinessAlert_ddlNumOfFailures4Alert %>"></asp:ListItem>
                        <asp:ListItem Value="1" Text="YES"></asp:ListItem>
                        <asp:ListItem Value="0" Text="NO"></asp:ListItem>
                    </asp:DropDownList>
                </p>
            </div>
            <div class="div_wrapper divTotalScore no-display" id="divThresholdScore">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label7" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblThresholdScore %>" /></label>
                    <input type="text" class="input-hyper" id="txtTotalScore" />
                </p>
            </div>
            <div class="div_wrapper divQuality no-display" id="divThresholdQuantity">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label8" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblThresholdQuantity %>" /></label>
                    <input type="text" class="input-hyper" id="txtQuality" />
                </p>
            </div>
            <div class="div_wrapper divPerfomanceLevel no-display" id="divThresholdExecutionLevel">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label9" Text="<%$ Resources:AlertSettings, ReadinessAlert_ddlThresholdExecutionLevel %>" /></label>
                    <asp:DropDownList ID="ddlPerfomanceLevel" CssClass="select-hyper" runat="server"
                        DataValueField="ExecutionLevel_ID" DataTextField="ExecutionLevel_ORGName" ClientIDMode="Static">
                    </asp:DropDownList>
                </p>
            </div>
        </div>
        <div class="emplSearch" id="divCumulativeQuantity">
            <div class="div_wrapper">
                <p>
                    <input type="checkbox" class="checkbox" id="chkCumulativeQuantity" />
                    <label class="inline checkboxinline">
                        <asp:Label runat="server" ID="Label5" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblCumulativeQuantity %>" /></label>
                </p>
            </div>
        </div>
        <div class="emplSearch noDisplay" id="divMinTipImages">
            <div class="div_wrapper">
                <p>
                    <label class="label">
                        <asp:Label runat="server" ID="Label10" Text="<%$ Resources:AlertSettings, ReadinessAlert_lblMinTipImages %>" /></label>
                    <input type="text" class="input-hyper" id="txtMinTipImages" />
                </p>
            </div>
        </div>
        <div class="emplSearch">
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnAddReadinessAlert" runat="server" clientidmode="Static"
                        value="<%$ Resources:AlertSettings, ReadinessAlert_btnAddAlert %>" class="button"
                        onclick="btnAddReadinessAlert_Click();" />
                </p>
            </div>
            <div class="div_wrapper">
                <p>
                    <input type="button" id="btnClose" runat="server" value="<%$ Resources:AlertSettings, ReadinessAlert_btnClose %>"
                        onclick="$('#divReadinessAlertDetails').dialog('destroy');" class="button" />
                </p>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidReadinessAlert_HeaderDefine" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_HeaderDefine %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_btnAddReadinessAlert" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_btnAddReadinessAlert %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_TrainingEventCategoryName" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_TrainingEventCategoryName %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_TrainingEventTypeName" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_TrainingEventTypeName %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_Quantity4Period" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_Quantity4Period %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_MinQuantity4Period" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_MinQuantity4Period %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_ThresholdLevelInDays" ClientIDMode="Static"
            runat="server" Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_ThresholdLevelInDays %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_GraceInDays" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_GraceInDays %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_AlertInDays" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_AlertInDays %>"></asp:Label>
        <asp:Label ID="hidReportsParam_GrtTrainingEventCategory" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_GrtTrainingEventCategory %>"></asp:Label>
        <asp:Label ID="hidReadinessAlert_Grid_Job_Name" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_Grid_Job_Name %>"></asp:Label>
        <asp:Label ID="lblReadinessAlert_btnUpdate" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, AlertSettings_btnUpdate %>"></asp:Label>
        <asp:Label ID="lblReadinessAlert_btnAddAlert" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:AlertSettings, ReadinessAlert_btnAddAlert %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidTrainingEventCategoryID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            var _readinessAlert = {
                Job_ID: $("#ddlJobsList").val()
            };
            $('#tblReadinessAlert').GridUnload();
            readinessAlert.CreateReadinessAlertGrid(_readinessAlert);
            readiness.GetchkMultiJobReadiness();
            readinessAlert.GetActivateComplianceStatus();
        });
        $('#txtQuantity4Period,#txtMinQuantuty4Period, #txtThresholdLevelInDays,#txtGraceInDay,#txtMinTipImages, #txtTotalScore,#txtQuality')
        .keypress(function (event) {
            //Allow only backspace and delete
            if (event.keyCode != 48 && event.keyCode != 8 && event.keyCode != 46) {
                if (!parseInt(String.fromCharCode(event.which))) {
                    event.preventDefault();
                }
            }
        });
        $("#chkMultiJobReadiness").click(function () {
            $("#waitplease").css({ 'display': 'block' });
            readiness.UpdateMultiJobReadiness($(this).attr("checked"));
        });
        $("#btnSearch").click(function () {
            var _readinessAlert = {
                Job_ID: $("#ddlJobsList").val()
            };
            $('#tblReadinessAlert').GridUnload();
            readinessAlert.CreateReadinessAlertGrid(_readinessAlert);
        });
        $("#chkCumulativeQuantity").click(function () {
            if ($(this).attr('checked'))
                $('#txtQuantity4Period,#txtMinQuantuty4Period').attr("readonly", true).val("").removeClass('ui-state-error');
            else
                $('#txtQuantity4Period,#txtMinQuantuty4Period').removeAttr('readonly');
        });
        $("#chkActivateComplStatus").click(function () {
            var status = 0;
            RaiseLoader(true);
            if ($(this).attr('checked')) status = 1;
            readinessAlert.UpdateActivateComplianceStatus(status);
        });

        function divReadinessAlertDetails_Open() {
            $("#divReadinessAlertDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '850px', modal: true, zIndex: 50,
                title: $('#hidReadinessAlert_HeaderDefine').text(),
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
                    SetVisibilityText($('#ddlTrainingEventType  option:selected').val());
                    $('#txtQuantity4Period,#txtMinQuantuty4Period, #txtThresholdLevelInDays,#txtGraceInDay, #txtTotalScore,#txtQuality').removeClass('ui-state-error');
                }
            });
            return false;
        };

        $("#ddlTrainingEventType").change(function () {
            readinessAlert.PopulateTrainingEventCategoryCombo($(this).val());
            SetVisibilityText($(this).val());
        });

        function btnAddReadinessAlert_Click() {
            readinessAlert.DefineReadinessAlert_Save();
        }

        $("#ddlJobs").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 500);
        });
        $("#ddlTrainingEventType").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 500);
        });
        $("#ddlEventCategory").change(function () {
            if ($(this).val() != "0")
                $(this).removeClass('ui-state-error', 500);
        });
        $("#txtThresholdLevelInDays").change(function () {
            if ($(this).val() != "")
                $(this).removeClass('ui-state-error', 500);
        });
        function btnReadinessCalculation_Click() {
            $("#waitplease").css({ 'display': 'block' });
            $("#divReadinessCalculation").block({
                css: { border: '0px' },
                overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                message: ''
            });
            PQ.Admin.WebService.AlertSettingService.CalculateReadinessMain(
            function (result) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divReadinessCalculation').unblock();
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divReadinessCalculation').unblock();
            });
        };
    </script>
</asp:Content>
