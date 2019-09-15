<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    EnableViewState="true" EnableEventValidation="false" ValidateRequest="false"
    CodeBehind="ReadinessStatus.aspx.cs" Inherits="PQ.Admin.Presentation.Readiness.ReadinessStatus" %>

<%@ OutputCache NoStore="true" VaryByParam="none" Duration="1" Location="None" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EmployeeSearchWS.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/readinessInfo.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div>
            <h2 class="jquery_tab_title">
                <asp:Label runat="server" ID="lblHeaderGeneralInfo" Text="<%$ Resources:Employee, grbReadinessIndex %>" /></h2>
            <div class="emplSearch">
                <div class="div_wrapper treeUnitsEdit">
                    <fieldset>
                        <legend>
                            <asp:Label runat="server" ID="Label3" Text="<%$ Resources:Employee, lblUnit %>" /></legend>
                        <span style="padding: 5px">
                            <input class="combobox-big" type="text" id="ddlUnit" runat="server" clientidmode="Static"
                                onclick="OnClientPopup_Click();" />
                            <div id="treeUnits">
                            </div>
                        </span>
                    </fieldset>
                </div>
                <div class="wrapper" style="margin-top: 4px">
                    <fieldset>
                        <legend>
                            <asp:Label runat="server" ID="Label4" Text="<%$ Resources:Employee, lblJob %>" /></legend>
                        <span style="padding: 5px">
                            <asp:DropDownList ID="ddlJobsList" runat="server" DataTextField="Job_Name" CssClass="select-hyper"
                                ClientIDMode="Static" DataValueField="Job_ID" onchange="ddlJobsList_OnChange(this);">
                            </asp:DropDownList>
                        </span>
                    </fieldset>
                </div>
                <div class="wrapper no-display" style="margin-top: 25px">
                    <p>
                        &nbsp;
                        <input type="button" id="btnUnitReadinessInfo" runat="server" class="button" onclick="btnUnitReadinessInfo_Click();"
                            value="<%$ Resources:Readiness, PerfomanceAnalisys_lblFilter %>" />
                    </p>
                </div>
            </div>
            <div id="divUserDetails" class="emplSearch" style="display: none">
                <div class="wrapper">
                    <fieldset>
                        <legend>
                            <asp:Label runat="server" ID="lblHeaderUserDetails" ClientIDMode="Static" /></legend>
                        <div class="emplSearch">
                            <div class="div_wrapper" id="trDefaultUserGreen">
                                <div class="div_wrapper">
                                    <img src="../../Resources/images/defaultUserGreen.gif" width="45" id="imgDefaultUserGreen"
                                        alt="" style="cursor: pointer" onclick="readinessInfo.UserDetailReadinessInfoPerUnit(1);" />
                                </div>
                                <div class="div_wrapper">
                                    <label id="lblUserGreen">
                                    </label>
                                    <asp:Label ID="lblReadinessStatus_UserDenotation" Text="<%$ Resources:Readiness, ReadinessStatus_UserDenotation %>"
                                        runat="server" />
                                </div>
                            </div>
                            <div class="div_wrapper" id="trDefaultUserYellow">
                                <div class="div_wrapper">
                                    <img src="../../Resources/images/defaultUserYellow.gif" width="45" id="imgDefaultUserYellow"
                                        alt="" style="cursor: pointer" onclick="readinessInfo.UserDetailReadinessInfoPerUnit(2);" />
                                </div>
                                <div class="div_wrapper">
                                    <label id="lblUserYellow">
                                    </label>
                                    <asp:Label ID="Label1" Text="<%$ Resources:Readiness, ReadinessStatus_UserDenotation %>"
                                        runat="server" />
                                </div>
                            </div>
                            <div class="div_wrapper" id="trDefaultUserRed">
                                <div class="div_wrapper">
                                    <img src="../../Resources/images/defaultUserRed.gif" width="45" alt="" id="imgDefaultUserRed"
                                        style="cursor: pointer" onclick="readinessInfo.UserDetailReadinessInfoPerUnit(3);" />
                                </div>
                                <div class="div_wrapper">
                                    <label id="lblUserRed">
                                    </label>
                                    <asp:Label ID="Label2" Text="<%$ Resources:Readiness, ReadinessStatus_UserDenotation %>"
                                        runat="server" />
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
            <div class="emplSearch" style="display: none" id="divChartArea">
                <div class="div_wrapper">
                    <fieldset>
                        <legend>
                            <label id="lblHeaderGraph">
                            </label>
                        </legend>
                        <div id="rightChartsPanel">
                            <table cellpadding="0" cellspacing="0" width="90%">
                                <tr>
                                    <td valign="top">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="center" colspan="2">
                                                    <div id="divPieChart" class="loading">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td valign="top">
                                        <div id="divGauges">
                                            <table cellpadding="0" cellspacing="0" id="tblGaugesArea">
                                                <tr>
                                                    <td>
                                                        <iframe id="frmGaugesMain" width="260px" scrolling="no" frameborder="0" height="260px">
                                                        </iframe>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="div_wrapper">
                                            <div id="chrtUnitReadinessLower" class="loading">
                                                &nbsp;
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>
    <div id="divUsersDetailsInfo" style="display: none;">
        <div id="divHeaderUserInfo">
            &nbsp;</div>
        <table id="tblHeadsEmlpoyee" cellpadding="0" cellspacing="0">
        </table>
        <div id="pgrEmlpoyee">
        </div>
    </div>
    <asp:HiddenField ID="hidUnitID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidJobID" runat="server" ClientIDMode="Static" />
    <div class="no-display">
        <asp:Label ID="hidEmpSearch_Grid_lblEmployeeID" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Readiness, ReadinessStatus_Grid_lblEmployeeID %>" />
        <asp:Label ID="hidEmpSearch_Grid_lblFirstName" runat="server" Text="<%$ Resources:Readiness, ReadinessStatus_Grid_lblFirstName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_Grid_lblLastName" runat="server" Text="<%$ Resources:Readiness, ReadinessStatus_Grid_lblLastName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_Grid_PersonReadiness_Remarks" runat="server" Text="<%$ Resources:Readiness, ReadinessStatus_Grid_PersonReadiness_Remarks %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidReadinessStatus_grtSelectJobs" runat="server" Text="<%$ Resources:Readiness, ReadinessStatus_grtSelectJobs %>"
            ClientIDMode="Static" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
    </div>
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
            if (args.get_error()) {
                args.set_errorHandled(true);
            };
        });
        //        $("#waitplease").css({ 'display': 'block' });
        $("#MySplitter").css({ "opacity": "0" }).fadeIn("slow");
        var _user = new PQ.BE.User();
        var pathSrcMain = '<%= this.ResolveClientUrl("~/Presentation/Gauge/Gauge.aspx") %>';
        var pathSrcSmall = '<%= this.ResolveClientUrl("~/Presentation/Gauge/LittleGauge.aspx") %>';

        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });

        $(function () {
            readinessInfo.PopulateJobsListCombo($("#hidUnitID").val());
        });

        function btnUnitReadinessInfo_Click() {
            $("#MySplitter").css({ "opacity": "1" });
            $("#waitplease").css({ 'display': 'none' });
            readinessInfo.DisplayUnitReadinessInfo($("#hidUnitID").val(), $("#ddlUnit").val());
            //            readinessInfo.PopulateJobsListCombo($("#hidUnitID").val());
            readinessInfo.DisplayUserReadinessDetals($("#hidUnitID").val(), $("#ddlUnit").val());
        };

        function OnClientPopup_Click() {
            var _user = new PQ.BE.User();
            if ($('#treeUnits').is(':visible')) {
                $('#treeUnits').fadeOut('slide');
            }
            else {
                $('#treeUnits').fadeIn('slide');
                readinessInfo.CreateUnitTree(_user);
            }
            return false;
        };

        function ddlJobsList_OnChange() {
            var dataID = $("#ddlJobsList").val();
            var dataText = $("#ddlJobsList option:selected").text();
            if (dataID != '0') {
                readinessInfo.DisplayJobReadinessInfo($("#hidUnitID").val(), dataID, dataText);
                readinessInfo.DisplayUserReadinessDetalsPerJob(dataID, dataText);
            }
            else {
                readinessInfo.DisplayUnitReadinessInfo($("#hidUnitID").val(), $("#ddlUnit").val());
                readinessInfo.DisplayUserReadinessDetals($("#hidUnitID").val(), $("#ddlUnit").val());
            }
        }
        
    </script>
</asp:Content>
