<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OrgJob2Units.aspx.cs" EnableViewState="false" Inherits="PQ.Admin.Presentation.OrganizationalStructure.OrgJob2Units" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/PQWebService.asmx" />
            <asp:ServiceReference Path="~/WebService/OrgUnitsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OrganizationalUnits/orgJob2Units.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div>
            <h2>
                <asp:Label runat="server" ClientIDMode="Static" ID="lblUserProfile_tabUser2Unit"
                    Text="<%$ Resources:OrgStructure, OrgJob2Units_headerOrgJob2Unit %>" /></h2>
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="leftPane">
                        <div class="emplSearch">
                            <div class="emplSearch">
                                <div class="div_wrapper" style="min-height: 350px">
                                    <p>
                                        <span id="UnitsTree"></span>
                                    </p>
                                </div>
                                <div class="div_wrapper reloadImage" title="Refresh" id="imgReload">
                                    &nbsp;
                                </div>
                            </div>
                        </div>
                    </td>
                    <td valign="top" class="rightPane">
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    &nbsp;<asp:UpdatePanel ID="updJobsList" runat="server" OnLoad="updJobsList_OnLoad">
                                        <ContentTemplate>
                                            <asp:CheckBoxList runat="server" DataTextField="Job_Name" ClientIDMode="Static" CssClass="checkbox inline checkboxinline"
                                                RepeatLayout="Table" RepeatColumns="2" RepeatDirection="Vertical" DataValueField="Job_ID"
                                                ID="cblJobsList">
                                            </asp:CheckBoxList>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </p>
                            </div>
                        </div>
                        <div class="emplSearch">
                            <div class="div_wrapper">
                                <p>
                                    <input id="btnAddJob2Unit" type="button" class="button" runat="server" clientidmode="Static"
                                        onclick="btnAddJob2Unit_Click()" value="<%$ Resources:OrgStructure, OrgJob2Units_btnAddJob2Unit %>"
                                        disabled="disabled" />
                                </p>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="emplSearch" id="divDenyAttachToParentNode" style="display: none">
                <div class="div_wrapper">
                    <p>
                        <asp:Label runat="server" ForeColor="Red" ClientIDMode="Static" ID="lblDenyAttachToParentNode"
                            Text="<%$ Resources:OrgStructure, OrgUnits_DenyAttachToParentNode %>" />
                    </p>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hidUnitID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            job2unit.CreateUnitTree();
        });

        function doPostBackToJobsList(value) {
            __doPostBack('<%= updJobsList.UniqueID %>', value);
        }

        function btnAddJob2Unit_Click() {
            $("#waitplease").css({ 'display': 'block' });
            var unitID = $("#hidUnitID").val();
            var values = new Array();
            var count = 0;
            $("#cblJobsList input[type=checkbox]:checked").each(function () {
                var currentValue = $(this).parent().attr('someValue');
                if (currentValue != '')
                    values[count] = currentValue;
                count++;
            });
            job2unit.SaveJobID2Unit(values, unitID);
        }
        $("#imgReload").live("click", function () {
            var tree = jQuery.jstree._reference("#UnitsTree");
            var currentNode = tree._get_node(null, false);
            var parentNode = tree._get_parent(currentNode);
            tree.refresh(parentNode);
            tree.open_all(-1, true);
        });
        /// --------------------------------------------------
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);

        function endRequestHandler(sender, args) {
            setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 1000);
        }

        function beginRequestHandler() {
            $("#waitplease").css({ 'display': 'block' });
        }
    </script>
</asp:Content>
