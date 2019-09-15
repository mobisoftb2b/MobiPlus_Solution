<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OrgUnits.aspx.cs" EnableViewState="false" Inherits="PQ.Admin.Presentation.OrganizationalStructure.OrgUnits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/WebService/PQWebService.asmx" />
            <asp:ServiceReference Path="~/WebService/OrgUnitsService.asmx" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.jstree.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/Common/jquery.blockUI.js" />
            <asp:ScriptReference Path="~/Resources/Scripts/OrganizationalUnits/organizationalUnits.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <div id="content">
        <div>
            <h2 class="jquery_tab_title">
                <asp:Label runat="server" ClientIDMode="Static" ID="lblUserProfile_tabUser2Unit"
                    Text="<%$ Resources:OrgStructure, OrgUnits_headerOrgUnits %>" /></h2>
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
               
                <div class="emplSearch">
                    <div class="div_wrapper">
                        <p>
                            <input id="btnAddOrgUnits" type="button" class="button licAction" clientidmode="Static"
                                runat="server" value="<%$ Resources:OrgStructure, OrgUnits_btnAddUnit %>" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input id="btnRemoveOrgUnits" type="button" class="button licAction" clientidmode="Static"
                                runat="server" value="<%$ Resources:OrgStructure, OrgUnits_btnRemoveUnit %>"
                                disabled="disabled" onclick="btnRemoveOrgUnits_Click();" />
                        </p>
                    </div>
                    <div class="div_wrapper">
                        <p>
                            <input id="btnRenameUnit" type="button" class="button licAction" clientidmode="Static"
                                runat="server" value="<%$ Resources:OrgStructure, OrgUnits_btnRenameUnit %>"
                                disabled="disabled" onclick="btnRenameUnit_Click();" />
                        </p>
                    </div>
                </div>
                 <div class="emplSearch" id="divDenyAddingNode" style="display:none">
                    <div class="div_wrapper">
                        <p>
                            <asp:Label runat="server" ForeColor="Red" ClientIDMode="Static" ID="lblWarningMessage" Text="<%$ Resources:OrgStructure, OrgUnits_DenyAddingNode %>" />
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="no-display">
        <asp:Label ID="hidOrgUnits_DeleteUnitError" runat="server" ClientIDMode="Static"
            Text="<%$ Resources:OrgStructure, OrgUnits_DeleteUnitError %>"></asp:Label>
    </div>
    <asp:HiddenField ID="hidUnitXml" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        $(function () {
            $("#waitplease").css({ 'display': 'block' });
            setTimeout(function () {
                orgUnit.CreateUnitTree();
                $("#btnAddOrgUnits").click(function () {
                    $("#UnitsTree").jstree("create");
                });
                $("#waitplease").css({ 'display': 'none' });
            }, 500);
        });
        $("#UnitsTree").keypress(function (event) {
            if (event.keyCode == '13') {
                event.preventDefault();
            }
        });

        $("#imgReload").live("click", function (e) {
            e.preventDefault();
            $.ajaxSetup({ cache: false });
            $("#waitplease").css({ 'display': 'block' });
            orgUnit.CreateUnitTree();
            var tree = $.jstree._reference("#UnitsTree");
            var currentNode = tree._get_node(null, false);
            var parentNode = tree._get_parent(currentNode);
            tree.refresh(parentNode);
            tree.open_all(-1, true);
        });

        function btnRemoveOrgUnits_Click() {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        $("#UnitsTree").jstree("remove");
                    },
                    Cancel: function (e) {
                        e.stopImmediatePropagation();
                        $(this).dialog('destroy');
                        return false;
                    }
                }
            });
            return false;
        }

        function btnRenameUnit_Click() {
            $("#UnitsTree").jstree("rename");
            return false;
        }
    </script>
</asp:Content>
