<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaskReport.aspx.cs" Inherits="Pages_Compield_TaskReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="lnkUi" runat="server" rel="stylesheet" />
    <link id="lnkStruct" runat="server" rel="stylesheet" />
    <link href="../../css/redmond/jquery-ui.theme.css" rel="stylesheet" />
    <link href="../../css/redmond/css/ui.jqgrid.css" rel="stylesheet" />
    <link href="../../js/dist/css/select2.min.css" rel="stylesheet" />

    <link id="MainStyleSheet" rel="stylesheet" href="../../css/Main.css?Ver=<%=ClientVersion %>" />
    <script type="text/javascript">
        (function () {
            var lang = '<%= SessionLanguage %>';
            var href;
            switch (lang.toLowerCase()) {
                case 'he':
                    href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>";
                    break;
                case 'en':
                    href = "../../css/MainLTR.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>";
                    break;
                case 'Ge':
                    href = "../../css/MainLTR.css?SessionID=<%= Session.SessionID%>";
                    break;
                default: href = "../../css/Main.css?Ver=<%=ClientVersion %>&SessionID=<%= Session.SessionID%>"; break;
            }
            document.getElementById('MainStyleSheet').href = href;
        })();

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Path="~/css/redmond/jquery.js" />
                <asp:ScriptReference Path="~/css/redmond/jquery-ui-1.9.2.custom.js" />
                <asp:ScriptReference Path="~/css/redmond/jqgrid/i18n/grid.locale-en.js" />
                <asp:ScriptReference Path="~/css/redmond/jqgrid/jquery.jqGrid.js" />
                <asp:ScriptReference Path="~/js/jquery.blockUI.js" />
                <asp:ScriptReference Path="~/js/Main.js" />
                <asp:ScriptReference Path="~/js/tasks.js" />
                <asp:ScriptReference Path="~/js/jszip.min.js" />
            </Scripts>
            <Services>
                <asp:ServiceReference Path="~/Handlers/HardwareWebService.asmx" />
            </Services>
        </asp:ScriptManager>


        <table style="width: 100%;">
            <tr>
                <td style="vertical-align: top; width: 15%">
                    <asp:ListBox CssClass="LBAgents1" Width="100%" Height="570px" ID="lstAgents" runat="server" ClientIDMode="Static"></asp:ListBox>
                </td>
                <td style="vertical-align: top;">
                    <div id="divTaskList" style="margin: 0">
                        <table id="grdTaskList">
                        </table>
                        <div id="grdTaskListPager">
                        </div>
                    </div>
                </td>
            </tr>
        </table>

        <div id="divAddTask2Driver" runat="server" style="display: none;">
            <table class="dialogTasksLayout">
                <tr>
                    <td class="ui-accordion-header ">
                        <label runat="server" id="lblDriverName" for="ddlDriversList"></label>
                    </td>
                    <td class="ui-accordion-content">
                         <asp:DropDownList ID="ddlDriversList" runat="server" CssClass="ddlU" ClientIDMode="Static" AppendDataBoundItems="true">
                            <asp:ListItem Value="0">Choose driver...</asp:ListItem>
                        </asp:DropDownList>
                    <td class="ui-accordion-header">
                        <label runat="server" for="txtCustomer" id="lblCustomer"></label>
                    </td>
                    <td class="ui-accordion-content">
                        <input type="text" id="txtCustomer" class="txtU" />
                    </td>
                </tr>
                <tr>
                    <td class="ui-accordion-header">
                        <label runat="server" for="txtCustomerAddress" id="lblCustomerAddress"></label>
                    </td>
                    <td class="ui-accordion-content ">
                        <input type="text" id="txtCustomerAddress" class="txtU" />
                    </td>
                    <td class="ui-accordion-header">
                        <label runat="server" for="txtCustomerCity" id="lblCustomerCity"></label>
                    </td>
                    <td class="ui-accordion-content">
                        <input type="text" id="txtCustomerCity" class="txtU" />
                    </td>
                </tr>
                <tr>
                    <td class="ui-accordion-header">
                        <label runat="server" for="txtFromDate" id="lblFromDate"></label>
                    </td>
                    <td class="ui-accordion-content">
                        <input type="text" id="txtFromDate"  readonly="readonly" class="txtU" />
                    </td>
                    <td class="ui-accordion-header">
                        <label runat="server" for="txtToDate" id="lblToDate"></label>
                    </td>
                    <td class="ui-accordion-content">
                        <input type="text" id="txtToDate" readonly="readonly" class="txtU" />
                    </td>
                </tr>
                <tr style="vertical-align:top; margin-top:5px">
                    <td class="ui-accordion-header">
                        <label runat="server" for="ddlTaskType" id="lblTaskType"></label>
                    </td>
                    <td class="ui-accordion-content">
                        <asp:DropDownList ID="ddlTaskType" runat="server" CssClass="ddlU" ClientIDMode="Static"  AppendDataBoundItems="true">
                            <asp:ListItem Value="0">Choose task type...</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td class="ui-accordion-header" style="vertical-align:top">
                        <label runat="server" for="txtTaskDesc" id="lblTaskDesc"></label>
                    </td>
                    <td class="ui-accordion-content">
                        <textarea name="txtTaskDesc" cols="1" rows="5" id="txtTaskDesc" class="txtU" ></textarea>
                    </td>
                </tr>
            </table>

            <asp:HiddenField ID="hidTask_ID" ClientIDMode="Static" runat="server" />
        </div>


        <asp:HiddenField ID="hidDriverID_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidTaskID_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidTaskType_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidTaskDesc_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDriverName_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCustomerCode_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDateTo_Grid_Header" ClientIDMode="Static" runat="server" />
		<asp:HiddenField ID="hidDateFrom_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCustAddress_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCustCity_Grid_Header" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidFromDate_Grid_Header" ClientIDMode="Static" runat="server" />

        <asp:HiddenField ID="hidLanguage" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidAddbuttonCaption" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidSearchButtonCaption" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidSaveButtonCaption" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidUpdateButtonCaption" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidCancelButtonCaption" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidConfirmMsg" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hidChangeMesageConfirm" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnFromDate" runat="server" ClientIDMode="Static" />
    </form>
</body>
</html>
