<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    EnableViewState="false" CodeBehind="ImageOverview.aspx.cs" Inherits="PQ.Admin.Presentation.Readiness.ImageOverview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/OpSemsService.svc" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OpSemSettings/imageOverview.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.multiselect.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.multiselect.filter.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.corner.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div>
            <h2 class="jquery_tab_title">
                <asp:Label runat="server" ID="lblHeaderGeneralInfo" Text="<%$ Resources:WorkStations, IO_headerImageOverview %>" /></h2>
            <fieldset>
                <legend></legend>
                <div class="emplSearch">
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="lblIO_txtDateFrom" Text="<%$ Resources:WorkStations, IO_txtDateFrom %>" /></label>
                                <input type="text" id="txtDateFrom" class="input-hyper" />
                            </p>
                        </div>
                        <div class="div_wrapper">
                            <p>
                                <label class="label">
                                    <asp:Label runat="server" ID="Label1" Text="<%$ Resources:WorkStations, IO_txtDateTo %>" /></label>
                                <input type="text" id="txtDateTo" class="input-hyper" />
                            </p>
                        </div>
                    </div>
                    <div class="emplSearch">
                        <div class="div_wrapper">
                            <fieldset>
                                <legend>
                                    <asp:Label runat="server" ID="Label2" Text="<%$ Resources:WorkStations, IO_fldsVerified %>" /></legend>
                                <div class="div_wrapper">
                                    <input type="radio" id="chkVerifiedThreats" checked="checked" name="VerifiedThreats"
                                        style="margin-top: 5px" />
                                    <label for="chkVerifiedThreats">
                                        <asp:Label runat="server" ID="Label5" Text="<%$ Resources:WorkStations, IO_chkVerifiedThreats %>" />
                                    </label>
                                </div>
                                <div class="div_wrapper">
                                    <input type="radio" id="chkNonVerifiedThreats" name="VerifiedThreats" style="margin-top: 5px" />
                                    <label for="chkNonVerifiedThreats">
                                        <asp:Label runat="server" ID="Label6" Text="<%$ Resources:WorkStations, IO_chkNonVerifiedThreats %>" />
                                    </label>
                                </div>
                                <div class="div_wrapper">
                                    <input type="radio" id="chkMissedThreats" name="VerifiedThreats" style="margin-top: 5px" />
                                    <label for="chkMissedThreats">
                                        <asp:Label runat="server" ID="Label7" Text="<%$ Resources:WorkStations, IO_chkMissedThreats %>" />
                                    </label>
                                </div>
                            </fieldset>
                        </div>
                        <div class="div_wrapper">
                            <fieldset>
                                <legend>
                                    <asp:Label runat="server" ID="Label3" Text="<%$ Resources:WorkStations, IO_fldsCategories %>" /></legend>
                                <div class="div_wrapper">
                                    <input type="radio" id="chkNormalCategory" value="1" checked="checked" name="CategoryThreats"
                                        style="margin-top: 5px" />
                                    <label for="chkNormalCategory">
                                        <asp:Label runat="server" ID="Label9" Text="<%$ Resources:WorkStations, IO_chkNormalCategory %>" />
                                    </label>
                                </div>
                                <div class="div_wrapper">
                                    <input type="radio" id="chkRandomCategory" value="2" name="CategoryThreats" style="margin-top: 5px" />
                                    <label for="chkRandomCategory">
                                        <asp:Label runat="server" ID="Label8" Text="<%$ Resources:WorkStations, IO_chkRandomCategory %>" />
                                    </label>
                                </div>
                            </fieldset>
                        </div>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper treeUnitsEdit">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label10" Text="<%$ Resources:WorkStations, IO_lblUnit %>" /></label>
                            <span>
                                <input class="combobox-big" type="text" id="ddlUnit" runat="server" clientidmode="Static" />
                                <div id="treeUnits">
                                </div>
                            </span>
                        </p>
                    </div>
                    <div class="wrapper" style="margin-top: 4px">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label11" Text="<%$ Resources:WorkStations, IO_lblJob %>" /></label>
                            <asp:DropDownList ID="ddlJobsList" runat="server" DataTextField="Job_Name" CssClass="select-hyper"
                                ClientIDMode="Static" DataValueField="Job_ID">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="Label4" Text="<%$ Resources:WorkStations, IO_ddlThreatType %>" /></label>
                            <asp:DropDownList ID="ddlThreatType" runat="server" DataTextField="ThreatType_Name"
                                CssClass="select-hyper" ClientIDMode="Static" DataValueField="ThreatType_ID" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <label class="label">
                                <asp:Label runat="server" ID="lblTrainingEventCategory" Text="<%$ Resources:WorkStations, IO_ddlEmployeeName %>" /></label>
                            <asp:DropDownList ID="ddlEmployeeName" ClientIDMode="Static" runat="server" DataTextField="Person_FullName"
                                DataValueField="Person_ID" AppendDataBoundItems="true">
                            </asp:DropDownList>
                        </p>
                    </div>
                </div>
                <div class="emplSearch">
                    <div class="div_wrapper" id="divImageOverviewButtonArea">
                        <p>
                            <input type="button" id="btnFilter" clientidmode="Static" runat="server" class="button"
                                value="<%$ Resources:WorkStations, IO_btnFilter %>" />
                        </p>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="emplSearch">
            <fieldset>
                <legend></legend>
                <div class="emplSearch" id="divImageOverviews">
                    <div class="div_wrapper">
                        <table id="tblImageOverviews" style="width: 100%">
                        </table>
                        <div id="pgrImageOverviews">
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>
    <asp:HiddenField ID="hidUnitID" runat="server" ClientIDMode="Static" />
    <div class="no-display">
        <asp:Label ID="hidIO_ddlEmployeeName_DefaultGreeting" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, IO_ddlEmployeeName_DefaultGreeting %>"></asp:Label>
        <asp:Label ID="hidIO_Multiselect_CheckAllText" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, IO_Multiselect_CheckAllText %>"></asp:Label>
        <asp:Label ID="hidIO_Multiselect_UncheckAllText" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, IO_Multiselect_UncheckAllText %>"></asp:Label>
        <asp:Label ID="hidIO_Multiselect_SelectedText" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, IO_Multiselect_SelectedText %>"></asp:Label>
        <asp:Label ID="hidIO_Multiselect_NoneSelectedText" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, IO_Multiselect_NoneSelectedText %>"></asp:Label>
        <asp:Label ID="hidIO_Multiselectfilter_label" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:WorkStations, IO_Multiselectfilter_label %>"></asp:Label>
        <asp:Label ID="hidIO_Grid_ImageDate" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, IO_Grid_ImageDate %>"></asp:Label>
        <asp:Label ID="hidIO_Grid_EmployeeName" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, IO_Grid_EmployeeName %>"></asp:Label>
        <asp:Label ID="hidIO_Grid_ThreatType" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, IO_Grid_ThreatType %>"></asp:Label>
        <asp:Label ID="hidIO_Grid_ViewImage" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, IO_Grid_ViewImage %>"></asp:Label>
        <asp:Label ID="hidIO_DownloadImages" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, IO_DownloadImages %>"></asp:Label>
        <asp:Label ID="hidIO_Grid_ImageID" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, IO_Grid_ImageID %>"></asp:Label>
        <asp:Label ID="hidIO_Grid_EmployeeID" ClientIDMode="Static" runat="server" Text="<%$ Resources:WorkStations, IO_Grid_EmployeeID %>"></asp:Label>
        <asp:Label ID="hidIO_grtSelectJobs" runat="server" Text="<%$ Resources:WorkStations, IO_grtSelectJobs %>"
            ClientIDMode="Static" />
    </div>
    <script type="text/javascript">
        var temp = new Array();
        var firstClick = true;
        imageOver.PopulateThreatTypeCombo(1);
        $("#ddlEmployeeName").multiselect({
            multiple: true,
            minWidth: 260,
            selectedList: 10,
            height: 300,
            checkAllText: $("#hidIO_Multiselect_CheckAllText").text(),
            uncheckAllText: $("#hidIO_Multiselect_UncheckAllText").text(),
            noneSelectedText: $("#hidIO_Multiselect_NoneSelectedText").text(),
            selectedText: $("#hidIO_Multiselect_SelectedText").text()
        }).multiselect("uncheckAll").multiselectfilter({ label: $("#hidIO_Multiselectfilter_label").text() });

        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
        });

        $(function () {
            if ($.cookie("dateFormat")) {
                if ($.cookie("dateFormat") === "103")
                    dateFormats = "dd/mm/yy";
                else
                    dateFormats = "mm/dd/yy";
            }
            if ($.cookie("lang"))
                $.datepicker.setDefaults($.datepicker.regional[$.cookie("lang").substring(0, 2)]);
            else
                $.datepicker.setDefaults($.datepicker.regional['']);

            $("#txtDateFrom, #txtDateTo").datepicker({
                firstDay: 1,
                changeFirstDay: false,
                changeYear: true,
                changeMonth: true,
                dateFormat: dateFormats
            });
            imageOver.PopulateJobsListCombo($("#hidUnitID").val());
        });
        $("#chkRandomCategory").change(function () {
            imageOver.PopulateThreatTypeCombo($(this).val());
        });
        $("#chkNormalCategory").change(function () {
            imageOver.PopulateThreatTypeCombo($(this).val());
        });
        $("#divImageOverviewButtonArea").delegate("#btnFilter", "click",
        function () {
            $("#waitplease").css({ 'display': 'block' });
            $("#tblImageOverviews").GridUnload();
            imageOver.CreateImageOverviewGrid();
        });
        $("#ddlJobsList").change(function () {
            $("#waitplease").css({ 'display': 'block' });
            var dataID = $("#ddlJobsList").val();
            var dataText = $("#ddlJobsList option:selected").text();
            imageOver.PopulationEmployeeData($("#hidUnitID").val(), dataID);
            //perfomance.DisplayJobReadinessInfo($("#hidUnitID").val(), dataID, dataText, $('#hidStartDate').val(), $('#hidEndDate').val());
        });

        $("#ddlUnit").live("click", function () {
            var _user = new PQ.BE.User();
            if ($('#treeUnits').is(':visible')) {
                $('#treeUnits').fadeOut('slide');
            }
            else {
                $('#treeUnits').fadeIn('slide');
                imageOver.CreateUnitTree(_user);
            }
            return false;
        });
      
    </script>
</asp:Content>
