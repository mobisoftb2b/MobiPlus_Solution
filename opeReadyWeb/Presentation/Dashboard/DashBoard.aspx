<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="DashBoard.aspx.cs" Inherits="PQ.Admin.Presentation.Dashboard.DashBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/DashboardService.svc" />
            <asp:ServiceReference Path="~/WebService/AlertSettingService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/employee.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Dashboard/dashboard.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2 class="jquery_tab_title">
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:Dashboard,  DB_Config_MainGreeting %>" /></h2>
        <div id="divConfigLine" style="margin-top: 1em">
            <fieldset>
                <div class="emplSearch" id="divToolbar" >
                    <%-- ReSharper disable once UnknownCssClass --%>
                    <div class="div_wrapper treeUnitsEdit ui-helper-hidden" >
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblEmployeeID" Text="<%$ Resources:Dashboard, DB_Config_lblUnit %>" /></label>
                            <span>
                                <input class="combobox" type="text" id="ddlUnit" runat="server" clientidmode="Static"
                                    onclick="OnClientPopup_Click();" />
                                <div id="treeUnits">
                                </div>
                            </span>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblYear" Text="<%$ Resources:Dashboard, DB_Config_lblYear %>" /></label>
                            <asp:DropDownList Style="width: 190px" ID="ddlYear" CssClassclass="select" runat="server"
                                AppendDataBoundItems="True" ClientIDMode="Static">
                                <asp:ListItem Value="0" Text="<%$ Resources:Dashboard, DB_Config_ddlYearGreeting %>" />
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblMonth" Text="<%$ Resources:Dashboard, DB_Config_lblMonth %>" /></label>
                            <asp:DropDownList Style="width: 190px" ID="ddlMonth" runat="server" ClientIDMode="Static"
                                class="select" AppendDataBoundItems="True">
                                <asp:ListItem Value="0" Text="<%$ Resources:Dashboard, DB_Config_optMonthGreeting %>" />
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="button" value="<%$ Resources:Dashboard, DB_Config_btnRefresh %>" class="button"
                                style="margin-top: 23px" id="btnRefresh" runat="server" clientidmode="Static" />
                            
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input type="button" value="<%$ Resources:Dashboard, DB_Config_btnConfig %>" class="button"
                                style="margin-top: 23px" id="btnConfig" runat="server" clientidmode="Static" />
                        </p>
                    </div>
                </div>
            </fieldset>
        </div>
        <div id="divParamPanel" style="display: none">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <fieldset>
                        <div class="emplSearch" style="width: 100%">
                            <div class="div_wrapper" style="margin-top: 5px">
                                <p>
                                    <h1>
                                        <b>
                                            <asp:Label runat="server" ID="lblUserName"></asp:Label></b></h1>
                                </p>
                            </div>
                            <div class="div_wrapper" style="width: 180px">
                            </div>
                            <div class="div_wrapper">
                                <div class="div_wrapper">
                                    <div class="div_wrapper" style="margin-top: 5px">
                                        <label class="label">
                                            <asp:Label runat="server" ID="lblCopyFromUser" Text="<%$ Resources:Dashboard, DB_Config_lblCopyFromUser %>" /></label>
                                    </div>
                                    <div class="div_wrapper">
                                        <asp:DropDownList runat="server" ID="ddlCopyFromUser" CssClass="select-hyper" ClientIDMode="Static" AppendDataBoundItems="True">
                                            <asp:ListItem Text="<%$ Resources:Dashboard, DB_Config_CopyFromUser_Greeting %>"
                                                Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="div_wrapper">
                                        <input type="button" value="<%$ Resources:Dashboard, DB_Config_btnCopyUser %>" class="button"
                                            id="btnUserConfig" runat="server" clientidmode="Static" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
            <div class="emplSearch">
                <table>
                    <tr>
                        <td style="vertical-align: top">
                            <div class="div_wrapper">
                                <p>
                                    <asp:ListBox ID="lsbReportList" runat="server" Height="400" Width="200" Rows="50"
                                        ClientIDMode="Static" />
                                </p>
                            </div>
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <div class="div_wrapper">
                                        <div class="move_down">
                                        </div>
                                    </div>
                                    <div class="div_wrapper">
                                        &nbsp;
                                    </div>
                                    <div class="div_wrapper">
                                        <div class="move_up">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="emplSearch">
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" value="<%$ Resources:Dashboard, DB_Config_btnAddReport %>" class="button"
                                            id="btnAddReport" runat="server" clientidmode="Static" /></p>
                                </div>
                                <div class="div_wrapper">
                                    <p>
                                        <input type="button" value="<%$ Resources:Dashboard, DB_Config_btnDeleteReport %>"
                                            class="button" id="btnDeleteReport" runat="server" clientidmode="Static" /></p>
                                </div>
                            </div>
                        </td>
                        <td style="vertical-align: top">
                            <div class="div_wrapper" id="divMainConfig" style="display: none;width: 560px">
                                <fieldset>
                                    <legend>
                                        <label class="label">
                                            <asp:Label runat="server" ID="lblViewConfig" Text="<%$ Resources:Dashboard, DB_Config_lblViewConfig %>" /></label></legend>
                                    <div class="emplSearch" style="display: none">
                                        <div class="div_wrapper dvadtsat">
                                            <p>
                                                <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Dashboard, DB_Config_lblOrder %>" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="text" class="input-hyper" id="txtOrder" readonly="readonly" />
                                            </p>
                                        </div>
                                      
                                    </div>
                                    <div class="emplSearch">
                                        <div class="div_wrapper dvadtsat">
                                            <p>
                                                <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Dashboard, DB_Config_lblViewName %>" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <input type="text" class="input-hyper" id="txtViewName" />
                                            </p>
                                        </div>
                                          <div class="div_wrapper">
                                            <p>
                                                <input type="checkbox" runat="server" class="checkbox" id="chkDashboardItemEnabled"
                                                    checked="checked" clientidmode="Static" />
                                                <label class="inline checkboxinline" for="chkDashboardItemEnabled">
                                                    <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblDashboardItemEnabled"
                                                        Text="<%$ Resources:Dashboard, DB_Config_lblDashboardItemEnabled %>" /></label>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="emplSearch">
                                        <div class="div_wrapper dvadtsat">
                                            <p>
                                                <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Dashboard, DB_Config_lblViewSource %>"></asp:Label>
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <asp:DropDownList ID="ddlViewSource" runat="server" ClientIDMode="Static" class="select-hyper">
                                                    <asp:ListItem Value="0" Text="<%$ Resources:Dashboard, DB_Config_SourceType_Greeting %>" />
                                                    <asp:ListItem Value="1" Text="<%$ Resources:Dashboard, DB_Config_SourceType_optAdminTask %>" />
                                                    <asp:ListItem Value="2" Text="<%$ Resources:Dashboard, DB_Config_SourceType_optComplianceTask %>" />
                                                    <asp:ListItem Value="3" Text="<%$ Resources:Dashboard, DB_Config_SourceType_optComplianceStatus %>" />
                                                    <asp:ListItem Value="4" Text="<%$ Resources:Dashboard, DB_Config_SourceType_optMaintenanceItem %>" />
                                                </asp:DropDownList>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="emplSearch" id="divChartType">
                                        <div class="div_wrapper dvadtsat">
                                            <p>
                                                <asp:Label runat="server" ID="Label4" Text="<%$ Resources:Dashboard, DB_Config_lblChatType %>" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper" >
                                            <p>
                                                <asp:DropDownList ID="ddlChartType" runat="server" ClientIDMode="Static" class="select-hyper">
                                                    <asp:ListItem Value="0" Text="<%$ Resources:Dashboard, DB_Config_ChartType_Greeting %>" />
                                                    <asp:ListItem Value="1" Text="<%$ Resources:Dashboard, DB_Config_ChartType_optColumnChart %>" />
                                                    <asp:ListItem Value="2" Text="<%$ Resources:Dashboard, DB_Config_ChartType_optBarChar %>" />
                                                </asp:DropDownList>
                                            </p>
                                        </div>
                                        <div class="div_wrapper" id="divChartTypeIcon">
                                            <p>
                                                <img alt="chat type" id="imgChatType" style="display: none; height: 25px" /></p>
                                        </div>
                                    </div>
                                </fieldset>
                                <div style="display: none!important" id="divComplianceTaskParam">
                                    <fieldset id="flsComplianceTaskParam">
                                        <legend>
                                            <asp:Label runat="server" ID="Label8" Text="<%$ Resources:Dashboard, DB_Config_lblComplianceTaskParam %>" /></legend>
                                        <div class="emplSearch">
                                            <div class="div_wrapper dvadtsat">
                                                <p>
                                                    <asp:Label runat="server" ID="Label5" Text="<%$ Resources:Dashboard, DB_Config_lblTaskName %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:DropDownList ID="ddlTaskName" runat="server" ClientIDMode="Static" class="select-hyper"
                                                        DataTextField="TrainingEventType_Name" DataValueField="TrainingEventType_ID">
                                                    </asp:DropDownList>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="emplSearch">
                                            <div class="div_wrapper dvadtsat">
                                                <p>
                                                    <asp:Label runat="server" ID="Label6" Text="<%$ Resources:Dashboard, DB_Config_lblDataLevel %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"
                                                        ID="rdbDataLevel">
                                                        <asp:ListItem Value="1" Selected="True" Text="<%$ Resources:Dashboard, DB_Config_DataLevel_optBySubject %>" />
                                                        <asp:ListItem Value="2" Text="<%$ Resources:Dashboard, DB_Config_DataLevel_optByCriteria %>" />
                                                    </asp:RadioButtonList>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="emplSearch">
                                            <div class="div_wrapper dvadtsat">
                                                <p>
                                                    <asp:Label runat="server" ID="Label7" Text="<%$ Resources:Dashboard, DB_Config_lblTaskSubject %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:DropDownList ID="ddlTaskSubject" runat="server" ClientIDMode="Static" class="select-hyper"
                                                        AppendDataBoundItems="True">
                                                        <asp:ListItem Value="0" Text="<%$ Resources:Dashboard, DB_Config_TaskSubject_optGreeting %>" />
                                                    </asp:DropDownList>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="emplSearch">
                                            <div class="div_wrapper dvadtsat">
                                                <p>
                                                    <asp:Label runat="server" ID="Label9" Text="<%$ Resources:Dashboard, DB_Config_lblCompAgregation %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"
                                                        ID="rdbCompAdggregation">
                                                        <asp:ListItem Value="1" Text="<%$ Resources:Dashboard, DB_Config_CompAggregation_optAvgScore %>" />
                                                        <asp:ListItem Value="2" Text="<%$ Resources:Dashboard, DB_Config_CompAggregation_optCountLebel %>" />
                                                        <asp:ListItem Value="3" Text="<%$ Resources:Dashboard, DB_Config_CompAggregation_optSumQuantity %>" />
                                                        <asp:ListItem Value="4" Text="<%$ Resources:Dashboard, DB_Config_CompAggregation_optTotalEvents %>" />
                                                    </asp:RadioButtonList>
                                                </p>
                                            </div>
                                        </div>
                                    </fieldset>
                                </div>
                                <div style="display: none!important" id="divMaintenanceItems">
                                    <fieldset id="fldMaintenanceItems">
                                        <legend>
                                            <asp:Label runat="server" ID="Label10" Text="<%$ Resources:Dashboard, DB_Config_lblMaintenanceItems %>" /></legend>
                                        <div class="emplSearch">
                                            <div class="div_wrapper dvadtsat">
                                                <p>
                                                    <asp:Label runat="server" ID="Label11" Text="<%$ Resources:Dashboard, DB_Config_lblDisplayLevel %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"
                                                        ID="rdbDisplayLevel">
                                                        <asp:ListItem Value="1" Selected="True" Text="<%$ Resources:Dashboard, DB_Config_DisplayLevel_optByCategory %>" />
                                                        <asp:ListItem Value="2" Text="<%$ Resources:Dashboard, DB_Config_DisplayLevel_optByType %>" />
                                                    </asp:RadioButtonList>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="emplSearch">
                                            <div class="div_wrapper dvadtsat">
                                                <p>
                                                    <asp:Label runat="server" ID="Label12" Text="<%$ Resources:Dashboard, DB_Config_lblItemCategory %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:DropDownList ID="ddlItemCategory" runat="server" ClientIDMode="Static" class="select-hyper">
                                                    </asp:DropDownList>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="emplSearch">
                                            <div class="div_wrapper dvadtsat">
                                                <p>
                                                    <asp:Label runat="server" ID="Label13" Text="<%$ Resources:Dashboard, DB_Config_lblAggregation %>" />
                                                </p>
                                            </div>
                                            <div class="div_wrapper">
                                                <p>
                                                    <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"
                                                        ID="rdbAggregation">
                                                        <asp:ListItem Value="1" Text="<%$ Resources:Dashboard, DB_Config_Aggregation_optMaintStatus %>" />
                                                        <asp:ListItem Value="2" Text="<%$ Resources:Dashboard, DB_Config_Aggregation_optUntreatedFaults %>" />
                                                    </asp:RadioButtonList>
                                                </p>
                                            </div>
                                        </div>
                                    </fieldset>
                                </div>
                                <fieldset>
                                    <legend>
                                        <asp:Label runat="server" ID="Label14" Text="<%$ Resources:Dashboard, DB_Config_lblDefaults %>" /></legend>
                                    <div class="emplSearch">
                                        <div class="div_wrapper dvadtsat">
                                            <p>
                                                <asp:Label runat="server" ID="Label15" Text="<%$ Resources:Dashboard, DB_Config_lblDefaultsUnits %>" />
                                            </p>
                                        </div>
                                        <%-- ReSharper disable UnknownCssClass --%>
                                        <div class="div_wrapper treeUnitsEdit">
                                            <p>
                                                <span>
                                                    <input class="combobox-big" type="text" id="ddlDefaultUnit" runat="server" clientidmode="Static" />
                                                    <div id="txtDefaultUnit">
                                                    </div>
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="emplSearch" id="divDefaultTime">
                                        <div class="div_wrapper dvadtsat">
                                            <p>
                                                <asp:Label runat="server" ID="Label17" Text="<%$ Resources:Dashboard, DB_Config_lblDefaultsTime %>" />
                                            </p>
                                        </div>
                                        <div class="div_wrapper">
                                            <p>
                                                <asp:RadioButtonList runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"
                                                    ID="rdbDefaultTime">
                                                    <asp:ListItem Value="1" Selected="True" Text="<%$ Resources:Dashboard, DB_Config_lDefaultsTime_optCurrenMonth %>" />
                                                    <asp:ListItem Value="2" Text="<%$ Resources:Dashboard, DB_Config_lDefaultsTime_optLastMonth %>" />
                                                </asp:RadioButtonList>
                                            </p>
                                        </div>
                                    </div>
                                </fieldset>
                                <div class="emplSearch">
                                    <div class="div_wrapper">
                                        <p>
                                            <input type="button" value="<%$ Resources:Dashboard, DB_Config_btnApply %>" class="button"
                                                style="margin-top: 23px" id="btnApply" runat="server" clientidmode="Static" />
                                        </p>
                                    </div>
                                     <div class="div_wrapper">
                                        <p>
                                            <input type="button" value="<%$ Resources:Dashboard, DB_Config_btnClose %>" class="button"
                                                style="margin-top: 23px" id="btnClose" runat="server" clientidmode="Static" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="emplSearch" id="divReportImages" style="display: none">
            <fieldset>
                <div class="emplSearch" id="divChrtCommonUpper" style="margin: 0 auto;">
                </div>
            </fieldset>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidDB_Config_HeaderDefine" ClientIDMode="Static" runat="server" Text="<%$ Resources:Dashboard, DB_Config_HeaderDefine %>"></asp:Label>
        <asp:Label ID="hidDB_Config_TaskSubject_optGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Dashboard, DB_Config_TaskSubject_optGreeting %>"></asp:Label>
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
        <asp:Label ID="hidDialogTitleHeaderDefine" ClientIDMode="Static" runat="server" Text="<%$ Resources:Dashboard, DB_Config_DialogTitleHeaderDefine %>"></asp:Label>
        <asp:Label ID="hidDB_Config_btnClose" ClientIDMode="Static" runat="server" Text="<%$ Resources:Dashboard, DB_Config_btnClose %>"></asp:Label>
        <asp:Label ID="hidDB_Config_GaugeHeader" ClientIDMode="Static" runat="server" Text="<%$ Resources:Dashboard, DB_Config_GaugeHeader %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidDefaultUnitID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidDashboardItemID" ClientIDMode="Static" runat="server" />
<asp:HiddenField ID="hidUserID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            dashboard.DefaultChartDashboard($("#hidUnitID").val(), $("#ddlYear").val(), $("#ddlMonth").val(), false);
        });
        $("#btnConfig").click(function () {
            $("#divMainConfig").hide('slide');
            dashboard.OpenDashboardConfigPanel();
        });
        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits,#txtDefaultUnit").hide();
        });


        function OnClientPopup_Click() {
            var user = new window.PQ.BE.User();
            if ($('#treeUnits').is(':visible')) {
                $('#treeUnits').fadeOut('slide');
            }
            else {
                $('#treeUnits').fadeIn('slide');
                employeePages.CreateUnitTree(user);
            }
            return false;
        };

        $("#ddlDefaultUnit").click(function () {
            if ($('#txtDefaultUnit').is(':visible')) {
                $('#txtDefaultUnit').fadeOut('slide');
            }
            else {
                $('#txtDefaultUnit').fadeIn('slide');
                dashboard.CreateUnitTree();
            }
            return false;
        });

        $('#rdbDataLevel input[type="radio"]').each(function () {
            $("#ddlTaskSubject").attr("disabled", true);
            $(this).click(function () {
                if ($(this).val() == "1") {
                    $("#ddlTaskSubject").attr("disabled", true);
                } else {
                    $("#ddlTaskSubject").removeAttr("disabled");
                }
            });
        });

        $('#rdbDisplayLevel input[type="radio"]').each(function () {
            $("#ddlItemCategory").attr("disabled", true);
            $(this).click(function () {
                if ($(this).val() == "1") {
                    $("#ddlItemCategory").attr("disabled", true);
                } else {
                    $("#ddlItemCategory").removeAttr("disabled");
                }
            });
        });

        $("#ddlViewSource").change(function () {
            RaiseLoader(true);
            if ($(this).val() == "2") {
                $("#divMaintenanceItems").fadeOut("fast"); $("#divComplianceTaskParam,#divChartType,#divDefaultTime").fadeIn("slow");
                $("#rdbDisplayLevel").find("input[value='1']").attr("checked", "checked");
                $("#ddlItemCategory").val("0");
            }
            if ($(this).val() == "4") {
                $("#divComplianceTaskParam,#divDefaultTime").fadeOut("fast"); $("#divMaintenanceItems,#divChartType,#divDefaultTime").fadeIn("slow");
                $("#rdbDataLevel").find("input[value='1']").attr("checked", "checked");
                $("#ddlTaskSubject").val("0");
            }
            if ($(this).val() == "1" || $(this).val() == "3") { $("#divComplianceTaskParam,#divMaintenanceItems").fadeOut("fast"); $("#divChartType,#divDefaultTime").fadeIn("fast"); }
            if ($(this).val() == "0") { $("#divComplianceTaskParam,#divMaintenanceItems").fadeOut("fast"); }
            if ($(this).val() == "3") { $("#divChartType,#divDefaultTime").fadeOut("fast"); }
            RaiseLoader(false);
        });
        $("#ddlTaskName").change(function () {
            $("#ddlEventCategory").addClass("ui-autocomplete-ddl-loading");
            dashboard.PopulateTaskSubjectList($(this).val());
        });
        $('#ddlChartType').change(function () {
            dashboard.ChartTypeImage($(this).val());
        });
        $("#btnApply").click(function () {
            dashboard.ApplyReportParameters();
        });
        $("#btnClose").click(function () {
            $("#divParamPanel").dialog("close");
        });
        $("#lsbReportList").change(function () {
            dashboard.DashboardGetSelectedData();
        });

        $(".move_up").click(function () {
            dashboard.MoveUp();
        });
        $(".move_down").click(function () {
            dashboard.MoveDown();
        });

        $("#btnAddReport").click(function () {
            dashboard.ClearFields();

            $("#divComplianceTaskParam,#divMaintenanceItems").hide();
            $("#divMainConfig").show('slide');
        });
        $("#btnDeleteReport").click(function () {
            dashboard.DeleteSelectedItem();
        });
        $("#txtViewName").change(function () {
            if ($(this).val() != "") $(this).removeClass('ui-state-error', 200);
            return false;
        });

        $("#btnRefresh").click(function () {
            $("#divReportImages").removeClass("no-display");
            dashboard.DefaultChartDashboard($("#hidUnitID").val(), $("#ddlYear").val(), $("#ddlMonth").val(), true);
        });
        $("#btnUserConfig").click(function () {
            dashboard.CopyDataToAnotherUser($("#hidUserID").val(), $("#ddlCopyFromUser").val());
        });

    </script>
</asp:Content>
