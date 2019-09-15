<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="EmployeeSearch.aspx.cs" Inherits="PQ.Admin.Presentation.Employee.EmployeeSearch" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/EmployeeSearchWS.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/employee.min.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Employee/employeeSearch.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.qtip-1.0.0-rc3.min.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <h2 id="h2Empl">
            <asp:Label ID="lblEmployee" runat="server" Text="<%$ Resources:Employee, lblEmployee %>" /><img
                alt="Show" id="imgShowParams" style="margin-bottom: -5px; display: none" src="../../Resources/images/down_alt.png" /></h2>
        <div id="divSerchPanel">
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblEmployeeID" Text="<%$ Resources:Employee, EmpSearch_lblEmployeeID %>" /></label>
                        <input class="input-medium" clientidmode="Static" type="text" id="txtEmployeeID"
                            runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblClassification" Text="<%$ Resources:Employee, EmpSerach_lblClassification %>" /></label>
                        <select id="cboClassification" class="select" runat="server" clientidmode="Static"
                            datatextfield="PersonCategory_Name" datavaluefield="PersonCategory_ID">
                        </select>
                    </p>
                </div>
                <%-- ReSharper disable UnknownCssClass --%>
                <div class="div_wrapper treeUnitsEdit">
                    <%-- ReSharper restore UnknownCssClass --%>
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblUnit" Text="<%$ Resources:Employee, EmpSearch_lblUnit %>" /></label>
                        <span>
                            <input class="combobox" type="text" id="ddlUnit" runat="server" clientidmode="Static"
                                onclick="OnClientPopup_Click();" />
                            <div id="treeUnits">
                            </div>
                        </span>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblFirstName" Text="<%$ Resources:Employee, EmpSearch_lblFirstName %>" /></label>
                        <input class="input-medium" clientidmode="Static" type="text" id="txtFirstName" runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblLastName" Text="<%$ Resources:Employee, EmpSearch_lblLastName %>" /></label>
                        <input class="input-medium" type="text" clientidmode="Static" id="txtLastName" runat="server" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblJob" Text="<%$ Resources:Employee, EmpSearch_lblJob %>" /></label>
                        <select style="width: 190px" id="cboJob" class="select" runat="server" datatextfield="Job_Name"
                            clientidmode="Static" datavaluefield="Job_ID">
                        </select>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <label class="label">
                            <asp:Label runat="server" ID="lblReadinessLabel" Text="<%$ Resources:Employee, EmpSearch_lblReadinessLabel %>" /></label>
                        <asp:DropDownList ID="ddlReadinessLabel" CssClass="select" runat="server" ClientIDMode="Static"
                            DataTextField="ORGName" DataValueField="ReadinessLevelID">
                        </asp:DropDownList>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="checkbox" runat="server" class="checkbox" id="chkActiveEmployee" clientidmode="Static"
                            checked="True" style="margin-top: 25px" />
                        <label class="inline checkboxinline" for="chkActiveEmployee">
                            <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblActiveEmployee"
                                Text="<%$ Resources:Employee, EmpSearch_lblActiveEmployee %>" /></label>
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input type="checkbox" runat="server" class="checkbox" id="chkIsReadiness" clientidmode="Static"
                            style="margin-top: 25px" checked="True"></input>
                        <label class="inline checkboxinline" for="chkIsReadiness">
                            <asp:Label runat="server" CssClass="inline checkboxinline" ID="lblIsReadiness" Text="<%$ Resources:Employee, GeneralInfo_lblIsReadiness %>" /></label>
                    </p>
                </div>
            </div>
            <div class="emplSearch">
                <div class="div_wrapper">
                    <p>
                        <input class="button" id="btnSearch" type="button" runat="server" value="<%$ Resources:Employee, EmpSearch_btnSearch %>"
                            clientidmode="Static" onclick="EmployeeSearch();" />
                    </p>
                </div>
                <div class="div_wrapper">
                    <p>
                        <input class="button" id="btnClear" type="button" runat="server" onclick="Clearence();"
                            value="<%$ Resources:Employee, EmpSearch_btnClear %>" />
                    </p>
                </div>
                <div class="div_wrapper demo" style="width: 380px">
                    <div id="slider-range-max">
                    </div>
                    <input type="text" id="amount" style="border: 0; color: #f6931f; font-weight: bold;" />
                </div>
            </div>
        </div>
        <h2>
            <asp:Label ID="lblResult" runat="server" Text="<%$ Resources:Employee, EmpSearch_lblResult %>" /></h2>
        <div id="divResultPanel" class="grid">
            <table id="tblEmlpoyee">
            </table>
            <div id="pgrEmlpoyee">
            </div>
        </div>
    </div>
    <div id="hiddFuildCaptions" style="display: none">
        <asp:Label ID="hidEmpSearch_Grid_lblEmployeeID" ClientIDMode="Static" runat="server"
            Text="<%$ Resources:Employee, EmpSearch_Grid_lblEmployeeID %>" />
        <asp:Label ID="hidEmpSearch_Grid_lblFirstName" runat="server" Text="<%$ Resources:Employee, EmpSearch_Grid_lblFirstName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_Grid_lblMiddleName" runat="server" Text="<%$ Resources:Employee, EmpSearch_Grid_lblMiddleName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_Grid_lblLastName" runat="server" Text="<%$ Resources:Employee, EmpSearch_Grid_lblLastName %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_Grid_lblJob" runat="server" Text="<%$ Resources:Employee, EmpSearch_Grid_lblJob %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_Grid_lblUnit" runat="server" Text="<%$ Resources:Employee, EmpSearch_Grid_lblUnit %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_btnEdit" runat="server" Text="<%$ Resources:Employee, EmpSearch_btnEdit %>"
            ClientIDMode="Static" />
        <asp:Label ID="hidEmpSearch_AllStuff" runat="server" Text="<%$ Resources:Employee, hidEmpSearch_AllStuff %>"
            ClientIDMode="Static" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEmpSearch_Grid_headerPhoto"
            Text="<%$ Resources: Employee, EmpSearch_Grid_headerPhoto %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="hidEmpSearch_Grid_header_ReadinessLevel"
            Text="<%$ Resources: Employee, EmpSearch_Grid_header_ReadinessLevel %>" />
        <asp:Label runat="server" ClientIDMode="Static" ID="lblTreeLebel" />
    </div>
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript" language="javascript">
        $(function () {
            $("#slider-range-max").slider({
                animate: true,
                range: "max",
                min: 100,
                max: 1000,
                step: 100,
                value: 100,
                slide: function (event, ui) {
                    if (ui.value == 1000) {
                        $("#amount").val($("#hidEmpSearch_AllStuff").text());
                    }
                    else {
                        $("#amount").val(ui.value);
                    }
                }
            });
            $("#amount").val($("#slider-range-max").slider("value"));
        });

        $(document).ready(function () {
            $('#h2Empl').hover(
                function () { $(this).css({ cursor: 'pointer' }); },
                function () { $(this).css({ cursor: 'default' }); })
            .click(function () {
                employeeSearch.ShowIconParamsArea();
            });
        });

        $("#frmScoutForm").keypress(function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13)
                $("#btnSearch").click();
        });

        $(document).bind('click', function (e) {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("treeUnitsEdit"))
                $("#treeUnits").hide();
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

        function EmployeeSearch() {
            $("#waitplease").css({ 'display': 'block' });
            $("#tblEmlpoyee").GridUnload();
            employeeSearch.CreateEmployeeCollectionGrid($("#amount").val());
            employeeSearch.ShowIconParamsArea();
        }

        function Clearence() {
            $('input:text').each(function () {
                $(this).val('');
            });
            $('.select').val('0');
            $('#hidUnitID').val('');
        }

        function formatItem(row) {
            return row[0] + " (<strong>id: " + row[1] + "</strong>)";
        }
        function formatResult(row) {
            return row[0].replace(/(<.+?>)/gi, '');
        }
        function log(event, data, formatted) {
            $("<li>").html(!data ? "No match!" : "Selected: " + formatted).appendTo("#result");
        }
    </script>
</asp:Content>
